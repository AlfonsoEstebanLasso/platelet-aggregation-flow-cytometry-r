# tests/testthat/test-export.R
#
# Purpose: checks of the export helpers of R/export.R (docs/v1_spec.md,
#   sections 7, 8.7 and 9).
# Inputs: data/synthetic/synthetic_aggregation.csv through read_inputs()
#   (for a figure and a skipped fit).
# Outputs: none under the repository; every file goes to tempfile().

test_that("output_path() builds the exact scheme of section 9 and rejects unknown kinds", {
  expect_identical(output_path("out", "hemogram", "CENTRE_A", "EPO", "anova", "csv"),
                   file.path("out", "hemogram", "CENTRE_A", "EPO_anova.csv"))
  expect_identical(output_path("out", "aggregation", "CENTRE_ATNCONMPL", "UNS_ratio", "figure", "png"),
                   file.path("out", "aggregation", "CENTRE_ATNCONMPL", "UNS_ratio_figure.png"))
  expect_identical(output_path("out", "markers", "CENTRE_A", "cohort_gender", "counts", "csv"),
                   file.path("out", "markers", "CENTRE_A", "cohort_gender_counts.csv"))
  expect_identical(output_path("out", "markers", "CENTRE_A", "CD9", "tukey", "csv"),
                   file.path("out", "markers", "CENTRE_A", "CD9_tukey.csv"))
  expect_identical(output_path("out", "markers", "CENTRE_A", "CD9", "assumptions", "csv"),
                   file.path("out", "markers", "CENTRE_A", "CD9_assumptions.csv"))
  expect_error(output_path("out", "hemogram", "CENTRE_A", "EPO", "summary", "csv"))
  expect_error(output_path("out", "hemogram", "CENTRE_A", "EPO", "anova", "pdf"))
  expect_false(dir.exists(file.path("out", "hemogram")))
})

test_that("export_table() writes a readable CSV with the same columns", {
  df <- data.frame(panel = "hemogram", variant = "CENTRE_A", measure = "EPO..mlU.ml.",
                   p_raw = c(0.5, NA), note = c("", "x"), stringsAsFactors = FALSE)
  path <- file.path(tempfile("export_"), "nested", "table.csv")
  returned <- export_table(df, path)
  expect_identical(returned, path)
  expect_true(file.exists(path))
  back <- utils::read.csv(path, stringsAsFactors = FALSE)
  expect_identical(names(back), names(df))
  expect_equal(nrow(back), nrow(df))
  expect_equal(back$p_raw, df$p_raw)
  first_line <- readLines(path, n = 1)
  expect_true(grepl(",", first_line, fixed = TRUE))
  expect_false(grepl(";", first_line, fixed = TRUE))
})

test_that("export_figure() writes a PNG file larger than 1 kB", {
  agg <- recode_variants(master_data("aggregation"), "CENTRE_A")
  p <- plot_measure(agg, "PMA", design = "two_way")
  path <- file.path(tempfile("figure_"), "PMA_figure.png")
  returned <- export_figure(p, path)
  expect_identical(returned, path)
  expect_true(file.exists(path))
  expect_gt(file.size(path), 1024)
  signature <- readBin(path, "raw", n = 8)
  expect_identical(signature, as.raw(c(0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a)))
})

test_that("write_session_info() records R version and the seed without any absolute path", {
  dir <- tempfile("session_")
  dir.create(dir, recursive = TRUE)
  path <- write_session_info(dir)
  expect_identical(path, file.path(dir, "sessionInfo.txt"))
  expect_true(file.exists(path))
  lines <- readLines(path)
  expect_true(any(grepl("R version", lines, fixed = TRUE)))
  expect_true(any(grepl("20211109", lines, fixed = TRUE)))
  expect_false(any(grepl("[A-Za-z]:[/\\\\]", lines)))
  expect_false(any(grepl("(^|[[:space:]=:\"'])/[A-Za-z]", lines)))
  expect_false(any(grepl(normalizePath(dir, winslash = "/"), lines, fixed = TRUE)))
  expect_false(any(grepl("LC_|locale:", lines)))
  expect_true(any(grepl("[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}", lines)))
  other <- write_session_info(dir, file = "other.txt", seed = 1234)
  expect_identical(other, file.path(dir, "other.txt"))
  expect_true(any(grepl("1234", readLines(other), fixed = TRUE)))
})

test_that("export_fit() on a skipped fit writes three header-only files", {
  agg <- recode_variants(master_data("aggregation"), "CENTRE_A")
  agg$PMA <- NA_real_
  fit <- fit_anova(agg, "PMA", design = "two_way")
  expect_identical(fit$status, "skipped_no_data")
  outdir <- tempfile("fit_")
  paths <- export_fit(fit, outdir, "aggregation", "CENTRE_A", "PMA")
  expected <- file.path(outdir, "aggregation", "CENTRE_A",
                        c("PMA_anova.csv", "PMA_tukey.csv", "PMA_assumptions.csv"))
  expect_setequal(unname(unlist(paths)), expected)
  for (f in expected) {
    expect_true(file.exists(f), info = f)
    expect_length(readLines(f), 1)
    expect_equal(nrow(utils::read.csv(f)), 0, info = f)
  }
  expect_true(all(c("term", "p_raw") %in% names(utils::read.csv(expected[1]))))
  expect_true(all(c("term", "comparison", "p_adj") %in% names(utils::read.csv(expected[2]))))
  expect_true(all(c("test", "p_value", "note") %in% names(utils::read.csv(expected[3]))))
})
