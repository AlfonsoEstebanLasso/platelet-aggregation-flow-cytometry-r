# Platelet function by flow cytometry in essential thrombocythemia: aggregation, surface markers and hemogram analysis in R

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
![R 4.x](https://img.shields.io/badge/R-4.x-276DC3?style=flat-square&logo=r&logoColor=white)
![ggplot2](https://img.shields.io/badge/ggplot2-figures-1F6FB2?style=flat-square)
![ggpubr](https://img.shields.io/badge/ggpubr-theme__pubclean-2C7FB8?style=flat-square)
![dplyr](https://img.shields.io/badge/dplyr-data%20wrangling-2E8B57?style=flat-square)
![readxl](https://img.shields.io/badge/readxl-Excel%20input-6F42C1?style=flat-square)
![car](https://img.shields.io/badge/car-type%20II%20ANOVA-B7791F?style=flat-square)
![testthat](https://img.shields.io/badge/testthat-tests-1F7A3A?style=flat-square)
![renv](https://img.shields.io/badge/renv-lock%20file-4C566A?style=flat-square)

**Exploratory R code of a 2021 commissioned analysis of platelet aggregation, platelet surface markers and the hemogram in essential thrombocythemia, published as delivered and cleaned, with its known defects documented and no patient data; v1.0 adds a refactored implementation of the first-centre analysis that runs on synthetic example data.**

R code of a commissioned statistical analysis (2021) of platelet function
measured by flow cytometry in essential thrombocythemia, written for the study
whose results appear in the 2026 article cited under How to cite. The five
scripts in `legacy/` are published as delivered, with the changes made to
remove identifying material (paths, `setwd()` arguments, centre tokens and
two genotype labels, all replaced by placeholders and logged in
`docs/cleaning.md`) and a provenance header; v0.1.0 added a description of
the inputs the scripts expect, a list of the known defects of the code and
the citation metadata, and v1.0 adds a refactored implementation of the
first-centre analysis (functions under `R/`, type II ANOVA with assumption
checks and multiplicity corrections, exported figures and tables, synthetic
example data, tests and a lock file), kept separate from the legacy code
and described under v1.0: refactored implementation. The legacy scripts
cannot run without the private input tables of the study, which are not
distributed; the v1.0 code runs on the synthetic tables of
`data/synthetic/`, which carry no biological meaning.

**Disclaimer:** this is research code published for transparency and
traceability. The repository contains no patient data, no identifier and no
value of any individual; it is not a clinical tool and must not be used to
guide the diagnosis or treatment of any patient; and the legacy scripts are
not executable without the study's private data, which are available only
from the principal investigator under the study's own terms. The v1.0 code
is executable, but only on synthetic example data generated from
distributions: no figure or table in this repository was produced from a
real subject.

Commissioned analysis for a platelet function study in essential
thrombocythemia (2021). Author: Alfonso Esteban Lasso, third author of the
resulting article.

> The scripts in `legacy/` are published as delivered in 2021 and keep their
> original Spanish comments, section labels and figure titles (for example
> "Analisis de Anova", "tratadosVSnotratados", "MPL CON TN"); everything
> written for v0.1.0 (this README, `legacy/README.md`, `data/README.md`,
> `docs/cleaning.md`, `docs/limitations.md` and `CITATION.cff`) and for v1.0
> (`R/`, `scripts/`, `tests/`, `run_all.R`, `data/synthetic/README.md`,
> `docs/v1_spec.md` and `docs/legacy_to_v1.md`) is in English. The four v1.0 variant ids (`CENTRE_A`, `CENTRE_Atratadosnotratados`, `CENTRE_AtratadosnotratadosMPLCONTN`, `CENTRE_ATNCONMPL`) reuse the legacy object suffixes verbatim, including the Spanish token `tratadosnotratados`, so that each v1.0 directory and figure title can be matched to its 2021 block; they are identifiers, not prose.

## Objective

The code describes and compares, between genotype groups of essential
thrombocythemia and between treatment groups, three panels of platelet
measurements obtained by flow cytometry in a two-centre cohort of roughly one
hundred subjects:

- **Platelet aggregation** (`Agonistas_2021-11-04.R` and
  `Agonistas_2021-11-09.R`): the response to six agonists (PMA, CVX, RISTO,
  AGGA, COL and TRAP) and three baseline measures (unstimulated aggregation
  at 10 minutes, the measurement at time zero and their ratio). For each
  measure and for each hand-prepared variant of the input table the scripts
  draw a box plot or a violin plot by treatment facetted by genotype, with
  every point drawn and the group n printed, and fit a two-way factorial
  ANOVA (genotype by treatment, with interaction) followed by Tukey HSD.
- **Platelet surface markers** (`surfacemarkers.R`): ten markers (CD61,
  CD41, CD49B, GPVI, CD42A, CD42B, CD31, CD36, CD9 and the unstained forward
  scatter) with the same figure and the same two-way ANOVA with Tukey HSD
  over eight variants of the table.
- **Hemogram** (`hemogram.R`): fourteen variables (EPO, TPO, haemoglobin,
  haematocrit, MCH, MCHC and the percentages and absolute counts of
  lymphocytes, monocytes, eosinophils and basophils) with one box or violin
  plot per genotype and a one-way ANOVA (genotype) followed by Tukey HSD over
  the same eight variants.

The two aggregation scripts and `surfacemarkers.R` open with cohort overview
charts (stacked bars of counts by treatment and sex, and by treatment and
genotype, with the count printed inside each segment); `hemogram.R` has no
overview block. The genotype groups are those named in the article (MPL,
CALR, TN for triple negative, plus control and further levels). Treatment is
either four levels (untreated plus three treatment groups) or two levels
(treated versus untreated), depending on the input table; it is a factor of
the figures and models of the aggregation and surface marker scripts, while
the hemogram figures and models are by genotype only, with treatment and
centre expressed solely through the choice of input table. The fifth script,
`pipeline_2021-03.R`, is the first exploratory look at the aggregation table
in March 2021 (descriptives, histograms, box plots with jittered points, a
global PCA and contingency tables in R base) and is kept only as lineage
documentation. All results go to the screen and the console; no script
writes any file.

The correspondence between individual code blocks and the panels or tables
published in the article has not been established from the code alone and is
not claimed here: the scripts cover more variables and more table variants
than the article reports, and nothing in the code records which block fed
which result.

## Data & methods

This repository does **not** contain and will **not** distribute any input
data. The inputs are subject-level research tables (one row per patient or
donor, with pseudonymous codes, sex, year of birth, genotype, treatment,
analysing centre and laboratory values) that cannot be published, not even
as a stripped extract, because the combination of their columns is a
quasi-identifier in a cohort of this size. `data/` holds nothing but its
README and, since v1.0, the synthetic folder `data/synthetic/` (tables
generated from hand-set distributions, see v1.0: refactored implementation),
and is ignored by git, together with every `.csv`, `.xlsx`, `.xls` and
`.txt` file, so that private tables placed there for local execution are
never committed; the only re-included paths are `data/synthetic/*.csv` and
the example outputs under `outputs/example/`, both produced from the
synthetic data. [`data/README.md`](data/README.md) documents what a reader
with authorized access needs to reproduce the inputs: the file names as
referenced by the cleaned scripts, their formats (XLSX with the header in row
1, semicolon-separated CSV with decimal comma, tab-delimited text), the
column names and types used by the code and the meaning of the suffixes of
the derived tables (export date, centre subset, treatment collapsed to two
levels, one genotype label merged into TN).

The five scripts, as delivered and cleaned (line counts as reported by
`wc -l` on the published files, each of which starts with a 14-line
provenance header, so the original line numbers are the published numbers
minus 14):

| Script | Lines | Data cut-off | What it computes |
| --- | --- | --- | --- |
| `legacy/Agonistas_2021-11-04.R` | 2206 | 2021-10-27, both centres | Nine aggregation measures over twelve table variants: 24 overview charts, 108 figures, 108 two-way ANOVA fits with Tukey HSD; version delivered on 2021-11-04. Followed by an unfinished test block (PCA by centre), two subsets drawn without tests and two four-factor ANOVA fits at the end of the file. |
| `legacy/Agonistas_2021-11-09.R` | 1477 | 2021-11-09, first centre only | Later version of the aggregation analysis over eight variants (`CENTRE_A` only): 16 overview charts, 72 figures with titles, 72 two-way ANOVA fits with Tukey HSD. |
| `legacy/hemogram.R` | 1788 | 2021-11-09 export | Fourteen hemogram and hormone variables over eight variants: 112 figures, 112 one-way ANOVA fits (genotype) with Tukey HSD. |
| `legacy/surfacemarkers.R` | 1558 | 2021-11-09 export | Ten surface markers over eight variants: 16 overview charts, 80 figures, 80 two-way ANOVA fits with Tukey HSD. |
| `legacy/pipeline_2021-03.R` | 167 | March 2021 export | Exploratory pipeline in R base on the first aggregation export: descriptives, 52 on-screen figures, one global PCA, contingency tables; no statistical test. |

Methods: every analysis script loads the hand-prepared variants of one
panel, draws the overview charts where it has them, and then repeats one
template per variable and per variant: a ggplot2 figure (box plot or violin
plot, points, the centre of each point as a text label, the group n printed
by `stat_summary`), `aov()`, `summary()` and `TukeyHSD()`. Treatment
recoding, genotype merging and the centre partition were done by hand in
spreadsheets before the analysis and have no code in the repository;
`data/README.md` describes them in words. No multiplicity correction and no
check of the ANOVA assumptions were applied, by design of the delivered
analysis.

Cleaning applied before publication: a fourteen-line provenance header with
the original file name (withheld for the March pipeline, whose name included
a first name), encoding, line endings and SHA-256 of the delivered file;
absolute paths replaced by `data/<file>` (11, 1, 9, 9 and 2 replacements in
the five scripts, in the order of the table above; in the four 2021-11
scripts the count includes the argument of the disabled `setwd()` call,
which now reads only the placeholder `data`); `setwd()` calls disabled (one
in each of the four 2021-11 scripts; the March pipeline had none); the two
analysing centres renamed `CENTRE_A` (171, 218, 344, 264 and 0 occurrences)
and `CENTRE_B` (245 occurrences, all in `Agonistas_2021-11-04.R`) in object
names, file names, comments and titles; the label of one genotype variant
renamed `VARIANT` (125, 64, 0, 13 and 16 occurrences), with the compound
label that paired it with a gene name reduced to the bare placeholder in the
genotype filter lists of `surfacemarkers.R` (4 occurrences) and in one file
name of `pipeline_2021-03.R`; and one genotype category of the filter lists
of `surfacemarkers.R` renamed `CALR Type_Other` (8 occurrences). No other
change was made to the code; the full log is in
[`docs/cleaning.md`](docs/cleaning.md) and the section maps of each script in
[`legacy/README.md`](legacy/README.md).

## Known limitations

The delivered code has the defects summarised below and documented with file
and line in [`docs/limitations.md`](docs/limitations.md). They are left
uncorrected in v0.1.0:

1. In `Agonistas_2021-11-09.R` only 48 of the 72 ANOVA fits are valid and
   distinct by direct count: 18 are fitted on measurement columns imported as
   text, because two CSV files with decimal comma are read with
   `read.csv(sep = ";")` instead of `read.csv2()` (one of those 18 also stops
   the script with a typo in its data argument), 5 reference an object that is
   never read, and 1 duplicates the fit that follows it. Sourcing the whole
   file fails at the first of these errors; the script must be run block by
   block.
2. The other scripts carry smaller copy errors of the same kind: in
   `Agonistas_2021-11-04.R` one input is read twice into the same object, so
   one of the twelve variants (the first centre with both recodings) is never
   analysed and its slot duplicates the global one, and the TRAP fits on the
   second centre run on an empty response; in `surfacemarkers.R` one ANOVA is
   fitted on the wrong object; in `hemogram.R` one fit prints the raw model
   instead of its summary and one formula reads `Genotype * Genotype`; in
   `pipeline_2021-03.R` the standard deviation of TRAP is computed on a
   misspelled column and is silently `NA`.
3. No script exports any figure or table (no `ggsave()`, `pdf()`,
   `write.*()`, `save()` or `sink()`), and the ggplot, `summary()` and
   `TukeyHSD()` calls are not wrapped in `print()`: sourcing a script
   produces nothing, results are visible only when the lines are run
   interactively, and no published panel can be traced to a code block from
   the code alone. The March 2021 pipeline and the test block of
   `Agonistas_2021-11-04.R` also call `View()`, which needs RStudio.
4. The code repeats one template block by hand for every variable and every
   variant (about 86 percent of `Agonistas_2021-11-04.R`, about 85 percent
   of `Agonistas_2021-11-09.R` and almost every line after the input section
   of `hemogram.R` and `surfacemarkers.R`) instead of using functions; the
   model object of each variable is overwritten in every block, so only the
   last fit survives in the session.
5. The eight or twelve variants of each table are hand-set subsets prepared
   in spreadsheets (centre partition, treatment collapsed to two levels, one
   genotype label merged into TN, with inconsistent suffixes for the same
   operation); the overview charts filter on hard-coded lists of genotype and
   sex labels and silently drop every row whose label is not listed.
6. The statistical design is exploratory: 108, 72, 112 and 80 ANOVA fits
   with Tukey HSD per script on unbalanced designs with very small cells,
   type I sums of squares, no multiplicity correction and no
   assumption checks; centre is never a model term in the delivered analysis
   (only the closing section of `Agonistas_2021-11-04.R`, lines 2197 to
   2205, after the test block and the two untested subsets, fits two
   four-factor ANOVAs with it), although three surface markers and TRAP were
   measured at one centre only.
7. The figures print the centre of every point and the n of every cell,
   including the smallest cells, so a figure regenerated from the private
   data is not publishable as produced; `position_jitter()` has no seed.
8. No package versions were recorded with the delivered code. The scripts
   use `fun.y` in `stat_summary()` (deprecated since ggplot2 3.3.0) and the
   `..ymax..` notation (deprecated since ggplot2 3.4.0), and pass the
   `outlier.*` arguments of `geom_boxplot()` to `geom_violin()`, which does
   not have them and ignores them with a warning. Some packages are loaded
   and never used (ggpubr in three scripts, dplyr and readxl in `hemogram.R`,
   readxl in `surfacemarkers.R`, gmodels in the March pipeline), while the
   test block of `Agonistas_2021-11-04.R` calls FactoMineR, factoextra and
   missMDA without loading them.
9. One line of `Agonistas_2021-11-04.R` (the Spanish comment that closes the
   delivered analysis, line 1919) holds the only non-ASCII character of the
   five files, an accented letter stored as UTF-8; in an editor that assumes
   Latin-1 or Windows-1252 it displays as two garbled characters. It is an
   artefact of the original file, kept as delivered.

The results of the delivered analysis should be read with these limitations
in mind. Items 3, 4, 5, 7 and 8, and the copy errors of items 1 and 2 that
fall within the first-centre scope, are addressed by v1.0 (next section)
without touching the legacy scripts.

## v1.0: refactored implementation

v1.0 reimplements, as functions, the analysis of the **first centre only**
(`CENTRE_A`) with the 2021-11-09 data cut-off: the `CENTRE_A` variants of
`legacy/Agonistas_2021-11-09.R`, `legacy/hemogram.R` and
`legacy/surfacemarkers.R`. The cohort-wide variants, the MPLSTN
subdivisions of the aggregation family, the 2021-10-27 cut-off and the
March 2021 pipeline are out of scope and are only mapped as such. The
legacy scripts are untouched; the binding specification is
[`docs/v1_spec.md`](docs/v1_spec.md) and the block-by-block mapping from
2021 to v1.0 is [`docs/legacy_to_v1.md`](docs/legacy_to_v1.md).

### What v1.0 adds

- **One function per task** under `R/` instead of repeated blocks:
  `read_inputs()` (one master table per panel, read with `read.csv2()` and
  type-checked), `recode_variants()` (the four `CENTRE_A` variants built in
  code from the master table: centre filter, treatment collapsed to
  `Untreated` versus `Treated`, `VARIANT` merged into `TN`),
  `plot_measure()` and `plot_cohort()` (figures), `fit_anova()` and
  `adjust_p_values()` (models), `run_panel()` (one panel end to end) and
  the export helpers of `R/export.R`. Every measure is fitted on the variant
  its figure uses, which removes the copy errors of the 2021 scripts
  (`docs/limitations.md`, items 1 and 2).
- **Three panels, same measures as 2021**: nine aggregation measures and ten
  surface markers with the model `measure ~ Genotype * Treatment`, fourteen
  hemogram variables with `measure ~ Genotype`; four variants per panel
  (`CENTRE_A`, `CENTRE_Atratadosnotratados`,
  `CENTRE_AtratadosnotratadosMPLCONTN`, `CENTRE_ATNCONMPL`), named after
  the legacy objects.
- **Type II ANOVA** (`car::Anova()` on `lm()`), assumption checks (Shapiro
  on the residuals, Levene on the cells), Tukey HSD on the `aov` object,
  and Holm and Benjamini-Hochberg corrections reported next to the raw p
  values within each panel and variant (details in Methodological
  differences below).
- **Figures** with per-point centre labels off by default, the group n
  printed only when the cell has at least 5 observations, a fixed seed for
  the jitter and export with `ggsave()`; cohort overview charts for the
  three panels, counting over all observed levels.
- **Exported outputs**: PNG figures and CSV tables with a fixed naming
  scheme (`<outdir>/<panel>/<variant>/<measure>_{figure.png, anova.csv,
  tukey.csv, assumptions.csv}`, overview figures and count tables per
  variant, panel-level tables `anova_all.csv`, `tukey_all.csv`,
  `assumptions_all.csv`, `cells_all.csv` and `run_log.csv`) and a
  `sessionInfo.txt` with every run. The full run on the synthetic data is
  committed under `outputs/example/` as a worked example.
- **Synthetic example data** under `data/synthetic/` (next subsection),
  **tests** with testthat on the synthetic data (`tests/testthat/`), a
  **lock file** (`renv.lock`, R 4.3.2 with dplyr, ggplot2, car and
  testthat) and the command-line runner `run_all.R` with `--panel`,
  `--variant`, `--fast`, `--label-points`, `--outdir` and `--data` options.

Privacy is unchanged by design: the v1.0 code names the centres only as
`CENTRE_A` and `CENTRE_B` and the merged genotype variant only as
`VARIANT`, reads no real data table, and its only data are synthetic. A
reader who runs v1.0 on the private tables must write the outputs to a
directory other than `outputs/example/` (every other path under `outputs/`
is ignored by git) and must not publish the figures or tables produced
from real data without the study's authorization.

### How to run v1.0

From the repository root, with R 4.3.2 installed (the `.Rprofile` created
by renv activates the project library when R starts at the root):

```sh
# one-off: install the recorded package versions from CRAN into the project library
Rscript -e "renv::restore()"

# full run on the synthetic data (default --panel all, --outdir outputs/example, --data data/synthetic)
Rscript run_all.R

# one panel, first two measures only, into a scratch directory
Rscript run_all.R --panel hemogram --fast --outdir outputs/scratch

# one variant of one panel, with per-point centre labels (off by default)
Rscript run_all.R --panel markers --variant CENTRE_A --label-points --outdir outputs/scratch

# tests on the synthetic data (write only under tempfile())
Rscript tests/testthat.R

# regenerate the synthetic tables (deterministic, seed 20211109)
Rscript scripts/generate_synthetic.R

# usage
Rscript run_all.R --help
```

Interactively, source the functions and call one panel:

```r
for (f in sort(list.files("R", pattern = "[.]R$", full.names = TRUE))) source(f)
library(dplyr); library(ggplot2); library(car)
res <- run_panel("aggregation", variants = "CENTRE_A", measures = "PMA",
                 outdir = "outputs/scratch")
res$anova    # type II table with p_raw, p_holm, p_bh and family_size
```

To run v1.0 on the private tables (authorized readers only): export each
master table to CSV with semicolon separator and decimal comma, the raw
headers of `data/README.md` and the placeholders `CENTRE_A`, `CENTRE_B` and
`VARIANT` in the `Centro Analisis` and `Genotype` columns; pass the file to
`run_panel(panel, data_path = "data/<file>.csv")`, or place the three files
in a directory under the synthetic file names
(`synthetic_aggregation.csv`, `synthetic_hemogram.csv`,
`synthetic_markers.csv`) and pass `--data <dir>` to `run_all.R`. The
`levels` argument of `run_panel()` (see `variant_levels()`) overrides the
spellings of the centre, treatment and genotype labels when the private
tables differ from the synthetic ones. Everything under `data/` except
`data/synthetic/` and `data/README.md` is ignored by git.

### Synthetic example data

`data/synthetic/` holds three tables (`synthetic_aggregation.csv`,
`synthetic_hemogram.csv`, `synthetic_markers.csv`) with the schema of the
private inputs (same raw headers, same format: semicolon separator, decimal
comma, one row per subject) for one fictitious cohort of 100 subjects,
generated by `scripts/generate_synthetic.R` from the column dictionary of
`data/README.md` with hand-set distributions ("via A": no real data were
read, fitted or perturbed). Genotype groups (`CNTRL`, `JAK2 V617F`, three
`CALR` levels, `MPL W515`, `TN`, `VARIANT`), treatment levels, sex, year of
birth and centre (`CENTRE_A` 75, `CENTRE_B` 25) are drawn with fixed
counts; laboratory values are drawn from normal, lognormal or gamma
distributions in plausible ranges, independently of every grouping factor;
TRAP, GPVI, CD42A and CD9 are missing for every `CENTRE_B` row, as in the
study. Every subject code starts with `SYN-` and every table carries a
`Synthetic` column equal to `SYNTHETIC`. **The values carry no biological
meaning and support no scientific conclusion**: they exist so that the code
can be exercised, tested and demonstrated without any real data.
`data/synthetic/README.md` gives the schema and the distributions.

### Methodological differences with respect to 2021

v1.0 does not reproduce any numerical result of 2021 (the study data are
not distributed); it reproduces the code blocks as calls. A reader
comparing a 2021 block with its v1.0 call on the private data should
expect the following differences, in this order:

| Topic | 2021 | v1.0 |
| --- | --- | --- |
| Sums of squares | Type I (sequential), from `summary(aov())`, so the p value of `Genotype` depended on it being first in the formula | Type II (`car::Anova`), invariant to term order; with the unbalanced cells of this cohort the `Genotype` and `Treatment` p values differ from the 2021 ones, the interaction p value is identical |
| Assumption checks | None | Shapiro on residuals and Levene on the cells, reported, never used to change the model |
| Multiplicity | None | Holm and Benjamini-Hochberg across the measures of a panel and variant, reported next to the raw p |
| Post hoc | Tukey HSD on `aov` | Same, exported as a table |
| Recodings | By hand in spreadsheets, one file per variant | In code from one master table per panel |
| Copy errors | 6 broken `CENTRE_A` slots in the aggregation script (5 on a never-read object, 1 duplicate; the 18 cohort-wide fits on character columns are out of scope), 1 in the marker script (CD41), 2 cosmetic in the hemogram script | Every measure fitted on the variant its figure uses |
| Figures | Points plus jittered centre labels with no seed, n printed for every cell, red outlier points | Points jittered with a fixed seed, centre labels off by default, n printed only when the cell has at least 5 observations, no duplicated outlier points, legend of the fill hidden |
| Cohort overview | Bar charts filtered on hard-coded label lists, hemogram without overview | Counts over all observed levels (missing shown as `(missing)`), overview for the three panels |
| Outputs | Screen only | PNG and CSV files with a fixed naming scheme, `sessionInfo.txt` with every run |
| Cohort definition | Both centres in half of the variants | `CENTRE_A` only, cut-off 2021-11-09 |
| Seeds | None | Project seed 20211109 in the generator and in every jitter |
| Versions | None recorded | R 4.3.2 and the four packages recorded in `renv.lock` |

The one-way hemogram fits are unaffected by the change of sums of squares;
in the two-way panels the interaction row and the Tukey tables should match
the 2021 output for every valid fit, while the main-effect rows differ
wherever the cells are unbalanced. `docs/legacy_to_v1.md` records, for each
of the 72 + 112 + 80 legacy fits, its status in 2021, the v1.0 call that
reproduces it and the files it writes, and marks the 7 `CENTRE_A` slots
whose 2021 fit was broken as new in v1.0.

## Tech stack

R 4.x with ggplot2 (all figures of the four 2021-11 scripts), dplyr
(filtering and counting in the overview charts; loaded without use in
`hemogram.R`), ggpubr (one theme, `theme_pubclean()`, loaded in all four
2021-11 scripts but used in `Agonistas_2021-11-04.R` only, on the two bar
charts of its untested subsets) and readxl (`read_excel()` for the XLSX
inputs of the two aggregation scripts; loaded without use in the other two);
`aov()`, `TukeyHSD()`, `read.csv2()` and `read.delim2()` from base R. The
March 2021 pipeline uses R base graphics plus FactoMineR (PCA) and gmodels
(loaded, unused). No lockfile or package versions were recorded with the
delivered code.

v1.0: R 4.3.2 with dplyr (recoding and counting), ggplot2 (figures, exported
with `ggsave()`), car (`Anova()` for the type II tables and `leveneTest()`)
and testthat (tests), the only four packages beyond base R, with their
versions and those of their dependencies recorded by renv in `renv.lock`;
`lm()`, `aov()`, `TukeyHSD()`, `shapiro.test()`, `p.adjust()`,
`read.csv2()` and `write.csv()` from base R. The native pipe `|>` replaces
`%>%`; ggpubr and readxl are not used.

## How to run

The legacy scripts cannot run without the private input tables; v1.0 runs
on the synthetic data out of the box (commands under v1.0: refactored
implementation, repeated in short at the end of this section). A reader
with authorized access to the study data can run the legacy scripts as
follows.

1. Install R 4.x and the packages (FactoMineR and gmodels are needed only by
   `pipeline_2021-03.R`):

   ```r
   install.packages(c("dplyr", "ggplot2", "ggpubr", "readxl", "FactoMineR", "gmodels"))
   ```

2. Place the authorized input tables under `data/` with the file names,
   formats and columns described in `data/README.md`, recoding the analysing
   centre to `CENTRE_A` and `CENTRE_B` in file names and in the
   `Centro.Analisis` column, the label of the merged genotype variant to
   `VARIANT` where the tables keep it (and in the name of the second table of
   the March pipeline), and the genotype category that the filter lists of
   `surfacemarkers.R` call `CALR Type_Other` to that placeholder. The two
   aggregation scripts reference part of their inputs by bare file name
   without the `data/` prefix (the two XLSX files in
   `Agonistas_2021-11-04.R` and all eight files in `Agonistas_2021-11-09.R`):
   either place those files at the project root or edit the read lines; both
   locations are ignored by git.

3. Open `platelet-aggregation-flow-cytometry-r.Rproj` in RStudio, or start R
   at the project root, and run a legacy script interactively, block by
   block. Sourcing a script produces nothing: no figure or table is printed
   or saved, because none of the ggplot, `summary()` or `TukeyHSD()` calls is
   wrapped in `print()` (item 3 of Known limitations). For example, the first
   block of `surfacemarkers.R` is lines 15 to 29 (packages and inputs),
   followed by one overview block and one figure-plus-ANOVA block at a time.

Nothing is written to disk: figures appear on the active graphics device and
the ANOVA and Tukey tables on the console. `Agonistas_2021-11-09.R` must be
run block by block because it stops at its first copy error (item 1); in
`Agonistas_2021-11-04.R` the test block (lines 1921 to 1960) and the leftover
lines 2201 to 2204 of the closing section are not executable, while the two
untested subsets (1963 to 2195) and the two four-factor fits around the
leftovers (2198 to 2200 and 2205) run on the global table; the hemogram and
surface marker scripts are expected to run from start to end with ggplot2
warnings.

v1.0, from the repository root:

```sh
Rscript -e "renv::restore()"        # once: project library from renv.lock (CRAN)
Rscript run_all.R                   # all panels, synthetic data, outputs/example
Rscript run_all.R --panel hemogram --fast --outdir outputs/scratch
Rscript run_all.R --panel markers --variant CENTRE_A,CENTRE_ATNCONMPL --outdir outputs/scratch
Rscript tests/testthat.R            # tests on the synthetic data
Rscript scripts/generate_synthetic.R  # regenerate data/synthetic/ (seed 20211109)
```

`run_all.R` exits with status 0 on success, prints the usage with `--help`
and exits with status 2 on an unknown option. Each fit carries a status in
the run log and tables: `ok` (full-rank fit) or `ok_aliased` (at least one
aliased coefficient because of empty genotype by treatment cells, the type
II table remains valid); the full list is in `docs/v1_spec.md`, section
8.5. Private tables, if any, go under `data/` (ignored by git) and their
outputs under any directory other than `outputs/example/`.

`p_holm`, `p_bh` and `family_size` are computed over the measures passed to the call; the corrected values of a single-measure or `--fast` run therefore differ from those of the full panel run under `outputs/example/`, while `p_raw`, the type II table, the Tukey table and the assumption tests are identical. Use the full panel run (or `anova_all.csv`) for the corrected p values.

## Repository structure

```
platelet-aggregation-flow-cytometry-r/
├── legacy/                                      # the five scripts as delivered in 2021, cleaned, with a provenance header
│   ├── README.md                                # section maps of the five scripts, provenance header, cleaning check and run notes
│   ├── Agonistas_2021-11-04.R                   # platelet aggregation, cut-off 2021-10-27, both centres, twelve variants (delivered 2021-11-04)
│   ├── Agonistas_2021-11-09.R                   # platelet aggregation, cut-off 2021-11-09, first centre only, eight variants
│   ├── hemogram.R                               # hemogram and hormone variables, export 2021-11-09, one-way ANOVA by genotype
│   ├── surfacemarkers.R                         # ten platelet surface markers, export 2021-11-09, two-way ANOVA
│   └── pipeline_2021-03.R                       # exploratory pipeline of March 2021 (R base, no tests), lineage only
├── R/                                           # v1.0 functions (one file per task, roxygen-style comments, namespaced calls, no library())
│   ├── read_inputs.R                            # panel_spec() (measures, slugs, labels, raw headers) and read_inputs() (one master table per panel)
│   ├── recode_variants.R                        # variant_levels(), variant_table(), the three recoding operations, recode_variants(), summarise_cohort()
│   ├── plot_measure.R                           # plot_measure() (box or violin, jitter with seed, n for cells of at least 5) and plot_cohort()
│   ├── fit_anova.R                              # fit_anova() (lm + aov, car::Anova type II, Shapiro, Levene, Tukey HSD), adjust_p_values(), tidy_*()
│   ├── run_panel.R                              # run_panel(): one panel end to end, figures, tables, run log and sessionInfo
│   ├── export.R                                 # output_path(), ensure_dir(), export_figure(), export_table(), export_fit(), write_session_info()
│   └── synthetic_data.R                         # synthetic_spec(), simulate_*() and generate_synthetic() (distributions only, no real data)
├── scripts/
│   └── generate_synthetic.R                     # writes data/synthetic/*.csv from the schema with seed 20211109
├── run_all.R                                    # command-line runner: --panel, --variant, --outdir, --data, --fast, --label-points, --help
├── tests/
│   ├── testthat.R                               # entry point: Rscript tests/testthat.R from the root
│   └── testthat/                                # helper-source.R and the nine test files (synthetic data only, write under tempfile())
├── data/
│   ├── README.md                                # inputs expected by the scripts: file names, formats, columns, suffixes (no data)
│   └── synthetic/                               # synthetic example data (committed): README.md and the three synthetic_*.csv tables
├── outputs/
│   └── example/                                 # full v1.0 run on the synthetic data (committed): <panel>/<variant>/ figures and tables, panel tables, sessionInfo.txt
├── docs/
│   ├── cleaning.md                              # cleaning log: original files, SHA-256 of the originals, transformations, verification
│   ├── limitations.md                           # known defects of the delivered code, with file and line
│   ├── v1_spec.md                               # binding specification of v1.0 (panels, variants, method, functions, outputs, tests)
│   └── legacy_to_v1.md                          # mapping of every 2021 fit (72 + 112 + 80) to the v1.0 call and the methodological differences
├── renv.lock                                    # R 4.3.2 with dplyr, ggplot2, car, testthat and their dependencies (CRAN)
├── renv/                                        # activate.R, settings.json and renv's own .gitignore (the library itself is not committed)
├── .Rprofile                                    # activates renv when R starts at the root
├── .gitignore                                   # ignores data/ (except its README and data/synthetic/), *.csv, *.xlsx, *.xls, *.txt, *.RData, *.rds, R session files and outputs/ (except outputs/example/)
├── platelet-aggregation-flow-cytometry-r.Rproj  # RStudio project file (open it to start R at the root)
├── CITATION.cff                                 # citation metadata for the code and the article
├── LICENSE                                      # MIT, the author's code only
└── README.md
```

## Provenance note

The code was written in 2021 as a commissioned statistical analysis for a
platelet function study in essential thrombocythemia and delivered to the
principal investigator in several versions between March and November 2021,
of which the five files published here are the surviving copies. The results
of the study appear in the article cited under How to cite, of which the
author of this code is the third author. The principal investigator gave
written authorization to publish the code with one requirement: nothing
that could re-identify a patient. This repository follows that requirement
by design: it contains no data, no identifier, no value of any individual,
no centre name and no label of the merged genotype variant; the centres
appear as `CENTRE_A` and `CENTRE_B`, the variant as `VARIANT` and one
genotype category of the surface marker filter lists as `CALR Type_Other`.

The scripts in `legacy/` are published for transparency and traceability, as
delivered in 2021, with their Spanish comments and their defects. The
delivered files had no header, date or version; the provenance header of
each file records the original file name, encoding, line endings and SHA-256
so that the published copy can be checked against the delivered one. The
changes made at cleaning (paths, `setwd()` arguments, centre tokens and the
two genotype labels) are counted file by file under Data & methods. The
hand-prepared input variants were produced in spreadsheets outside R and
cannot be reproduced from the repository, only described.

What this release is, and what it is **not**:

- **v0.1.0 (released 2026-10-06):** the code as delivered and cleaned, plus
  the description of the expected inputs, the list of known limitations and
  the citation metadata. It is **not** a corrected version: the defects
  listed in `docs/limitations.md` are left as they are, the scripts remain
  non-executable without the private data, and no correspondence between
  code blocks and published panels is claimed. Everything stated here about
  the legacy code still holds in v1.0, which leaves `legacy/` untouched.
- **v1.0 (this release, supersedes the v0.1.0 roadmap):** a refactored
  implementation of the first-centre analysis with the 2021-11-09 cut-off,
  kept separate from the legacy code: one function per task instead of
  repeated blocks, the recodings done in code from one master table per
  panel, every measure fitted on the variant its figure uses (which removes
  the copy errors within scope), type II ANOVA with assumption checks, Tukey
  HSD and Holm and Benjamini-Hochberg corrections reported next to the raw
  p values, figures with a fixed seed, centre labels off by default and a
  minimum cell size for printed counts, figures and tables exported with a
  naming scheme, `sessionInfo()` with every run, package versions recorded
  in `renv.lock`, only the packages actually used, a synthetic example
  dataset with the schema of the private tables so that the code can be
  exercised without any real data, tests on that dataset, a committed
  example run, and the mapping of every 2021 fit to its v1.0 call in
  `docs/legacy_to_v1.md`. It is **not** a reproduction of the 2021 numbers
  (the data are not distributed) and still claims no correspondence between
  code blocks and published panels.

## License

The author's code is released under the MIT License, 2021-2026 (see
`LICENSE`). The data of the study are not part of this repository and remain
under the study's own terms (data access agreement and ethics approval);
they can be obtained only from the principal investigator. The article is
cited, not reproduced.

## How to cite

Use the metadata in `CITATION.cff` (GitHub shows a "Cite this repository"
button) for the code, and cite the article for the study:

Guerrero-Carreño, X., Smits, S., Esteban Lasso, A., Samiotaki, M.,
Calabuig-Navarro, V., Iborra, F. J., Rantanen, F., Álvarez-Larrán, A.,
Angona Figueras, A., Bellosillo, B., Sáez Marín, A. J., García-Gutiérrez,
V., Dekkers, D. H. W., Demmers, J. A. A., Ferrer-Marín, F.,
Hernández-Boluda, J. C., Matsakas, A., Benavente Cuesta, C., Vandenberghe,
P., & Papadopoulos, P. (2026). Platelet Proteome Links Metabolism to
Reactivity in Essential Thrombocythemia. *Molecular & Cellular Proteomics,
25*(8), 101617. <https://doi.org/10.1016/j.mcpro.2026.101617>. PMID
42372951, PMCID PMC13450191.

Esteban Lasso, A. (2026). *Platelet function by flow cytometry in essential
thrombocythemia: aggregation, surface markers and hemogram analysis in R
(legacy code, as delivered and cleaned)* (v1.0.0) [Computer software].
<https://github.com/AlfonsoEstebanLasso/platelet-aggregation-flow-cytometry-r>

The citation metadata in `CITATION.cff` and the software citation above
refer to v0.1.0; v1.0 (this release) will carry its own tag and version in
`CITATION.cff` when the release is made.

## Acknowledgements

Thanks to Petros Papadopoulos, principal investigator of the study, for the
written authorization to publish this code, and to the study team for the
measurements the analysis was commissioned on. Figures and tests follow the
public documentation of ggplot2, ggpubr, dplyr, readxl and FactoMineR, and
the base R documentation of `aov()` and `TukeyHSD()`; v1.0 additionally
follows the documentation of car (`Anova()`, `leveneTest()`), testthat and
renv, and the base R documentation of `lm()`, `shapiro.test()` and
`p.adjust()`.
