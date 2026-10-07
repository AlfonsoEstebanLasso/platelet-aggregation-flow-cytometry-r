# R/run_panel.R
#
# Purpose: run one panel end to end: read the master table, recode each
#          variant, export the cohort overview figures and count tables,
#          draw and export the figure of every measure, fit the v1.0 model,
#          apply the Holm and Benjamini-Hochberg corrections within panel
#          and variant, and export the per-measure and panel-level tables
#          with the naming scheme of section 9 of docs/v1_spec.md.
# Inputs:  the master table of the panel (by default the synthetic file
#          under data/synthetic/).
# Outputs: PNG figures, CSV tables and sessionInfo.txt under outdir/<panel>/
#          (through R/export.R only), and an invisible list of the stacked
#          tables, the run log and the files written.

#' @title Prepend constant columns to a table
#' @description Puts the given constant values as the first columns of a
#'   data frame (zero-row tables keep zero rows).
#' @param tbl A data frame.
#' @param ... Named scalars to prepend, in order.
#' @return The data frame with the new columns first.
prepend_columns <- function(tbl, ...) {
  consts <- list(...)
  k <- nrow(tbl)
  cols <- lapply(consts, function(v) rep(v, k))
  do.call(data.frame, c(cols, list(tbl, stringsAsFactors = FALSE,
                                   check.names = FALSE)))
}

#' @title Stack a list of data frames
#' @param tables A list of data frames with the same columns.
#' @param template A zero-row data frame returned when the list is empty.
#' @return One data frame.
stack_tables <- function(tables, template) {
  tables <- tables[!vapply(tables, is.null, logical(1))]
  if (length(tables) == 0) {
    return(template)
  }
  out <- do.call(rbind, tables)
  rownames(out) <- NULL
  out
}

#' @title Run one panel end to end
#' @description Reads the master table of the panel, and for each variant
#'   recodes it, writes the two cohort overview figures and count tables,
#'   then for each measure draws and exports the figure with the geometry of
#'   the variant, fits the model and collects the tidy tables. After all
#'   variants the Holm and Benjamini-Hochberg corrections are applied within
#'   panel and variant, the per-measure tables (which then carry p_holm and
#'   p_bh), the panel-level tables, the run log and sessionInfo.txt are
#'   written. A skipped fit never stops the run; the function stops only on
#'   a missing input or an unknown panel, variant or measure.
#' @param panel One of "aggregation", "hemogram", "markers".
#' @param variants Variant ids (default the four of variant_table()).
#' @param measures R names of the measures (default all of panel_spec()).
#' @param data_path Path of the master CSV; when NULL the synthetic file
#'   under data_dir is read.
#' @param data_dir Directory of the synthetic files.
#' @param outdir Output directory.
#' @param fast When TRUE only the first two measures are run.
#' @param label_points Draw the per-point centre labels (default FALSE).
#' @param min_cell Minimum cell size for a printed n.
#' @param seed Seed of the jitter.
#' @param levels List returned by variant_levels().
#' @param verbose Print one line per measure and variant.
#' @return Invisibly, a list with anova, tukey, assumptions, cells, cohort,
#'   log and files.
run_panel <- function(panel, variants = NULL, measures = NULL,
                      data_path = NULL, data_dir = "data/synthetic",
                      outdir = "outputs", fast = FALSE, label_points = FALSE,
                      min_cell = 5, seed = 20211109, levels = variant_levels(),
                      verbose = TRUE) {
  spec <- panel_spec(panel)
  panel <- spec$panel
  vt <- variant_table()
  if (is.null(variants)) {
    variants <- vt$variant
  }
  stopifnot(is.character(variants), length(variants) >= 1,
            is.character(outdir), length(outdir) == 1,
            is.logical(fast), length(fast) == 1,
            is.logical(label_points), length(label_points) == 1,
            is.numeric(min_cell), length(min_cell) == 1,
            is.numeric(seed), length(seed) == 1,
            is.logical(verbose), length(verbose) == 1)
  unknown_variants <- setdiff(variants, vt$variant)
  if (length(unknown_variants) > 0) {
    stop(sprintf("run_panel(): unknown variant(s): %s; expected one of: %s",
                 paste(unknown_variants, collapse = ", "),
                 paste(vt$variant, collapse = ", ")))
  }
  if (is.null(measures)) {
    measures <- spec$measures
  }
  stopifnot(is.character(measures), length(measures) >= 1)
  unknown_measures <- setdiff(measures, spec$measures)
  if (length(unknown_measures) > 0) {
    stop(sprintf("run_panel(): unknown measure(s) for panel '%s': %s",
                 panel, paste(unknown_measures, collapse = ", ")))
  }
  if (isTRUE(fast)) {
    measures <- measures[seq_len(min(2L, length(measures)))]
  }
  if (isTRUE(verbose) && length(measures) < length(spec$measures)) {
    cat(sprintf(paste0("[%s] note: %d of %d measures run; p_holm, p_bh and ",
                       "family_size are computed over these measures only ",
                       "and differ from those of a full panel run\n"),
                panel, length(measures), length(spec$measures)))
  }
  slugs <- spec$slugs[match(measures, spec$measures)]
  labels <- spec$labels[match(measures, spec$measures)]

  data <- read_inputs(panel, path = data_path, data_dir = data_dir)
  data_label <- attr(data, "data_label")
  design <- spec$design
  empty <- empty_fit_tables()

  fits <- list()
  cells_list <- list()
  cohort_list <- list()
  log_rows <- list()
  files <- character(0)

  for (variant in variants) {
    d <- recode_variants(data, variant, levels = levels)
    geom <- vt$geom[vt$variant == variant]

    for (group in c("Gender", "Genotype")) {
      counts <- summarise_cohort(d, group)
      token <- paste0("cohort_", tolower(group))
      fig_path <- output_path(outdir, panel, variant, token, "figure", "png")
      p <- plot_cohort(counts, group,
                       title = paste(group, "by Treatment,", variant),
                       min_cell = min_cell)
      export_figure(p, fig_path)
      counts_out <- data.frame(panel = rep(panel, nrow(counts)),
                               variant = rep(variant, nrow(counts)),
                               group = rep(group, nrow(counts)),
                               Treatment = as.character(counts$Treatment),
                               level = as.character(counts[[group]]),
                               n = as.integer(counts$n),
                               stringsAsFactors = FALSE)
      counts_path <- output_path(outdir, panel, variant, token, "counts", "csv")
      export_table(counts_out, counts_path)
      cohort_list[[length(cohort_list) + 1]] <- counts_out
      files <- c(files, fig_path, counts_path)
    }

    for (i in seq_along(measures)) {
      measure <- measures[i]
      slug <- slugs[i]
      fit <- fit_anova(d, measure, design = design, min_cell = min_cell)
      p <- plot_measure(d, measure, design = design, geom = geom,
                        title = paste(slug, variant),
                        subtitle = paste0(panel, ", n = ", fit$n),
                        caption = data_label, y_label = labels[i],
                        label_points = label_points,
                        label_column = levels$centre_column,
                        min_cell = min_cell, seed = seed)
      fig_path <- output_path(outdir, panel, variant, slug, "figure", "png")
      export_figure(p, fig_path)
      files <- c(files, fig_path)
      key <- paste(variant, measure, sep = "\r")
      fits[[key]] <- list(fit = fit, variant = variant, slug = slug,
                          figure_file = fig_path)
      cells_list[[key]] <- prepend_columns(fit$cells, panel = panel,
                                           variant = variant,
                                           measure = measure)
      if (isTRUE(verbose)) {
        cat(sprintf("[%s] %s / %s: %s (n = %d)%s\n", panel, variant, measure,
                    fit$status, fit$n,
                    if (nzchar(fit$message)) paste0(" ", fit$message) else ""))
      }
    }
  }

  anova_all <- stack_tables(
    lapply(fits, function(f) prepend_columns(tidy_anova(f$fit), panel = panel,
                                             variant = f$variant)),
    prepend_columns(prepend_columns(empty$anova, measure = character(0),
                                    status = character(0), n = integer(0)),
                    panel = character(0), variant = character(0)))
  anova_all <- adjust_p_values(anova_all, by = c("panel", "variant"))

  tukey_all <- list()
  assumptions_all <- list()
  for (key in names(fits)) {
    f <- fits[[key]]
    fit <- f$fit
    rows <- anova_all$variant == f$variant & anova_all$measure == fit$measure
    fit$anova <- anova_all[rows, c("term", "sum_sq", "df", "f_value", "p_raw",
                                   "p_holm", "p_bh", "family_size"),
                           drop = FALSE]
    rownames(fit$anova) <- NULL
    paths <- export_fit(fit, outdir, panel, f$variant, f$slug)
    files <- c(files, unname(paths))
    tukey_all[[key]] <- prepend_columns(tidy_tukey(fit), panel = panel,
                                        variant = f$variant)
    assumptions_all[[key]] <- prepend_columns(tidy_assumptions(fit),
                                              panel = panel,
                                              variant = f$variant)
    log_rows[[key]] <- data.frame(panel = panel, variant = f$variant,
                                  measure = fit$measure, status = fit$status,
                                  n = as.integer(fit$n),
                                  figure_file = f$figure_file,
                                  anova_file = paths[["anova"]],
                                  tukey_file = paths[["tukey"]],
                                  assumptions_file = paths[["assumptions"]],
                                  stringsAsFactors = FALSE)
  }

  tukey_all <- stack_tables(
    tukey_all,
    prepend_columns(prepend_columns(empty$tukey, measure = character(0),
                                    status = character(0), n = integer(0)),
                    panel = character(0), variant = character(0)))
  assumptions_all <- stack_tables(
    assumptions_all,
    prepend_columns(prepend_columns(empty$assumptions, measure = character(0),
                                    status = character(0), n = integer(0)),
                    panel = character(0), variant = character(0)))
  cells_all <- stack_tables(
    cells_list,
    data.frame(panel = character(0), variant = character(0),
               measure = character(0), Genotype = character(0),
               Treatment = character(0), n = integer(0),
               below_min = logical(0), stringsAsFactors = FALSE))
  cohort_all <- stack_tables(
    cohort_list,
    data.frame(panel = character(0), variant = character(0),
               group = character(0), Treatment = character(0),
               level = character(0), n = integer(0),
               stringsAsFactors = FALSE))
  log_all <- stack_tables(
    log_rows,
    data.frame(panel = character(0), variant = character(0),
               measure = character(0), status = character(0), n = integer(0),
               figure_file = character(0), anova_file = character(0),
               tukey_file = character(0), assumptions_file = character(0),
               stringsAsFactors = FALSE))

  panel_dir <- file.path(outdir, panel)
  panel_files <- c(anova = file.path(panel_dir, "anova_all.csv"),
                   tukey = file.path(panel_dir, "tukey_all.csv"),
                   assumptions = file.path(panel_dir, "assumptions_all.csv"),
                   cells = file.path(panel_dir, "cells_all.csv"),
                   log = file.path(panel_dir, "run_log.csv"))
  export_table(anova_all, panel_files[["anova"]])
  export_table(tukey_all, panel_files[["tukey"]])
  export_table(assumptions_all, panel_files[["assumptions"]])
  export_table(cells_all, panel_files[["cells"]])
  export_table(log_all, panel_files[["log"]])
  session_file <- write_session_info(panel_dir, seed = seed)
  files <- c(files, unname(panel_files), session_file)

  if (isTRUE(verbose)) {
    status_counts <- table(log_all$status)
    cat(sprintf("[%s] %d variant(s), %d measure(s), %d fit(s): %s\n", panel,
                length(variants), length(measures), nrow(log_all),
                paste(names(status_counts), status_counts, sep = " = ",
                      collapse = ", ")))
  }

  invisible(list(anova = anova_all, tukey = tukey_all,
                 assumptions = assumptions_all, cells = cells_all,
                 cohort = cohort_all, log = log_all, files = files))
}
