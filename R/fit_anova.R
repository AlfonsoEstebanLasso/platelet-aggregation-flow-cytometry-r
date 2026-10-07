# R/fit_anova.R
#
# Purpose: the statistical method of v1.0 (section 6 of docs/v1_spec.md):
#          a linear model per measure and variant, the type II ANOVA table
#          from car::Anova(), the assumption checks (Shapiro on the
#          residuals, Levene on the cells), the Tukey HSD post hoc on the
#          aov object and the Holm and Benjamini-Hochberg corrections across
#          the measures of one panel and variant. The 2021 scripts used type
#          I (sequential) sums of squares from summary(aov()); the change is
#          documented in README.md and docs/legacy_to_v1.md.
# Inputs:  a recoded data frame and the name of a numeric measure column.
# Outputs: no file is written. fit_anova() returns an object of class
#          v1_fit; adjust_p_values() and the tidy_*() helpers return data
#          frames that R/run_panel.R stacks and exports.

#' @title Zero-row templates of the fit tables
#' @description Returns the empty anova, tukey and assumptions data frames
#'   with the column sets of section 8.4, used for skipped fits.
#' @return A list with the elements anova, tukey and assumptions.
empty_fit_tables <- function() {
  list(anova = data.frame(term = character(0), sum_sq = numeric(0),
                          df = numeric(0), f_value = numeric(0),
                          p_raw = numeric(0), stringsAsFactors = FALSE),
       tukey = data.frame(term = character(0), comparison = character(0),
                          diff = numeric(0), lwr = numeric(0),
                          upr = numeric(0), p_adj = numeric(0),
                          stringsAsFactors = FALSE),
       assumptions = data.frame(test = character(0), statistic = numeric(0),
                                p_value = numeric(0), note = character(0),
                                stringsAsFactors = FALSE))
}

#' @title Convert a car::Anova table to the v1.0 layout
#' @param a An object returned by car::Anova() on an lm fit.
#' @return Data frame term, sum_sq, df, f_value, p_raw (Residuals included).
tidy_car_anova <- function(a) {
  a <- as.data.frame(a)
  data.frame(term = rownames(a),
             sum_sq = as.numeric(a[["Sum Sq"]]),
             df = as.numeric(a[["Df"]]),
             f_value = as.numeric(a[["F value"]]),
             p_raw = as.numeric(a[["Pr(>F)"]]),
             stringsAsFactors = FALSE, row.names = NULL)
}

#' @title Convert a TukeyHSD object to one long table
#' @param tk An object returned by stats::TukeyHSD().
#' @return Data frame term, comparison, diff, lwr, upr, p_adj, all terms
#'   stacked in the order returned by R.
tidy_tukey_object <- function(tk) {
  parts <- lapply(names(tk), function(term) {
    m <- tk[[term]]
    data.frame(term = rep(term, nrow(m)),
               comparison = rownames(m),
               diff = as.numeric(m[, "diff"]),
               lwr = as.numeric(m[, "lwr"]),
               upr = as.numeric(m[, "upr"]),
               p_adj = as.numeric(m[, "p adj"]),
               stringsAsFactors = FALSE, row.names = NULL)
  })
  if (length(parts) == 0) {
    return(empty_fit_tables()$tukey)
  }
  do.call(rbind, parts)
}

#' @title Fit the v1.0 model of one measure
#' @description Removes the rows with a missing response (or a missing
#'   factor), drops unused levels, fits lm() and aov() with the formula
#'   measure ~ Genotype * Treatment (two_way) or measure ~ Genotype
#'   (one_way), computes the type II ANOVA table with car::Anova(), the
#'   Shapiro test on the residuals, the Levene test on the cells and the
#'   Tukey HSD post hoc on the aov object. The fit is skipped, with the
#'   status of section 8.5, when fewer than 3 responses remain, when a
#'   factor has fewer than two levels or when the residual degrees of
#'   freedom are zero.
#' @param data A data frame with the measure and the factor columns.
#' @param measure Name of the numeric response column.
#' @param design "two_way" or "one_way".
#' @param min_cell Cells with fewer observations are flagged in the cells
#'   table (the flag never changes the fit).
#' @return A list of class v1_fit with the elements measure, design,
#'   formula, n, status, aliased, message, cells, anova, tukey,
#'   assumptions, lm and aov.
fit_anova <- function(data, measure, design = c("two_way", "one_way"),
                      min_cell = 5) {
  design <- match.arg(design)
  stopifnot(is.data.frame(data), is.character(measure), length(measure) == 1,
            is.numeric(min_cell), length(min_cell) == 1)
  if (!measure %in% names(data)) {
    stop(sprintf("fit_anova(): measure column '%s' not found", measure))
  }
  if (!is.numeric(data[[measure]])) {
    stop(sprintf("fit_anova(): measure column '%s' is not numeric", measure))
  }
  if (make.names(measure) != measure) {
    stop(sprintf("fit_anova(): measure name '%s' is not a syntactic R name",
                 measure))
  }
  factors <- if (design == "two_way") c("Genotype", "Treatment") else "Genotype"
  absent <- setdiff(factors, names(data))
  if (length(absent) > 0) {
    stop(sprintf("fit_anova(): factor column(s) not found: %s",
                 paste(absent, collapse = ", ")))
  }
  formula_chr <- paste(measure, "~",
                       if (design == "two_way") "Genotype * Treatment" else "Genotype")
  empty <- empty_fit_tables()
  result <- list(measure = measure, design = design, formula = formula_chr,
                 n = 0L, status = "ok", aliased = FALSE, message = "",
                 cells = NULL, anova = empty$anova, tukey = empty$tukey,
                 assumptions = empty$assumptions, lm = NULL, aov = NULL)
  class(result) <- "v1_fit"

  d <- data[, c(measure, factors), drop = FALSE]
  keep <- stats::complete.cases(d)
  d <- d[keep, , drop = FALSE]
  rownames(d) <- NULL
  for (f in factors) {
    d[[f]] <- droplevels(as.factor(d[[f]]))
  }
  result$n <- nrow(d)

  if (design == "two_way") {
    tab <- as.data.frame(table(Genotype = d$Genotype, Treatment = d$Treatment),
                         stringsAsFactors = FALSE)
    cells <- data.frame(Genotype = tab$Genotype, Treatment = tab$Treatment,
                        n = as.integer(tab$Freq), stringsAsFactors = FALSE)
  } else {
    tab <- as.data.frame(table(Genotype = d$Genotype), stringsAsFactors = FALSE)
    cells <- data.frame(Genotype = tab$Genotype,
                        Treatment = rep(NA_character_, nrow(tab)),
                        n = as.integer(tab$Freq), stringsAsFactors = FALSE)
  }
  cells$below_min <- cells$n < min_cell
  result$cells <- cells

  if (nrow(d) < 3) {
    result$status <- "skipped_no_data"
    result$message <- sprintf("fewer than 3 non-missing responses (%d)", nrow(d))
    return(result)
  }
  n_levels <- vapply(factors, function(f) nlevels(d[[f]]), integer(1))
  if (any(n_levels < 2)) {
    result$status <- "skipped_single_level"
    result$message <- sprintf("factor with fewer than two levels: %s",
                              paste(factors[n_levels < 2], collapse = ", "))
    return(result)
  }

  fml <- stats::as.formula(formula_chr)
  fitted <- tryCatch({
    fit_lm <- stats::lm(fml, data = d)
    fit_aov <- stats::aov(fml, data = d)
    list(lm = fit_lm, aov = fit_aov)
  }, error = function(e) e)
  if (inherits(fitted, "error")) {
    result$status <- "error"
    result$message <- paste("model fit:", conditionMessage(fitted))
    return(result)
  }
  fit_lm <- fitted$lm
  fit_aov <- fitted$aov
  if (stats::df.residual(fit_lm) == 0) {
    result$status <- "skipped_no_residual_df"
    result$message <- "residual degrees of freedom equal to zero"
    return(result)
  }
  result$lm <- fit_lm
  result$aov <- fit_aov
  result$aliased <- any(is.na(stats::coef(fit_lm)))
  result$status <- if (result$aliased) "ok_aliased" else "ok"

  # car::Anova() prints a note for every model with aliased coefficients;
  # the status ok_aliased already records that fact, so the note is muted.
  anova_tab <- tryCatch(
    tidy_car_anova(suppressMessages(car::Anova(fit_lm, type = 2))),
    error = function(e) e)
  if (inherits(anova_tab, "error")) {
    result$status <- "error"
    result$message <- paste("car::Anova:", conditionMessage(anova_tab))
    return(result)
  }
  result$anova <- anova_tab

  notes <- character(0)
  res <- stats::residuals(fit_lm)
  if (length(res) >= 3 && length(res) <= 5000) {
    sh <- stats::shapiro.test(res)
    shapiro <- c(statistic = unname(sh$statistic), p_value = unname(sh$p.value))
    shapiro_note <- ""
  } else {
    shapiro <- c(statistic = NA_real_, p_value = NA_real_)
    shapiro_note <- sprintf("not run: %d residuals (needs 3 to 5000)", length(res))
  }
  cell <- if (design == "two_way") {
    interaction(d$Genotype, d$Treatment, drop = TRUE)
  } else {
    d$Genotype
  }
  lev_data <- data.frame(response = d[[measure]], cell = cell)
  lev <- tryCatch(suppressWarnings(
    car::leveneTest(response ~ cell, data = lev_data, center = median)),
    error = function(e) e)
  if (inherits(lev, "error")) {
    levene <- c(statistic = NA_real_, p_value = NA_real_)
    levene_note <- paste("not run:", conditionMessage(lev))
  } else {
    levene <- c(statistic = as.numeric(lev[1, "F value"]),
                p_value = as.numeric(lev[1, "Pr(>F)"]))
    levene_note <- if (is.na(levene[["p_value"]])) "p value not defined for these cells" else ""
  }
  result$assumptions <- data.frame(
    test = c("shapiro_residuals", "levene_cells"),
    statistic = c(shapiro[["statistic"]], levene[["statistic"]]),
    p_value = c(shapiro[["p_value"]], levene[["p_value"]]),
    note = c(shapiro_note, levene_note),
    stringsAsFactors = FALSE)

  tukey <- tryCatch(
    withCallingHandlers(stats::TukeyHSD(fit_aov),
                        warning = function(w) {
                          notes <<- c(notes, paste("TukeyHSD warning:", conditionMessage(w)))
                          invokeRestart("muffleWarning")
                        }),
    error = function(e) e)
  if (inherits(tukey, "error")) {
    result$tukey <- empty$tukey
    notes <- c(notes, paste("TukeyHSD error:", conditionMessage(tukey)))
  } else {
    result$tukey <- tidy_tukey_object(tukey)
  }
  result$message <- paste(unique(notes), collapse = "; ")
  result
}

#' @title Print method of a v1_fit object
#' @param x A v1_fit object.
#' @param ... Ignored.
#' @return x, invisibly.
print.v1_fit <- function(x, ...) {
  cat(sprintf("v1_fit: %s [%s], n = %d, status = %s\n", x$formula, x$design,
              x$n, x$status))
  if (nzchar(x$message)) {
    cat("  ", x$message, "\n", sep = "")
  }
  invisible(x)
}

#' @title Holm and Benjamini-Hochberg corrections across measures
#' @description Takes a stacked ANOVA table (the anova elements of several
#'   fits with the columns panel, variant and measure prepended) and adds
#'   p_holm, p_bh and family_size, computed with p.adjust() over the rows
#'   whose term is not Residuals and whose p_raw is not NA, separately for
#'   each combination of the by columns. The other rows get NA.
#' @param anova_table Data frame with at least the by columns, term and
#'   p_raw.
#' @param by Columns that define the family (default panel and variant).
#' @return The table with the three columns added.
adjust_p_values <- function(anova_table, by = c("panel", "variant")) {
  stopifnot(is.data.frame(anova_table), is.character(by), length(by) >= 1)
  absent <- setdiff(c(by, "term", "p_raw"), names(anova_table))
  if (length(absent) > 0) {
    stop(sprintf("adjust_p_values(): column(s) not found: %s",
                 paste(absent, collapse = ", ")))
  }
  n <- nrow(anova_table)
  anova_table$p_holm <- rep(NA_real_, n)
  anova_table$p_bh <- rep(NA_real_, n)
  anova_table$family_size <- rep(NA_integer_, n)
  if (n == 0) {
    return(anova_table)
  }
  eligible <- anova_table$term != "Residuals" & !is.na(anova_table$p_raw)
  key <- do.call(paste, c(lapply(by, function(b) as.character(anova_table[[b]])),
                          sep = "\r"))
  for (k in unique(key[eligible])) {
    idx <- which(eligible & key == k)
    anova_table$p_holm[idx] <- stats::p.adjust(anova_table$p_raw[idx], method = "holm")
    anova_table$p_bh[idx] <- stats::p.adjust(anova_table$p_raw[idx], method = "BH")
    anova_table$family_size[idx] <- length(idx)
  }
  anova_table
}

#' @title Prepend measure, status and n to a fit table
#' @param fit A v1_fit object.
#' @param table One of "anova", "tukey", "assumptions".
#' @return The table with the columns measure, status and n first.
prepend_fit_columns <- function(fit, table) {
  stopifnot(inherits(fit, "v1_fit"), table %in% c("anova", "tukey", "assumptions"))
  tbl <- fit[[table]]
  k <- nrow(tbl)
  data.frame(measure = rep(fit$measure, k), status = rep(fit$status, k),
             n = rep(as.integer(fit$n), k), tbl,
             stringsAsFactors = FALSE, check.names = FALSE)
}

#' @title Tidy ANOVA table of a fit
#' @param fit A v1_fit object.
#' @return The anova element with measure, status and n prepended.
tidy_anova <- function(fit) {
  prepend_fit_columns(fit, "anova")
}

#' @title Tidy Tukey table of a fit
#' @param fit A v1_fit object.
#' @return The tukey element with measure, status and n prepended.
tidy_tukey <- function(fit) {
  prepend_fit_columns(fit, "tukey")
}

#' @title Tidy assumption table of a fit
#' @param fit A v1_fit object.
#' @return The assumptions element with measure, status and n prepended.
tidy_assumptions <- function(fit) {
  prepend_fit_columns(fit, "assumptions")
}
