# R/read_inputs.R
#
# Purpose: panel definitions (measures, designs, column names) and the typed
#          reader of one master table per panel for v1.0.
# Inputs:  one CSV master table per panel in the private format (semicolon
#          separator, decimal comma, header in row 1), by default the
#          synthetic tables under data/synthetic/.
# Outputs: no file is written. panel_spec() returns the panel definition and
#          read_inputs() returns a checked data frame with typed columns and
#          the attributes panel, source and data_label.
#
# The measure lists, slugs and labels follow section 2 of docs/v1_spec.md and
# the legacy order of the three 2021-11 scripts. Every non-base function is
# called with its namespace; this file contains no library() call.

#' @title Subject columns shared by the three panels
#' @description Returns the R names of the seven subject columns of section
#'   3.2 of the specification, in file order.
#' @return Character vector of length seven.
subject_columns <- function() {
  c("Codigo.Estudio", "Codigo.muestra", "Gender", "Birth.Year",
    "Genotype", "Treatment", "Centro.Analisis")
}

#' @title Raw headers of the subject columns
#' @description Named character vector mapping the R name of each subject
#'   column to the raw header written in the CSV files.
#' @return Named character vector of length seven (names are R names).
subject_raw_headers <- function() {
  c(Codigo.Estudio = "Codigo Estudio",
    Codigo.muestra = "Codigo muestra",
    Gender = "Gender",
    Birth.Year = "Birth Year",
    Genotype = "Genotype",
    Treatment = "Treatment",
    Centro.Analisis = "Centro Analisis")
}

#' @title Fixed level orders of the subject factors
#' @description The level order of section 3.2 for Gender, Genotype,
#'   Treatment (the four levels of the master table; the collapsed level
#'   Treated exists only after collapse_treatment()) and the analysing
#'   centre.
#' @return Named list of character vectors.
subject_level_orders <- function() {
  list(Gender = c("F", "M"),
       Genotype = c("CNTRL", "JAK2 V617F", "CALR Type I", "CALR Type II",
                    "CALR Type_Other", "MPL W515", "TN", "VARIANT"),
       Treatment = c("Untreated", "ASA", "Anagrelide", "HU"),
       Centro.Analisis = c("CENTRE_A", "CENTRE_B"))
}

#' @title Order the levels of a factor by a preferred list
#' @description Converts x to a factor whose levels follow the preferred
#'   order; values present in x but absent from the preferred list are
#'   appended in alphabetical order and never dropped. When keep_absent is
#'   TRUE the preferred levels absent from x are kept as (empty) levels.
#' @param x Character or factor vector.
#' @param preferred Character vector with the preferred level order.
#' @param keep_absent Logical. Keep preferred levels that do not occur in x.
#' @return Factor.
order_levels <- function(x, preferred, keep_absent = TRUE) {
  stopifnot(is.character(preferred))
  x <- as.character(x)
  present <- unique(x[!is.na(x)])
  first <- if (keep_absent) preferred else preferred[preferred %in% present]
  lv <- c(first, sort(setdiff(present, preferred)))
  factor(x, levels = lv)
}

#' @title Panel definition
#' @description Returns the definition of one panel: design, measures in the
#'   legacy order, output slugs, axis labels, subject columns, columns read
#'   but not analysed, the synthetic file name and the mapping from R names
#'   to raw headers in file order (section 2 and section 3 of the
#'   specification).
#' @param panel One of "aggregation", "hemogram", "markers".
#' @return A list with the elements panel, design, measures, slugs, labels,
#'   subject_columns, extra_columns, synthetic_file and raw_headers.
panel_spec <- function(panel = c("aggregation", "hemogram", "markers")) {
  panel <- match.arg(panel)
  subj <- subject_raw_headers()
  if (panel == "aggregation") {
    measures <- c("PMA", "CVX", "RISTO", "AGGA", "COL", "TRAP",
                  "UNSTIMULATED.10min", "Time.0min",
                  "UNS.Time.10min.vs.Time.0")
    slugs <- c("PMA", "CVX", "RISTO", "AGGA", "COL", "TRAP",
               "UNSTIMULATED_10min", "Time_0min", "UNS_ratio")
    labels <- c("PMA response", "CVX response", "RISTO response",
                "AGGA response", "COL response", "TRAP response",
                "Unstimulated aggregation at 10 min",
                "Unstimulated measurement at time zero",
                "Ratio of 10 min to time zero")
    design <- "two_way"
    extra <- character(0)
    file_order <- c(subj,
                    PMA = "PMA", CVX = "CVX", RISTO = "RISTO", AGGA = "AGGA",
                    COL = "COL", TRAP = "TRAP",
                    UNSTIMULATED.10min = "UNSTIMULATED.10min",
                    Time.0min = "Time.0min",
                    UNS.Time.10min.vs.Time.0 = "UNS.Time.10min.vs.Time.0",
                    Synthetic = "Synthetic")
    synthetic_file <- "synthetic_aggregation.csv"
  } else if (panel == "hemogram") {
    measures <- c("EPO..mlU.ml.", "TPO..pg.ml.", "HGB.gr.dl.", "HCT....",
                  "MCH..pg.", "MCHC..gr.dl.", "Lymph.", "Mono.", "Eos.",
                  "Baso.", "Lymph..10.6.ml.", "Mono..10.6.ml.",
                  "Eos..10.6.ml.", "Baso..10.6.ml.")
    slugs <- c("EPO", "TPO", "HGB", "HCT", "MCH", "MCHC", "Lymph_pct",
               "Mono_pct", "Eos_pct", "Baso_pct", "Lymph_abs", "Mono_abs",
               "Eos_abs", "Baso_abs")
    labels <- c("EPO (mlU/ml)", "TPO (pg/ml)", "Haemoglobin (g/dl)",
                "Haematocrit (%)", "MCH (pg)", "MCHC (g/dl)",
                "Lymphocytes (%)", "Monocytes (%)", "Eosinophils (%)",
                "Basophils (%)", "Lymphocytes (10^6/ml)",
                "Monocytes (10^6/ml)", "Eosinophils (10^6/ml)",
                "Basophils (10^6/ml)")
    design <- "one_way"
    extra <- c("WBC.10.6.ml.", "RBC...10.9.ml.", "MCV..fl.",
               "PLT...10.6..ml", "MPV..fl.", "RETIC..", "Neutr.",
               "Neutr...10.6.ml.")
    file_order <- c(subj,
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
                    Baso..10.6.ml. = "Baso(*10^6/ml)",
                    Synthetic = "Synthetic")
    synthetic_file <- "synthetic_hemogram.csv"
  } else {
    measures <- c("CD61", "CD41", "CD49B", "GPVI", "CD42A", "CD42B", "CD31",
                  "CD36", "CD9", "FSC.unstained")
    slugs <- c("CD61", "CD41", "CD49B", "GPVI", "CD42A", "CD42B", "CD31",
               "CD36", "CD9", "FSC_unstained")
    labels <- c("CD61 intensity", "CD41 intensity", "CD49B intensity",
                "GPVI intensity", "CD42A intensity", "CD42B intensity",
                "CD31 intensity", "CD36 intensity", "CD9 intensity",
                "FSC unstained")
    design <- "two_way"
    extra <- "RAW.FSC"
    file_order <- c(subj,
                    RAW.FSC = "RAW FSC", CD61 = "CD61", CD41 = "CD41",
                    CD49B = "CD49B", GPVI = "GPVI", CD42A = "CD42A",
                    CD42B = "CD42B", CD31 = "CD31", CD36 = "CD36",
                    CD9 = "CD9", FSC.unstained = "FSC unstained",
                    Synthetic = "Synthetic")
    synthetic_file <- "synthetic_markers.csv"
  }
  stopifnot(length(measures) == length(slugs),
            length(measures) == length(labels),
            all(make.names(names(file_order)) == names(file_order)))
  list(panel = panel,
       design = design,
       measures = measures,
       slugs = slugs,
       labels = labels,
       subject_columns = subject_columns(),
       extra_columns = extra,
       synthetic_file = synthetic_file,
       raw_headers = file_order)
}

#' @title Read one master table of a panel
#' @description Reads a semicolon separated CSV with decimal comma through
#'   read.csv2(), checks that every subject column and every measure column
#'   exists, converts the measures and the extra columns to numeric, sets the
#'   subject factors with the level orders of section 3.2 (levels found in
#'   the data but absent from that list are appended alphabetically) and
#'   drops the column Synthetic if present. A private master kept as XLSX
#'   must be exported to CSV (semicolon, decimal comma) before use.
#' @param panel One of "aggregation", "hemogram", "markers".
#' @param path Path of the CSV file. When NULL the synthetic file of the
#'   panel under data_dir is read.
#' @param data_dir Directory holding the synthetic files (default
#'   "data/synthetic").
#' @return A plain data frame with the attributes panel, source (the path)
#'   and data_label ("synthetic example data (no biological meaning)" when
#'   every Codigo.Estudio starts with "SYN-", otherwise "study data").
read_inputs <- function(panel, path = NULL, data_dir = "data/synthetic") {
  spec <- panel_spec(panel)
  if (is.null(path)) {
    stopifnot(is.character(data_dir), length(data_dir) == 1)
    path <- file.path(data_dir, spec$synthetic_file)
  }
  stopifnot(is.character(path), length(path) == 1)
  if (!file.exists(path)) {
    stop(sprintf("input file not found for panel '%s': %s", panel, path))
  }
  data <- utils::read.csv2(path, check.names = TRUE,
                           stringsAsFactors = FALSE,
                           na.strings = c("", "NA"))
  required <- c(spec$subject_columns, spec$measures)
  missing_cols <- setdiff(required, names(data))
  if (length(missing_cols) > 0) {
    stop(sprintf("panel '%s': missing column(s) in %s: %s", panel, path,
                 paste(missing_cols, collapse = ", ")))
  }
  for (col in spec$measures) {
    raw <- data[[col]]
    num <- suppressWarnings(as.numeric(raw))
    bad <- !is.na(raw) & is.na(num)
    if (any(bad)) {
      stop(sprintf(
        "panel '%s': measure column '%s' cannot be converted to numeric (%d value(s), for example '%s')",
        panel, col, sum(bad), as.character(raw[bad][1])))
    }
    data[[col]] <- num
  }
  for (col in intersect(spec$extra_columns, names(data))) {
    data[[col]] <- suppressWarnings(as.numeric(data[[col]]))
  }
  orders <- subject_level_orders()
  for (col in names(orders)) {
    data[[col]] <- order_levels(data[[col]], orders[[col]], keep_absent = TRUE)
  }
  data$Codigo.Estudio <- as.character(data$Codigo.Estudio)
  data$Codigo.muestra <- as.character(data$Codigo.muestra)
  data$Birth.Year <- suppressWarnings(as.integer(data$Birth.Year))
  if ("Synthetic" %in% names(data)) {
    data$Synthetic <- NULL
  }
  codes <- data$Codigo.Estudio
  synthetic <- length(codes) > 0 && all(!is.na(codes) & startsWith(codes, "SYN-"))
  data <- as.data.frame(data, stringsAsFactors = FALSE)
  attr(data, "panel") <- panel
  attr(data, "source") <- path
  attr(data, "data_label") <- if (synthetic) {
    "synthetic example data (no biological meaning)"
  } else {
    "study data"
  }
  data
}
