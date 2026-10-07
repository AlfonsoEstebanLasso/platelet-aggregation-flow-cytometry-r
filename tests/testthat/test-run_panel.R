# tests/testthat/test-run_panel.R
#
# Purpose: checks of run_panel() (docs/v1_spec.md, sections 8.6 and 9) on
#   the synthetic hemogram and marker tables.
# Inputs: data/synthetic/synthetic_hemogram.csv and
#   data/synthetic/synthetic_markers.csv through run_panel().
# Outputs: none under the repository; every file goes to tempfile().

variant_ids <- c("CENTRE_A", "CENTRE_Atratadosnotratados",
                 "CENTRE_AtratadosnotratadosMPLCONTN", "CENTRE_ATNCONMPL")
valid_status <- c("ok", "ok_aliased", "skipped_no_data", "skipped_single_level",
                  "skipped_no_residual_df", "error")
anova_columns <- c("panel", "variant", "measure", "status", "n", "term", "sum_sq",
                   "df", "f_value", "p_raw", "p_holm", "p_bh", "family_size")
log_columns <- c("panel", "variant", "measure", "status", "n", "figure_file",
                 "anova_file", "tukey_file", "assumptions_file")

test_that("run_panel('hemogram', fast = TRUE) writes every expected file and a log of 8 rows", {
  outdir <- tempfile("run_panel_")
  result <- run_panel("hemogram", fast = TRUE, data_dir = synthetic_dir(),
                      outdir = outdir, verbose = FALSE)
  expect_type(result, "list")
  expect_true(all(c("anova", "tukey", "assumptions", "cells", "cohort", "log", "files")
                  %in% names(result)))
  slugs <- panel_spec("hemogram")$slugs[1:2]
  expect_identical(slugs, c("EPO", "TPO"))
  for (variant in variant_ids) {
    dir <- file.path(outdir, "hemogram", variant)
    expected <- c("cohort_gender_figure.png", "cohort_genotype_figure.png",
                  "cohort_gender_counts.csv", "cohort_genotype_counts.csv",
                  paste0(rep(slugs, each = 4),
                         c("_figure.png", "_anova.csv", "_tukey.csv", "_assumptions.csv")))
    for (f in expected) {
      expect_true(file.exists(file.path(dir, f)), info = file.path(variant, f))
    }
    expect_setequal(list.files(dir), expected)
  }
  panel_files <- c("anova_all.csv", "tukey_all.csv", "assumptions_all.csv",
                   "cells_all.csv", "run_log.csv", "sessionInfo.txt")
  for (f in panel_files) {
    expect_true(file.exists(file.path(outdir, "hemogram", f)), info = f)
  }
  expect_true(all(file.exists(result$files)))
  expect_true(all(startsWith(normalizePath(result$files, winslash = "/", mustWork = FALSE),
                             normalizePath(outdir, winslash = "/", mustWork = FALSE))))
  expect_equal(sum(grepl("[.]png$", result$files)), 4 * (2 + 2))
  expect_false(dir.exists(file.path(outdir, "aggregation")))

  log <- result$log
  expect_s3_class(log, "data.frame")
  expect_identical(names(log), log_columns)
  expect_equal(nrow(log), 8)
  expect_true(all(log$status %in% valid_status))
  expect_true(all(log$panel == "hemogram"))
  expect_setequal(log$variant, variant_ids)
  expect_setequal(log$measure, panel_spec("hemogram")$measures[1:2])
  expect_true(all(file.exists(file.path(outdir, "hemogram", log$variant, basename(log$figure_file)))))

  written_log <- utils::read.csv(file.path(outdir, "hemogram", "run_log.csv"),
                                 stringsAsFactors = FALSE)
  expect_identical(names(written_log), log_columns)
  expect_equal(nrow(written_log), 8)

  expect_identical(names(result$anova)[1:3], c("panel", "variant", "measure"))
  expect_identical(names(result$cells), c("panel", "variant", "measure", "Genotype",
                                          "Treatment", "n", "below_min"))
  expect_identical(names(result$cohort)[1:3], c("panel", "variant", "group"))
  counts <- utils::read.csv(file.path(outdir, "hemogram", "CENTRE_A", "cohort_gender_counts.csv"),
                            stringsAsFactors = FALSE)
  expect_identical(names(counts), c("panel", "variant", "group", "Treatment", "level", "n"))
  expect_equal(sum(counts$n), 75)
})

test_that("anova_all.csv has the column set of section 9 and p_holm for every ok row", {
  outdir <- tempfile("run_panel_")
  run_panel("hemogram", fast = TRUE, data_dir = synthetic_dir(), outdir = outdir,
            verbose = FALSE)
  anova_all <- utils::read.csv(file.path(outdir, "hemogram", "anova_all.csv"),
                               stringsAsFactors = FALSE)
  expect_identical(names(anova_all), anova_columns)
  tested <- anova_all$status %in% c("ok", "ok_aliased") & anova_all$term != "Residuals"
  expect_true(sum(tested) > 0)
  expect_false(anyNA(anova_all$p_holm[tested]))
  expect_false(anyNA(anova_all$p_bh[tested]))
  expect_false(anyNA(anova_all$family_size[tested]))
  expect_true(all(anova_all$p_holm[tested] >= anova_all$p_raw[tested] - 1e-12))
  expect_true(all(is.na(anova_all$p_raw[anova_all$term == "Residuals"])))
  for (variant in variant_ids) {
    rows <- tested & anova_all$variant == variant
    expect_true(all(anova_all$family_size[rows] == sum(rows)), info = variant)
  }
  per_measure <- utils::read.csv(file.path(outdir, "hemogram", "CENTRE_A", "EPO_anova.csv"),
                                 stringsAsFactors = FALSE)
  expect_identical(names(per_measure), anova_columns)
  tukey_all <- utils::read.csv(file.path(outdir, "hemogram", "tukey_all.csv"),
                               stringsAsFactors = FALSE)
  expect_identical(names(tukey_all), c("panel", "variant", "measure", "status", "n", "term",
                                       "comparison", "diff", "lwr", "upr", "p_adj"))
  assumptions_all <- utils::read.csv(file.path(outdir, "hemogram", "assumptions_all.csv"),
                                     stringsAsFactors = FALSE)
  expect_identical(names(assumptions_all), c("panel", "variant", "measure", "status", "n",
                                             "test", "statistic", "p_value", "note"))
  session <- readLines(file.path(outdir, "hemogram", "sessionInfo.txt"))
  expect_true(any(grepl("R version", session, fixed = TRUE)))
})

test_that("run_panel('markers', variants = 'CENTRE_A', measures = 'GPVI') runs without error", {
  outdir <- tempfile("run_panel_")
  expect_error(result <- run_panel("markers", variants = "CENTRE_A", measures = "GPVI",
                                   data_dir = synthetic_dir(), outdir = outdir,
                                   verbose = FALSE),
               regexp = NA)
  expect_equal(nrow(result$log), 1)
  expect_identical(result$log$measure, "GPVI")
  expect_identical(result$log$variant, "CENTRE_A")
  expect_true(file.exists(file.path(outdir, "markers", "CENTRE_A", "GPVI_figure.png")))
  expect_true(file.exists(file.path(outdir, "markers", "CENTRE_A", "GPVI_anova.csv")))
  expect_false(dir.exists(file.path(outdir, "markers", "CENTRE_ATNCONMPL")))
  expect_true(file.exists(file.path(outdir, "markers", "sessionInfo.txt")))
})

test_that("an unknown variant or measure errors before writing anything", {
  outdir <- tempfile("run_panel_")
  expect_error(run_panel("hemogram", variants = "CENTRE_B", data_dir = synthetic_dir(),
                         outdir = outdir, verbose = FALSE))
  expect_length(list.files(outdir, recursive = TRUE, all.files = TRUE), 0)
  expect_error(run_panel("hemogram", measures = "PMA", data_dir = synthetic_dir(),
                         outdir = outdir, verbose = FALSE))
  expect_length(list.files(outdir, recursive = TRUE, all.files = TRUE), 0)
  expect_error(run_panel("proteome", data_dir = synthetic_dir(), outdir = outdir,
                         verbose = FALSE))
  expect_length(list.files(outdir, recursive = TRUE, all.files = TRUE), 0)
})
