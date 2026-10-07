# tests/testthat/test-plot_measure.R
#
# Purpose: checks of plot_measure() (docs/v1_spec.md, section 8.3) on the
#   synthetic aggregation and hemogram tables.
# Inputs: data/synthetic/synthetic_aggregation.csv and
#   data/synthetic/synthetic_hemogram.csv through read_inputs().
# Outputs: none (figures are built in memory, never saved).

agg <- recode_variants(master_data("aggregation"), "CENTRE_A")
hem <- recode_variants(master_data("hemogram"), "CENTRE_A")

is_text_layer <- function(layer) inherits(layer$geom, "GeomText")
is_point_layer <- function(layer) inherits(layer$geom, "GeomPoint")

layer_uses_column <- function(layer, column) {
  mapping <- layer$mapping
  if (is.null(mapping) || is.null(mapping$label)) return(FALSE)
  grepl(column, paste(deparse(mapping$label), collapse = ""), fixed = TRUE)
}

n_labels <- function(p) {
  built <- ggplot2::ggplot_build(p)
  text_layers <- which(vapply(p$layers, is_text_layer, logical(1)))
  labels <- character(0)
  for (i in text_layers) {
    lab <- as.character(built$data[[i]]$label)
    labels <- c(labels, lab[startsWith(lab, "n = ")])
  }
  labels
}

point_coordinates <- function(p) {
  built <- ggplot2::ggplot_build(p)
  i <- which(vapply(p$layers, is_point_layer, logical(1)))[1]
  built$data[[i]][, c("x", "y")]
}

test_that("plot_measure() returns a ggplot for both designs and both geometries", {
  for (geom in c("box", "violin")) {
    p2 <- plot_measure(agg, "PMA", design = "two_way", geom = geom,
                       subtitle = "aggregation", caption = "synthetic")
    expect_s3_class(p2, "ggplot")
    p1 <- plot_measure(hem, "HGB.gr.dl.", design = "one_way", geom = geom,
                       y_label = "Haemoglobin (g/dl)")
    expect_s3_class(p1, "ggplot")
    expect_true(any(vapply(p2$layers, is_point_layer, logical(1))))
    expect_true(any(vapply(p1$layers, is_point_layer, logical(1))))
  }
  expect_identical(plot_measure(agg, "PMA", design = "two_way")$labels$title, "PMA")
})

test_that("centre labels are off by default and on with label_points = TRUE", {
  p_off <- plot_measure(agg, "PMA", design = "two_way", label_points = FALSE)
  uses_off <- vapply(p_off$layers, function(l) is_text_layer(l) &&
                       layer_uses_column(l, "Centro.Analisis"), logical(1))
  expect_equal(sum(uses_off), 0)
  p_on <- plot_measure(agg, "PMA", design = "two_way", label_points = TRUE)
  uses_on <- vapply(p_on$layers, function(l) is_text_layer(l) &&
                      layer_uses_column(l, "Centro.Analisis"), logical(1))
  expect_equal(sum(uses_on), 1)
  built <- ggplot2::ggplot_build(p_on)
  centre_labels <- as.character(built$data[[which(uses_on)]]$label)
  expect_true(all(centre_labels == "CENTRE_A"))
})

test_that("the n labels exist only for cells with at least min_cell responses", {
  d <- agg[!is.na(agg$PMA), ]
  cells <- table(d$Treatment, d$Genotype)
  for (min_cell in c(5, 1, 20)) {
    p <- plot_measure(agg, "PMA", design = "two_way", min_cell = min_cell)
    # sprintf() returns character(0) for a zero-length input, unlike paste0()
    expected <- sprintf("n = %d", as.integer(cells[cells >= min_cell]))
    expect_identical(sort(n_labels(p)), sort(expected), info = paste("min_cell", min_cell))
  }
  expect_length(n_labels(plot_measure(agg, "PMA", design = "two_way", min_cell = 20)), 0)
  d1 <- hem[!is.na(hem$HGB.gr.dl.), ]
  cells1 <- table(d1$Genotype)
  p1 <- plot_measure(hem, "HGB.gr.dl.", design = "one_way", min_cell = 5)
  expect_identical(sort(n_labels(p1)), sort(sprintf("n = %d", as.integer(cells1[cells1 >= 5]))))
})

test_that("the same seed gives identical point coordinates and a different seed does not", {
  p1 <- plot_measure(agg, "CVX", design = "two_way", seed = 20211109)
  p2 <- plot_measure(agg, "CVX", design = "two_way", seed = 20211109)
  p3 <- plot_measure(agg, "CVX", design = "two_way", seed = 1)
  c1 <- point_coordinates(p1)
  c2 <- point_coordinates(p2)
  c3 <- point_coordinates(p3)
  expect_identical(c1, c2)
  expect_equal(nrow(c1), sum(!is.na(agg$CVX)))
  expect_false(identical(c1$x, c3$x))
  expect_identical(c1$y, c3$y)
})

test_that("rows with a missing response produce no warning", {
  expect_true(anyNA(agg$TRAP))
  p <- plot_measure(agg, "TRAP", design = "two_way")
  expect_silent(built <- ggplot2::ggplot_build(p))
  expect_equal(nrow(point_coordinates(p)), sum(!is.na(agg$TRAP)))
  p1 <- plot_measure(hem, "EPO..mlU.ml.", design = "one_way")
  expect_silent(ggplot2::ggplot_build(p1))
})
