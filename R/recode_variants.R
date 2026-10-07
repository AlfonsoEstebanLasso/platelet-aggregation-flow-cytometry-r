# R/recode_variants.R
#
# Purpose: the recodings that the 2021 analysis did by hand in spreadsheets,
#          implemented in code from one master table per panel: the centre
#          filter, the collapse of Treatment to treated versus untreated and
#          the merge of the VARIANT genotype label into TN, combined into the
#          four variants of section 5 of docs/v1_spec.md; plus the cohort
#          count summary used by the overview figures.
# Inputs:  a data frame returned by read_inputs() (or any data frame with
#          the subject columns Genotype, Treatment and Centro.Analisis).
# Outputs: no file is written. The functions return recoded data frames
#          with the attributes variant and recoding, the variant table and
#          the cohort count table.

#' @title Labels used by the recodings
#' @description Returns the list of labels that the recodings rely on. A
#'   user of private data overrides the elements whose spelling differs.
#' @return A list with centre_column, centre_keep, untreated, treated,
#'   variant, tn, treatment_levels and genotype_levels.
variant_levels <- function() {
  list(centre_column = "Centro.Analisis",
       centre_keep = "CENTRE_A",
       untreated = "Untreated",
       treated = "Treated",
       variant = "VARIANT",
       tn = "TN",
       treatment_levels = c("Untreated", "ASA", "Anagrelide", "HU"),
       genotype_levels = c("CNTRL", "JAK2 V617F", "CALR Type I",
                           "CALR Type II", "CALR Type_Other", "MPL W515",
                           "TN", "VARIANT"))
}

#' @title Table of the four v1.0 variants
#' @description One row per variant of section 5 of the specification, with
#'   the flags of the recoding operations, the default geometry and the
#'   legacy object and file names that the variant reproduces.
#' @return A data frame with the columns variant, centre, treatment,
#'   genotype, geom, legacy_object, legacy_file_aggregation,
#'   legacy_file_hemogram, legacy_file_markers and legacy_title_suffix.
variant_table <- function() {
  data.frame(
    variant = c("CENTRE_A", "CENTRE_Atratadosnotratados",
                "CENTRE_AtratadosnotratadosMPLCONTN", "CENTRE_ATNCONMPL"),
    centre = c(TRUE, TRUE, TRUE, TRUE),
    treatment = c(FALSE, TRUE, TRUE, FALSE),
    genotype = c(FALSE, FALSE, TRUE, TRUE),
    geom = c("box", "violin", "box", "box"),
    legacy_object = c("CENTRE_A", "CENTRE_Atratadosnotratados",
                      "CENTRE_AtratadosnotratadosMPLCONTN",
                      "CENTRE_ATNCONMPL"),
    legacy_file_aggregation = c("CENTRE_A.csv",
                                "CENTRE_Atratadosnotratados.csv",
                                "CENTRE_AtratadosnotratadosMPLCONTN.csv",
                                "CENTRE_ATNCONMPL.csv"),
    legacy_file_hemogram = c(
      "Hemograma_ALL_Nov9_2021CENTRE_A.csv",
      "Hemograma_ALL_Nov9_2021_CENTRE_Atratadosnotratados.csv",
      "Hemograma_ALL_Nov9_2021_CENTRE_AtratadosnotratadosMPLSTN.csv",
      "Hemograma_ALL_Nov9_2021CENTRE_AMPLSTN.csv"),
    legacy_file_markers = c(
      "SurfaceMarkers_ALL_Nov9_2021CENTRE_A.csv",
      "SurfaceMarkers_ALL_Nov9_2021_CENTRE_Atratadosnotratados.csv",
      "SurfaceMarkers_ALL_Nov9_2021_CENTRE_AtratadosnotratadosMPLSTN.csv",
      "SurfaceMarkers_ALL_Nov9_2021CENTRE_ATNCONMPL.csv"),
    legacy_title_suffix = c("CENTRE_A", "CENTRE_A tratadosVSnotratados",
                            "CENTRE_A tratadosVSnotratados MPLCONTN",
                            "CENTRE_A MPL CON TN"),
    stringsAsFactors = FALSE)
}

#' @title Copy the user attributes of a data frame
#' @description Returns the attributes of a data frame other than names,
#'   row.names and class, so that they can be restored after subsetting.
#' @param data A data frame.
#' @return A named list of attributes (possibly empty).
user_attributes <- function(data) {
  a <- attributes(data)
  a[setdiff(names(a), c("names", "row.names", "class"))]
}

#' @title Restore user attributes on a data frame
#' @param data A data frame.
#' @param attrs A named list as returned by user_attributes().
#' @return The data frame with the attributes set.
set_user_attributes <- function(data, attrs) {
  for (nm in names(attrs)) {
    attr(data, nm) <- attrs[[nm]]
  }
  data
}

#' @title Keep the rows of the first centre
#' @description Keeps the rows whose centre column equals levels$centre_keep
#'   and errors if none remains. Factor levels are not dropped here.
#' @param data A data frame with the centre column.
#' @param levels List returned by variant_levels().
#' @return The filtered data frame with the attributes of the input.
filter_centre <- function(data, levels = variant_levels()) {
  stopifnot(is.data.frame(data), is.list(levels))
  col <- levels$centre_column
  if (!col %in% names(data)) {
    stop(sprintf("filter_centre(): column '%s' not found", col))
  }
  attrs <- user_attributes(data)
  keep <- !is.na(data[[col]]) & as.character(data[[col]]) == levels$centre_keep
  if (!any(keep)) {
    stop(sprintf("filter_centre(): no row with %s == '%s'", col,
                 levels$centre_keep))
  }
  out <- data[keep, , drop = FALSE]
  rownames(out) <- NULL
  set_user_attributes(out, attrs)
}

#' @title Collapse Treatment to untreated versus treated
#' @description Maps every Treatment level other than levels$untreated to
#'   levels$treated and sets the factor levels to c(untreated, treated).
#'   Missing values stay missing.
#' @param data A data frame with the column Treatment.
#' @param levels List returned by variant_levels().
#' @return The data frame with Treatment recoded.
collapse_treatment <- function(data, levels = variant_levels()) {
  stopifnot(is.data.frame(data), "Treatment" %in% names(data))
  x <- as.character(data$Treatment)
  x[!is.na(x) & x != levels$untreated] <- levels$treated
  data$Treatment <- factor(x, levels = c(levels$untreated, levels$treated))
  data
}

#' @title Merge the VARIANT genotype label into TN
#' @description Replaces the Genotype level levels$variant by levels$tn and
#'   removes the VARIANT level; the other levels keep their order and TN is
#'   appended if it was absent.
#' @param data A data frame with the column Genotype.
#' @param levels List returned by variant_levels().
#' @return The data frame with Genotype recoded.
merge_variant_genotype <- function(data, levels = variant_levels()) {
  stopifnot(is.data.frame(data), "Genotype" %in% names(data))
  old <- data$Genotype
  lv <- if (is.factor(old)) levels(old) else sort(unique(as.character(old[!is.na(old)])))
  x <- as.character(old)
  x[!is.na(x) & x == levels$variant] <- levels$tn
  lv <- lv[lv != levels$variant]
  if (!levels$tn %in% lv) {
    lv <- c(lv, levels$tn)
  }
  data$Genotype <- factor(x, levels = lv)
  data
}

#' @title Restore the level order of section 3.2
#' @description Reorders the levels of the subject factors that remain after
#'   droplevels(): Genotype by levels$genotype_levels, Treatment by
#'   levels$treatment_levels followed by levels$treated, the centre column
#'   with levels$centre_keep first and Gender as F, M. Levels absent from the
#'   reference lists are appended alphabetically.
#' @param data A data frame.
#' @param levels List returned by variant_levels().
#' @return The data frame with reordered factor levels.
restore_level_order <- function(data, levels = variant_levels()) {
  prefs <- list(Gender = c("F", "M"),
                Genotype = levels$genotype_levels,
                Treatment = c(levels$treatment_levels, levels$treated))
  prefs[[levels$centre_column]] <- levels$centre_keep
  for (col in intersect(names(prefs), names(data))) {
    data[[col]] <- order_levels(data[[col]], prefs[[col]], keep_absent = FALSE)
  }
  data
}

#' @title Apply the recoding operations of one variant
#' @description Applies, in the order centre, treatment, genotype, the
#'   operations flagged for the variant in variant_table(), then
#'   droplevels() and the restoration of the level order of section 3.2.
#' @param data A data frame returned by read_inputs().
#' @param variant One of the four variant ids of variant_table().
#' @param levels List returned by variant_levels().
#' @return The recoded data frame with the attributes of the input plus
#'   variant (the id) and recoding (the operations applied, in order).
recode_variants <- function(data, variant, levels = variant_levels()) {
  stopifnot(is.data.frame(data), is.character(variant), length(variant) == 1)
  vt <- variant_table()
  if (!variant %in% vt$variant) {
    stop(sprintf("unknown variant '%s'; expected one of: %s", variant,
                 paste(vt$variant, collapse = ", ")))
  }
  row <- vt[vt$variant == variant, ]
  attrs <- user_attributes(data)
  ops <- character(0)
  out <- data
  if (isTRUE(row$centre)) {
    out <- filter_centre(out, levels)
    ops <- c(ops, "centre")
  }
  if (isTRUE(row$treatment)) {
    out <- collapse_treatment(out, levels)
    ops <- c(ops, "treatment")
  }
  if (isTRUE(row$genotype)) {
    out <- merge_variant_genotype(out, levels)
    ops <- c(ops, "genotype")
  }
  out <- droplevels(out)
  out <- restore_level_order(out, levels)
  rownames(out) <- NULL
  out <- set_user_attributes(out, attrs)
  attr(out, "variant") <- variant
  attr(out, "recoding") <- ops
  out
}

#' @title Count the cohort by Treatment and one grouping column
#' @description Counts the rows of every observed combination of Treatment
#'   and the grouping column, showing missing values as the level
#'   "(missing)", and adds the cumulative mid-point used to place the count
#'   inside the stacked bar of the overview figure (as in the legacy
#'   overview, cumulated within Treatment in descending level order so that
#'   the first level sits on top of the stack).
#' @param data A data frame with the columns Treatment and the group column.
#' @param group "Gender" or "Genotype".
#' @return A plain data frame with the columns Treatment, the group column
#'   (named after it), n and label_y. The sum of n equals nrow(data).
summarise_cohort <- function(data, group = c("Gender", "Genotype")) {
  group <- match.arg(group)
  stopifnot(is.data.frame(data), "Treatment" %in% names(data),
            group %in% names(data))
  missing_label <- "(missing)"
  with_missing <- function(x) {
    lv <- if (is.factor(x)) levels(x) else sort(unique(as.character(x[!is.na(x)])))
    x <- as.character(x)
    if (anyNA(x)) {
      x[is.na(x)] <- missing_label
      lv <- c(lv, missing_label)
    }
    factor(x, levels = lv)
  }
  d <- data.frame(Treatment = with_missing(data$Treatment),
                  level_ = with_missing(data[[group]]),
                  stringsAsFactors = FALSE)
  counts <- d |>
    dplyr::count(Treatment, level_, name = "n") |>
    dplyr::arrange(Treatment, dplyr::desc(level_)) |>
    dplyr::group_by(Treatment) |>
    dplyr::mutate(label_y = cumsum(n) - 0.5 * n) |>
    dplyr::ungroup() |>
    as.data.frame(stringsAsFactors = FALSE)
  names(counts)[names(counts) == "level_"] <- group
  stopifnot(sum(counts$n) == nrow(data))
  counts
}
