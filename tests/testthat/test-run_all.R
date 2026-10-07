# tests/testthat/test-run_all.R
#
# Purpose: end-to-end checks of run_all.R through Rscript (docs/v1_spec.md,
#   section 10): a fast run of one panel, --help and an unknown option.
# Inputs: run_all.R, R/ and data/synthetic, run from the repository root in
#   a child R process.
# Outputs: none under the repository; the run writes to tempfile().

rscript <- file.path(R.home("bin"), "Rscript")
quote_type <- if (.Platform$OS.type == "windows") "cmd" else "sh"

run_all <- function(args, log_file) {
  with_root(system2(rscript, c("run_all.R", args), stdout = log_file, stderr = log_file))
}

test_that("run_all.R --fast --panel hemogram returns status 0 and writes the session files", {
  base <- tempfile("run_all_")
  dir.create(base, recursive = TRUE)
  outdir <- file.path(base, "out")
  log_file <- file.path(base, "run_all_output.txt")
  status <- run_all(c("--fast", "--panel", "hemogram", "--outdir", shQuote(outdir, type = quote_type)),
                    log_file)
  expect_equal(status, 0, info = paste(readLines(log_file, warn = FALSE), collapse = "\n"))
  expect_true(file.exists(file.path(outdir, "hemogram", "sessionInfo.txt")))
  expect_true(file.exists(file.path(outdir, "sessionInfo.txt")))
  expect_true(file.exists(file.path(outdir, "run_log.csv")))
  expect_true(file.exists(file.path(outdir, "hemogram", "run_log.csv")))
  expect_true(file.exists(file.path(outdir, "hemogram", "CENTRE_A", "EPO_figure.png")))
  expect_false(dir.exists(file.path(outdir, "aggregation")))
  expect_false(dir.exists(file.path(outdir, "markers")))
  log <- utils::read.csv(file.path(outdir, "run_log.csv"), stringsAsFactors = FALSE)
  expect_equal(nrow(log), 8)
  output <- readLines(log_file, warn = FALSE)
  expect_true(any(grepl("Run finished", output, fixed = TRUE)))
})

test_that("run_all.R --help returns status 0 and prints the usage", {
  log_file <- tempfile("run_all_help_", fileext = ".txt")
  status <- run_all("--help", log_file)
  expect_equal(status, 0)
  output <- readLines(log_file, warn = FALSE)
  expect_true(any(grepl("Usage", output, fixed = TRUE)))
  expect_true(any(grepl("--panel", output, fixed = TRUE)))
})

test_that("an unknown option returns status 2", {
  log_file <- tempfile("run_all_unknown_", fileext = ".txt")
  expect_equal(run_all("--bogus", log_file), 2)
  expect_equal(run_all(c("--panel", "proteome"), tempfile(fileext = ".txt")), 2)
  expect_equal(run_all("--outdir", tempfile(fileext = ".txt")), 2)
})
