# run_all.R
#
# Purpose: command line entry point of v1.0. Runs the three analysis panels
#   (aggregation, hemogram, markers) of the first centre with the 2021-11-09
#   cut-off, each from one master table, through run_panel(), and writes the
#   figures, tables, run log and session information of docs/v1_spec.md,
#   section 9.
# Inputs: the master tables under --data (default data/synthetic, the
#   synthetic example tables that carry no biological meaning) and the
#   functions under R/ (sourced in alphabetical order).
# Outputs: under --outdir (default outputs/example) one directory per panel
#   with the figures (PNG), tables (CSV), run_log.csv and sessionInfo.txt of
#   run_panel(), plus <outdir>/run_log.csv (the logs of every panel stacked)
#   and <outdir>/sessionInfo.txt written by this script.
# Usage:
#   Rscript run_all.R [--panel all|aggregation|hemogram|markers]
#                     [--variant <id>[,<id>...]]
#                     [--outdir <dir>] [--data <dir>]
#                     [--fast] [--label-points] [--help]
# Exit status: 0 on success (also after --help), 2 on an unknown option or
#   an invalid value, non-zero on any uncaught error (Rscript default).
# The command line is parsed in base R (no optparse). Options may be given
#   as "--outdir dir" or "--outdir=dir". --fast keeps every variant but only
#   the first two measures of each panel.

#' @title Usage text of run_all.R
#' @return A single string with the usage message.
usage_text <- function() {
  paste0(
    "Usage: Rscript run_all.R [options]\n",
    "\n",
    "Options:\n",
    "  --panel <name>        all (default), aggregation, hemogram or markers\n",
    "  --variant <id>[,...]  variant ids to run (default: the four variants of\n",
    "                        docs/v1_spec.md, section 5): CENTRE_A,\n",
    "                        CENTRE_Atratadosnotratados,\n",
    "                        CENTRE_AtratadosnotratadosMPLCONTN, CENTRE_ATNCONMPL\n",
    "  --outdir <dir>        output directory (default: outputs/example)\n",
    "  --data <dir>          directory of the master tables (default: data/synthetic)\n",
    "  --fast                first two measures of each panel only\n",
    "  --label-points        print the centre label next to every point\n",
    "  --help                print this message and exit\n",
    "\n",
    "Options take their value as '--outdir dir' or '--outdir=dir'.\n",
    "Run from the repository root.\n"
  )
}

#' @title Parse the command line of run_all.R
#' @param args Character vector, normally commandArgs(trailingOnly = TRUE).
#' @return A list with the elements panel (string), variants (character or
#'   NULL for all), outdir, data (strings), fast, label_points, help
#'   (logical) and error (NULL, or the text of the first problem found).
parse_args <- function(args) {
  stopifnot(is.character(args))
  opts <- list(panel = "all", variants = NULL, outdir = "outputs/example",
               data = "data/synthetic", fast = FALSE, label_points = FALSE,
               help = FALSE, error = NULL)
  value_options <- c("--panel", "--variant", "--outdir", "--data")
  flag_options <- c("--fast", "--label-points", "--help")
  valid_panels <- c("all", "aggregation", "hemogram", "markers")
  i <- 1L
  while (i <= length(args)) {
    arg <- args[[i]]
    key <- arg
    value <- NULL
    if (grepl("^--[A-Za-z-]+=", arg)) {
      key <- sub("=.*$", "", arg)
      value <- sub("^[^=]*=", "", arg)
    }
    if (key %in% value_options) {
      if (is.null(value)) {
        if (i == length(args)) {
          opts$error <- paste("Option", key, "needs a value")
          return(opts)
        }
        i <- i + 1L
        value <- args[[i]]
      }
      if (!nzchar(value)) {
        opts$error <- paste("Option", key, "needs a non-empty value")
        return(opts)
      }
      if (key == "--panel") {
        opts$panel <- value
      } else if (key == "--variant") {
        ids <- trimws(strsplit(value, ",", fixed = TRUE)[[1]])
        ids <- unique(ids[nzchar(ids)])
        if (length(ids) == 0) {
          opts$error <- "Option --variant needs at least one id"
          return(opts)
        }
        opts$variants <- ids
      } else if (key == "--outdir") {
        opts$outdir <- value
      } else {
        opts$data <- value
      }
    } else if (key %in% flag_options) {
      if (!is.null(value)) {
        opts$error <- paste("Option", key, "takes no value")
        return(opts)
      }
      if (key == "--fast") {
        opts$fast <- TRUE
      } else if (key == "--label-points") {
        opts$label_points <- TRUE
      } else {
        opts$help <- TRUE
      }
    } else {
      opts$error <- paste("Unknown option:", arg)
      return(opts)
    }
    i <- i + 1L
  }
  if (!opts$panel %in% valid_panels) {
    opts$error <- paste0("Unknown panel '", opts$panel, "' (expected one of ",
                         paste(valid_panels, collapse = ", "), ")")
  }
  opts
}

#' @title Print the run summary
#' @param panels Character vector of the panels run.
#' @param log Data frame, the stacked log element of run_panel().
#' @param files Character vector of every file written by the panels.
#' @param outdir Output directory (string).
#' @param elapsed Elapsed time in seconds (numeric).
#' @return NULL, invisibly. Prints to standard output.
print_summary <- function(panels, log, files, outdir, elapsed) {
  status_counts <- table(factor(log$status))
  cat("\nRun finished\n")
  cat("  Panels run:        ", paste(panels, collapse = ", "), "\n", sep = "")
  cat("  Variants:          ", paste(unique(log$variant), collapse = ", "), "\n", sep = "")
  cat("  Figures written:   ", sum(grepl("[.]png$", files)), "\n", sep = "")
  cat("  Tables written:    ", sum(grepl("[.]csv$", files)), "\n", sep = "")
  cat("  Fits:              ", nrow(log), "\n", sep = "")
  cat("  Fits by status:    ",
      paste(paste0(names(status_counts), " = ", as.integer(status_counts)),
            collapse = ", "), "\n", sep = "")
  cat("  Output directory:  ", outdir, "\n", sep = "")
  cat("  Elapsed:           ", sprintf("%.1f s", elapsed), "\n", sep = "")
  invisible(NULL)
}

# ---- Script flow -----------------------------------------------------------

opts <- parse_args(commandArgs(trailingOnly = TRUE))

if (isTRUE(opts$help)) {
  cat(usage_text())
  quit(save = "no", status = 0)
}
if (!is.null(opts$error)) {
  message("run_all.R: ", opts$error)
  cat(usage_text(), file = stderr())
  quit(save = "no", status = 2)
}
if (!dir.exists("R") || !file.exists("run_all.R")) {
  stop("run_all.R must be run from the repository root (the directory ",
       "that contains run_all.R and R/)")
}

for (f in sort(list.files("R", pattern = "[.]R$", full.names = TRUE))) source(f)

library(dplyr)
library(ggplot2)
library(car)

panels <- if (opts$panel == "all") c("aggregation", "hemogram", "markers") else opts$panel
started <- Sys.time()
results <- list()
for (panel in panels) {
  cat("== Panel ", panel, if (opts$fast) " (fast mode)" else "", " ==\n", sep = "")
  results[[panel]] <- run_panel(
    panel = panel,
    variants = opts$variants,
    data_dir = opts$data,
    outdir = opts$outdir,
    fast = opts$fast,
    label_points = opts$label_points,
    verbose = TRUE
  )
}

log_all <- do.call(rbind, lapply(results, function(r) r$log))
rownames(log_all) <- NULL
files_all <- unlist(lapply(results, function(r) r$files), use.names = FALSE)

log_path <- export_table(log_all, file.path(opts$outdir, "run_log.csv"))
session_path <- write_session_info(opts$outdir)
cat("Run log:          ", log_path, "\n", sep = "")
cat("Session info:     ", session_path, "\n", sep = "")

print_summary(panels, log_all, files_all, opts$outdir,
              as.numeric(difftime(Sys.time(), started, units = "secs")))

quit(save = "no", status = 0)
