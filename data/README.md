# Input data (not distributed)

## No data file is included

This folder is intentionally empty apart from this README. None of the input
tables read by the scripts in `legacy/` is distributed with the repository,
and none will be. They are subject level research data (one row per patient or
donor, about one hundred rows per panel) from a clinical cohort of two
centres, and they contain pseudonymous study and sample codes that the centres
can link to clinical records, together with sex, year of birth, driver
genotype, treatment, analysing centre and individual laboratory values. In a
cohort of this size the combination of sex, year of birth, genotype, treatment
and centre is a quasi identifier even after the code columns are removed, so
no row level extract, not even a stripped one, can be published.

The only material reproduced here is structural metadata: the file names as
referenced by the cleaned scripts, delimiters, sheet names, column names,
column types and the meaning of the file name suffixes. This is enough for a
reader with authorized access to rebuild the expected inputs and run the
scripts.

The `data/` folder is listed in `.gitignore` (everything except this README),
so private tables placed here for local execution are never committed.

## How an authorized reader obtains the data

The data can be obtained only from the principal investigator of the study
(last author of the article cited in the root README and in `CITATION.cff`)
under the study's own data access agreement and ethics approval. The owner of
this repository holds no right to share them.

Once obtained, the tables must be prepared as follows before the cleaned
scripts can run:

1. Rename the files so that the centre tokens in the file names read
   `CENTRE_A` (first analysing centre) and `CENTRE_B` (second analysing
   centre). In the private source folders these two placeholders stand for
   the identifying token of each centre as it appeared in the delivered file
   names (the same tokens that `docs/cleaning.md`, transformations 3 and 4,
   replaced in the code).
2. Recode the values of the column `Centro.Analisis` (or `Centro Analisis`) to
   `CENTRE_A` and `CENTRE_B` in the same way.
3. Recode two values of the `Genotype` column where the cleaned scripts name
   them: the label of the merged genotype variant to `VARIANT`, and the CALR
   category that the filter lists of `surfacemarkers.R` call
   `CALR Type_Other` to that placeholder. Both matter only for the overview
   bar charts of `surfacemarkers.R` (filter lists at lines 54 to 325), which
   keep rows by exact label; the ANOVA fits use whatever labels the tables
   carry. The second table of the March pipeline must also be renamed so that
   `VARIANT` replaces the original genotype label in its file name (family 5
   below).
4. Place the files at the locations listed below. `hemogram.R`,
   `surfacemarkers.R` and `pipeline_2021-03.R` read from `data/` relative to
   the project root. `Agonistas_2021-11-04.R` reads its two workbooks from the
   working directory and its CSV tables from `data/`. `Agonistas_2021-11-09.R`
   reads every file from the working directory, so run it from the folder that
   holds the files or adjust the paths at the top of the script.

v1.0 adds a synthetic example dataset with the same schema under
`data/synthetic/` (see `data/synthetic/README.md`) so that the v1.0 code can
be exercised without any real data; the legacy scripts still need the private
files listed below.

## Expected files by script

The scripts expect the files with the exact names below. Objects are loaded
one per file, and the object name repeats the suffix of the file name.

### Family 1. Platelet aggregation, data cut-off 2021-10-27 (both centres)

Read by `legacy/Agonistas_2021-11-04.R`.

| Expected location | Format |
|---|---|
| `FCA_aggregation_filtered_NA27102021.xlsx` (working directory) | XLSX master workbook |
| `FCA_aggregation_filtered_NA27102021_tratadosnotratados.xlsx` (working directory) | XLSX master workbook, Treatment recoded to two levels |
| `data/TNCONMPL.csv` | CSV, Genotype relabelled |
| `data/FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL.csv` | CSV, both relabellings (read twice, at lines 24 and 28, into the same object; see `docs/limitations.md`) |
| `data/CENTRE_A.csv` | CSV, first centre subset |
| `data/CENTRE_Atratadosnotratados.csv` | CSV, first centre subset, Treatment recoded |
| `data/CENTRE_ATNCONMPL.csv` | CSV, first centre subset, Genotype relabelled |
| `data/CENTRE_B.csv` | CSV, second centre subset |
| `data/CENTRE_Btratadosnotratados.csv` | CSV, second centre subset, Treatment recoded |
| `data/CENTRE_BTNCONMPL.csv` | CSV, second centre subset, Genotype relabelled |
| `data/CENTRE_BtratadosnotratadosTNCONMPL.csv` | CSV, second centre subset, both relabellings |

Format details:

- The two master workbooks are read with `readxl::read_excel` from the working
  directory. Each has a single sheet named `25_OCT2021` (name inherited from
  an earlier export), header in row 1 and one row per sample. The column
  `UNS.Time.10min.vs.Time.0` is stored as an Excel formula in most rows. The
  workbooks also carry about one thousand trailing empty columns, which
  `read_excel` imports as automatically named empty columns.
- The nine derived tables are read with `read.csv2` from `data/`: semicolon
  delimiter, decimal comma, no quoting, header in row 1, ASCII or UTF-8
  without BOM, CRLF line endings, exported from Excel. The file
  `..._tratadosnotratadosTNCONMPL.csv` was exported with the same trailing
  empty columns (about one thousand fields per line).
- The global tables have 16 columns. The centre subsets (`CENTRE_A*`,
  `CENTRE_B*`) drop `Codigo Estudio` and have 15. The centre subsets are
  disjoint and complementary partitions of the master table.
- All derived tables differ from the master only by row filtering (centre) or
  by relabelling of `Genotype` or `Treatment`, never by measurement values
  (differences limited to rounding at the sixth decimal).
- Rows: global tables about one hundred rows (one per sample); `CENTRE_A`
  subsets roughly three quarters of them; `CENTRE_B` subsets a few dozen rows.

Column dictionary (families 1 and 2 share this schema):

| Column | Type | Meaning |
|---|---|---|
| `Codigo Estudio` | integer or character identifier (global tables only) | Study code of the subject, unique per row, pseudonymous key shared with the hemogram and surface marker panels. Absent from the centre subsets. |
| `Codigo muestra` | character identifier | Sample code, unique per row where present (missing in some CENTRE_B rows). Not used by the analyses. |
| `Gender` | character, factor with two levels (some missing) | Sex of the subject, used as a grouping variable in the overview plots. |
| `Birth Year` | integer, mostly missing | Year of birth. Informed in about half of the rows. Not used by the analyses. |
| `Genotype` | character, factor (8 levels in the master; 7 after the TNCONMPL merge) | Driver genotype group of essential thrombocythemia (groups named in the article: MPL, CALR, TN for triple negative, plus further levels). Main explanatory factor in the ANOVA and Tukey comparisons. |
| `Treatment` | character, factor (4 levels in the master; 2 in the tratadosnotratados tables) | Antiplatelet or cytoreductive treatment at sampling: untreated plus three treatment groups (acetylsalicylic acid, anagrelide, hydroxyurea according to the comment in the script), or treated versus untreated after recoding. Second explanatory factor. |
| `Centro.Analisis` | character, factor with two levels | Analysing centre. The cleaned scripts expect the levels `CENTRE_A` and `CENTRE_B`; the private tables carry the real names and must be recoded before running the cleaned code. |
| `PMA` | numeric (decimal comma in CSV) | Platelet aggregation response to phorbol ester stimulation (area under the curve, named `AUCPMA` by the March 2021 pipeline). |
| `CVX` | numeric | Aggregation response to convulxin. |
| `RISTO` | numeric | Aggregation response to ristocetin. |
| `AGGA` | numeric | Aggregation response to the agonist labelled AGGA in the source tables. |
| `COL` | numeric | Aggregation response to collagen. |
| `TRAP` | numeric, missing for all CENTRE_B rows | Aggregation response to thrombin receptor activating peptide. Not measured at CENTRE_B, so the column is empty in `CENTRE_B*` tables and in about half of the global rows. |
| `UNSTIMULATED.10min` | numeric | Unstimulated (spontaneous) aggregation measured after 10 minutes. |
| `Time.0min` | numeric | Unstimulated measurement at time zero. |
| `UNS.Time.10min.vs.Time.0` | numeric (Excel formula in the XLSX) | Ratio of the unstimulated 10 minute measurement to the time zero measurement. |

### Family 2. Platelet aggregation, data cut-off 2021-11-09 (CENTRE_A only in the centre subsets)

Read by `legacy/Agonistas_2021-11-09.R`. All files are read from the working
directory (no `data/` prefix in this script).

| Expected location | Format |
|---|---|
| `FCA_aggregation_filtered_NA9112021.xlsx` | XLSX master workbook |
| `FCA_aggregation_filtered_NA9112021MPLSTN.csv` | CSV, Genotype subdivided into finer labels (ten levels) |
| `FCA_aggregation_filtered_NA9112021_tratadosnotratados.xlsx` | XLSX master workbook, Treatment recoded |
| `FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN.csv` | CSV, Treatment recoded, Genotype subdivided (eight levels) |
| `CENTRE_A.csv` | CSV, first centre subset |
| `CENTRE_ATNCONMPL.csv` | CSV, first centre subset, Genotype relabelled |
| `CENTRE_Atratadosnotratados.csv` | CSV, first centre subset, Treatment recoded |
| `CENTRE_AtratadosnotratadosMPLCONTN.csv` | CSV, first centre subset, both relabellings |

Format details:

- The two master workbooks are read with `readxl::read_excel`: single sheet
  named `25_OCT2021`, header in row 1, ratio column as an Excel formula,
  trailing empty columns as in the October workbooks (fewer in the
  tratadosnotratados workbook, which was saved with a different spreadsheet
  application).
- The six CSV tables use semicolon delimiter, decimal comma, no quoting and
  header in row 1. The four `CENTRE_A*` tables are read with `read.csv2`
  (decimal comma handled). The two `...MPLSTN.csv` tables are read with
  `read.csv(sep = ";")` without `dec = ","`, so their decimal comma numbers
  are imported as text or factors; this is one of the known defects listed in
  `docs/limitations.md`.
- One of the MPLSTN CSV files and `CENTRE_AtratadosnotratadosMPLCONTN.csv` use
  LF line endings; the rest use CRLF.
- Same 16 column schema as family 1 (15 in the `CENTRE_A*` subsets, which drop
  `Codigo Estudio`). `Genotype` has 8 levels in the master, 7 after TNCONMPL
  or MPLCONTN, and 10 or 8 longer labels in the MPLSTN tables.
  `Centro.Analisis` contains a single level in the `CENTRE_A*` subsets.
- The November master is a strict superset of the October master (identical
  values plus additional CENTRE_A samples).
- Known inconsistencies in the derived tables: the tratadosnotratados workbook
  and the tratadosnotratadosMPLSTN CSV alter `Centro.Analisis` in a few rows
  with respect to the master; the two MPLSTN CSV files leave some rows with
  all nine measurements empty; `CENTRE_AtratadosnotratadosMPLCONTN.csv`
  contains stray `Treatment` and `Genotype` labels that match no other row of
  the family. No CENTRE_B subset was exported for this cut-off.
- Rows: global tables slightly more than one hundred rows (the October rows
  plus additional CENTRE_A samples); `CENTRE_A` subsets about eighty rows.

### Family 3. Hemogram (complete blood count with differential, plus TPO and EPO), export of 2021-11-09

Read by `legacy/hemogram.R`.

| Expected location | Format |
|---|---|
| `data/Hemograma_ALL_Nov9_2021.csv` | CSV, base table |
| `data/Hemograma_ALL_Nov9_2021_tratadosnotratados.csv` | CSV, Treatment recoded |
| `data/Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN.csv` | CSV, Treatment recoded, Genotype merged |
| `data/Hemograma_ALL_Nov9_2021MPLSTN.csv` | CSV, Genotype merged |
| `data/Hemograma_ALL_Nov9_2021CENTRE_A.csv` | CSV, first centre subset |
| `data/Hemograma_ALL_Nov9_2021_CENTRE_Atratadosnotratados.csv` | CSV, first centre subset, Treatment recoded |
| `data/Hemograma_ALL_Nov9_2021_CENTRE_AtratadosnotratadosMPLSTN.csv` | CSV, first centre subset, both relabellings |
| `data/Hemograma_ALL_Nov9_2021CENTRE_AMPLSTN.csv` | CSV, first centre subset, Genotype merged |

Format details:

- Eight CSV tables read with `read.csv2` from `data/`: semicolon delimiter,
  decimal comma, header in row 1, UTF-8 without BOM, one row per subject, 29
  columns in every file.
- All seven derived tables come from the base table by row filtering (CENTRE_A
  only) or by relabelling `Genotype` or `Treatment`, never by changing values.
- The raw header names contain units and punctuation. `read.csv2` converts
  them with `make.names`, and the script addresses the measurement columns by
  the converted names (for example `HGB.gr.dl.`, `EPO..mlU.ml.`, `Neutr.`,
  `Baso..10.6.ml.`), so the raw headers must be reproduced exactly for the
  formulas to match.
- The base table contains an additional level of `Centro Analisis` besides the
  two centres; recode or drop it before running the cleaned script.
- Rows: base and globally relabelled tables slightly more than one hundred
  rows; `CENTRE_A` subsets about ninety rows.

Column dictionary (raw header, then the name R assigns after `make.names`):

| Column (raw header) | R name | Type | Meaning |
|---|---|---|---|
| `Codigo Estudio` | `Codigo.Estudio` | character identifier | Study code of the subject, unique per row; shared with the aggregation and surface marker panels. |
| `Codigo muestra` | `Codigo.muestra` | character identifier | Sample code, unique per row. Not used by the analyses. |
| `Gender` | `Gender` | character, factor with two levels | Sex of the subject, grouping variable in the overview plots. |
| `Birth Year` | `Birth.Year` | integer, partly missing | Year of birth. Not used by the analyses. |
| `Genotype` | `Genotype` | character, factor (8 levels; 7 in the MPLSTN tables) | Driver genotype group (MPL, CALR, TN and further levels). Factor of the one way ANOVA and Tukey HSD per hemogram variable. |
| `Treatment` | `Treatment` | character, factor (4 levels; 2 in the tratadosnotratados tables) | Untreated plus three treatment groups, or treated versus untreated. |
| `Centro Analisis` | `Centro.Analisis` | character, factor | Analysing centre, expected as `CENTRE_A` and `CENTRE_B` in the cleaned script. |
| `TPO (pg/ml)` | `TPO..pg.ml.` | numeric, largely missing | Thrombopoietin concentration. |
| `EPO (mlU/ml)` | `EPO..mlU.ml.` | numeric, largely missing | Erythropoietin concentration. |
| `WBC*10^6/ml)` | `WBC.10.6.ml.` | numeric | White blood cell count (header reproduced as in the source, including the unbalanced parenthesis). |
| `RBC (*10^9/ml)` | `RBC...10.9.ml.` | numeric | Red blood cell count. |
| `HGB(gr/dl)` | `HGB.gr.dl.` | numeric | Haemoglobin concentration. |
| `HCT (%)` | `HCT....` | numeric | Haematocrit. |
| `MCV (fl)` | `MCV..fl.` | numeric | Mean corpuscular volume. |
| `MCH (pg)` | `MCH..pg.` | numeric | Mean corpuscular haemoglobin. |
| `MCHC (gr/dl)` | `MCHC..gr.dl.` | numeric | Mean corpuscular haemoglobin concentration. |
| `PLT (*10^6)/ml` | `PLT...10.6..ml` | numeric | Platelet count. |
| `MPV( fl)` | `MPV..fl.` | numeric | Mean platelet volume. |
| `RETIC %` | `RETIC..` | numeric | Reticulocyte percentage. |
| `Neutr%` | `Neutr.` | numeric | Neutrophil percentage of the leukocyte differential. |
| `Lymph%` | `Lymph.` | numeric | Lymphocyte percentage. |
| `Mono%` | `Mono.` | numeric | Monocyte percentage. |
| `Eos%` | `Eos.` | numeric | Eosinophil percentage. |
| `Baso%` | `Baso.` | numeric | Basophil percentage. |
| `Neutr (*10^6/ml)` | `Neutr...10.6.ml.` | numeric | Absolute neutrophil count. |
| `Lymph(*10^6/ml)` | `Lymph..10.6.ml.` | numeric | Absolute lymphocyte count. |
| `Mono(*10^6/ml)` | `Mono..10.6.ml.` | numeric | Absolute monocyte count. |
| `Eos(*10^6/ml)` | `Eos..10.6.ml.` | numeric | Absolute eosinophil count. |
| `Baso(*10^6/ml)` | `Baso..10.6.ml.` | numeric | Absolute basophil count. |

### Family 4. Platelet surface markers by flow cytometry, export of 2021-11-09

Read by `legacy/surfacemarkers.R`.

| Expected location | Format |
|---|---|
| `data/SurfaceMarkers_ALL_Nov9_2021.csv` | CSV, base table |
| `data/SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados.csv` | CSV, Treatment recoded |
| `data/SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN.csv` | CSV, Treatment recoded, Genotype merged |
| `data/SurfaceMarkers_ALL_Nov9_2021MPLSTN.csv` | CSV, Genotype merged |
| `data/SurfaceMarkers_ALL_Nov9_2021CENTRE_A.csv` | CSV, first centre subset |
| `data/SurfaceMarkers_ALL_Nov9_2021_CENTRE_Atratadosnotratados.csv` | CSV, first centre subset, Treatment recoded |
| `data/SurfaceMarkers_ALL_Nov9_2021_CENTRE_AtratadosnotratadosMPLSTN.csv` | CSV, first centre subset, both relabellings |
| `data/SurfaceMarkers_ALL_Nov9_2021CENTRE_ATNCONMPL.csv` | CSV, first centre subset, Genotype merged |

Format details:

- Eight CSV tables read with `read.csv2` from `data/`: semicolon delimiter,
  decimal comma, header in row 1, UTF-8 without BOM, one row per subject, 18
  columns in every file.
- The seven derived tables come from the base table by row filtering (CENTRE_A
  only) or by relabelling `Genotype` or `Treatment`.
- Marker columns have simple headers and are addressed directly in the two way
  ANOVA formulas (`marker ~ Genotype * Treatment`); the only converted name is
  `FSC.unstained`.
- Three markers (GPVI, CD42A, CD9) were measured only at CENTRE_A and are
  empty for CENTRE_B rows.
- The `Gender` column of this panel contains, besides the two expected levels,
  a placeholder level in some rows.
- Rows: base and globally relabelled tables slightly more than one hundred
  rows; `CENTRE_A` subsets roughly eighty five rows.

Column dictionary:

| Column (raw header) | R name | Type | Meaning |
|---|---|---|---|
| `Codigo Estudio` | `Codigo.Estudio` | character identifier | Study code of the subject, unique per row; shared with the hemogram and aggregation panels. |
| `Codigo muestra` | `Codigo.muestra` | character identifier, a few missing | Sample code. Not used by the analyses. |
| `Gender` | `Gender` | character, factor (two levels plus a placeholder level) | Sex of the subject, grouping variable in the overview plots. |
| `Birth Year` | `Birth.Year` | integer, about half missing | Year of birth. Not used by the analyses. |
| `Genotype` | `Genotype` | character, factor (8 levels; 7 in the MPLSTN and TNCONMPL tables) | Driver genotype group (MPL, CALR, TN and further levels). First factor of the two way ANOVA per marker. The cleaned script expects two of the levels spelled `VARIANT` and `CALR Type_Other` in its overview filter lists. |
| `Treatment` | `Treatment` | character, factor (4 levels; 2 in the tratadosnotratados tables) | Untreated plus three treatment groups, or treated versus untreated. Second factor of the two way ANOVA. |
| `Centro Analisis` | `Centro.Analisis` | character, factor with two levels | Analysing centre, expected as `CENTRE_A` and `CENTRE_B` in the cleaned script. |
| `RAW FSC` | `RAW.FSC` | numeric | Forward scatter of the stained platelet population (size proxy). |
| `CD61` | `CD61` | numeric | Surface expression intensity of CD61 (integrin beta 3). |
| `CD41` | `CD41` | numeric | Surface expression intensity of CD41 (integrin alpha IIb). |
| `CD49B` | `CD49B` | numeric | Surface expression intensity of CD49b (integrin alpha 2). |
| `GPVI` | `GPVI` | numeric, missing for CENTRE_B rows | Surface expression intensity of glycoprotein VI. |
| `CD42A` | `CD42A` | numeric, missing for CENTRE_B rows | Surface expression intensity of CD42a (GPIX). |
| `CD42B` | `CD42B` | numeric | Surface expression intensity of CD42b (GPIb alpha). |
| `CD31` | `CD31` | numeric | Surface expression intensity of CD31 (PECAM-1). |
| `CD36` | `CD36` | numeric | Surface expression intensity of CD36. |
| `CD9` | `CD9` | numeric, missing for CENTRE_B rows | Surface expression intensity of CD9. |
| `FSC unstained` | `FSC.unstained` | numeric | Forward scatter of the unstained control. |

### Family 5. March 2021 exploratory pipeline tables (first aggregation export)

Read by `legacy/pipeline_2021-03.R`.

| Expected location | Format |
|---|---|
| `data/FCA PLT aggregation.txt` | tab delimited text |
| `data/FCA PLT aggregationTNVARIANT.txt` | tab delimited text, VARIANT genotype level merged into TN (the original file name carried the full genotype label, gene name and variant, where `VARIANT` now stands) |

Format details:

- Two tab delimited text tables read with `read.delim2` (tab delimiter,
  decimal comma, header in row 1), one row per sample, with a few trailing
  empty lines that are loaded as rows of NA.
- The second file is the same table with the genotype level that the cleaned
  code calls `VARIANT` merged into TN.
- These tables predate the filtered exports of October and November 2021 and
  were not part of the final delivery. The script uses only the columns listed
  below, so any identifier or birth year columns present in the file are
  ignored.
- The script also references a non existent column `AUTRAP` (typo for
  `AUCTRAP`), which yields NA silently.
- Rows: slightly more than one hundred lines per file, some of which are empty
  and load as NA rows.

Column dictionary (the name in the auxiliary data frames built by the script
is given in parentheses):

| Column | Type | Meaning |
|---|---|---|
| `Gender` | character, factor | Sex of the subject (`SEXO`). |
| `Genotype` | character, factor | Driver genotype group (`GENOTIPO`). |
| `Treatment` | character, factor | Treatment group (`TRATAMIENTO`), used for the contingency table against `Genotype`. |
| `Centro.Analisis` | character, factor with two levels | Analysing centre (`CENTRO`), expected as `CENTRE_A` and `CENTRE_B` in the cleaned script. |
| `PMA` | numeric | Aggregation response to phorbol ester (`AUCPMA`). |
| `CVX` | numeric | Aggregation response to convulxin (`AUCCVX`). |
| `RISTO` | numeric | Aggregation response to ristocetin (`AUCRISTO`). |
| `AGGA` | numeric | Aggregation response to the agonist labelled AGGA (`AUCAGGA`). |
| `COL` | numeric | Aggregation response to collagen (`AUCCOL`). |
| `TRAP` | numeric, largely missing | Aggregation response to thrombin receptor activating peptide (`AUCTRAP`); the PCA imputes its missing values by the mean. |
| `UNSTIMULATED.10min` | numeric | Unstimulated aggregation after 10 minutes. |
| `Time.0min` | numeric | Unstimulated measurement at time zero. |
| `UNS.Time.10min.vs.Time.0` | numeric | Ratio of the 10 minute unstimulated measurement to the time zero measurement. |

## Suffix conventions

File names combine a base export name with one or more suffixes that encode an
export date, a centre subset or a relabelling of a grouping column. Suffixes
never change measurement values. They combine in the order date, centre,
treatment, genotype, and the scripts load each combination into an object
whose name repeats the suffix.

| Token | Kind | Meaning |
|---|---|---|
| `27102021` | date | Export of 27 October 2021, the data cut-off used by `Agonistas_2021-11-04.R`. |
| `9112021`, `Nov9_2021` | date | Export of 9 November 2021, used by `Agonistas_2021-11-09.R`, `hemogram.R` and `surfacemarkers.R`. |
| `CENTRE_A` | centre | Rows of the first analysing centre only. These subsets drop the `Codigo Estudio` column in the aggregation family. |
| `CENTRE_B` | centre | Rows of the second centre only. Such subsets exist only in the October aggregation family. |
| `tratadosnotratados` | treatment | "Treated versus untreated". Collapses `Treatment` from four levels (untreated plus three treatment groups, the scheme the scripts call `PTRESGRUPOS` or `TRESGRUPOS`) to two levels, treated versus untreated. |
| `TNCONMPL`, `MPLCONTN` | genotype | Merge one genotype level (the one the cleaned code calls `VARIANT`) into the triple negative (TN) group, so `Genotype` goes from eight to seven levels. |
| `MPLSTN` | genotype | Same merging meaning in the hemogram and surface marker families (there, `CENTRE_AMPLSTN` in the hemogram family and `CENTRE_ATNCONMPL` in the surface marker family are the same operation under two spellings). In the November aggregation family, however, the two MPLSTN CSV files do the opposite operation and subdivide TN and MPL into finer labels (ten levels in one file and eight in the other), so the token is not consistent across sub-projects. |

In the private source folders the centre tokens are the identifying tokens of
the two centres as they appeared in the delivered file names. A reader with
authorized access must rename the files and recode the `Centro.Analisis`
labels to `CENTRE_A` and `CENTRE_B`, and the two genotype labels described
above, before running the cleaned scripts.

## Privacy note

None of the input tables is distributed with this repository, and none will
be. They are subject level research data from a clinical cohort of two
centres, with pseudonymous study and sample codes linkable to clinical records
by the centres, sex, year of birth, driver genotype, treatment, analysing
centre and individual laboratory values. Because the combination of these
attributes is a quasi identifier in a cohort of about one hundred subjects, no
row level extract, not even one with the code columns removed, can be
published.

This README reproduces structural metadata only: file names as referenced by
the cleaned scripts, delimiters, sheet names, column names, column types and
the meaning of the relabelling suffixes. It contains no data value, no
identifier, no birth year and no individual attribute. Access to the data is
granted only by the principal investigator of the study under the study's data
access agreement and ethics approval; the owner of this repository holds no
right to share them.
