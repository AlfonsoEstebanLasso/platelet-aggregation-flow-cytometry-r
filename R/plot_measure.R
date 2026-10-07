# R/plot_measure.R
#
# Purpose: the two figure templates of v1.0: the box or violin plot of one
#          measure by treatment facetted by genotype (two_way) or by genotype
#          alone (one_way), with jittered points under a fixed seed, optional
#          per-point centre labels (off by default) and the group n printed
#          only for cells with at least min_cell observations; and the cohort
#          overview stacked bar chart of counts by Treatment.
# Inputs:  a recoded data frame (plot_measure) or the output of
#          summarise_cohort() (plot_cohort).
# Outputs: no file is written; both functions return ggplot objects, which
#          R/export.R saves with ggsave().

#' @title Box or violin plot of one measure
#' @description Draws the v1.0 figure of one measure: two_way puts Treatment
#'   on the x axis and facets by Genotype, one_way puts Genotype on the x
#'   axis without facets. The fill follows the x factor with the legend
#'   hidden; the geometry is geom_boxplot(outlier.shape = NA) or
#'   geom_violin(); every row with a non-missing response is drawn as a
#'   point jittered with position_jitter(width = 0.15, height = 0, seed);
#'   the per-point label (label_column) is drawn with the same position
#'   object only when label_points is TRUE; the group n is printed at the
#'   cell median only for cells with at least min_cell responses. Rows with
#'   a missing response are removed before plotting.
#' @param data A data frame with the measure and the factor columns.
#' @param measure Name of the response column.
#' @param design "two_way" (Genotype by Treatment) or "one_way" (Genotype).
#' @param geom "box" or "violin".
#' @param title Figure title; the measure name when NULL.
#' @param subtitle Optional subtitle.
#' @param caption Optional caption.
#' @param y_label Label of the y axis (default the measure name).
#' @param label_points Logical; draw the per-point label (default FALSE).
#' @param label_column Column used for the per-point label.
#' @param min_cell Minimum number of responses for a printed n.
#' @param seed Seed of the jitter.
#' @return A ggplot object (never printed or saved).
plot_measure <- function(data, measure, design = c("two_way", "one_way"),
                         geom = c("box", "violin"), title = NULL,
                         subtitle = NULL, caption = NULL, y_label = measure,
                         label_points = FALSE,
                         label_column = "Centro.Analisis", min_cell = 5,
                         seed = 20211109) {
  design <- match.arg(design)
  geom <- match.arg(geom)
  stopifnot(is.data.frame(data), is.character(measure), length(measure) == 1,
            is.logical(label_points), length(label_points) == 1,
            is.numeric(min_cell), length(min_cell) == 1,
            is.numeric(seed), length(seed) == 1)
  if (!measure %in% names(data)) {
    stop(sprintf("plot_measure(): measure column '%s' not found", measure))
  }
  if (!is.numeric(data[[measure]])) {
    stop(sprintf("plot_measure(): measure column '%s' is not numeric", measure))
  }
  x_var <- if (design == "two_way") "Treatment" else "Genotype"
  needed <- unique(c(x_var, "Genotype", if (label_points) label_column))
  absent <- setdiff(needed, names(data))
  if (length(absent) > 0) {
    stop(sprintf("plot_measure(): column(s) not found: %s",
                 paste(absent, collapse = ", ")))
  }
  if (is.null(title)) {
    title <- measure
  }
  d <- data[!is.na(data[[measure]]), , drop = FALSE]
  rownames(d) <- NULL
  cell_vars <- if (design == "two_way") c("Genotype", "Treatment") else "Genotype"
  counts <- d |>
    dplyr::group_by(dplyr::across(dplyr::all_of(cell_vars))) |>
    dplyr::summarise(n = dplyr::n(),
                     median = stats::median(.data[[measure]]),
                     .groups = "drop") |>
    dplyr::filter(n >= min_cell) |>
    as.data.frame(stringsAsFactors = FALSE)
  pos <- ggplot2::position_jitter(width = 0.15, height = 0, seed = seed)
  p <- ggplot2::ggplot(d, ggplot2::aes(x = .data[[x_var]], y = .data[[measure]]))
  if (geom == "box") {
    p <- p + ggplot2::geom_boxplot(ggplot2::aes(fill = .data[[x_var]]),
                                   outlier.shape = NA)
  } else {
    # ggplot2 cannot compute a density for a cell with a single observation
    # and drops it with a warning; the violin layer is therefore drawn from
    # the cells with at least two responses (the drawing is identical) while
    # the point layer below still shows every row.
    cell_n <- stats::ave(seq_len(nrow(d)), d[cell_vars], FUN = length)
    p <- p + ggplot2::geom_violin(data = d[cell_n >= 2, , drop = FALSE],
                                  ggplot2::aes(fill = .data[[x_var]]))
  }
  p <- p + ggplot2::geom_point(size = 1, position = pos)
  if (isTRUE(label_points)) {
    p <- p + ggplot2::geom_text(ggplot2::aes(label = .data[[label_column]]),
                                size = 2.5, position = pos)
  }
  if (nrow(counts) > 0) {
    p <- p + ggplot2::geom_text(data = counts,
                                ggplot2::aes(y = median,
                                             label = paste0("n = ", n)),
                                vjust = -0.6)
  }
  if (design == "two_way") {
    p <- p + ggplot2::facet_grid(. ~ Genotype)
  }
  p <- p +
    ggplot2::labs(title = title, subtitle = subtitle, caption = caption,
                  x = x_var, y = y_label) +
    ggplot2::guides(fill = "none")
  p
}

#' @title Stacked bar chart of the cohort counts
#' @description Takes the output of summarise_cohort() and draws the counts
#'   by Treatment stacked and filled by the group column, with the count
#'   printed in white inside each segment whose n is at least min_cell. The
#'   palette is the ggplot2 default sized from the number of levels.
#' @param counts Data frame returned by summarise_cohort().
#' @param group Name of the group column ("Gender" or "Genotype").
#' @param title Optional title.
#' @param min_cell Minimum count for a printed number.
#' @return A ggplot object.
plot_cohort <- function(counts, group, title = NULL, min_cell = 5) {
  stopifnot(is.data.frame(counts), is.character(group), length(group) == 1,
            all(c("Treatment", group, "n", "label_y") %in% names(counts)),
            is.numeric(min_cell), length(min_cell) == 1)
  labelled <- counts[counts$n >= min_cell, , drop = FALSE]
  p <- ggplot2::ggplot(counts, ggplot2::aes(x = Treatment, y = n)) +
    ggplot2::geom_bar(ggplot2::aes(fill = .data[[group]]), stat = "identity")
  if (nrow(labelled) > 0) {
    p <- p + ggplot2::geom_text(data = labelled,
                                ggplot2::aes(y = label_y, label = n,
                                             group = .data[[group]]),
                                colour = "white")
  }
  p + ggplot2::labs(title = title, x = "Treatment", y = "Count", fill = group)
}
