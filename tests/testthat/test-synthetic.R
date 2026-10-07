# tests/testthat/test-synthetic.R
#
# Purpose: checks of the synthetic example tables (docs/v1_spec.md,
#   sections 3 and 4) and of the generator in R/synthetic_data.R.
# Inputs: data/synthetic/synthetic_*.csv, generate_synthetic(), panel_spec().
# Outputs: none under the repository; generated copies go to tempfile().

subject_names <- c("Codigo.Estudio", "Codigo.muestra", "Gender", "Birth.Year",
                   "Genotype", "Treatment", "Centro.Analisis")
r_names <- list(
  aggregation = c(subject_names, "PMA", "CVX", "RISTO", "AGGA", "COL", "TRAP",
                  "UNSTIMULATED.10min", "Time.0min", "UNS.Time.10min.vs.Time.0",
                  "Synthetic"),
  hemogram = c(subject_names, "TPO..pg.ml.", "EPO..mlU.ml.", "WBC.10.6.ml.",
               "RBC...10.9.ml.", "HGB.gr.dl.", "HCT....", "MCV..fl.", "MCH..pg.",
               "MCHC..gr.dl.", "PLT...10.6..ml", "MPV..fl.", "RETIC..", "Neutr.",
               "Lymph.", "Mono.", "Eos.", "Baso.", "Neutr...10.6.ml.",
               "Lymph..10.6.ml.", "Mono..10.6.ml.", "Eos..10.6.ml.",
               "Baso..10.6.ml.", "Synthetic"),
  markers = c(subject_names, "RAW.FSC", "CD61", "CD41", "CD49B", "GPVI", "CD42A",
              "CD42B", "CD31", "CD36", "CD9", "FSC.unstained", "Synthetic")
)
synthetic_files <- c(aggregation = "synthetic_aggregation.csv",
                     hemogram = "synthetic_hemogram.csv",
                     markers = "synthetic_markers.csv")
panels <- names(synthetic_files)
genotype_counts <- c("CNTRL" = 20, "JAK2 V617F" = 25, "CALR Type I" = 12,
                     "CALR Type II" = 8, "CALR Type_Other" = 4, "MPL W515" = 6,
                     "TN" = 15, "VARIANT" = 10)

read_raw <- function(panel) {
  read.csv2(file.path(synthetic_dir(), synthetic_files[[panel]]),
            check.names = TRUE, stringsAsFactors = FALSE,
            na.strings = c("", "NA"))
}

within_bounds <- function(x, lower, upper) {
  x <- x[!is.na(x)]
  length(x) > 0 && all(x >= lower & x <= upper)
}

test_that("the three synthetic CSV files exist", {
  for (panel in panels) {
    expect_true(file.exists(file.path(synthetic_dir(), synthetic_files[[panel]])),
                info = panel)
  }
})

test_that("each synthetic table has 100 rows", {
  for (panel in panels) {
    expect_equal(nrow(read_raw(panel)), 100, info = panel)
  }
})

test_that("the header of each file yields exactly the R names of the spec, in order", {
  for (panel in panels) {
    expect_identical(names(read_raw(panel)), r_names[[panel]], info = panel)
  }
})

test_that("Codigo.Estudio is unique and starts with SYN-", {
  for (panel in panels) {
    codes <- read_raw(panel)$Codigo.Estudio
    expect_false(anyDuplicated(codes) > 0, info = panel)
    expect_true(all(startsWith(codes, "SYN-")), info = panel)
  }
})

test_that("Synthetic equals SYNTHETIC in every row", {
  for (panel in panels) {
    expect_true(all(read_raw(panel)$Synthetic == "SYNTHETIC"), info = panel)
  }
})

test_that("genotype counts match section 3.2", {
  for (panel in panels) {
    counts <- table(read_raw(panel)$Genotype)
    expect_setequal(names(counts), names(genotype_counts))
    expect_equal(as.integer(counts[names(genotype_counts)]),
                 unname(genotype_counts), info = panel)
  }
})

test_that("centre counts are 75 CENTRE_A and 25 CENTRE_B", {
  for (panel in panels) {
    centre <- read_raw(panel)$Centro.Analisis
    expect_equal(sum(centre == "CENTRE_A"), 75, info = panel)
    expect_equal(sum(centre == "CENTRE_B"), 25, info = panel)
  }
})

test_that("every CNTRL subject is Untreated", {
  for (panel in panels) {
    d <- read_raw(panel)
    expect_true(all(d$Treatment[d$Genotype == "CNTRL"] == "Untreated"), info = panel)
    expect_true(all(d$Treatment %in% c("Untreated", "ASA", "Anagrelide", "HU")),
                info = panel)
  }
})

test_that("TRAP is missing in CENTRE_B and present in at least 60 CENTRE_A rows", {
  d <- read_raw("aggregation")
  expect_true(all(is.na(d$TRAP[d$Centro.Analisis == "CENTRE_B"])))
  expect_gte(sum(!is.na(d$TRAP[d$Centro.Analisis == "CENTRE_A"])), 60)
})

test_that("GPVI, CD42A and CD9 are missing in CENTRE_B and mostly present in CENTRE_A", {
  d <- read_raw("markers")
  for (m in c("GPVI", "CD42A", "CD9")) {
    expect_true(all(is.na(d[[m]][d$Centro.Analisis == "CENTRE_B"])), info = m)
    expect_gte(sum(!is.na(d[[m]][d$Centro.Analisis == "CENTRE_A"])), 60)
  }
})

test_that("the ratio equals UNSTIMULATED.10min / Time.0min within 1e-3", {
  d <- read_raw("aggregation")
  expect_false(anyNA(d$UNSTIMULATED.10min))
  expect_false(anyNA(d$Time.0min))
  expect_false(anyNA(d$UNS.Time.10min.vs.Time.0))
  expect_true(all(abs(d$UNS.Time.10min.vs.Time.0 -
                        d$UNSTIMULATED.10min / d$Time.0min) < 1e-3))
})

test_that("every clipped measure lies within its bounds", {
  a <- read_raw("aggregation")
  for (m in c("PMA", "CVX", "RISTO", "AGGA", "COL", "TRAP")) {
    expect_true(within_bounds(a[[m]], 0, 100), info = m)
  }
  expect_true(within_bounds(a$Time.0min, 1, 30))
  expect_true(within_bounds(a$UNSTIMULATED.10min, 1, 40))
  h <- read_raw("hemogram")
  bounds <- list("WBC.10.6.ml." = c(2.5, 20), "RBC...10.9.ml." = c(3, 6.5),
                 "HGB.gr.dl." = c(8, 18), "HCT...." = c(25, 55),
                 "MCV..fl." = c(65, 110), "MCH..pg." = c(20, 38),
                 "MCHC..gr.dl." = c(28, 37), "PLT...10.6..ml" = c(100, 1500),
                 "MPV..fl." = c(6, 14), "RETIC.." = c(0.1, 4))
  for (m in names(bounds)) {
    expect_true(within_bounds(h[[m]], bounds[[m]][1], bounds[[m]][2]), info = m)
  }
  expect_true(within_bounds(h$TPO..pg.ml., 0, Inf))
  expect_true(within_bounds(h$EPO..mlU.ml., 0, Inf))
})

test_that("the differential percentages sum to 100 within 0.5", {
  h <- read_raw("hemogram")
  pct <- h[, c("Neutr.", "Lymph.", "Mono.", "Eos.", "Baso.")]
  complete <- stats::complete.cases(pct)
  expect_gt(sum(complete), 80)
  sums <- rowSums(pct[complete, ])
  expect_true(all(abs(sums - 100) <= 0.5))
  missing_rows <- is.na(h$WBC.10.6.ml.)
  expect_true(all(is.na(h$Neutr.[missing_rows])))
})

test_that("generate_synthetic(write = FALSE) called twice gives identical data frames", {
  first <- generate_synthetic(outdir = tempfile("syn_"), write = FALSE)
  second <- generate_synthetic(outdir = tempfile("syn_"), write = FALSE)
  expect_identical(first, second)
  expect_setequal(names(first), c("cohort", "aggregation", "hemogram", "markers"))
  for (panel in panels) {
    expect_equal(nrow(first[[panel]]), 100, info = panel)
    expect_identical(names(first[[panel]]), r_names[[panel]], info = panel)
  }
  expect_false(file.exists(file.path(tempdir(), synthetic_files[["aggregation"]])))
})

test_that("the raw header mapping of generate_synthetic() agrees with panel_spec()$raw_headers", {
  outdir <- tempfile("syn_")
  generated <- generate_synthetic(outdir = outdir, write = TRUE)
  for (panel in panels) {
    spec <- panel_spec(panel)
    expect_identical(spec$synthetic_file, synthetic_files[[panel]], info = panel)
    written <- file.path(outdir, spec$synthetic_file)
    expect_true(file.exists(written), info = panel)
    header <- strsplit(readLines(written, n = 1), ";", fixed = TRUE)[[1]]
    expect_identical(header, unname(spec$raw_headers), info = panel)
    expect_identical(names(spec$raw_headers), names(generated[[panel]]), info = panel)
    expect_identical(names(spec$raw_headers), r_names[[panel]], info = panel)
    committed <- file.path(synthetic_dir(), spec$synthetic_file)
    expect_identical(readLines(written), readLines(committed), info = panel)
  }
})
