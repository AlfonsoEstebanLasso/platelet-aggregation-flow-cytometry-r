# Synthetic example data (no biological meaning)

## What this folder contains

The three CSV files in this folder are a synthetic example data set: a
fictitious cohort of 100 subjects, present in all three panels (one row per
subject per panel), whose tables follow the schema of the private study
tables described in `data/README.md`. The values are drawn from hand-set
distributions and carry no biological meaning. No group effect is
simulated: genotype, treatment, sex and centre have no relation to any
measurement, apart from the missingness by centre described below and the
platelet count, which is drawn with a higher mean for the patients than for
the controls only so that the table looks like a cohort of the disease (it
is not analysed). No real data table was read, copied or referenced to
build these files.

Every file name starts with `synthetic_`, every subject code starts with
`SYN-` and every table ends with a column `Synthetic` whose value is
`SYNTHETIC` in every row, so that the tables cannot be mistaken for study
data. They exist so that the v1.0 pipeline (`run_all.R`), its tests and the
committed example outputs can be exercised without any study data.

| File | Rows | Columns |
| --- | --- | --- |
| `synthetic_aggregation.csv` | 100 | 17 |
| `synthetic_hemogram.csv` | 100 | 30 |
| `synthetic_markers.csv` | 100 | 19 |

## How the files were generated

The generator is `R/synthetic_data.R` (functions) and
`scripts/generate_synthetic.R` (the script that writes the files). It uses
base R only. From the repository root:

```
Rscript scripts/generate_synthetic.R
```

The script calls `generate_synthetic(outdir = "data/synthetic", n = 100,
seed = 20211109)`, which runs `simulate_cohort()` and then
`simulate_aggregation()`, `simulate_hemogram()` and `simulate_markers()`,
each starting with `set.seed(20211109)`. The output is deterministic: running
the script again rewrites byte-identical files. The distribution table used
by the simulators is returned by `synthetic_spec()`; the fixed cohort design
(levels, counts, probabilities) by `synthetic_cohort_design()`; the mapping
from R column names to raw headers by `synthetic_raw_headers(panel)`.

Order of the draws, for reproducibility: in `simulate_cohort()`, the
genotype labels are shuffled, then the centre labels, then the treatment of
the patients, then sex, then the birth year and its missing subjects. In
each panel simulator, every measurement column is drawn in file order,
derived columns are computed, then the random missingness is applied column
by column in file order with `sample()` on the row indices, and the
missingness by centre is applied last.

## File format

Identical to the private format: semicolon separator, decimal comma, no
quoting, header in row 1 with the raw headers below, UTF-8 without BOM
(the content is ASCII), LF line endings, empty fields for missing values.
Written with `write.csv2(x, file, row.names = FALSE, na = "", quote =
FALSE, eol = "\n")` on a connection opened in binary mode. Read back with
`read.csv2(file, check.names = TRUE)`, which converts the raw headers to
the R names listed below with `make.names()`.

## Subject columns (shared by the three panels, identical values)

| Raw header | R name | Type | Values and distribution |
| --- | --- | --- | --- |
| `Codigo Estudio` | `Codigo.Estudio` | character | `SYN-001` to `SYN-100`, unique |
| `Codigo muestra` | `Codigo.muestra` | character | `SYN-S-001` to `SYN-S-100`, unique |
| `Gender` | `Gender` | character, factor | `F` with probability 0.55, otherwise `M`; the subjects in positions 7 and 58 are set to missing (exactly two missing) |
| `Birth Year` | `Birth.Year` | integer | `round(rnorm(n, 1962, 12))` clipped to 1930 to 2000; 50 subjects chosen at random are missing |
| `Genotype` | `Genotype` | character, factor with 8 levels | exact counts, shuffled with the seed: `CNTRL` 20, `JAK2 V617F` 25, `CALR Type I` 12, `CALR Type II` 8, `CALR Type_Other` 4, `MPL W515` 6, `TN` 15, `VARIANT` 10 |
| `Treatment` | `Treatment` | character, factor with 4 levels | every `CNTRL` subject is `Untreated`; the 80 patients draw `Untreated`, `ASA`, `Anagrelide`, `HU` with probabilities 0.30, 0.40, 0.15, 0.15 |
| `Centro Analisis` | `Centro.Analisis` | character, factor with 2 levels | `CENTRE_A` 75, `CENTRE_B` 25, assigned independently of the genotype |

Factor level order (fixed everywhere): Genotype in the order listed above;
Treatment `Untreated`, `ASA`, `Anagrelide`, `HU`; centre `CENTRE_A`,
`CENTRE_B`. `CENTRE_A`, `CENTRE_B` and `VARIANT` are placeholders, as in the
rest of the repository.

## Aggregation table (`synthetic_aggregation.csv`, 17 columns)

The seven subject columns, then (`clip(a, b)` means `pmin(pmax(x, a), b)`):

| Raw header | R name | Distribution | Decimals | Missingness |
| --- | --- | --- | --- | --- |
| `PMA` | `PMA` | normal(55, 18) clip(0, 100) | 2 | 5 percent at random (5 rows) |
| `CVX` | `CVX` | normal(60, 15) clip(0, 100) | 2 | 5 percent at random |
| `RISTO` | `RISTO` | normal(45, 20) clip(0, 100) | 2 | 5 percent at random |
| `AGGA` | `AGGA` | normal(50, 17) clip(0, 100) | 2 | 5 percent at random |
| `COL` | `COL` | normal(40, 16) clip(0, 100) | 2 | 5 percent at random |
| `TRAP` | `TRAP` | normal(58, 14) clip(0, 100) | 2 | missing for every `CENTRE_B` row; 5 percent at random among the `CENTRE_A` rows (4 of 75) |
| `UNSTIMULATED.10min` | `UNSTIMULATED.10min` | normal(12, 5) clip(1, 40) | 2 | none |
| `Time.0min` | `Time.0min` | normal(8, 3) clip(1, 30) | 2 | none |
| `UNS.Time.10min.vs.Time.0` | `UNS.Time.10min.vs.Time.0` | `UNSTIMULATED.10min / Time.0min`, computed, never drawn | 4 | none |
| `Synthetic` | `Synthetic` | constant `SYNTHETIC` | | none |

## Hemogram table (`synthetic_hemogram.csv`, 30 columns)

The seven subject columns, then the 22 numeric columns with the raw headers
of `data/README.md` reproduced exactly (including `WBC*10^6/ml)` with its
unbalanced parenthesis), then `Synthetic`:

| Raw header | R name | Distribution | Decimals | Missingness |
| --- | --- | --- | --- | --- |
| `TPO (pg/ml)` | `TPO..pg.ml.` | lognormal(meanlog log(120), sdlog 0.6) | 1 | 60 percent at random |
| `EPO (mlU/ml)` | `EPO..mlU.ml.` | lognormal(log(12), 0.6) | 1 | 60 percent at random |
| `WBC*10^6/ml)` | `WBC.10.6.ml.` | normal(7.5, 2) clip(2.5, 20) | 2 | 3 percent at random (3 rows) |
| `RBC (*10^9/ml)` | `RBC...10.9.ml.` | normal(4.7, 0.5) clip(3, 6.5) | 2 | 3 percent at random |
| `HGB(gr/dl)` | `HGB.gr.dl.` | normal(13.5, 1.5) clip(8, 18) | 1 | 3 percent at random |
| `HCT (%)` | `HCT....` | normal(41, 4) clip(25, 55) | 1 | 3 percent at random |
| `MCV (fl)` | `MCV..fl.` | normal(90, 6) clip(65, 110) | 1 | 3 percent at random |
| `MCH (pg)` | `MCH..pg.` | normal(30, 2.5) clip(20, 38) | 1 | 3 percent at random |
| `MCHC (gr/dl)` | `MCHC..gr.dl.` | normal(33.5, 1.2) clip(28, 37) | 1 | 3 percent at random |
| `PLT (*10^6)/ml` | `PLT...10.6..ml` | normal(350, 120) for `CNTRL`, normal(700, 200) for every other genotype, clip(100, 1500); the only group-dependent draw, not analysed | 0 | 3 percent at random |
| `MPV( fl)` | `MPV..fl.` | normal(10, 1.2) clip(6, 14) | 1 | 3 percent at random |
| `RETIC %` | `RETIC..` | normal(1.2, 0.5) clip(0.1, 4) | 2 | 3 percent at random |
| `Neutr%` | `Neutr.` | gamma share, shape 60 | 1 | same rows as WBC |
| `Lymph%` | `Lymph.` | gamma share, shape 30 | 1 | same rows as WBC |
| `Mono%` | `Mono.` | gamma share, shape 6 | 1 | same rows as WBC |
| `Eos%` | `Eos.` | gamma share, shape 3 | 1 | same rows as WBC |
| `Baso%` | `Baso.` | gamma share, shape 1 | 1 | same rows as WBC |
| `Neutr (*10^6/ml)` | `Neutr...10.6.ml.` | `WBC * Neutr% / 100` | 2 | same rows as WBC |
| `Lymph(*10^6/ml)` | `Lymph..10.6.ml.` | `WBC * Lymph% / 100` | 2 | same rows as WBC |
| `Mono(*10^6/ml)` | `Mono..10.6.ml.` | `WBC * Mono% / 100` | 2 | same rows as WBC |
| `Eos(*10^6/ml)` | `Eos..10.6.ml.` | `WBC * Eos% / 100` | 2 | same rows as WBC |
| `Baso(*10^6/ml)` | `Baso..10.6.ml.` | `WBC * Baso% / 100` | 2 | same rows as WBC |
| `Synthetic` | `Synthetic` | constant `SYNTHETIC` | | none |

The differential percentages are drawn as `rgamma(n, shape, 1)` with the
shapes above, normalised so that the five values of a row sum to 100, and
rounded to 1 decimal (the rounded values sum to 100 within 0.5). The
absolute counts are computed from the rounded percentages and the WBC value
before any value is set to missing; the ten differential columns are then
set to missing exactly in the rows where WBC is missing. Eight of the
numeric columns (WBC, RBC, MCV, PLT, MPV, RETIC, Neutr percentage and
absolute count) are read and kept by the pipeline but not analysed, as in
2021.

## Surface marker table (`synthetic_markers.csv`, 19 columns)

The seven subject columns, then eleven columns, all lognormal with sdlog
0.35 and the median given below (meanlog is the logarithm of the median),
rounded to 1 decimal, then `Synthetic`:

| Raw header | R name | Median | Missingness |
| --- | --- | --- | --- |
| `RAW FSC` | `RAW.FSC` | 25000 | 3 percent at random (3 rows) |
| `CD61` | `CD61` | 6000 | 3 percent at random |
| `CD41` | `CD41` | 5000 | 3 percent at random |
| `CD49B` | `CD49B` | 350 | 3 percent at random |
| `GPVI` | `GPVI` | 500 | missing for every `CENTRE_B` row; 3 percent at random among the `CENTRE_A` rows (2 of 75) |
| `CD42A` | `CD42A` | 2200 | missing for every `CENTRE_B` row; 3 percent among the `CENTRE_A` rows |
| `CD42B` | `CD42B` | 3200 | 3 percent at random |
| `CD31` | `CD31` | 900 | 3 percent at random |
| `CD36` | `CD36` | 1600 | 3 percent at random |
| `CD9` | `CD9` | 2600 | missing for every `CENTRE_B` row; 3 percent among the `CENTRE_A` rows |
| `FSC unstained` | `FSC.unstained` | 18000 | 3 percent at random |
| `Synthetic` | `Synthetic` | constant `SYNTHETIC` | none |

`RAW.FSC` is read and kept by the pipeline but not analysed, as in 2021.

## Missingness pattern in the committed files

With the project seed, the committed files contain the following numbers of
missing values per column (out of 100 rows): aggregation, 5 in each of
`PMA`, `CVX`, `RISTO`, `AGGA` and `COL`, 29 in `TRAP` (25 `CENTRE_B` rows
plus 4 `CENTRE_A` rows), none elsewhere; hemogram, 60 in `TPO` and `EPO`,
3 in every other numeric column (the differential columns share the three
rows of WBC); markers, 3 in every column except `GPVI`, `CD42A` and `CD9`,
which have 27 (25 `CENTRE_B` rows plus 2 `CENTRE_A` rows). `Gender` is
missing in 2 rows and `Birth.Year` in 50.

## Other cohort sizes

`generate_synthetic(n = ...)` and `simulate_cohort(n = ...)` accept a size
other than 100: the genotype counts are scaled proportionally and rounded,
with the remainder assigned to `JAK2 V617F`; the centre split stays 3 to 1
(`round(0.75 * n)` subjects in `CENTRE_A`); half of the subjects
(`round(0.5 * n)`) have a missing birth year; the sex positions 7 and 58 are
set to missing only when they exist. The committed files use n = 100 and
nothing in the repository depends on another size.

## Notes

- Section 1 of `docs/v1_spec.md` states that the functions in `R/` write
  to disk only through `R/export.R`, while section 8.8 asks
  `generate_synthetic(write = TRUE)` to write the three CSV files. The
  generator follows section 8.8: it writes only inside the directory passed
  as `outdir` (default `data/synthetic`) and only when `write = TRUE`.
- `.gitignore` ignores every CSV file under `data/` except the three
  synthetic tables (`!data/synthetic/*.csv`), so private tables placed under
  `data/` are never committed while these files are.
