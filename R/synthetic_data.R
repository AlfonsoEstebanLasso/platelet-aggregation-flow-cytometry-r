# R/synthetic_data.R
#
# Purpose: generate the synthetic example cohort of v1.0, a fictitious set of
#   100 subjects whose three panel tables (aggregation, hemogram, surface
#   markers) follow the schema of the private study tables described in
#   data/README.md. Every value is drawn from a hand-set distribution
#   (docs/v1_spec.md, section 4) and carries no biological meaning. No group
#   effect is simulated; the only structure is the missingness by centre.
# Inputs: none. No data file is read. All draws are seeded from the project
#   seed 20211109.
# Outputs: data frames with R column names (make.names() form). When
#   generate_synthetic(write = TRUE) is called, the three CSV files
#   synthetic_aggregation.csv, synthetic_hemogram.csv and
#   synthetic_markers.csv are written to the directory passed as outdir
#   (default data/synthetic) with the raw headers of docs/v1_spec.md,
#   section 3, semicolon separator, decimal comma, no quoting, empty fields
#   for missing values, LF line endings and UTF-8 without BOM.
# Packages: base R only (stats and utils). No library() call in this file.

#' @title Fixed design of the synthetic cohort
#' @description Returns the constants that define the subject columns of the
#'   synthetic cohort (docs/v1_spec.md, section 3.2): factor levels in their
#'   fixed order, exact genotype counts for n = 100, centre split, treatment
#'   probabilities, sex probability and the positions set to missing, birth
#'   year distribution, and the platelet count parameters of the control
#'   group (the only group-dependent draw, section 4).
#' @return A named list of constants.
synthetic_cohort_design <- function() {
  list(
    genotype_levels = c("CNTRL", "JAK2 V617F", "CALR Type I", "CALR Type II",
                        "CALR Type_Other", "MPL W515", "TN", "VARIANT"),
    genotype_counts = c(20L, 25L, 12L, 8L, 4L, 6L, 15L, 10L),
    genotype_remainder = "JAK2 V617F",
    control = "CNTRL",
    treatment_levels = c("Untreated", "ASA", "Anagrelide", "HU"),
    treatment_probs = c(0.30, 0.40, 0.15, 0.15),
    untreated = "Untreated",
    centre_levels = c("CENTRE_A", "CENTRE_B"),
    centre_a = "CENTRE_A",
    centre_b = "CENTRE_B",
    centre_fraction_a = 0.75,
    gender_levels = c("F", "M"),
    gender_prob_f = 0.55,
    gender_missing_positions = c(7L, 58L),
    birth_year_mean = 1962,
    birth_year_sd = 12,
    birth_year_lower = 1930L,
    birth_year_upper = 2000L,
    birth_year_missing_fraction = 0.5,
    plt_control_mean = 350,
    plt_control_sd = 120,
    subject_columns = c("Codigo.Estudio", "Codigo.muestra", "Gender",
                        "Birth.Year", "Genotype", "Treatment",
                        "Centro.Analisis"),
    synthetic_column = "Synthetic",
    synthetic_value = "SYNTHETIC",
    study_prefix = "SYN-",
    sample_prefix = "SYN-S-"
  )
}

#' @title Raw headers of a synthetic panel file
#' @description Maps every R column name of a panel table to the raw header
#'   written in the CSV file, in file order, with the subject columns first
#'   and the Synthetic column last (docs/v1_spec.md, section 3). The raw
#'   headers reproduce the private format exactly, including the WBC header
#'   with its unbalanced parenthesis. Applying make.names() to the raw
#'   headers gives back the R names, which is what read.csv2() does when
#'   the file is read with check.names = TRUE.
#' @param panel One of "aggregation", "hemogram", "markers".
#' @return A named character vector: names are R names, values are raw
#'   headers.
synthetic_raw_headers <- function(panel = c("aggregation", "hemogram",
                                            "markers")) {
  panel <- match.arg(panel)
  subject <- c(
    Codigo.Estudio = "Codigo Estudio",
    Codigo.muestra = "Codigo muestra",
    Gender = "Gender",
    Birth.Year = "Birth Year",
    Genotype = "Genotype",
    Treatment = "Treatment",
    Centro.Analisis = "Centro Analisis"
  )
  measures <- switch(
    panel,
    aggregation = c(
      PMA = "PMA",
      CVX = "CVX",
      RISTO = "RISTO",
      AGGA = "AGGA",
      COL = "COL",
      TRAP = "TRAP",
      UNSTIMULATED.10min = "UNSTIMULATED.10min",
      Time.0min = "Time.0min",
      UNS.Time.10min.vs.Time.0 = "UNS.Time.10min.vs.Time.0"
    ),
    hemogram = c(
      TPO..pg.ml. = "TPO (pg/ml)",
      EPO..mlU.ml. = "EPO (mlU/ml)",
      WBC.10.6.ml. = "WBC*10^6/ml)",
      RBC...10.9.ml. = "RBC (*10^9/ml)",
      HGB.gr.dl. = "HGB(gr/dl)",
      HCT.... = "HCT (%)",
      MCV..fl. = "MCV (fl)",
      MCH..pg. = "MCH (pg)",
      MCHC..gr.dl. = "MCHC (gr/dl)",
      PLT...10.6..ml = "PLT (*10^6)/ml",
      MPV..fl. = "MPV( fl)",
      RETIC.. = "RETIC %",
      Neutr. = "Neutr%",
      Lymph. = "Lymph%",
      Mono. = "Mono%",
      Eos. = "Eos%",
      Baso. = "Baso%",
      Neutr...10.6.ml. = "Neutr (*10^6/ml)",
      Lymph..10.6.ml. = "Lymph(*10^6/ml)",
      Mono..10.6.ml. = "Mono(*10^6/ml)",
      Eos..10.6.ml. = "Eos(*10^6/ml)",
      Baso..10.6.ml. = "Baso(*10^6/ml)"
    ),
    markers = c(
      RAW.FSC = "RAW FSC",
      CD61 = "CD61",
      CD41 = "CD41",
      CD49B = "CD49B",
      GPVI = "GPVI",
      CD42A = "CD42A",
      CD42B = "CD42B",
      CD31 = "CD31",
      CD36 = "CD36",
      CD9 = "CD9",
      FSC.unstained = "FSC unstained"
    )
  )
  c(subject, measures, Synthetic = "Synthetic")
}

#' @title File name of a synthetic panel table
#' @param panel One of "aggregation", "hemogram", "markers".
#' @return The file name (without directory), for example
#'   "synthetic_hemogram.csv".
synthetic_file_name <- function(panel = c("aggregation", "hemogram",
                                          "markers")) {
  panel <- match.arg(panel)
  paste0("synthetic_", panel, ".csv")
}

#' @title Distribution table of the synthetic measurements
#' @description Returns the hand-set distributions of docs/v1_spec.md,
#'   section 4, one row per measurement column of the three panels, in file
#'   order. The simulators read this table, so it is the single source of
#'   the parameters. Distributions: "normal" (par1 mean, par2 sd),
#'   "lognormal" (par1 meanlog, par2 sdlog), "normal_by_genotype" (par1 and
#'   par2 are the mean and sd of every genotype other than CNTRL; the CNTRL
#'   parameters are plt_control_mean and plt_control_sd of
#'   synthetic_cohort_design()), "gamma_share" (par1 shape, par2 rate; the
#'   five shares of a row are normalised to sum 100), "derived_absolute"
#'   (WBC times the matching percentage divided by 100, never drawn) and
#'   "ratio" (UNSTIMULATED.10min divided by Time.0min, never drawn). Values
#'   are clipped to the interval lower to upper when given, then rounded to
#'   decimals. missing_fraction is the fraction of rows set to missing at
#'   random; NA means that the column is missing exactly where WBC is
#'   missing. missing_centre_b marks the columns that are missing for every
#'   CENTRE_B row (the random fraction is then applied among the CENTRE_A
#'   rows only).
#' @return A data frame with the columns panel, r_name, distribution, par1,
#'   par2, lower, upper, decimals, missing_fraction, missing_centre_b.
synthetic_spec <- function() {
  row <- function(panel, r_name, distribution, par1 = NA_real_,
                  par2 = NA_real_, lower = NA_real_, upper = NA_real_,
                  decimals, missing_fraction, missing_centre_b = FALSE) {
    data.frame(panel = panel, r_name = r_name, distribution = distribution,
               par1 = par1, par2 = par2, lower = lower, upper = upper,
               decimals = as.integer(decimals),
               missing_fraction = missing_fraction,
               missing_centre_b = missing_centre_b,
               stringsAsFactors = FALSE)
  }
  a <- "aggregation"
  h <- "hemogram"
  m <- "markers"
  rows <- list(
    # Aggregation (section 3.3 order)
    row(a, "PMA", "normal", 55, 18, 0, 100, 2, 0.05),
    row(a, "CVX", "normal", 60, 15, 0, 100, 2, 0.05),
    row(a, "RISTO", "normal", 45, 20, 0, 100, 2, 0.05),
    row(a, "AGGA", "normal", 50, 17, 0, 100, 2, 0.05),
    row(a, "COL", "normal", 40, 16, 0, 100, 2, 0.05),
    row(a, "TRAP", "normal", 58, 14, 0, 100, 2, 0.05, TRUE),
    row(a, "UNSTIMULATED.10min", "normal", 12, 5, 1, 40, 2, 0),
    row(a, "Time.0min", "normal", 8, 3, 1, 30, 2, 0),
    row(a, "UNS.Time.10min.vs.Time.0", "ratio", decimals = 4,
        missing_fraction = 0),
    # Hemogram (section 3.4 order)
    row(h, "TPO..pg.ml.", "lognormal", log(120), 0.6, decimals = 1,
        missing_fraction = 0.60),
    row(h, "EPO..mlU.ml.", "lognormal", log(12), 0.6, decimals = 1,
        missing_fraction = 0.60),
    row(h, "WBC.10.6.ml.", "normal", 7.5, 2, 2.5, 20, 2, 0.03),
    row(h, "RBC...10.9.ml.", "normal", 4.7, 0.5, 3, 6.5, 2, 0.03),
    row(h, "HGB.gr.dl.", "normal", 13.5, 1.5, 8, 18, 1, 0.03),
    row(h, "HCT....", "normal", 41, 4, 25, 55, 1, 0.03),
    row(h, "MCV..fl.", "normal", 90, 6, 65, 110, 1, 0.03),
    row(h, "MCH..pg.", "normal", 30, 2.5, 20, 38, 1, 0.03),
    row(h, "MCHC..gr.dl.", "normal", 33.5, 1.2, 28, 37, 1, 0.03),
    row(h, "PLT...10.6..ml", "normal_by_genotype", 700, 200, 100, 1500, 0,
        0.03),
    row(h, "MPV..fl.", "normal", 10, 1.2, 6, 14, 1, 0.03),
    row(h, "RETIC..", "normal", 1.2, 0.5, 0.1, 4, 2, 0.03),
    row(h, "Neutr.", "gamma_share", 60, 1, decimals = 1,
        missing_fraction = NA_real_),
    row(h, "Lymph.", "gamma_share", 30, 1, decimals = 1,
        missing_fraction = NA_real_),
    row(h, "Mono.", "gamma_share", 6, 1, decimals = 1,
        missing_fraction = NA_real_),
    row(h, "Eos.", "gamma_share", 3, 1, decimals = 1,
        missing_fraction = NA_real_),
    row(h, "Baso.", "gamma_share", 1, 1, decimals = 1,
        missing_fraction = NA_real_),
    row(h, "Neutr...10.6.ml.", "derived_absolute", decimals = 2,
        missing_fraction = NA_real_),
    row(h, "Lymph..10.6.ml.", "derived_absolute", decimals = 2,
        missing_fraction = NA_real_),
    row(h, "Mono..10.6.ml.", "derived_absolute", decimals = 2,
        missing_fraction = NA_real_),
    row(h, "Eos..10.6.ml.", "derived_absolute", decimals = 2,
        missing_fraction = NA_real_),
    row(h, "Baso..10.6.ml.", "derived_absolute", decimals = 2,
        missing_fraction = NA_real_),
    # Surface markers (section 3.5 order)
    row(m, "RAW.FSC", "lognormal", log(25000), 0.35, decimals = 1,
        missing_fraction = 0.03),
    row(m, "CD61", "lognormal", log(6000), 0.35, decimals = 1,
        missing_fraction = 0.03),
    row(m, "CD41", "lognormal", log(5000), 0.35, decimals = 1,
        missing_fraction = 0.03),
    row(m, "CD49B", "lognormal", log(350), 0.35, decimals = 1,
        missing_fraction = 0.03),
    row(m, "GPVI", "lognormal", log(500), 0.35, decimals = 1,
        missing_fraction = 0.03, missing_centre_b = TRUE),
    row(m, "CD42A", "lognormal", log(2200), 0.35, decimals = 1,
        missing_fraction = 0.03, missing_centre_b = TRUE),
    row(m, "CD42B", "lognormal", log(3200), 0.35, decimals = 1,
        missing_fraction = 0.03),
    row(m, "CD31", "lognormal", log(900), 0.35, decimals = 1,
        missing_fraction = 0.03),
    row(m, "CD36", "lognormal", log(1600), 0.35, decimals = 1,
        missing_fraction = 0.03),
    row(m, "CD9", "lognormal", log(2600), 0.35, decimals = 1,
        missing_fraction = 0.03, missing_centre_b = TRUE),
    row(m, "FSC.unstained", "lognormal", log(18000), 0.35, decimals = 1,
        missing_fraction = 0.03)
  )
  out <- do.call(rbind, rows)
  rownames(out) <- NULL
  out
}

#' @title Map of the hemogram absolute counts to their percentages
#' @description The absolute differential counts are derived from WBC and
#'   the differential percentage of the same leukocyte class.
#' @return A named character vector: names are the R names of the absolute
#'   count columns, values the R names of the matching percentage columns.
hemogram_differential_map <- function() {
  c(Neutr...10.6.ml. = "Neutr.",
    Lymph..10.6.ml. = "Lymph.",
    Mono..10.6.ml. = "Mono.",
    Eos..10.6.ml. = "Eos.",
    Baso..10.6.ml. = "Baso.")
}

#' @title Clip a numeric vector to a closed interval
#' @param x Numeric vector.
#' @param lower Lower bound, or NA for no bound.
#' @param upper Upper bound, or NA for no bound.
#' @return pmin(pmax(x, lower), upper) with NA bounds ignored.
clip_values <- function(x, lower = NA_real_, upper = NA_real_) {
  stopifnot(is.numeric(x))
  if (!is.na(lower)) x <- pmax(x, lower)
  if (!is.na(upper)) x <- pmin(x, upper)
  x
}

#' @title Scale the genotype counts to a cohort size
#' @description For n = 100 the counts of docs/v1_spec.md, section 3.2, are
#'   returned unchanged. For any other n they are scaled proportionally and
#'   rounded, and the remainder (positive or negative) is added to the
#'   genotype named in remainder so that the counts sum to n.
#' @param counts Integer vector of counts for n = 100, in the order of
#'   levels.
#' @param n Target cohort size.
#' @param levels Genotype levels, same length as counts.
#' @param remainder The level that absorbs the rounding remainder.
#' @return An integer vector of counts summing to n.
scale_genotype_counts <- function(counts, n, levels, remainder) {
  stopifnot(length(counts) == length(levels), remainder %in% levels,
            sum(counts) > 0)
  scaled <- as.integer(round(counts * n / sum(counts)))
  scaled[levels == remainder] <- scaled[levels == remainder] +
    (as.integer(n) - sum(scaled))
  if (any(scaled < 0)) {
    stop("The cohort size n = ", n, " is too small for the genotype counts.")
  }
  scaled
}

#' @title Set a random fraction of the candidate rows to missing
#' @description Draws round(fraction * length(candidates)) row indices with
#'   sample() among candidates and sets them to NA. No draw is made when
#'   the number of rows to blank is zero.
#' @param x A vector.
#' @param fraction Fraction of the candidate rows to set to missing.
#' @param candidates Integer vector of eligible row indices (default all).
#' @return The vector with the chosen entries set to NA.
apply_random_missing <- function(x, fraction, candidates = seq_along(x)) {
  stopifnot(is.numeric(fraction), length(fraction) == 1, fraction >= 0,
            fraction <= 1)
  k <- as.integer(round(fraction * length(candidates)))
  if (k > 0) {
    x[candidates[sample.int(length(candidates), k)]] <- NA
  }
  x
}

#' @title Draw one measurement column from a row of synthetic_spec()
#' @description Draws n values according to the distribution of the row,
#'   clips them to the interval lower to upper and rounds them to decimals.
#'   Only the distributions "normal", "lognormal" and "normal_by_genotype"
#'   are drawn here; the derived distributions are computed by the
#'   simulators.
#' @param spec_row One row of synthetic_spec() as a data frame.
#' @param n Number of values.
#' @param genotype Character or factor vector of length n, needed only by
#'   "normal_by_genotype".
#' @param design Output of synthetic_cohort_design().
#' @return A numeric vector of length n.
draw_measurement <- function(spec_row, n, genotype = NULL,
                             design = synthetic_cohort_design()) {
  stopifnot(is.data.frame(spec_row), nrow(spec_row) == 1, n >= 1)
  x <- switch(
    spec_row$distribution,
    normal = stats::rnorm(n, spec_row$par1, spec_row$par2),
    lognormal = stats::rlnorm(n, spec_row$par1, spec_row$par2),
    normal_by_genotype = {
      stopifnot(!is.null(genotype), length(genotype) == n)
      is_control <- as.character(genotype) == design$control
      stats::rnorm(n,
                   ifelse(is_control, design$plt_control_mean, spec_row$par1),
                   ifelse(is_control, design$plt_control_sd, spec_row$par2))
    },
    stop("Distribution '", spec_row$distribution, "' of column '",
         spec_row$r_name, "' is not drawn by draw_measurement().")
  )
  x <- clip_values(x, spec_row$lower, spec_row$upper)
  round(x, spec_row$decimals)
}

#' @title Apply the missingness pattern of a panel
#' @description Applies, column by column in file order, the random
#'   missingness of synthetic_spec() with sample() on the row indices (among
#'   the CENTRE_A rows for the columns flagged missing_centre_b), then sets
#'   the columns whose missing_fraction is NA to missing exactly where
#'   linked_to is missing, and last sets every CENTRE_B row of the flagged
#'   columns to NA.
#' @param data Panel data frame with R names and a Centro.Analisis column.
#' @param spec Rows of synthetic_spec() for the panel, in file order.
#' @param linked_to R name of the column whose missingness is copied by the
#'   columns with missing_fraction NA (the hemogram uses WBC); NULL if none.
#' @param design Output of synthetic_cohort_design().
#' @return The data frame with missing values applied.
apply_missingness <- function(data, spec, linked_to = NULL,
                              design = synthetic_cohort_design()) {
  stopifnot(is.data.frame(data), "Centro.Analisis" %in% names(data),
            all(spec$r_name %in% names(data)))
  centre <- as.character(data$Centro.Analisis)
  rows_a <- which(centre == design$centre_a)
  rows_b <- which(centre == design$centre_b)
  for (i in seq_len(nrow(spec))) {
    r <- spec$r_name[i]
    fraction <- spec$missing_fraction[i]
    if (is.na(fraction)) {
      next
    }
    candidates <- if (isTRUE(spec$missing_centre_b[i])) rows_a else
      seq_len(nrow(data))
    data[[r]] <- apply_random_missing(data[[r]], fraction, candidates)
  }
  linked <- spec$r_name[is.na(spec$missing_fraction)]
  if (length(linked) > 0) {
    stopifnot(!is.null(linked_to), linked_to %in% names(data))
    blank <- is.na(data[[linked_to]])
    for (r in linked) data[[r]][blank] <- NA
  }
  for (r in spec$r_name[spec$missing_centre_b]) {
    data[[r]][rows_b] <- NA
  }
  data
}

#' @title Simulate the subject columns of the synthetic cohort
#' @description Builds the seven subject columns of docs/v1_spec.md,
#'   section 3.2, with R names. Genotype counts are the fixed counts
#'   (scaled for n other than 100, remainder to JAK2 V617F) shuffled with
#'   the seed; the centre is assigned independently of the genotype with a
#'   3 to 1 split; every CNTRL subject is Untreated and the patients draw
#'   Untreated, ASA, Anagrelide, HU with probabilities 0.30, 0.40, 0.15,
#'   0.15; sex is F with probability 0.55 and the subjects in positions 7
#'   and 58 are set to missing; the birth year is round(rnorm(n, 1962, 12))
#'   clipped to 1930 to 2000 with half of the subjects (50 for n = 100)
#'   chosen at random set to missing. Gender, Genotype, Treatment and
#'   Centro.Analisis are factors with the fixed level order.
#' @param n Number of subjects (default 100).
#' @param seed Seed passed to set.seed() at the start (default 20211109).
#' @return A data frame with the columns Codigo.Estudio, Codigo.muestra,
#'   Gender, Birth.Year, Genotype, Treatment, Centro.Analisis and n rows.
simulate_cohort <- function(n = 100, seed = 20211109) {
  stopifnot(is.numeric(n), length(n) == 1, n >= 1, n == round(n),
            is.numeric(seed), length(seed) == 1)
  n <- as.integer(n)
  design <- synthetic_cohort_design()
  set.seed(seed)
  counts <- scale_genotype_counts(design$genotype_counts, n,
                                  design$genotype_levels,
                                  design$genotype_remainder)
  genotype <- sample(rep(design$genotype_levels, counts))
  n_a <- as.integer(round(design$centre_fraction_a * n))
  centre <- sample(rep(design$centre_levels, c(n_a, n - n_a)))
  treatment <- rep(design$untreated, n)
  patients <- which(genotype != design$control)
  if (length(patients) > 0) {
    treatment[patients] <- sample(design$treatment_levels, length(patients),
                                  replace = TRUE,
                                  prob = design$treatment_probs)
  }
  gender <- ifelse(stats::runif(n) < design$gender_prob_f,
                   design$gender_levels[1], design$gender_levels[2])
  missing_positions <- design$gender_missing_positions
  gender[missing_positions[missing_positions <= n]] <- NA
  birth_year <- round(stats::rnorm(n, design$birth_year_mean,
                                   design$birth_year_sd))
  birth_year <- clip_values(birth_year, design$birth_year_lower,
                            design$birth_year_upper)
  birth_year <- apply_random_missing(birth_year,
                                     design$birth_year_missing_fraction)
  data.frame(
    Codigo.Estudio = sprintf("%s%03d", design$study_prefix, seq_len(n)),
    Codigo.muestra = sprintf("%s%03d", design$sample_prefix, seq_len(n)),
    Gender = factor(gender, levels = design$gender_levels),
    Birth.Year = as.integer(birth_year),
    Genotype = factor(genotype, levels = design$genotype_levels),
    Treatment = factor(treatment, levels = design$treatment_levels),
    Centro.Analisis = factor(centre, levels = design$centre_levels),
    stringsAsFactors = FALSE
  )
}

#' @title Check a cohort data frame
#' @param cohort Output of simulate_cohort().
#' @return Invisibly TRUE; stops with a message otherwise.
check_cohort <- function(cohort) {
  design <- synthetic_cohort_design()
  stopifnot(is.data.frame(cohort), nrow(cohort) >= 1)
  missing <- setdiff(design$subject_columns, names(cohort))
  if (length(missing) > 0) {
    stop("The cohort lacks the subject columns: ",
         paste(missing, collapse = ", "))
  }
  invisible(TRUE)
}

#' @title Simulate the synthetic aggregation table
#' @description Draws the nine aggregation measures of docs/v1_spec.md,
#'   section 3.3, for the subjects of cohort: PMA, CVX, RISTO, AGGA, COL,
#'   TRAP, UNSTIMULATED.10min and Time.0min from normal distributions
#'   clipped and rounded to 2 decimals, and the ratio
#'   UNSTIMULATED.10min / Time.0min rounded to 4 decimals (computed before
#'   any value is set to missing). Then 5 percent of the rows at random are
#'   set to missing in each of the six agonist columns (TRAP among the
#'   CENTRE_A rows), and TRAP is set to missing for every CENTRE_B row.
#' @param cohort Output of simulate_cohort().
#' @param seed Seed passed to set.seed() at the start (default 20211109).
#' @return A data frame with the seven subject columns, the nine measures
#'   and the column Synthetic ("SYNTHETIC" in every row), 17 columns.
simulate_aggregation <- function(cohort, seed = 20211109) {
  check_cohort(cohort)
  design <- synthetic_cohort_design()
  spec <- synthetic_spec()
  spec <- spec[spec$panel == "aggregation", ]
  n <- nrow(cohort)
  set.seed(seed)
  out <- cohort
  for (i in seq_len(nrow(spec))) {
    r <- spec$r_name[i]
    if (spec$distribution[i] == "ratio") {
      out[[r]] <- round(out[["UNSTIMULATED.10min"]] / out[["Time.0min"]],
                        spec$decimals[i])
    } else {
      out[[r]] <- draw_measurement(spec[i, ], n, out$Genotype, design)
    }
  }
  out <- apply_missingness(out, spec, linked_to = NULL, design = design)
  out[[design$synthetic_column]] <- rep(design$synthetic_value, n)
  rownames(out) <- NULL
  out
}

#' @title Simulate the synthetic hemogram table
#' @description Draws the 22 numeric columns of docs/v1_spec.md, section
#'   3.4, for the subjects of cohort: TPO and EPO lognormal, the ten blood
#'   count variables normal clipped (PLT with a higher mean for the patients
#'   than for CNTRL, the only group-dependent draw), the five differential
#'   percentages as gamma shares normalised to 100 per row and rounded to 1
#'   decimal, and the absolute counts as WBC times the percentage divided by
#'   100 rounded to 2 decimals. Then the random missingness is applied (60
#'   percent for TPO and EPO, 3 percent for the blood count variables) and
#'   the ten differential columns are set to missing exactly where WBC is
#'   missing.
#' @param cohort Output of simulate_cohort().
#' @param seed Seed passed to set.seed() at the start (default 20211109).
#' @return A data frame with the seven subject columns, the 22 numeric
#'   columns and the column Synthetic, 30 columns.
simulate_hemogram <- function(cohort, seed = 20211109) {
  check_cohort(cohort)
  design <- synthetic_cohort_design()
  spec <- synthetic_spec()
  spec <- spec[spec$panel == "hemogram", ]
  n <- nrow(cohort)
  set.seed(seed)
  out <- cohort
  shares <- list()
  for (i in seq_len(nrow(spec))) {
    r <- spec$r_name[i]
    d <- spec$distribution[i]
    if (d %in% c("normal", "lognormal", "normal_by_genotype")) {
      out[[r]] <- draw_measurement(spec[i, ], n, out$Genotype, design)
    } else if (d == "gamma_share") {
      shares[[r]] <- stats::rgamma(n, shape = spec$par1[i],
                                   rate = spec$par2[i])
      out[[r]] <- NA_real_
    } else if (d == "derived_absolute") {
      out[[r]] <- NA_real_
    } else {
      stop("Unexpected distribution '", d, "' in the hemogram panel.")
    }
  }
  share_matrix <- do.call(cbind, shares)
  share_matrix <- share_matrix / rowSums(share_matrix) * 100
  for (r in names(shares)) {
    out[[r]] <- round(share_matrix[, r],
                      spec$decimals[spec$r_name == r])
  }
  diff_map <- hemogram_differential_map()
  for (r in names(diff_map)) {
    out[[r]] <- round(out[["WBC.10.6.ml."]] * out[[diff_map[[r]]]] / 100,
                      spec$decimals[spec$r_name == r])
  }
  out <- apply_missingness(out, spec, linked_to = "WBC.10.6.ml.",
                           design = design)
  out[[design$synthetic_column]] <- rep(design$synthetic_value, n)
  rownames(out) <- NULL
  out
}

#' @title Simulate the synthetic surface marker table
#' @description Draws the eleven marker columns of docs/v1_spec.md, section
#'   3.5, for the subjects of cohort, all lognormal with sdlog 0.35 and the
#'   stated median, rounded to 1 decimal. Then 3 percent of the rows at
#'   random are set to missing in every column (GPVI, CD42A and CD9 among
#'   the CENTRE_A rows), and GPVI, CD42A and CD9 are set to missing for
#'   every CENTRE_B row.
#' @param cohort Output of simulate_cohort().
#' @param seed Seed passed to set.seed() at the start (default 20211109).
#' @return A data frame with the seven subject columns, the eleven marker
#'   columns and the column Synthetic, 19 columns.
simulate_markers <- function(cohort, seed = 20211109) {
  check_cohort(cohort)
  design <- synthetic_cohort_design()
  spec <- synthetic_spec()
  spec <- spec[spec$panel == "markers", ]
  n <- nrow(cohort)
  set.seed(seed)
  out <- cohort
  for (i in seq_len(nrow(spec))) {
    out[[spec$r_name[i]]] <- draw_measurement(spec[i, ], n, out$Genotype,
                                              design)
  }
  out <- apply_missingness(out, spec, linked_to = NULL, design = design)
  out[[design$synthetic_column]] <- rep(design$synthetic_value, n)
  rownames(out) <- NULL
  out
}

#' @title Rename a panel table from R names to raw headers
#' @param data Panel data frame with R names, in file order.
#' @param panel One of "aggregation", "hemogram", "markers".
#' @return The data frame with the raw headers of synthetic_raw_headers()
#'   as column names; stops if the columns differ from the expected set.
rename_to_raw_headers <- function(data, panel) {
  headers <- synthetic_raw_headers(panel)
  if (!identical(names(data), names(headers))) {
    stop("The ", panel, " table does not have the expected columns in ",
         "order. Expected: ", paste(names(headers), collapse = ", "))
  }
  names(data) <- unname(headers)
  data
}

#' @title Write a synthetic table in the private CSV format
#' @description Writes with write.csv2(): semicolon separator, decimal
#'   comma, no quoting, empty fields for missing values, header in row 1,
#'   LF line endings. The content is ASCII, so the file is also valid UTF-8
#'   without BOM. The file is opened in binary mode so that the LF line
#'   ending is kept on every operating system.
#' @param data Data frame with raw headers.
#' @param path Destination file path.
#' @return The path, invisibly.
write_synthetic_csv <- function(data, path) {
  stopifnot(is.data.frame(data), is.character(path), length(path) == 1)
  con <- file(path, open = "wb")
  on.exit(close(con))
  utils::write.csv2(data, con, row.names = FALSE, na = "", quote = FALSE,
                    eol = "\n")
  invisible(path)
}

#' @title Generate the synthetic example data set
#' @description Calls simulate_cohort() and the three panel simulators with
#'   the same seed, and when write is TRUE renames the columns to the raw
#'   headers of synthetic_raw_headers() and writes
#'   synthetic_aggregation.csv, synthetic_hemogram.csv and
#'   synthetic_markers.csv into outdir (created if needed) in the private
#'   CSV format. The returned data frames keep the R names.
#' @param outdir Output directory, relative to the repository root
#'   (default "data/synthetic").
#' @param n Number of subjects (default 100).
#' @param seed Project seed (default 20211109).
#' @param write Whether to write the CSV files (default TRUE).
#' @return Invisibly, a list with the data frames cohort, aggregation,
#'   hemogram and markers (R names) and, when write is TRUE, the attribute
#'   "files" with the paths written.
generate_synthetic <- function(outdir = "data/synthetic", n = 100,
                               seed = 20211109, write = TRUE) {
  stopifnot(is.character(outdir), length(outdir) == 1, nchar(outdir) > 0,
            is.logical(write), length(write) == 1, !is.na(write))
  cohort <- simulate_cohort(n = n, seed = seed)
  tables <- list(
    aggregation = simulate_aggregation(cohort, seed = seed),
    hemogram = simulate_hemogram(cohort, seed = seed),
    markers = simulate_markers(cohort, seed = seed)
  )
  result <- c(list(cohort = cohort), tables)
  if (write) {
    if (!dir.exists(outdir)) dir.create(outdir, recursive = TRUE)
    files <- character(0)
    for (panel in names(tables)) {
      path <- file.path(outdir, synthetic_file_name(panel))
      write_synthetic_csv(rename_to_raw_headers(tables[[panel]], panel), path)
      files <- c(files, path)
    }
    attr(result, "files") <- files
  }
  invisible(result)
}
