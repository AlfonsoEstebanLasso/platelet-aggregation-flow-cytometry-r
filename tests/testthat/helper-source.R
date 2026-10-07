# tests/testthat/helper-source.R
#
# Purpose: shared setup of the v1.0 tests. Attaches the packages, sources
#   every file under R/ and defines small helpers to locate the repository
#   root and the synthetic data from any working directory (testthat sets
#   the working directory to tests/testthat while the files run).
# Inputs: the files under R/ and the synthetic tables under data/synthetic.
# Outputs: none on disk. Functions defined in the test environment:
#   project_root(), root_path(), synthetic_dir(), with_root(), master_data().

library(dplyr)
library(ggplot2)
library(car)

#' @title Locate the repository root
#' @return The first directory, walking up from the current directory, that
#'   contains run_all.R.
project_root <- function() {
  d <- normalizePath(getwd(), winslash = "/", mustWork = FALSE)
  repeat {
    if (file.exists(file.path(d, "run_all.R"))) return(d)
    parent <- dirname(d)
    if (identical(parent, d)) stop("Repository root not found from ", getwd())
    d <- parent
  }
}

#' @title Build a path relative to the repository root
#' @param ... Path components passed to file.path().
#' @return The path.
root_path <- function(...) file.path(project_root(), ...)

#' @title Directory of the synthetic example tables
#' @return The path of data/synthetic, relative to the repository root.
synthetic_dir <- function() root_path("data", "synthetic")

#' @title Evaluate code with the repository root as working directory
#' @param code Expression evaluated after setwd(project_root()); the
#'   previous working directory is restored afterwards.
#' @return The value of the expression.
with_root <- function(code) {
  old <- setwd(project_root())
  on.exit(setwd(old), add = TRUE)
  code
}

#' @title Read one synthetic master table through read_inputs()
#' @param panel One of "aggregation", "hemogram", "markers".
#' @return The data frame returned by read_inputs() on the synthetic table.
master_data <- function(panel) read_inputs(panel, data_dir = synthetic_dir())

for (f in sort(list.files(root_path("R"), pattern = "[.]R$", full.names = TRUE))) source(f)
