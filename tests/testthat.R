# tests/testthat.R
#
# Purpose: entry point of the v1.0 test suite. Finds the repository root
#   (the directory that contains run_all.R) by walking up from the location
#   of this file or from the current directory, sets it as the working
#   directory and runs every test file under tests/testthat/ with testthat.
# Inputs: the functions under R/, the synthetic tables under data/synthetic
#   and the test files tests/testthat/test-*.R (helper-source.R is sourced
#   by testthat before the tests).
# Outputs: the test report on the console. Tests write only under
#   tempfile() directories, never under the repository. The process ends
#   with a non-zero status when any test fails (stop_on_failure = TRUE).
# Usage: Rscript tests/testthat.R (from the repository root).

#' @title Find the repository root
#' @return The path of the first directory, walking up from the location of
#'   this file or from the current directory, that contains run_all.R.
find_root <- function() {
  starts <- character(0)
  file_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
  if (length(file_arg) > 0) {
    script <- sub("^--file=", "", file_arg[[1]])
    starts <- c(starts, dirname(normalizePath(script, winslash = "/", mustWork = FALSE)))
  }
  starts <- c(starts, normalizePath(getwd(), winslash = "/", mustWork = FALSE))
  for (start in starts) {
    d <- start
    repeat {
      if (file.exists(file.path(d, "run_all.R"))) return(d)
      parent <- dirname(d)
      if (identical(parent, d)) break
      d <- parent
    }
  }
  stop("Repository root not found: no parent directory contains run_all.R")
}

root <- find_root()
setwd(root)
cat("Running the v1.0 tests from", basename(root), "\n")

testthat::test_dir("tests/testthat", stop_on_failure = TRUE)
