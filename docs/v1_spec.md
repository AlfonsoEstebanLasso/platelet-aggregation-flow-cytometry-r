# v1.0 specification (binding)

This document fixes what the four builders of v1.0 implement. It is the
only shared contract: each builder writes the files assigned to it in
section 14, reads nothing but this file, the repository documentation
(`README.md`, `legacy/README.md`, `docs/limitations.md`, `docs/cleaning.md`,
`data/README.md`) and the legacy scripts, and never edits a file owned by
another builder. Where this file and a builder's own judgement differ, this
file wins. Where this file is silent, the builder follows the legacy scripts
and the rules in section 1.

## 1. Rules that apply to every builder

- Scope of v1.0: the analysis of the first centre only (`CENTRE_A`) with
  the 2021-11-09 data cut-off, that is, the `CENTRE_A` variants of
  `legacy/Agonistas_2021-11-09.R`, `legacy/hemogram.R` and
  `legacy/surfacemarkers.R`. The cohort-wide variants, the MPLSTN
  subdivisions of the aggregation family, the 2021-10-27 cut-off and the
  March 2021 pipeline are out of scope and are only mapped as such in
  `docs/legacy_to_v1.md`.
- The five scripts in `legacy/`, `LICENSE`, `CITATION.cff`,
  `docs/limitations.md` and `docs/cleaning.md` are never modified.
- Language: English everywhere (code, comments, file names, figure text,
  tables, documentation). No em dash, no en dash, no emoji. Headings in
  sentence case.
- Packages: base R (R 4.3.2) plus dplyr, ggplot2, car and testthat. renv is
  used only to record the lock file. No other package. The native pipe `|>`
  is used instead of `%>%`. Files under `R/` call every non-base function
  with its namespace (`dplyr::`, `ggplot2::`, `car::`) and contain no
  `library()` call; `library()` calls appear only in `run_all.R`,
  `scripts/generate_synthetic.R` and `tests/testthat/helper-source.R`.
- Every function has a roxygen-style comment block (`#' @title`,
  `#' @param`, `#' @return`) even though no package is built. Every file
  under `R/` and `scripts/` starts with a comment header stating its
  purpose, inputs and outputs.
- Seeds: every random draw is preceded by `set.seed()` with a seed derived
  from the project seed 20211109 (section 7). No draw without a seed.
- Privacy: only the placeholders `CENTRE_A`, `CENTRE_B` and `VARIANT` name
  the centres and the merged genotype variant. No real centre name, no real
  variant name, no person's name other than the owner (Alfonso Esteban
  Lasso), no e-mail, no absolute path, no account alias, anywhere. No real
  data table is read, copied or referenced; the only data in the repository
  are the synthetic tables of section 3.
- Paths: every path in code is relative to the repository root. Scripts and
  tests are run from the root (`Rscript run_all.R`, `Rscript
  scripts/generate_synthetic.R`, `Rscript tests/testthat.R`).
- Nothing is written to disk by the functions in `R/` except through the
  helpers of `R/export.R`, and never outside the directory passed as
  `outdir` (or the temporary directory of a test).

## 2. Panels, measures and designs

Three panels, identified by the strings `"aggregation"`, `"hemogram"` and
`"markers"`. The table below is the single source of the measure lists; it
is returned by `panel_spec()` (section 8.1) and reproduced in the synthetic
generator and the tests. `R name` is the column name after `read.csv2()`
(that is, after `make.names()` on the raw header); `slug` is the token used
in output file names; `label` is the axis label.

### 2.1 Aggregation (design two_way, nine measures, legacy order)

| R name | slug | label |
| --- | --- | --- |
| `PMA` | `PMA` | PMA response |
| `CVX` | `CVX` | CVX response |
| `RISTO` | `RISTO` | RISTO response |
| `AGGA` | `AGGA` | AGGA response |
| `COL` | `COL` | COL response |
| `TRAP` | `TRAP` | TRAP response |
| `UNSTIMULATED.10min` | `UNSTIMULATED_10min` | Unstimulated aggregation at 10 min |
| `Time.0min` | `Time_0min` | Unstimulated measurement at time zero |
| `UNS.Time.10min.vs.Time.0` | `UNS_ratio` | Ratio of 10 min to time zero |

Model: `measure ~ Genotype * Treatment`.

### 2.2 Hemogram (design one_way, fourteen measures, legacy order)

| R name | slug | label |
| --- | --- | --- |
| `EPO..mlU.ml.` | `EPO` | EPO (mlU/ml) |
| `TPO..pg.ml.` | `TPO` | TPO (pg/ml) |
| `HGB.gr.dl.` | `HGB` | Haemoglobin (g/dl) |
| `HCT....` | `HCT` | Haematocrit (%) |
| `MCH..pg.` | `MCH` | MCH (pg) |
| `MCHC..gr.dl.` | `MCHC` | MCHC (g/dl) |
| `Lymph.` | `Lymph_pct` | Lymphocytes (%) |
| `Mono.` | `Mono_pct` | Monocytes (%) |
| `Eos.` | `Eos_pct` | Eosinophils (%) |
| `Baso.` | `Baso_pct` | Basophils (%) |
| `Lymph..10.6.ml.` | `Lymph_abs` | Lymphocytes (10^6/ml) |
| `Mono..10.6.ml.` | `Mono_abs` | Monocytes (10^6/ml) |
| `Eos..10.6.ml.` | `Eos_abs` | Eosinophils (10^6/ml) |
| `Baso..10.6.ml.` | `Baso_abs` | Basophils (10^6/ml) |

Model: `measure ~ Genotype`. The other eight numeric columns of the
hemogram table (WBC, RBC, MCV, PLT, MPV, RETIC, Neutr percentage and
absolute count) are read and kept but not analysed, as in 2021.

### 2.3 Surface markers (design two_way, ten measures, legacy order)

| R name | slug | label |
| --- | --- | --- |
| `CD61` | `CD61` | CD61 intensity |
| `CD41` | `CD41` | CD41 intensity |
| `CD49B` | `CD49B` | CD49B intensity |
| `GPVI` | `GPVI` | GPVI intensity |
| `CD42A` | `CD42A` | CD42A intensity |
| `CD42B` | `CD42B` | CD42B intensity |
| `CD31` | `CD31` | CD31 intensity |
| `CD36` | `CD36` | CD36 intensity |
| `CD9` | `CD9` | CD9 intensity |
| `FSC.unstained` | `FSC_unstained` | FSC unstained |

Model: `measure ~ Genotype * Treatment`. `RAW.FSC` is read and kept but
not analysed, as in 2021.

## 3. Synthetic master tables (schema and files)

One fictitious cohort of 100 subjects, present in all three panels (one row
per subject per panel). The values are drawn from the hand-set
distributions of section 4 and carry no biological meaning; no group
effect is simulated. Every file name starts with `synthetic_`, every
subject code starts with `SYN-` and every table ends with a column
`Synthetic` whose value is `SYNTHETIC` in every row, so that the tables
cannot be mistaken for study data.

### 3.1 Files

| File | Rows | Columns |
| --- | --- | --- |
| `data/synthetic/synthetic_aggregation.csv` | 100 | 17 (section 3.3) |
| `data/synthetic/synthetic_hemogram.csv` | 100 | 30 (section 3.4) |
| `data/synthetic/synthetic_markers.csv` | 100 | 19 (section 3.5) |
| `data/synthetic/README.md` | | statement that the data are synthetic, how they were generated, the schema tables of this section, and a sentence that the values carry no biological meaning |

Format of the three CSV files, identical to the private format described
in `data/README.md`: semicolon separator, decimal comma, no quoting
(`write.csv2(x, file, row.names = FALSE, na = "", quote = FALSE, eol =
"\n")`), header in row 1 with the raw headers below, UTF-8 without BOM, LF
line endings. Missing values are empty fields. The files are read back
with `read.csv2(file, check.names = TRUE)`, which yields the R names.

### 3.2 Subject columns (shared by the three panels, identical values)

| Raw header | R name | Type | Values |
| --- | --- | --- | --- |
| `Codigo Estudio` | `Codigo.Estudio` | character | `SYN-001` to `SYN-100`, unique |
| `Codigo muestra` | `Codigo.muestra` | character | `SYN-S-001` to `SYN-S-100`, unique |
| `Gender` | `Gender` | character, factor | `F`, `M`; missing (empty) for exactly two subjects |
| `Birth Year` | `Birth.Year` | integer | 1930 to 2000; missing for about half of the subjects |
| `Genotype` | `Genotype` | character, factor with 8 levels | `CNTRL`, `JAK2 V617F`, `CALR Type I`, `CALR Type II`, `CALR Type_Other`, `MPL W515`, `TN`, `VARIANT` |
| `Treatment` | `Treatment` | character, factor with 4 levels | `Untreated`, `ASA`, `Anagrelide`, `HU` |
| `Centro Analisis` | `Centro.Analisis` | character, factor with 2 levels | `CENTRE_A`, `CENTRE_B` |

Factor level order (fixed everywhere, figures included): Genotype in the
order listed above; Treatment `Untreated`, `ASA`, `Anagrelide`, `HU`
(after collapsing: `Untreated`, `Treated`); centre `CENTRE_A`, `CENTRE_B`.

Cohort composition (exact counts, shuffled with the seed): Genotype
`CNTRL` 20, `JAK2 V617F` 25, `CALR Type I` 12, `CALR Type II` 8,
`CALR Type_Other` 4, `MPL W515` 6, `TN` 15, `VARIANT` 10. Centre
`CENTRE_A` 75, `CENTRE_B` 25, assigned independently of genotype.
Treatment: every `CNTRL` subject is `Untreated`; the 80 patients draw
`Untreated`, `ASA`, `Anagrelide`, `HU` with probabilities 0.30, 0.40,
0.15, 0.15. Gender: `F` with probability 0.55, then the subjects in
positions 7 and 58 of the shuffled table are set to missing. Birth year:
`round(rnorm(n, 1962, 12))` clipped to 1930 to 2000, then 50 subjects
chosen at random are set to missing.

### 3.3 Aggregation table (17 columns, in this order)

The seven subject columns of 3.2, then:

| Raw header | R name | Type | Missingness |
| --- | --- | --- | --- |
| `PMA` | `PMA` | numeric, 2 decimals | 5 percent at random |
| `CVX` | `CVX` | numeric, 2 decimals | 5 percent at random |
| `RISTO` | `RISTO` | numeric, 2 decimals | 5 percent at random |
| `AGGA` | `AGGA` | numeric, 2 decimals | 5 percent at random |
| `COL` | `COL` | numeric, 2 decimals | 5 percent at random |
| `TRAP` | `TRAP` | numeric, 2 decimals | missing for every `CENTRE_B` row; 5 percent at random among `CENTRE_A` rows |
| `UNSTIMULATED.10min` | `UNSTIMULATED.10min` | numeric, 2 decimals | none |
| `Time.0min` | `Time.0min` | numeric, 2 decimals | none |
| `UNS.Time.10min.vs.Time.0` | `UNS.Time.10min.vs.Time.0` | numeric, 4 decimals | none (computed) |
| `Synthetic` | `Synthetic` | character | `SYNTHETIC` |

### 3.4 Hemogram table (30 columns, in this order)

The seven subject columns of 3.2, then the 22 numeric columns with the raw
headers of `data/README.md` (reproduced exactly, including `WBC*10^6/ml)`
with its unbalanced parenthesis), then `Synthetic`:

| Raw header | R name | Decimals | Missingness |
| --- | --- | --- | --- |
| `TPO (pg/ml)` | `TPO..pg.ml.` | 1 | 60 percent at random |
| `EPO (mlU/ml)` | `EPO..mlU.ml.` | 1 | 60 percent at random |
| `WBC*10^6/ml)` | `WBC.10.6.ml.` | 2 | 3 percent at random |
| `RBC (*10^9/ml)` | `RBC...10.9.ml.` | 2 | 3 percent |
| `HGB(gr/dl)` | `HGB.gr.dl.` | 1 | 3 percent |
| `HCT (%)` | `HCT....` | 1 | 3 percent |
| `MCV (fl)` | `MCV..fl.` | 1 | 3 percent |
| `MCH (pg)` | `MCH..pg.` | 1 | 3 percent |
| `MCHC (gr/dl)` | `MCHC..gr.dl.` | 1 | 3 percent |
| `PLT (*10^6)/ml` | `PLT...10.6..ml` | 0 | 3 percent |
| `MPV( fl)` | `MPV..fl.` | 1 | 3 percent |
| `RETIC %` | `RETIC..` | 2 | 3 percent |
| `Neutr%` | `Neutr.` | 1 | same rows as WBC |
| `Lymph%` | `Lymph.` | 1 | same rows as WBC |
| `Mono%` | `Mono.` | 1 | same rows as WBC |
| `Eos%` | `Eos.` | 1 | same rows as WBC |
| `Baso%` | `Baso.` | 1 | same rows as WBC |
| `Neutr (*10^6/ml)` | `Neutr...10.6.ml.` | 2 | same rows as WBC |
| `Lymph(*10^6/ml)` | `Lymph..10.6.ml.` | 2 | same rows as WBC |
| `Mono(*10^6/ml)` | `Mono..10.6.ml.` | 2 | same rows as WBC |
| `Eos(*10^6/ml)` | `Eos..10.6.ml.` | 2 | same rows as WBC |
| `Baso(*10^6/ml)` | `Baso..10.6.ml.` | 2 | same rows as WBC |
| `Synthetic` | `Synthetic` | | `SYNTHETIC` |

### 3.5 Surface marker table (19 columns, in this order)

The seven subject columns of 3.2, then:

| Raw header | R name | Decimals | Missingness |
| --- | --- | --- | --- |
| `RAW FSC` | `RAW.FSC` | 1 | 3 percent at random |
| `CD61` | `CD61` | 1 | 3 percent |
| `CD41` | `CD41` | 1 | 3 percent |
| `CD49B` | `CD49B` | 1 | 3 percent |
| `GPVI` | `GPVI` | 1 | missing for every `CENTRE_B` row; 3 percent among `CENTRE_A` rows |
| `CD42A` | `CD42A` | 1 | missing for every `CENTRE_B` row; 3 percent among `CENTRE_A` rows |
| `CD42B` | `CD42B` | 1 | 3 percent |
| `CD31` | `CD31` | 1 | 3 percent |
| `CD36` | `CD36` | 1 | 3 percent |
| `CD9` | `CD9` | 1 | missing for every `CENTRE_B` row; 3 percent among `CENTRE_A` rows |
| `FSC unstained` | `FSC.unstained` | 1 | 3 percent |
| `Synthetic` | `Synthetic` | | `SYNTHETIC` |

## 4. Synthetic distributions (hand-set, no biological meaning)

All draws are independent of genotype, treatment, sex and centre; the only
structure is the missingness by centre of section 3. `clip(a, b)` means
`pmin(pmax(x, a), b)`.

Aggregation: `PMA` normal(55, 18) clip(0, 100); `CVX` normal(60, 15)
clip(0, 100); `RISTO` normal(45, 20) clip(0, 100); `AGGA` normal(50, 17)
clip(0, 100); `COL` normal(40, 16) clip(0, 100); `TRAP` normal(58, 14)
clip(0, 100); `Time.0min` normal(8, 3) clip(1, 30); `UNSTIMULATED.10min`
normal(12, 5) clip(1, 40); `UNS.Time.10min.vs.Time.0` is
`UNSTIMULATED.10min / Time.0min` rounded to 4 decimals (never drawn).

Hemogram: `TPO` lognormal(meanlog log(120), sdlog 0.6); `EPO`
lognormal(log(12), 0.6); `WBC` normal(7.5, 2) clip(2.5, 20); `RBC`
normal(4.7, 0.5) clip(3, 6.5); `HGB` normal(13.5, 1.5) clip(8, 18); `HCT`
normal(41, 4) clip(25, 55); `MCV` normal(90, 6) clip(65, 110); `MCH`
normal(30, 2.5) clip(20, 38); `MCHC` normal(33.5, 1.2) clip(28, 37); `PLT`
normal(350, 120) for `CNTRL` and normal(700, 200) for the other genotypes,
clip(100, 1500) (the only group-dependent draw, and it is a platelet count
that is not analysed; it exists so that the table looks like a cohort of
the disease); `MPV` normal(10, 1.2) clip(6, 14); `RETIC` normal(1.2, 0.5)
clip(0.1, 4). Differential percentages: draw gamma shapes `Neutr` 60,
`Lymph` 30, `Mono` 6, `Eos` 3, `Baso` 1 with `rgamma(n, shape, 1)`,
normalise the five to sum 100 per row, round to 1 decimal. Absolute counts
are `WBC * percentage / 100` rounded to 2 decimals.

Markers (all lognormal with sdlog 0.35 and the stated median): `RAW.FSC`
25000, `CD61` 6000, `CD41` 5000, `CD49B` 350, `GPVI` 500, `CD42A` 2200,
`CD42B` 3200, `CD31` 900, `CD36` 1600, `CD9` 2600, `FSC.unstained` 18000.

Random missingness is applied after the draws, column by column, with
`sample()` on the row indices. The missingness by centre is applied last.

## 5. Variants (CENTRE_A, cut-off 2021-11-09)

v1.0 reproduces exactly four variants, named with the legacy object
suffixes shared by the three 2021-11 scripts. Each is defined as the
ordered set of recoding operations applied by `recode_variants()` to the
master table of a panel; the operations are: `centre` (keep rows with
`Centro.Analisis == "CENTRE_A"`), `treatment` (collapse `Treatment` to
`Untreated` versus `Treated`, every level other than `Untreated` becoming
`Treated`), `genotype` (replace the level `VARIANT` by `TN`), followed in
every variant by `droplevels()` and the restoration of the level order of
section 3.2.

| Variant id | Operations | Geometry | Legacy object (all three scripts) | Legacy input file, aggregation | Legacy input file, hemogram | Legacy input file, markers | Legacy title suffix |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `CENTRE_A` | centre | box | `CENTRE_A` | `CENTRE_A.csv` | `Hemograma_ALL_Nov9_2021CENTRE_A.csv` | `SurfaceMarkers_ALL_Nov9_2021CENTRE_A.csv` | `CENTRE_A` |
| `CENTRE_Atratadosnotratados` | centre, treatment | violin | `CENTRE_Atratadosnotratados` | `CENTRE_Atratadosnotratados.csv` | `Hemograma_ALL_Nov9_2021_CENTRE_Atratadosnotratados.csv` | `SurfaceMarkers_ALL_Nov9_2021_CENTRE_Atratadosnotratados.csv` | `CENTRE_A tratadosVSnotratados` |
| `CENTRE_AtratadosnotratadosMPLCONTN` | centre, treatment, genotype | box | `CENTRE_AtratadosnotratadosMPLCONTN` | `CENTRE_AtratadosnotratadosMPLCONTN.csv` | `Hemograma_ALL_Nov9_2021_CENTRE_AtratadosnotratadosMPLSTN.csv` | `SurfaceMarkers_ALL_Nov9_2021_CENTRE_AtratadosnotratadosMPLSTN.csv` | `CENTRE_A tratadosVSnotratados MPLCONTN` |
| `CENTRE_ATNCONMPL` | centre, genotype | box | `CENTRE_ATNCONMPL` | `CENTRE_ATNCONMPL.csv` | `Hemograma_ALL_Nov9_2021CENTRE_AMPLSTN.csv` | `SurfaceMarkers_ALL_Nov9_2021CENTRE_ATNCONMPL.csv` | `CENTRE_A MPL CON TN` |

The geometry column is the v1.0 default for every panel (it follows the
hemogram and marker scripts, where the four CENTRE_A slots are box,
violin, box, box for almost every variable; the legacy aggregation script
alternates differently and `docs/legacy_to_v1.md` records the legacy
geometry block by block). The `geom` argument of `plot_measure()` and the
`geom` column of `variant_table()` allow any other choice.

## 6. Statistical method (and the differences with respect to 2021)

For every measure and variant:

1. Rows with a missing response are removed; unused factor levels are
   dropped. If fewer than 3 responses remain, or a factor has fewer than
   two levels, or the residual degrees of freedom are zero, the fit is
   skipped with the status of section 8.5 and no table is produced for it
   (the figure is still drawn).
2. `fit <- stats::lm(formula, data)` and `fit_aov <- stats::aov(formula,
   data)` with `formula` `measure ~ Genotype * Treatment` (two_way) or
   `measure ~ Genotype` (one_way).
3. ANOVA table of type II: `car::Anova(fit, type = 2)` (the default
   `singular.ok = TRUE` of type II tolerates aliased coefficients, which
   occur in empty interaction cells; when `any(is.na(coef(fit)))` the status
   is `ok_aliased`, otherwise `ok`).
4. Assumption checks: `stats::shapiro.test(residuals(fit))` (only if the
   number of residuals is between 3 and 5000) and
   `car::leveneTest(response ~ cell, center = median)` where `cell` is
   `interaction(Genotype, Treatment, drop = TRUE)` for two_way and
   `Genotype` for one_way. Both are reported, never used to change the
   model.
5. Post hoc: `stats::TukeyHSD(fit_aov)` on the `aov` object, all terms,
   converted to one long table (section 8.5). Tukey p values are adjusted
   within the fit by the method itself and receive no further correction.
6. Multiplicity across measures: within each panel and variant, the raw p
   values of every non-residual term of every fitted measure form one
   family; `p.adjust(method = "holm")` and `p.adjust(method = "BH")` are
   reported next to the raw p value, with the family size.

Differences with respect to the 2021 scripts, to be stated in this order
in `README.md` and `docs/legacy_to_v1.md`:

| Topic | 2021 | v1.0 |
| --- | --- | --- |
| Sums of squares | Type I (sequential), from `summary(aov())`, so the p value of `Genotype` depended on it being first in the formula | Type II (`car::Anova`), invariant to term order; with the unbalanced cells of this cohort the Genotype and Treatment p values differ from the 2021 ones, the interaction p value is identical |
| Assumption checks | None | Shapiro on residuals and Levene on the cells, reported |
| Multiplicity | None | Holm and Benjamini-Hochberg across the measures of a panel and variant, reported next to the raw p |
| Post hoc | Tukey HSD on `aov` | Same, exported as a table |
| Recodings | By hand in spreadsheets, one file per variant | In code from one master table per panel (section 5) |
| Copy errors | 6 broken slots in the aggregation script (5 on a never-read object, 1 duplicate), 1 in the marker script (CD41), 2 cosmetic in the hemogram script | Every measure fitted on the variant its figure uses |
| Figures | Points plus jittered centre labels with no seed, n printed for every cell, red outlier points | Points jittered with a fixed seed, centre labels off by default, n printed only when the cell has at least 5 observations, no duplicated outlier points, legend of the fill hidden |
| Cohort overview | Bar charts filtered on hard-coded label lists, hemogram without overview | Counts over all observed levels (missing shown as `(missing)`), overview for the three panels |
| Outputs | Screen only | PNG and CSV files with the naming scheme of section 9, `sessionInfo.txt` with every run |
| Cohort definition | Both centres in half of the variants | `CENTRE_A` only, cut-off 2021-11-09 |

## 7. Parameters

| Parameter | Value |
| --- | --- |
| Project seed | 20211109 (`set.seed(20211109)` in the generator and in every jitter) |
| Minimum cell size for a printed n | 5 (`min_cell = 5`; the rule applies to figure labels and overview counts only, never to the fits) |
| Centre placeholder kept by the variants | `CENTRE_A` |
| Treatment levels | `Untreated`, `ASA`, `Anagrelide`, `HU`; collapsed to `Untreated`, `Treated` |
| Genotype merge | `VARIANT` into `TN` |
| Jitter | `ggplot2::position_jitter(width = 0.15, height = 0, seed = 20211109)` |
| Figure export | `ggplot2::ggsave(path, plot, width = 9, height = 5, units = "in", dpi = 100, bg = "white")` |
| Table export | `utils::write.csv(df, path, row.names = FALSE, na = "")` (comma separator, decimal point, UTF-8) |
| Fast mode | first two measures of the panel, all four variants |
| Default output directory of `run_all.R` | `outputs/example` |
| Default data directory | `data/synthetic` |

## 8. Functions in `R/` (signatures and return values)

Every function validates its arguments with `stopifnot()` or `match.arg()`
and stops with an informative message. Data frames are plain
`data.frame` objects (not tibbles); the pipe is `|>`.

### 8.1 `R/read_inputs.R`

```r
panel_spec(panel = c("aggregation", "hemogram", "markers"))
```
Returns a list: `panel` (string), `design` (`"two_way"` or `"one_way"`),
`measures` (character vector of R names, section 2), `slugs` (same
length), `labels` (same length), `subject_columns` (the seven R names of
section 3.2), `extra_columns` (character: the R names read but not
analysed, `character(0)` for aggregation, the eight hemogram columns, and
`"RAW.FSC"` for markers), `synthetic_file` (the file name of section 3.1,
without directory), `raw_headers` (named character vector mapping every R
name to its raw header, in file order, including `Synthetic`).

```r
read_inputs(panel, path = NULL, data_dir = "data/synthetic")
```
Reads one master table with `read.csv2(path, check.names = TRUE,
stringsAsFactors = FALSE, na.strings = c("", "NA"))`. When `path` is
`NULL` it reads `file.path(data_dir, panel_spec(panel)$synthetic_file)`.
Checks that every subject column and every measure column exists (error
listing the missing names), converts the measures and extra columns with
`as.numeric()` (error if a measure column cannot be converted, naming it),
converts `Gender`, `Genotype`, `Treatment`, `Centro.Analisis` to factors
with the level orders of section 3.2 (levels present in the data but not
in that list are appended in alphabetical order, never dropped), drops the
column `Synthetic` if present, and returns the data frame with attributes
`panel`, `source` (the path) and `data_label`
(`"synthetic example data (no biological meaning)"` if every
`Codigo.Estudio` starts with `SYN-`, otherwise `"study data"`). A private
master kept as XLSX must be exported to CSV (semicolon, decimal comma)
before use; v1.0 reads CSV only.

### 8.2 `R/recode_variants.R`

```r
variant_levels()
```
Returns the list of labels used by the recodings: `centre_column =
"Centro.Analisis"`, `centre_keep = "CENTRE_A"`, `untreated = "Untreated"`,
`treated = "Treated"`, `variant = "VARIANT"`, `tn = "TN"`,
`treatment_levels = c("Untreated", "ASA", "Anagrelide", "HU")`,
`genotype_levels = c("CNTRL", "JAK2 V617F", "CALR Type I", "CALR Type II",
"CALR Type_Other", "MPL W515", "TN", "VARIANT")`. A user of private data
overrides the elements whose spelling differs.

```r
variant_table()
```
Returns a data frame with one row per variant of section 5 and the
columns `variant`, `centre` (logical), `treatment` (logical), `genotype`
(logical), `geom`, `legacy_object`, `legacy_file_aggregation`,
`legacy_file_hemogram`, `legacy_file_markers`, `legacy_title_suffix`, in
the order of section 5.

```r
filter_centre(data, levels = variant_levels())
collapse_treatment(data, levels = variant_levels())
merge_variant_genotype(data, levels = variant_levels())
```
Each applies one operation of section 5 and returns the data frame.
`collapse_treatment()` maps every level other than `levels$untreated` to
`levels$treated` and sets the factor levels to `c(untreated, treated)`;
`merge_variant_genotype()` replaces `levels$variant` by `levels$tn` and
removes the `VARIANT` level; `filter_centre()` keeps the rows whose centre
column equals `levels$centre_keep` and errors if none remains.

```r
recode_variants(data, variant, levels = variant_levels())
```
Applies, in the order centre, treatment, genotype, the operations flagged
for `variant` in `variant_table()`, then `droplevels()`, then restores the
level order of section 3.2 for the levels that remain. Returns the data
frame with attributes `variant` (the id), `recoding` (character vector of
the operations applied, in order), plus the attributes of the input.
Errors on an unknown variant id.

```r
summarise_cohort(data, group = c("Gender", "Genotype"))
```
Returns a data frame with the columns `Treatment`, `group` (named after
the chosen column), `n` and `label_y` (the cumulative mid-point used to
place the count inside the stacked bar, as in the legacy overview), with
one row per observed combination, counting over all observed levels and
showing missing values as the level `(missing)`. The sum of `n` equals
`nrow(data)`.

### 8.3 `R/plot_measure.R`

```r
plot_measure(data, measure, design = c("two_way", "one_way"),
             geom = c("box", "violin"), title = NULL, subtitle = NULL,
             caption = NULL, y_label = measure, label_points = FALSE,
             label_column = "Centro.Analisis", min_cell = 5,
             seed = 20211109)
```
Returns a ggplot object (never prints or saves). Layout: two_way draws
`x = Treatment` facetted by `Genotype` (`facet_grid(. ~ Genotype)`), one_way
draws `x = Genotype` without facets; fill by the x factor with the legend
hidden; `geom_boxplot(outlier.shape = NA)` or `geom_violin()`; one
`geom_point(size = 1, position = position_jitter(width = 0.15, height =
0, seed = seed))` over all rows with a non-missing response; if
`label_points` is `TRUE`, a `geom_text(aes(label = .data[[label_column]]),
size = 2.5, position = <the same position object>)`; and the group n as
`geom_text(data = counts, aes(y = median, label = paste0("n = ", n)),
vjust = -0.6)` where `counts` holds one row per cell (x by facet) with at
least `min_cell` non-missing responses. Rows with a missing response are
removed before plotting (no ggplot2 warning). Default `title` is
`measure`; `subtitle` and `caption` are added when not `NULL`.

```r
plot_cohort(counts, group, title = NULL, min_cell = 5)
```
Takes the output of `summarise_cohort()` and returns the stacked bar chart
of counts by `Treatment` filled by `group`, with the count printed in white
inside each segment whose `n >= min_cell`, palette sized from the number
of levels (`scales::hue_pal()` through ggplot2 defaults, no manual
palette).

### 8.4 `R/fit_anova.R`

```r
fit_anova(data, measure, design = c("two_way", "one_way"), min_cell = 5)
```
Returns a list of class `v1_fit` with the elements:

- `measure`, `design`, `formula` (character, for example
  `"PMA ~ Genotype * Treatment"`), `n` (rows used), `status` (section
  8.5), `aliased` (logical), `message` (character, empty when ok);
- `cells`: data frame `Genotype`, `Treatment` (`NA` for one_way), `n`,
  `below_min` (logical, `n < min_cell`);
- `anova`: data frame `term`, `sum_sq`, `df`, `f_value`, `p_raw`, one row
  per term of `car::Anova(type = 2)` including `Residuals` (with `NA` in
  `f_value` and `p_raw`);
- `tukey`: data frame `term`, `comparison`, `diff`, `lwr`, `upr`, `p_adj`,
  all terms of `TukeyHSD()` stacked, in the order returned by R;
- `assumptions`: data frame `test` (`shapiro_residuals`, `levene_cells`),
  `statistic`, `p_value`, `note` (empty, or why the test was not run);
- `lm`, `aov`: the model objects (not exported).

When the fit is skipped the `anova`, `tukey` and `assumptions` elements
are zero-row data frames with the same columns, `lm` and `aov` are
`NULL`, and `message` states the reason. `TukeyHSD()` is wrapped in
`tryCatch()`; on error `tukey` is a zero-row data frame and `message`
records the error text, status unchanged.

```r
adjust_p_values(anova_table, by = c("panel", "variant"))
```
Takes a stacked ANOVA table (the `anova` elements of several fits with
the columns `panel`, `variant`, `measure` prepended) and returns it with
`p_holm`, `p_bh` and `family_size` added, computed with `p.adjust()` over
the rows whose `term != "Residuals"` and `p_raw` is not `NA`, separately
for each combination of the `by` columns. Residual rows get `NA`.

```r
tidy_anova(fit)
tidy_tukey(fit)
tidy_assumptions(fit)
```
Return the corresponding element with `measure`, `status` and `n`
prepended as columns (used by `run_panel()` to stack fits).

### 8.5 Fit status values

| Status | Meaning |
| --- | --- |
| `ok` | fitted, no aliased coefficient |
| `ok_aliased` | fitted, at least one aliased coefficient (empty cells); type II table still valid |
| `skipped_no_data` | fewer than 3 non-missing responses |
| `skipped_single_level` | a factor has fewer than two levels after removing missing responses |
| `skipped_no_residual_df` | residual degrees of freedom equal to zero |
| `error` | any other error, text in `message` |

### 8.6 `R/run_panel.R`

```r
run_panel(panel, variants = NULL, measures = NULL, data_path = NULL,
          data_dir = "data/synthetic", outdir = "outputs", fast = FALSE,
          label_points = FALSE, min_cell = 5, seed = 20211109,
          levels = variant_levels(), verbose = TRUE)
```
Runs one panel end to end: reads the master (`read_inputs()`), and for
each variant (default all four of `variant_table()`; `fast = TRUE` keeps
all variants but only the first two measures) recodes it, writes the two
cohort overview figures and count tables, then for each measure (default
all of `panel_spec()`) draws and exports the figure with the variant's
geometry, title `paste(slug, variant)`, subtitle `paste0(panel, ", n = ",
n)` and caption `attr(data, "data_label")`, fits the model, and collects
the tidy tables. After all variants, applies `adjust_p_values()` to the
stacked ANOVA table, exports the per-measure tables (so that the
per-measure `_anova.csv` files already carry `p_holm` and `p_bh`), the
panel-level tables and `sessionInfo.txt`. Returns invisibly a list:
`anova`, `tukey`, `assumptions`, `cells` (stacked data frames with
`panel`, `variant`, `measure` as the first columns), `cohort` (stacked
counts with `panel`, `variant`, `group`), `log` (data frame `panel`,
`variant`, `measure`, `status`, `n`, `figure_file`, `anova_file`,
`tukey_file`, `assumptions_file`), `files` (character vector of every
file written). `verbose = TRUE` prints one line per measure and variant
with the status.

`run_panel()` never stops on a skipped fit; it stops only on a missing
input or an unknown panel, variant or measure.

### 8.7 `R/export.R`

```r
output_path(outdir, panel, variant, variable, kind, ext)
```
Returns `file.path(outdir, panel, variant, paste0(variable, "_", kind, ".",
ext))` with `kind` one of `figure`, `anova`, `tukey`, `assumptions`,
`counts` and `ext` one of `png`, `csv`. Does not create anything.

```r
ensure_dir(path)
```
Creates the directory of `path` recursively if needed; returns `path`.

```r
export_figure(plot, path, width = 9, height = 5, dpi = 100)
export_table(df, path)
export_fit(fit, outdir, panel, variant, slug)
write_session_info(dir, file = "sessionInfo.txt", seed = 20211109)
```
`export_figure()` calls `ensure_dir()` then `ggplot2::ggsave()` with the
parameters of section 7 and returns the path invisibly. `export_table()`
calls `ensure_dir()` then `utils::write.csv()` as in section 7 and returns
the path invisibly. `export_fit()` writes `<slug>_anova.csv`,
`<slug>_tukey.csv` and `<slug>_assumptions.csv` through `output_path()`
and `export_table()` and returns the three paths; for a skipped fit it
writes the zero-row tables (header only) so that every measure has its
three files. `write_session_info()` writes the date and time
(`format(Sys.time(), "%Y-%m-%d %H:%M:%S")`), the seed, the working
directory name (basename only, never the absolute path) and the output of
`utils::sessionInfo()` captured with `capture.output()`, and returns the
path invisibly.

### 8.8 `R/synthetic_data.R`

```r
synthetic_spec()
```
Returns the distribution table of section 4 as a data frame `panel`,
`r_name`, `distribution`, `par1`, `par2`, `lower`, `upper`, `decimals`,
`missing_fraction`, `missing_centre_b` (logical).

```r
simulate_cohort(n = 100, seed = 20211109)
simulate_aggregation(cohort, seed = 20211109)
simulate_hemogram(cohort, seed = 20211109)
simulate_markers(cohort, seed = 20211109)
```
`simulate_cohort()` returns the seven subject columns of section 3.2 with
R names; the other three take that data frame and return the panel table
with R names (the subject columns first, then the measurement columns of
section 3, then `Synthetic`). Each starts with `set.seed(seed)` and is
deterministic for a given seed. `n` other than 100 scales the genotype
counts proportionally (rounded, remainder to `JAK2 V617F`) and the centre
split 3 to 1.

```r
generate_synthetic(outdir = "data/synthetic", n = 100, seed = 20211109,
                   write = TRUE)
```
Calls the four simulators, renames the columns to the raw headers of
section 3 (`panel_spec(panel)$raw_headers` is not available to this
builder, so the mapping is repeated here as a named vector per panel and a
test checks that both agree), writes the three CSV files as in section 3.1
when `write = TRUE`, and returns invisibly a list `cohort`,
`aggregation`, `hemogram`, `markers` of data frames with R names.

## 9. Output naming scheme

```
<outdir>/<panel>/<variant>/<slug>_figure.png
<outdir>/<panel>/<variant>/<slug>_anova.csv
<outdir>/<panel>/<variant>/<slug>_tukey.csv
<outdir>/<panel>/<variant>/<slug>_assumptions.csv
<outdir>/<panel>/<variant>/cohort_gender_figure.png
<outdir>/<panel>/<variant>/cohort_genotype_figure.png
<outdir>/<panel>/<variant>/cohort_gender_counts.csv
<outdir>/<panel>/<variant>/cohort_genotype_counts.csv
<outdir>/<panel>/anova_all.csv
<outdir>/<panel>/tukey_all.csv
<outdir>/<panel>/assumptions_all.csv
<outdir>/<panel>/cells_all.csv
<outdir>/<panel>/run_log.csv
<outdir>/<panel>/sessionInfo.txt
<outdir>/sessionInfo.txt            (written by run_all.R)
```

`<panel>` is `aggregation`, `hemogram` or `markers`; `<variant>` is one of
the four ids of section 5; `<slug>` is the token of section 2. The
committed example is the full run on the synthetic data with
`outdir = "outputs/example"`: 36 + 56 + 40 measure figures, the same
number of ANOVA, Tukey and assumption tables, 24 overview figures and 24
count tables, the five panel-level tables per panel and the session files.

Column sets of the exported tables:

- `<slug>_anova.csv` and `anova_all.csv`: `panel`, `variant`, `measure`,
  `status`, `n`, `term`, `sum_sq`, `df`, `f_value`, `p_raw`, `p_holm`,
  `p_bh`, `family_size`.
- `<slug>_tukey.csv` and `tukey_all.csv`: `panel`, `variant`, `measure`,
  `status`, `n`, `term`, `comparison`, `diff`, `lwr`, `upr`, `p_adj`.
- `<slug>_assumptions.csv` and `assumptions_all.csv`: `panel`, `variant`,
  `measure`, `status`, `n`, `test`, `statistic`, `p_value`, `note`.
- `cells_all.csv`: `panel`, `variant`, `measure`, `Genotype`, `Treatment`,
  `n`, `below_min`.
- `cohort_<group>_counts.csv`: `panel`, `variant`, `group`, `Treatment`,
  `level`, `n`.
- `run_log.csv`: the `log` element of section 8.6.

## 10. `run_all.R` (repository root)

Command line, parsed from `commandArgs(trailingOnly = TRUE)` in base R
(no optparse):

```
Rscript run_all.R [--panel all|aggregation|hemogram|markers]
                  [--variant <id>[,<id>...]]
                  [--outdir <dir>] [--data <dir>]
                  [--fast] [--label-points] [--help]
```

Defaults: `--panel all`, all four variants, `--outdir outputs/example`,
`--data data/synthetic`, fast off, labels off. Options may be given as
`--outdir dir` or `--outdir=dir`. `--help` prints the usage and exits with
status 0. An unknown option prints the usage and exits with status 2.

The script: sources every file of `R/` in alphabetical order (`for (f in
sort(list.files("R", pattern = "[.]R$", full.names = TRUE))) source(f)`),
attaches `dplyr`, `ggplot2` and `car` with `library()`, runs `run_panel()`
for each requested panel with the parsed arguments, writes
`<outdir>/sessionInfo.txt` with `write_session_info()`, prints a summary
(panels run, number of figures, number of fits by status) and ends with
`quit(status = 0)`; any uncaught error ends with a non-zero status (the
default behaviour of `Rscript`). With `renv` active, the `.Rprofile`
created by `renv::init()` is sourced automatically when R starts at the
root.

## 11. Tests (`tests/testthat/`)

Entry point `tests/testthat.R`: sets the working directory to the
repository root (the directory that contains `run_all.R`, found by walking
up from the file's location or assumed to be the current directory), then
`testthat::test_dir("tests/testthat")`. Helper
`tests/testthat/helper-source.R`: attaches `dplyr`, `ggplot2`, `car`,
sources every file of `R/` and defines `synthetic_dir()` returning
`data/synthetic` relative to the root. Tests write only under
`tempfile()` directories and never under the repository. Every test file
uses the synthetic data; none needs network access.

| File | Tests (one `test_that()` each) |
| --- | --- |
| `test-synthetic.R` | the three CSV files exist; each has 100 rows; the header of each file, read with `read.csv2(check.names = TRUE)`, equals exactly the R names of section 3 in order; `Codigo.Estudio` is unique and starts with `SYN-`; `Synthetic` equals `SYNTHETIC` in every row; genotype counts match section 3.2; centre counts are 75 and 25; every `CNTRL` subject is `Untreated`; `TRAP` is `NA` for every `CENTRE_B` row and non-missing for at least 60 `CENTRE_A` rows; `GPVI`, `CD42A` and `CD9` are `NA` for every `CENTRE_B` row and mostly present in `CENTRE_A`; the ratio equals `UNSTIMULATED.10min / Time.0min` within 1e-3; every clipped measure lies within its bounds; the differential percentages sum to 100 within 0.5; `generate_synthetic(write = FALSE)` called twice gives identical data frames; the raw header mapping of `generate_synthetic()` agrees with `panel_spec()$raw_headers` for the three panels |
| `test-read_inputs.R` | `panel_spec()` returns 9, 14 and 10 measures with slugs and labels of equal length; `read_inputs()` returns a data frame of 100 rows with the subject columns as factors in the level order of section 3.2 and every measure numeric; the `Synthetic` column is dropped and `data_label` says synthetic; a file with a missing measure column raises an error naming the column; a measure column with text raises an error naming the column; an unknown panel errors |
| `test-recode_variants.R` | `variant_table()` has the four ids in order with the flags of section 5; `CENTRE_A` keeps exactly the 75 `CENTRE_A` rows and leaves every measurement value unchanged; `CENTRE_Atratadosnotratados` has `Treatment` levels `Untreated`, `Treated` and the number of `Treated` equals the number of `ASA`, `Anagrelide` and `HU` rows of `CENTRE_A`; `CENTRE_ATNCONMPL` has no `VARIANT` level and its `TN` count equals `TN` plus `VARIANT` of `CENTRE_A`; `CENTRE_AtratadosnotratadosMPLCONTN` applies both; the `recoding` attribute lists the operations in order; an unknown id errors; `filter_centre()` errors when no row matches |
| `test-summarise_cohort.R` | `n` sums to `nrow(data)`; a missing `Gender` appears as `(missing)`; no observed level is dropped; `plot_cohort()` returns a ggplot |
| `test-plot_measure.R` | returns a ggplot for both designs and both geometries; with `label_points = FALSE` no text layer uses `Centro.Analisis`; with `label_points = TRUE` one does; the n labels (text layer built with `ggplot2::ggplot_build()`) exist only for cells with at least `min_cell` responses, checked against `table()` of the data; two builds with the same seed give identical point coordinates and two builds with different seeds do not; rows with a missing response produce no warning (`expect_silent()` on `ggplot_build()`) |
| `test-fit_anova.R` | structure of the `v1_fit` object and of its three tables; the type II table equals `car::Anova(lm(formula, data), type = 2)` row by row; on a constructed balanced two_way data set the type II p values equal the type I p values of `summary(aov())` within 1e-10; on the synthetic `CENTRE_A` variant the type I and type II p values of `Genotype` differ for at least one aggregation measure (the documented methodological difference); `p_holm >= p_raw`, `p_bh >= p_raw` and `p_holm >= p_bh` for every row after `adjust_p_values()`, and `family_size` equals the number of non-residual rows with a p value in the family; Tukey rows exist for every term and `p_adj` lies in 0 to 1; a response entirely missing gives `skipped_no_data` with zero-row tables; a factor with one level gives `skipped_single_level`; a design with an empty interaction cell gives `ok_aliased` with a complete ANOVA table; `assumptions` has the two tests with p values in 0 to 1 |
| `test-export.R` | `output_path()` builds the exact scheme of section 9 and rejects an unknown `kind` or `ext`; `export_table()` writes a readable CSV with the same columns; `export_figure()` writes a PNG file larger than 1 kB; `write_session_info()` writes a file containing `R version` and the seed and no absolute path (no drive letter followed by a colon, no leading slash path); `export_fit()` on a skipped fit writes three header-only files |
| `test-run_panel.R` | `run_panel("hemogram", fast = TRUE, outdir = tempdir)` writes, for each of the four variants, the two overview figures, two count tables and the four files of the two measures, plus the five panel-level tables and `sessionInfo.txt`; the returned `log` has 8 rows with a valid status; `anova_all.csv` has the column set of section 9 and `p_holm` present for every `ok` row; `run_panel("markers", variants = "CENTRE_A", measures = "GPVI", outdir = tempdir)` runs without error; an unknown variant or measure errors before writing anything |
| `test-run_all.R` | `system2(Rscript, c("run_all.R", "--fast", "--panel", "hemogram", "--outdir", shQuote(tempdir)))` returns status 0 and the output directory holds `hemogram/sessionInfo.txt` and `sessionInfo.txt`; `--help` returns status 0; an unknown option returns status 2 (`Rscript` is `file.path(R.home("bin"), "Rscript")`) |

All tests must pass with `Rscript tests/testthat.R` from the root under
the lock file of section 12.

## 12. Environment and lock file

`renv::init(bare = TRUE)` at the root, `renv::install(c("dplyr",
"ggplot2", "car", "testthat"))` from CRAN
(`options(repos = c(CRAN = "https://cloud.r-project.org"))`), then
`renv::snapshot(type = "implicit")`. Committed: `renv.lock`, `.Rprofile`,
`renv/activate.R`, `renv/settings.json` and renv's own `renv/.gitignore`.
The lock records R 4.3.2. No other package is added to the lock file
beyond these four and their dependencies.

## 13. `.gitignore` edits

Append the following block at the end of the existing file (nothing above
it is changed; the order matters because the last matching pattern wins
and a re-included file needs its parent directory re-included first):

```
# v1.0: synthetic example data and example outputs are committed
!data/synthetic/
!data/synthetic/README.md
!data/synthetic/*.csv
outputs/*
!outputs/example/
!outputs/example/**
```

After the edit, `git check-ignore -v data/synthetic/synthetic_hemogram.csv
outputs/example/hemogram/sessionInfo.txt` must report neither file as
ignored, while `data/anything.csv` and `outputs/scratch/x.csv` stay
ignored.

## 14. Builder assignment

The stages run in the order synthetic, core, runner_tests, docs. A later
stage may read and run everything an earlier stage wrote; no stage edits a
file of another stage. Temporary files go outside the repository.

| Stage | Writes | May assume |
| --- | --- | --- |
| synthetic | `R/synthetic_data.R`, `scripts/generate_synthetic.R`, `data/synthetic/README.md`, `data/synthetic/synthetic_aggregation.csv`, `data/synthetic/synthetic_hemogram.csv`, `data/synthetic/synthetic_markers.csv` | nothing else exists; the CSV files are produced by running `Rscript scripts/generate_synthetic.R` from the root (the `.gitignore` exceptions arrive with the runner_tests stage; the files are still written to disk) |
| core | `R/read_inputs.R`, `R/recode_variants.R`, `R/plot_measure.R`, `R/fit_anova.R`, `R/run_panel.R`, `R/export.R` | the synthetic files of section 3 exist with the exact schema; uses them for a manual smoke run into a temporary directory, never into `outputs/` |
| runner_tests | `run_all.R`, `tests/testthat.R`, `tests/testthat/helper-source.R`, `tests/testthat/test-*.R` (the eight files of section 11), the `.gitignore` block of section 13, `renv.lock`, `.Rprofile`, `renv/activate.R`, `renv/settings.json`, `renv/.gitignore`, and the committed example `outputs/example/**` produced by `Rscript run_all.R` with defaults after the tests pass | the `R/` functions exist with the signatures of section 8 and the synthetic files exist |
| docs | `README.md` (v1.0 sections: what v1.0 adds, how to run v1.0 with renv and `run_all.R`, synthetic data, methodological differences of section 6 in that order, updated repository structure, the roadmap entry of v0.1.0 marked as superseded by v1.0, keeping the v0.1.0 text about the legacy code), `docs/legacy_to_v1.md` | everything above exists; does not write `data/synthetic/README.md`, does not touch `CITATION.cff`, `docs/limitations.md`, `docs/cleaning.md` or `legacy/` |

Nobody writes `docs/v1_spec.md` after this version; a builder that finds
an inconsistency records it in the file it owns (a `Notes` section) and
implements this specification as written.

## 15. `docs/legacy_to_v1.md` (contract for the docs stage)

One table per 2021-11 script, one row per `aov()` fit of that script
(72, 112 and 80 rows, so that the counts of `docs/limitations.md` can be
checked against the document), with the columns: `Measure`, `Slot` (1 to
8, in the variant order of `legacy/README.md`), `Legacy variant` (the
object name in the `data` argument), `Figure lines` (from the `ggplot(`
call to the `ggtitle()` line), `aov line`, `Legacy geometry` (box or
violin, read from the legacy file), `Legacy status` (`valid`,
`character columns`, `never-read object`, `duplicate fit`, `wrong
object`, `cosmetic defect`, as in `docs/limitations.md`), `Scope`
(`CENTRE_A` or `cohort-wide, out of scope`), `v1.0 call`
(`run_panel("<panel>", variants = "<variant>", measures = "<R name>")`
for the `CENTRE_A` slots, `none` otherwise), `v1.0 outputs` (the three or
four files of section 9), `Note`.

Anchors for the `aov line` column (lines of the cleaned files; the four
values per measure are slots 5 to 8, that is, the variants `CENTRE_A`,
`CENTRE_Atratadosnotratados`, `CENTRE_AtratadosnotratadosMPLCONTN` and
`CENTRE_ATNCONMPL`; the docs builder reads the legacy file for slots 1 to
4 and for the figure lines):

- `Agonistas_2021-11-09.R`: PMA 416, 431, 446, 461; CVX 538, 554, 570
  (fitted on `CENTRE_ATNCONMPL`, duplicate of 584), 584; RISTO 667, 682,
  697 (never-read object), 712; AGGA 791, 806, 821, 836; COL 917, 932,
  947 (never-read object), 962; TRAP 1039, 1054, 1068 (never-read object),
  1082; UNSTIMULATED.10min 1167, 1182, 1198, 1214; Time.0min 1297, 1312,
  1327 (never-read object), 1342; UNS.Time.10min.vs.Time.0 1425, 1440,
  1455 (never-read object), 1470. Of the 48 valid fits of the script, 30
  are `CENTRE_A` (slots 5, 6 and 8 of the nine measures plus slot 7 of
  PMA, AGGA and UNSTIMULATED.10min) and 18 are cohort-wide (slots 1 and 2);
  v1.0 produces the 36 `CENTRE_A` fits, so 6 of them (slot 7 of CVX,
  RISTO, COL, TRAP, Time.0min and the ratio) have no valid 2021
  counterpart and are marked `new in v1.0`.
- `hemogram.R`: EPO 105 (formula `Genotype * Genotype`, numerically the
  one-way fit), 120, 135, 150; TPO 230, 245, 260, 275; HGB 355, 370, 385,
  400; HCT 481, 496, 511, 526; MCH 607, 622, 637, 652; MCHC 733, 748,
  763, 778; Lymph. 859, 874, 889, 904; Mono. 985, 1000, 1015, 1030; Eos.
  1111, 1126, 1141, 1156; Baso. 1238, 1253, 1268, 1283; Lymph abs 1363,
  1378, 1393, 1408; Mono abs 1489, 1504, 1519, 1534; Eos abs 1614 (raw
  object printed at 1615 instead of its summary), 1629, 1644, 1659; Baso
  abs 1740, 1755, 1770, 1785. All 112 fits are valid; 56 are `CENTRE_A`
  and map to v1.0, 56 are cohort-wide.
- `surfacemarkers.R`: CD61 419, 434, 449, 464; CD41 542, 558, 574 (fitted
  on `CENTRE_ATNCONMPL`, duplicate of 588), 588; CD49B 668, 683, 698,
  713; GPVI 792, 807, 822, 837; CD42A 914, 929, 943, 957; CD42B 1034,
  1049, 1063, 1077; CD31 1154, 1169, 1183, 1197; CD36 1274, 1289, 1303,
  1317; CD9 1393, 1408, 1422, 1436; FSC.unstained 1513, 1528, 1542, 1556.
  Of the 80 fits, 79 are distinct; 40 are `CENTRE_A`, of which 39 are
  valid 2021 fits and 1 (CD41 slot 7) is `new in v1.0`.

The document closes with a summary table (script, legacy fits, valid,
`CENTRE_A` valid, reproduced by v1.0, new in v1.0, cohort-wide out of
scope) and the methodological differences of section 6, and states that
no numerical result of 2021 is reproduced in the repository because the
study data are not distributed: the mapping is between code blocks and
calls, not between numbers.

## 16. Notes of the integration stage (deviations from the text above)

Recorded after the four stages were merged and the full run and the test
suite passed (`Rscript run_all.R`: 156 figures and 436 tables under
`outputs/example/`; `Rscript tests/testthat.R`: 620 tests, 0 failures).

- Section 1 says that only `R/export.R` writes to disk, section 8.8 says
  that `generate_synthetic(write = TRUE)` writes the three CSV files.
  Section 8.8 wins: the generator writes `data/synthetic/*.csv` itself
  (with `write.csv2()`, the format of section 3.1); every other file is
  written through `R/export.R`.
- Section 9: `run_all.R` writes one file beyond the list, the stacked log
  of every panel run at `<outdir>/run_log.csv` (same columns as the
  per-panel `run_log.csv`). The committed example therefore holds 436 CSV
  files (435 from the panels plus this one), 156 PNG files and 4
  `sessionInfo.txt` files.
- Section 8.7: `write_session_info()` drops the lines of `sessionInfo()`
  that describe the machine rather than the software (the `time zone`
  line, and the `BLAS` and `LAPACK` lines, which print absolute library
  paths on Linux and macOS), so that no location or absolute path reaches
  the committed files.
- Section 12: `renv::install()` from CRAN failed under renv 1.3.0 on the
  build machine and would have resolved package versions without Windows
  binaries for R 4.3.2; the project library was filled with
  `renv::hydrate()` from packages originally installed from CRAN and then
  recorded with `renv::snapshot(type = "implicit")`. The lock records R
  4.3.2 and the CRAN repository for every package, with the records reduced
  to the fields `Package`, `Version`, `Source`, `Repository`, `Depends`,
  `Imports`, `LinkingTo` and `NeedsCompilation` (the full records written
  by renv carry third-party author names, e-mails and URLs, which the
  privacy rule forbids); there is no `Hash` field, and `renv::restore()`
  installs by version from CRAN. The legacy dependencies `ggpubr`,
  `readxl`, `FactoMineR` and `gmodels` are listed in
  `renv/settings.json` as ignored packages so that the untouched legacy
  scripts do not pull them into the lock.
- Section 6, step 3: on the synthetic data every two_way fit (aggregation
  and markers) has the status `ok_aliased`, because the 8 by 4 (or 8 by 2,
  7 by 4, 7 by 2) design on 75 `CENTRE_A` rows has empty interaction
  cells; the type II table is still valid and the informative note of
  `car::Anova()` is muted because the status records the fact. The
  hemogram fits are `ok`.
- Section 8.3: in the violin geometry the `geom_violin()` layer is drawn
  only for the cells with at least two responses (ggplot2 3.5.1 drops such
  cells with a warning, and fails with `drop = FALSE`); the point layer
  shows every row, so the drawing is unchanged and the build is silent.
