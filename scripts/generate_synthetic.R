# scripts/generate_synthetic.R
#
# Purpose: write the synthetic example data set of v1.0 (a fictitious cohort
#   of 100 subjects drawn from hand-set distributions, no biological
#   meaning) with the fixed project seed, so that the pipeline, the tests
#   and the committed example outputs can be exercised without any study
#   data.
# Inputs: R/synthetic_data.R (sourced). No data file is read.
# Outputs: data/synthetic/synthetic_aggregation.csv,
#   data/synthetic/synthetic_hemogram.csv and
#   data/synthetic/synthetic_markers.csv, in the private CSV format
#   (semicolon, decimal comma, no quoting, empty fields for missing values,
#   LF line endings), plus a short summary printed to the console.
# Usage, from the repository root:
#   Rscript scripts/generate_synthetic.R
# Packages: base R only.

if (!file.exists("R/synthetic_data.R")) {
  stop("Run this script from the repository root: ",
       "Rscript scripts/generate_synthetic.R")
}
source("R/synthetic_data.R")

synthetic_outdir <- "data/synthetic"
synthetic_n <- 100
synthetic_seed <- 20211109

result <- generate_synthetic(outdir = synthetic_outdir, n = synthetic_n,
                             seed = synthetic_seed, write = TRUE)

cat("Synthetic example data written with seed", synthetic_seed, "\n")
for (panel in c("aggregation", "hemogram", "markers")) {
  table <- result[[panel]]
  path <- file.path(synthetic_outdir, synthetic_file_name(panel))
  n_missing <- sum(is.na(table))
  cat(sprintf("  %-12s %s: %d rows, %d columns, %d missing cells\n",
              panel, path, nrow(table), ncol(table), n_missing))
}
cat("Cohort: ", nrow(result$cohort), " subjects; centre ",
    paste(names(table(result$cohort$Centro.Analisis)),
          as.integer(table(result$cohort$Centro.Analisis)),
          sep = " = ", collapse = ", "),
    "\n", sep = "")
cat("Genotype: ",
    paste(names(table(result$cohort$Genotype)),
          as.integer(table(result$cohort$Genotype)),
          sep = " = ", collapse = ", "),
    "\n", sep = "")
cat("The values carry no biological meaning; see data/synthetic/README.md.\n")
