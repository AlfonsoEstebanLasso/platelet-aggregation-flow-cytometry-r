# tests/testthat/test-summarise_cohort.R
#
# Purpose: checks of summarise_cohort() and plot_cohort() (docs/v1_spec.md,
#   sections 8.2 and 8.3) on the synthetic aggregation table.
# Inputs: data/synthetic/synthetic_aggregation.csv through read_inputs().
# Outputs: none.

master <- master_data("aggregation")

test_that("n sums to nrow(data) and the columns are those of the spec", {
  for (group in c("Gender", "Genotype")) {
    s <- summarise_cohort(master, group = group)
    expect_s3_class(s, "data.frame")
    expect_identical(names(s), c("Treatment", group, "n", "label_y"))
    expect_equal(sum(s$n), nrow(master), info = group)
    expect_true(all(s$n > 0), info = group)
    expect_true(is.numeric(s$label_y), info = group)
  }
  rec <- recode_variants(master, "CENTRE_Atratadosnotratados")
  s <- summarise_cohort(rec, group = "Genotype")
  expect_equal(sum(s$n), nrow(rec))
  expect_true(all(as.character(s$Treatment) %in% c("Untreated", "Treated")))
})

test_that("a missing Gender appears as the level (missing)", {
  s <- summarise_cohort(master, group = "Gender")
  expect_true("(missing)" %in% as.character(s$Gender))
  expect_equal(sum(s$n[as.character(s$Gender) == "(missing)"]), sum(is.na(master$Gender)))
  expect_equal(sum(is.na(master$Gender)), 2)
})

test_that("no observed level is dropped", {
  s <- summarise_cohort(master, group = "Genotype")
  observed <- sort(unique(as.character(master$Genotype)))
  expect_setequal(as.character(unique(s$Genotype)), observed)
  for (g in observed) {
    expect_equal(sum(s$n[as.character(s$Genotype) == g]), sum(master$Genotype == g), info = g)
  }
  for (t in levels(master$Treatment)) {
    expect_equal(sum(s$n[as.character(s$Treatment) == t]), sum(master$Treatment == t), info = t)
  }
  expect_false(anyNA(s$Genotype))
})

test_that("plot_cohort() returns a ggplot", {
  for (group in c("Gender", "Genotype")) {
    s <- summarise_cohort(master, group = group)
    p <- plot_cohort(s, group = group, title = paste("Cohort by", group))
    expect_s3_class(p, "ggplot")
    expect_silent(built <- ggplot2::ggplot_build(p))
    expect_true(length(built$data) >= 1)
  }
})
