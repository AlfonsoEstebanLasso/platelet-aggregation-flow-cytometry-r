# tests/testthat/test-read_inputs.R
#
# Purpose: checks of panel_spec() and read_inputs() (docs/v1_spec.md,
#   section 8.1) on the synthetic tables.
# Inputs: data/synthetic/synthetic_*.csv through read_inputs().
# Outputs: none under the repository; modified copies go to tempfile().

subject_names <- c("Codigo.Estudio", "Codigo.muestra", "Gender", "Birth.Year",
                   "Genotype", "Treatment", "Centro.Analisis")
genotype_levels <- c("CNTRL", "JAK2 V617F", "CALR Type I", "CALR Type II",
                     "CALR Type_Other", "MPL W515", "TN", "VARIANT")
treatment_levels <- c("Untreated", "ASA", "Anagrelide", "HU")
centre_levels <- c("CENTRE_A", "CENTRE_B")

write_modified_copy <- function(panel, modify) {
  spec <- panel_spec(panel)
  raw <- read.csv2(file.path(synthetic_dir(), spec$synthetic_file),
                   check.names = TRUE, stringsAsFactors = FALSE,
                   na.strings = c("", "NA"))
  raw <- modify(raw)
  path <- tempfile(paste0("modified_", panel, "_"), fileext = ".csv")
  write.csv2(raw, path, row.names = FALSE, na = "", quote = FALSE, eol = "\n")
  path
}

test_that("panel_spec() returns 9, 14 and 10 measures with slugs and labels of equal length", {
  expected <- c(aggregation = 9L, hemogram = 14L, markers = 10L)
  designs <- c(aggregation = "two_way", hemogram = "one_way", markers = "two_way")
  for (panel in names(expected)) {
    spec <- panel_spec(panel)
    expect_identical(spec$panel, panel)
    expect_identical(spec$design, designs[[panel]])
    expect_length(spec$measures, expected[[panel]])
    expect_length(spec$slugs, expected[[panel]])
    expect_length(spec$labels, expected[[panel]])
    expect_false(anyDuplicated(spec$slugs) > 0)
    expect_identical(spec$subject_columns, subject_names)
    expect_true(all(spec$measures %in% names(spec$raw_headers)))
    expect_true("Synthetic" %in% names(spec$raw_headers))
  }
  expect_identical(panel_spec("aggregation")$measures[1:3], c("PMA", "CVX", "RISTO"))
  expect_identical(panel_spec("aggregation")$slugs[7:9],
                   c("UNSTIMULATED_10min", "Time_0min", "UNS_ratio"))
  expect_identical(panel_spec("hemogram")$measures[1:2], c("EPO..mlU.ml.", "TPO..pg.ml."))
  expect_length(panel_spec("hemogram")$extra_columns, 8)
  expect_identical(panel_spec("markers")$extra_columns, "RAW.FSC")
  expect_length(panel_spec("aggregation")$extra_columns, 0)
})

test_that("read_inputs() returns 100 rows with factors in the spec order and numeric measures", {
  for (panel in c("aggregation", "hemogram", "markers")) {
    d <- master_data(panel)
    expect_s3_class(d, "data.frame")
    expect_false(inherits(d, "tbl_df"))
    expect_equal(nrow(d), 100, info = panel)
    expect_true(all(subject_names %in% names(d)), info = panel)
    expect_s3_class(d$Gender, "factor")
    expect_identical(levels(d$Gender), c("F", "M"))
    expect_identical(levels(d$Genotype), genotype_levels)
    expect_identical(levels(d$Treatment), treatment_levels)
    expect_identical(levels(d$Centro.Analisis), centre_levels)
    expect_type(d$Codigo.Estudio, "character")
    spec <- panel_spec(panel)
    for (m in c(spec$measures, spec$extra_columns)) {
      expect_true(is.numeric(d[[m]]), info = paste(panel, m))
    }
    expect_identical(attr(d, "panel"), panel)
    expect_true(nzchar(attr(d, "source")))
  }
})

test_that("the Synthetic column is dropped and data_label says synthetic", {
  d <- master_data("aggregation")
  expect_false("Synthetic" %in% names(d))
  expect_identical(attr(d, "data_label"),
                   "synthetic example data (no biological meaning)")
})

test_that("a file with a missing measure column raises an error naming the column", {
  path <- write_modified_copy("aggregation", function(raw) {
    raw$PMA <- NULL
    raw
  })
  expect_error(read_inputs("aggregation", path = path), "PMA")
})

test_that("a measure column with text raises an error naming the column", {
  path <- write_modified_copy("markers", function(raw) {
    raw$CD61 <- as.character(raw$CD61)
    raw$CD61[1] <- "not_a_number"
    raw
  })
  expect_error(suppressWarnings(read_inputs("markers", path = path)), "CD61")
})

test_that("an unknown panel errors", {
  expect_error(panel_spec("proteome"))
  expect_error(read_inputs("proteome", data_dir = synthetic_dir()))
})
