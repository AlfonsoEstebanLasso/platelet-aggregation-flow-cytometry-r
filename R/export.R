# R/export.R
#
# Purpose: the only functions of v1.0 that write to disk: the output naming
#          scheme of section 9 of docs/v1_spec.md, directory creation,
#          figure export with ggsave(), table export with write.csv(), the
#          three tables of one fit and the sessionInfo file written with
#          every run.
# Inputs:  ggplot objects, data frames and v1_fit objects.
# Outputs: PNG figures and CSV tables under the directory passed as outdir,
#          and sessionInfo.txt; nothing is written anywhere else.

#' @title Build an output path of the v1.0 naming scheme
#' @description Returns outdir/panel/variant/<variable>_<kind>.<ext> without
#'   creating anything.
#' @param outdir Output directory.
#' @param panel Panel id.
#' @param variant Variant id.
#' @param variable Slug of the measure or the overview token.
#' @param kind One of figure, anova, tukey, assumptions, counts.
#' @param ext One of png, csv.
#' @return A file path.
output_path <- function(outdir, panel, variant, variable, kind, ext) {
  stopifnot(is.character(outdir), length(outdir) == 1,
            is.character(panel), length(panel) == 1,
            is.character(variant), length(variant) == 1,
            is.character(variable), length(variable) == 1)
  kind <- match.arg(kind, c("figure", "anova", "tukey", "assumptions", "counts"))
  ext <- match.arg(ext, c("png", "csv"))
  file.path(outdir, panel, variant, paste0(variable, "_", kind, ".", ext))
}

#' @title Create the directory of a path
#' @param path A file path whose parent directory may not exist.
#' @return The path, unchanged.
ensure_dir <- function(path) {
  stopifnot(is.character(path), length(path) == 1)
  dir <- dirname(path)
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  }
  path
}

#' @title Save a figure as PNG
#' @description Calls ggsave() with the parameters of section 7 (9 by 5
#'   inches, 100 dpi, white background).
#' @param plot A ggplot object.
#' @param path Destination file.
#' @param width Width in inches.
#' @param height Height in inches.
#' @param dpi Resolution.
#' @return The path, invisibly.
export_figure <- function(plot, path, width = 9, height = 5, dpi = 100) {
  stopifnot(inherits(plot, "ggplot"))
  ensure_dir(path)
  ggplot2::ggsave(path, plot, width = width, height = height, units = "in",
                  dpi = dpi, bg = "white")
  invisible(path)
}

#' @title Save a table as CSV
#' @description Calls write.csv() with row.names = FALSE and na = "" (comma
#'   separator, decimal point, UTF-8).
#' @param df A data frame.
#' @param path Destination file.
#' @return The path, invisibly.
export_table <- function(df, path) {
  stopifnot(is.data.frame(df))
  ensure_dir(path)
  utils::write.csv(df, path, row.names = FALSE, na = "")
  invisible(path)
}

#' @title Write the three tables of one fit
#' @description Writes <slug>_anova.csv, <slug>_tukey.csv and
#'   <slug>_assumptions.csv under outdir/panel/variant with the columns
#'   panel and variant prepended to the tidy tables. For a skipped fit the
#'   header-only tables are written so that every measure has its three
#'   files. When the anova element already carries p_holm, p_bh and
#'   family_size (set by run_panel() after adjust_p_values()) they are
#'   written as they are.
#' @param fit A v1_fit object.
#' @param outdir Output directory.
#' @param panel Panel id.
#' @param variant Variant id.
#' @param slug Slug of the measure.
#' @return Named character vector with the three paths (anova, tukey,
#'   assumptions).
export_fit <- function(fit, outdir, panel, variant, slug) {
  stopifnot(inherits(fit, "v1_fit"))
  prepend <- function(tbl) {
    k <- nrow(tbl)
    data.frame(panel = rep(panel, k), variant = rep(variant, k), tbl,
               stringsAsFactors = FALSE, check.names = FALSE)
  }
  paths <- c(anova = output_path(outdir, panel, variant, slug, "anova", "csv"),
             tukey = output_path(outdir, panel, variant, slug, "tukey", "csv"),
             assumptions = output_path(outdir, panel, variant, slug,
                                       "assumptions", "csv"))
  export_table(prepend(tidy_anova(fit)), paths[["anova"]])
  export_table(prepend(tidy_tukey(fit)), paths[["tukey"]])
  export_table(prepend(tidy_assumptions(fit)), paths[["assumptions"]])
  paths
}

#' @title Write the session information of a run
#' @description Writes the date and time, the seed, the name of the working
#'   directory (basename only, never the absolute path) and the output of
#'   sessionInfo(). Lines of sessionInfo() that describe the machine rather
#'   than the software are dropped so that the file carries no location or
#'   absolute path: the time zone line, the BLAS and LAPACK library lines
#'   (which print absolute paths on Linux and macOS) and the locale block
#'   (which names the language and country of the build machine).
#' @param dir Directory of the file.
#' @param file File name (default sessionInfo.txt).
#' @param seed The project seed.
#' @return The path, invisibly.
write_session_info <- function(dir, file = "sessionInfo.txt", seed = 20211109) {
  stopifnot(is.character(dir), length(dir) == 1, is.character(file),
            length(file) == 1)
  path <- ensure_dir(file.path(dir, file))
  session <- utils::capture.output(utils::sessionInfo())
  machine_lines <- grepl("^\\s*(time zone|BLAS|LAPACK)\\s*:|^\\s*locale:|^\\[[0-9]+\\] +LC_", session)
  lines <- c(paste("Run date and time:", format(Sys.time(), "%Y-%m-%d %H:%M:%S")),
             paste("Project seed:", format(seed, scientific = FALSE)),
             paste("Working directory (basename):", basename(getwd())),
             "",
             session[!machine_lines])
  writeLines(lines, path, useBytes = FALSE)
  invisible(path)
}
