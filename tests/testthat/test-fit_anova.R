# tests/testthat/test-fit_anova.R
#
# Purpose: checks of fit_anova(), adjust_p_values() and the tidy_*()
#   helpers (docs/v1_spec.md, sections 6, 8.4 and 8.5) on the synthetic
#   tables and on small constructed designs.
# Inputs: data/synthetic/synthetic_aggregation.csv and
#   data/synthetic/synthetic_hemogram.csv through read_inputs().
# Outputs: none.

agg <- recode_variants(master_data("aggregation"), "CENTRE_A")
hem <- recode_variants(master_data("hemogram"), "CENTRE_A")
agg_measures <- panel_spec("aggregation")$measures
two_way_terms <- c("Genotype", "Treatment", "Genotype:Treatment")

anova_columns <- c("term", "sum_sq", "df", "f_value", "p_raw")
tukey_columns <- c("term", "comparison", "diff", "lwr", "upr", "p_adj")
assumption_columns <- c("test", "statistic", "p_value", "note")
cell_columns <- c("Genotype", "Treatment", "n", "below_min")

# A balanced two-way design (3 by 2 cells, 6 observations each).
set.seed(20211109)
balanced <- expand.grid(Genotype = c("A", "B", "C"), Treatment = c("U", "T"),
                        rep = 1:6, stringsAsFactors = FALSE)
balanced$Genotype <- factor(balanced$Genotype, levels = c("A", "B", "C"))
balanced$Treatment <- factor(balanced$Treatment, levels = c("U", "T"))
balanced$y <- stats::rnorm(nrow(balanced), 50, 10)
balanced$rep <- NULL

# The same design with one empty interaction cell (C by T removed).
aliased <- balanced[!(balanced$Genotype == "C" & balanced$Treatment == "T"), ]

type_one_p <- function(formula, data) {
  tab <- summary(stats::aov(formula, data = data))[[1]]
  p <- tab[["Pr(>F)"]]
  names(p) <- trimws(rownames(tab))
  p
}

p_of <- function(fit, term) fit$anova$p_raw[fit$anova$term == term]

test_that("fit_anova() returns the documented v1_fit structure", {
  fit <- fit_anova(agg, "PMA", design = "two_way")
  expect_s3_class(fit, "v1_fit")
  expect_true(all(c("measure", "design", "formula", "n", "status", "aliased",
                    "message", "cells", "anova", "tukey", "assumptions",
                    "lm", "aov") %in% names(fit)))
  expect_identical(fit$measure, "PMA")
  expect_identical(fit$design, "two_way")
  expect_identical(fit$formula, "PMA ~ Genotype * Treatment")
  expect_equal(fit$n, sum(!is.na(agg$PMA)))
  expect_true(fit$status %in% c("ok", "ok_aliased"))
  expect_type(fit$aliased, "logical")
  expect_type(fit$message, "character")
  expect_identical(names(fit$anova), anova_columns)
  expect_identical(names(fit$tukey), tukey_columns)
  expect_identical(names(fit$assumptions), assumption_columns)
  expect_identical(names(fit$cells), cell_columns)
  expect_s3_class(fit$lm, "lm")
  expect_s3_class(fit$aov, "aov")
  expect_equal(sum(fit$cells$n), fit$n)
  expect_identical(fit$cells$below_min, fit$cells$n < 5)
  one_way <- fit_anova(hem, "HGB.gr.dl.", design = "one_way")
  expect_identical(one_way$formula, "HGB.gr.dl. ~ Genotype")
  expect_true(all(is.na(one_way$cells$Treatment)))
  expect_identical(one_way$anova$term, c("Genotype", "Residuals"))
})

test_that("the type II table equals car::Anova(lm(formula, data), type = 2) row by row", {
  for (measure in c("PMA", "RISTO")) {
    fit <- fit_anova(agg, measure, design = "two_way")
    d <- droplevels(agg[!is.na(agg[[measure]]), ])
    ref <- car::Anova(stats::lm(stats::as.formula(paste(measure, "~ Genotype * Treatment")), data = d),
                      type = 2)
    idx <- match(fit$anova$term, rownames(ref))
    expect_false(anyNA(idx), info = measure)
    expect_equal(nrow(fit$anova), nrow(ref), info = measure)
    expect_equal(fit$anova$sum_sq, unname(ref[["Sum Sq"]][idx]), info = measure)
    expect_equal(fit$anova$df, unname(ref[["Df"]][idx]), info = measure)
    expect_equal(fit$anova$f_value, unname(ref[["F value"]][idx]), info = measure)
    expect_equal(fit$anova$p_raw, unname(ref[["Pr(>F)"]][idx]), info = measure)
    expect_true(is.na(fit$anova$p_raw[fit$anova$term == "Residuals"]))
  }
  fit1 <- fit_anova(hem, "MCH..pg.", design = "one_way")
  d1 <- droplevels(hem[!is.na(hem$MCH..pg.), ])
  ref1 <- car::Anova(stats::lm(MCH..pg. ~ Genotype, data = d1), type = 2)
  expect_equal(fit1$anova$p_raw[1], unname(ref1[["Pr(>F)"]][1]))
})

test_that("on a balanced design the type II p values equal the type I p values", {
  fit <- fit_anova(balanced, "y", design = "two_way")
  expect_identical(fit$status, "ok")
  expect_false(fit$aliased)
  p1 <- type_one_p(y ~ Genotype * Treatment, balanced)
  for (term in two_way_terms) {
    expect_equal(p_of(fit, term), unname(p1[[term]]), tolerance = 1e-10, info = term)
  }
})

test_that("on the synthetic CENTRE_A variant the type I and type II p values of Genotype differ", {
  differences <- vapply(agg_measures, function(measure) {
    fit <- fit_anova(agg, measure, design = "two_way")
    d <- droplevels(agg[!is.na(agg[[measure]]), ])
    p1 <- type_one_p(stats::as.formula(paste(measure, "~ Genotype * Treatment")), d)
    abs(p_of(fit, "Genotype") - unname(p1[["Genotype"]]))
  }, numeric(1))
  expect_true(any(differences > 1e-8))
  # The interaction p value is the same under both types of sums of squares.
  fit <- fit_anova(agg, "PMA", design = "two_way")
  d <- droplevels(agg[!is.na(agg$PMA), ])
  p1 <- type_one_p(PMA ~ Genotype * Treatment, d)
  expect_equal(p_of(fit, "Genotype:Treatment"), unname(p1[["Genotype:Treatment"]]),
               tolerance = 1e-10)
})

test_that("adjust_p_values() reports Holm and BH with the family size", {
  stacked <- do.call(rbind, lapply(agg_measures[1:5], function(measure) {
    fit <- fit_anova(agg, measure, design = "two_way")
    cbind(panel = "aggregation", variant = "CENTRE_A", tidy_anova(fit),
          stringsAsFactors = FALSE)
  }))
  stacked_hem <- do.call(rbind, lapply(c("HGB.gr.dl.", "MCH..pg."), function(measure) {
    fit <- fit_anova(hem, measure, design = "one_way")
    cbind(panel = "hemogram", variant = "CENTRE_A", tidy_anova(fit),
          stringsAsFactors = FALSE)
  }))
  stacked <- rbind(stacked, stacked_hem)
  expect_identical(names(stacked)[1:5], c("panel", "variant", "measure", "status", "n"))
  adjusted <- adjust_p_values(stacked)
  expect_identical(names(adjusted)[seq_along(names(stacked))], names(stacked))
  expect_true(all(c("p_holm", "p_bh", "family_size") %in% names(adjusted)))
  expect_equal(nrow(adjusted), nrow(stacked))
  tested <- adjusted$term != "Residuals" & !is.na(adjusted$p_raw)
  expect_true(all(is.na(adjusted$p_holm[!tested])))
  expect_true(all(is.na(adjusted$p_bh[!tested])))
  expect_true(all(is.na(adjusted$family_size[!tested])))
  expect_false(anyNA(adjusted$p_holm[tested]))
  expect_true(all(adjusted$p_holm[tested] >= adjusted$p_raw[tested] - 1e-12))
  expect_true(all(adjusted$p_bh[tested] >= adjusted$p_raw[tested] - 1e-12))
  expect_true(all(adjusted$p_holm[tested] >= adjusted$p_bh[tested] - 1e-12))
  expect_true(all(adjusted$p_holm[tested] <= 1))
  for (key in unique(paste(adjusted$panel, adjusted$variant))) {
    rows <- tested & paste(adjusted$panel, adjusted$variant) == key
    expect_true(all(adjusted$family_size[rows] == sum(rows)), info = key)
    expect_equal(adjusted$p_holm[rows], stats::p.adjust(adjusted$p_raw[rows], method = "holm"))
    expect_equal(adjusted$p_bh[rows], stats::p.adjust(adjusted$p_raw[rows], method = "BH"))
  }
  expect_equal(unique(adjusted$family_size[tested & adjusted$panel == "aggregation"]), 15)
  expect_equal(unique(adjusted$family_size[tested & adjusted$panel == "hemogram"]), 2)
})

test_that("Tukey rows exist for every term and p_adj lies in 0 to 1", {
  fit <- fit_anova(balanced, "y", design = "two_way")
  expect_identical(unique(fit$tukey$term), two_way_terms)
  expect_true(all(fit$tukey$p_adj >= 0 & fit$tukey$p_adj <= 1))
  expect_equal(sum(fit$tukey$term == "Genotype"), 3)
  expect_equal(sum(fit$tukey$term == "Treatment"), 1)
  expect_equal(sum(fit$tukey$term == "Genotype:Treatment"), 15)
  ref <- stats::TukeyHSD(stats::aov(y ~ Genotype * Treatment, data = balanced))
  expect_equal(fit$tukey$diff[fit$tukey$term == "Genotype"], unname(ref$Genotype[, "diff"]))
  expect_equal(fit$tukey$comparison[fit$tukey$term == "Genotype"], rownames(ref$Genotype))
  one_way <- fit_anova(hem, "HGB.gr.dl.", design = "one_way")
  expect_identical(unique(one_way$tukey$term), "Genotype")
  expect_true(all(is.na(one_way$tukey$p_adj) |
                    (one_way$tukey$p_adj >= 0 & one_way$tukey$p_adj <= 1)))
  two_way <- fit_anova(agg, "PMA", design = "two_way")
  expect_true(nrow(two_way$tukey) > 0)
  expect_true(all(is.na(two_way$tukey$p_adj) |
                    (two_way$tukey$p_adj >= 0 & two_way$tukey$p_adj <= 1)))
  tidy <- tidy_tukey(two_way)
  expect_identical(names(tidy), c("measure", "status", "n", tukey_columns))
})

test_that("a response entirely missing gives skipped_no_data with zero-row tables", {
  d <- agg
  d$PMA <- NA_real_
  fit <- fit_anova(d, "PMA", design = "two_way")
  expect_s3_class(fit, "v1_fit")
  expect_identical(fit$status, "skipped_no_data")
  expect_equal(fit$n, 0)
  expect_true(nzchar(fit$message))
  expect_equal(nrow(fit$anova), 0)
  expect_equal(nrow(fit$tukey), 0)
  expect_equal(nrow(fit$assumptions), 0)
  expect_identical(names(fit$anova), anova_columns)
  expect_identical(names(fit$tukey), tukey_columns)
  expect_identical(names(fit$assumptions), assumption_columns)
  expect_null(fit$lm)
  expect_null(fit$aov)
  expect_equal(nrow(tidy_anova(fit)), 0)
  expect_identical(names(tidy_anova(fit)), c("measure", "status", "n", anova_columns))
  expect_identical(names(tidy_assumptions(fit)), c("measure", "status", "n", assumption_columns))
  d2 <- agg
  d2$PMA[3:nrow(d2)] <- NA_real_
  expect_identical(fit_anova(d2, "PMA", design = "two_way")$status, "skipped_no_data")
})

test_that("a factor with one level gives skipped_single_level", {
  d <- hem[hem$Genotype == "CNTRL", ]
  fit <- fit_anova(d, "HGB.gr.dl.", design = "one_way")
  expect_identical(fit$status, "skipped_single_level")
  expect_equal(nrow(fit$anova), 0)
  expect_null(fit$lm)
  d2 <- agg[agg$Genotype == "CNTRL", ]
  expect_identical(fit_anova(d2, "PMA", design = "two_way")$status, "skipped_single_level")
})

test_that("a design with an empty interaction cell gives ok_aliased with a complete ANOVA table", {
  fit <- fit_anova(aliased, "y", design = "two_way")
  expect_identical(fit$status, "ok_aliased")
  expect_true(fit$aliased)
  expect_true(anyNA(stats::coef(fit$lm)))
  expect_identical(fit$anova$term, c(two_way_terms, "Residuals"))
  expect_false(anyNA(fit$anova$p_raw[1:3]))
  expect_true(any(fit$cells$n == 0) || nrow(fit$cells) == 5)
  synthetic_fit <- fit_anova(agg, "PMA", design = "two_way")
  expect_identical(synthetic_fit$status, "ok_aliased")
  expect_equal(nrow(synthetic_fit$anova), 4)
})

test_that("assumptions has the two tests with p values in 0 to 1", {
  for (fit in list(fit_anova(agg, "PMA", design = "two_way"),
                   fit_anova(hem, "HGB.gr.dl.", design = "one_way"),
                   fit_anova(balanced, "y", design = "two_way"))) {
    expect_identical(fit$assumptions$test, c("shapiro_residuals", "levene_cells"))
    expect_true(all(fit$assumptions$p_value >= 0 & fit$assumptions$p_value <= 1))
    expect_true(all(is.finite(fit$assumptions$statistic)))
    expect_type(fit$assumptions$note, "character")
  }
  fit <- fit_anova(agg, "PMA", design = "two_way")
  shapiro <- stats::shapiro.test(stats::residuals(fit$lm))
  expect_equal(fit$assumptions$p_value[1], unname(shapiro$p.value))
  tidy <- tidy_assumptions(fit)
  expect_equal(nrow(tidy), 2)
  expect_identical(tidy$measure, c("PMA", "PMA"))
})
