# Legacy scripts (commissioned analysis, 2021)

These five R scripts are the statistical analysis code written by the owner
of this repository in 2021 for a study of platelet function by flow cytometry
in essential thrombocythemia, whose results appear in Molecular & Cellular
Proteomics 25(8):101617, 2026 (<https://doi.org/10.1016/j.mcpro.2026.101617>;
full citation in the top-level `README.md`). They are published **as delivered
and cleaned**: every file keeps its code, its structure and its original
Spanish comments, and differs from the delivered file only by a 14-line
provenance header and by the privacy substitutions described below (see
also `../docs/cleaning.md`). Nothing was corrected, refactored or re-run; the
known defects are listed in `../docs/limitations.md`.

The scripts cannot be executed from this repository: the input tables are
subject-level research data of the study and are never distributed. What they
expect is described in `../data/README.md` (file names as referenced in the
code, column names and types), so that a reader with authorized access to the
data could reproduce the runs.

Line numbers quoted anywhere in this repository refer to the cleaned files.
Subtract 14 to obtain the line in the delivered original (this holds for all
five files, including `pipeline_2021-03.R`).

## The five scripts

| Script | Original name and version date | Purpose | Inputs family | Lines |
|---|---|---|---|---|
| `Agonistas_2021-11-04.R` | `Agonistas.R`, version delivered on 2021-11-04 (data cut-off 2021-10-27, both centres) | Platelet aggregation after six agonists (PMA, CVX, RISTO, AGGA, COL, TRAP) and three baseline measures (UNSTIMULATED.10min, Time.0min and their ratio) by genotype and treatment: cohort bar charts, box or violin plots and two-way ANOVA with Tukey HSD on twelve dataset variants, plus an unfinished test block (PCA, subsets, four-factor ANOVA) | Aggregation tables, cut-off 2021-10-27: two XLSX workbooks and ten CSV reads (eleven objects) | 2206 |
| `Agonistas_2021-11-09.R` | `Agonistas.R`, later version with the 2021-11-09 data cut-off (first centre only) | Same nine aggregation variables, eight dataset variants (cohort-wide and CENTRE_A only, four-level and two-level treatment, with and without genotype relabelling): cohort bar charts, box or violin plots and two-way ANOVA with Tukey HSD; no test block, titles on every figure | Aggregation tables, cut-off 2021-11-09: two XLSX workbooks and six CSV files, all read from the working directory | 1477 |
| `hemogram.R` | `hemogram.R` (2021-11-09 data cut-off) | Fourteen haemogram and hormone variables (EPO, TPO, haemoglobin, haematocrit, MCH, MCHC, percentages and absolute counts of lymphocytes, monocytes, eosinophils and basophils) by genotype: one box or violin plot and one one-way ANOVA with Tukey HSD per variable and per subset, over eight subsets | Hemogram export of 2021-11-09: eight CSV files under `data/` | 1788 |
| `surfacemarkers.R` | `surfacemarkers.R` (2021-11-09 data cut-off) | Ten platelet surface markers (CD61, CD41, CD49B, GPVI, CD42A, CD42B, CD31, CD36, CD9, FSC.unstained) by genotype and treatment: cohort bar charts, box or violin plots and two-way ANOVA with Tukey HSD over eight dataset variants | Surface marker export of 2021-11-09: eight CSV files under `data/` | 1558 |
| `pipeline_2021-03.R` | Original name withheld (it embeds a person's first name); exploratory pipeline of March 2021 (R base, no tests) | First look at the aggregation table: descriptives, histograms, boxplots with jittered points by sex, genotype, treatment and centre for six agonists, one global PCA, control subset, treatment by genotype cross-tabulations and the three time measures by genotype | First aggregation export, March 2021: two tab-delimited text tables under `data/` | 167 |

Line counts are those reported by `wc -l` on the cleaned files. None of the
five scripts writes anything to disk (no `ggsave()`, `pdf()`, `png()`,
`write.*()`, `save()`, `saveRDS()` or `sink()`): every figure goes to the
active graphics device and every table to the console.

Lineage, from oldest to newest: `pipeline_2021-03.R` is the ancestor of the
aggregation analysis, although no line of it survives in the later scripts;
two ideas persisted, the merge of the VARIANT label into TN (the origin of
the TNCONMPL, MPLCONTN and MPLSTN suffixes of the derived tables) and the
request for a PCA by genotype or centre, of which only the unfinished
remnants in the test block of `Agonistas_2021-11-04.R` remain;
`Agonistas_2021-11-04.R` is the version delivered to the study with both
centres;
`Agonistas_2021-11-09.R` is the later edit with the 2021-11-09 cut-off, the
second centre removed and the test block dropped;
`hemogram.R` and `surfacemarkers.R` apply the same template to the haemogram
and surface marker panels of the 2021-11-09 export and share the loading
header of the later aggregation version.

## Section maps

Every analysis script follows the same template: package loading, data
import, a cohort overview of stacked bar charts (except `hemogram.R`), and then
one block per variable in which the same figure-plus-ANOVA sub-block is copied
once per dataset variant. The ranges below are the lines of the cleaned
files.

### Agonistas_2021-11-04.R

| Lines | Contents |
|---|---|
| 1-14 | Provenance header added at cleaning. |
| 15-18 | `library()` calls: dplyr, ggplot2, ggpubr, readxl. |
| 19-32 | Input section: disabled `setwd()` at line 20 (argument replaced by the placeholder `data`), two `read_excel()` calls with bare file names (21-22) and ten `read.csv2()` calls under `data/` (23-32). Line 28 repeats line 24, so twelve reads produce eleven objects. |
| 33-480 | Cohort overview: for each of twelve dataset slots, a stacked bar chart of counts by Treatment and Gender and another by Treatment and Genotype (24 charts; slot 8, lines 296-332, reuses the object of slot 4). |
| 482-638 | PMA: twelve slots, each a boxplot (odd slots) or violin plot (even slots) by Treatment facetted by Genotype, followed after every pair of slots by `aov(PMA ~ Genotype * Treatment)` with `summary()` and `TukeyHSD()`. |
| 640-802 | CVX: same template (the box or violin alternation is broken here: 5 boxplots, 7 violins). |
| 804-959 | RISTO: same template. |
| 961-1116 | AGGA: same template. |
| 1117-1272 | COL: same template. |
| 1273-1434 | TRAP: same template; TRAP is not measured in the second centre, so the CENTRE_B slots (1381-1434) run on an empty response. |
| 1436-1591 | UNSTIMULATED.10min: same template. |
| 1594-1755 | Time.0min: same template. |
| 1757-1918 | UNS.Time.10min.vs.Time.0 (ratio): same template. End of the delivered analysis. |
| 1919 | Original comment of the author stating that the analysis ends here and that what follows are tests (the only non-ASCII line of the file, see below). |
| 1921-1960 | Tests: PCA data frames by centre, `View()` calls, FactoMineR PCA with factoextra biplots, `imputePCA()` from missMDA, base plots. Not executable (undefined objects, missing columns, packages never loaded). |
| 1963-2078 | CENTRE_B subset of the global three-treatment table: one bar chart of counts by Treatment with `theme_pubclean()` and nine boxplots facetted by Genotype; no ANOVA. |
| 2080-2195 | JAK2 V617F subset of the same table: same bar chart and nine boxplots; no ANOVA. |
| 2197-2206 | Additive four-factor ANOVA `PMA ~ Gender + Treatment + Genotype + Centro.Analisis` with summary and coefficients (2198-2200), leftovers of an unrelated didactic example with undefined objects (2201-2204), full four-factor interaction ANOVA without summary (2205); line 2206 is blank. |

Totals: 152 `ggplot()` calls (26 bar charts, 71 boxplots, 55 violins), 110
`aov()` calls (108 two-way fits with Tukey HSD, 99 of them distinct, plus two
four-factor fits).

### Agonistas_2021-11-09.R

| Lines | Contents |
|---|---|
| 1-14 | Provenance header added at cleaning. |
| 15-18 | `library()` calls: dplyr, ggplot2, ggpubr, readxl (ggpubr is never used). |
| 19-28 | Section comment, disabled `setwd()` at line 20 (argument replaced by the placeholder `data`), and the eight reads: two XLSX with `read_excel()` (21, 23), two CSV with `read.csv(sep = ";")` (22, 24) and four CSV with `read.csv2()` (25-28). Lines 21 and 23 carry original comments on the treatment coding of each table. |
| 30-338 | Cohort overview: 16 stacked bar charts, two per variant (Gender by Treatment, then Genotype by Treatment), in the order TRESGRUPOS (30-67), tratadosnotratados (68-105), tratadosnotratadosMPLSTN (106-143), MPLSTN (144-182), CENTRE_A (185-222), CENTRE_Atratadosnotratados (223-261), CENTRE_AtratadosnotratadosMPLCONTN (262-300), CENTRE_ATNCONMPL (301-338); lines 339-343 are blank. |
| 344-463 | PMA: eight slots in the same variant order, each a figure followed by `aov(PMA ~ Genotype * Treatment)`, `summary()` and `TukeyHSD()`. |
| 468-586 | CVX: eight slots (the ANOVA at 570 is fitted on a different object than its figure). |
| 595-714 | RISTO: eight slots (the seventh references an object that is never read). |
| 720-838 | AGGA: eight slots. |
| 845-964 | COL: eight slots (seventh slot on the never-read object). |
| 970-1084 | TRAP: eight slots (seventh slot on the never-read object). |
| 1092-1216 | UNSTIMULATED.10min: eight slots. |
| 1226-1344 | Time.0min: eight slots (seventh slot on the never-read object). |
| 1351-1472 | UNS.Time.10min.vs.Time.0 (ratio): eight slots (seventh slot on the never-read object). The last statement is `TukeyHSD()` at 1472. |
| 1473-1477 | Blank trailing lines. |

Totals: 72 figures (36 boxplots, 36 violins) and 72 `aov()` fits (9 variables
by 8 variants), of which 48 are distinct and valid as explained in
`../docs/limitations.md`.

### hemogram.R

| Lines | Contents |
|---|---|
| 1-14 | Provenance header added at cleaning. |
| 15-18 | `library()` calls: dplyr, ggplot2, ggpubr, readxl (only ggplot2 is used). |
| 19-29 | Section label, disabled `setwd()` at line 20 (argument replaced by the placeholder `data`), eight `read.csv2()` calls under `data/` (21-24 cohort-wide tables, 26-29 first-centre tables; line 25 is blank as in the original). No filtering, recoding or joining anywhere in the script. |
| 32-152 | EPO (`EPO..mlU.ml.`): eight subset blocks labelled at 33, 48, 64, 79, 94, 109, 124 and 139, each a ggplot (box or violin plot by Genotype), an `aov(<variable> ~ Genotype)` fit, `summary()` and `TukeyHSD()`. |
| 158-277 | TPO (`TPO..pg.ml.`). |
| 283-402 | Haemoglobin (`HGB.gr.dl.`). |
| 409-528 | Haematocrit (`HCT....`). |
| 535-654 | MCH (`MCH..pg.`). |
| 661-780 | MCHC (`MCHC..gr.dl.`). |
| 787-906 | Lymphocyte percentage (`Lymph.`). |
| 913-1032 | Monocyte percentage (`Mono.`). |
| 1039-1158 | Eosinophil percentage (`Eos.`). |
| 1166-1285 | Basophil percentage (`Baso.`). |
| 1291-1410 | Absolute lymphocyte count (`Lymph..10.6.ml.`). |
| 1417-1536 | Absolute monocyte count (`Mono..10.6.ml.`). |
| 1542-1661 | Absolute eosinophil count (`Eos..10.6.ml.`); line 1615 prints the `aov` object instead of its summary. |
| 1668-1788 | Absolute basophil count (`Baso..10.6.ml.`); last code line 1787, line 1788 blank as in the original. |

The eight subsets of every variable are, in order: full cohort (label
TRESGRUPOS), full cohort with treatment in two levels (tratadosnotratados),
the same with VARIANT merged into TN (tratadosnotratadosMPLSTN), full cohort
with VARIANT merged into TN (MPLSTN), first centre (CENTRE_A), first centre
with two treatment levels (CENTRE_Atratadosnotratados), the same with VARIANT
merged into TN (CENTRE_AtratadosnotratadosMPLCONTN) and first centre with
VARIANT merged into TN (CENTRE_ATNCONMPL). Plot type per subset: box, violin,
violin, box, box, violin, box, box. Totals: 112 figures and 112 one-way ANOVA
fits.

### surfacemarkers.R

| Lines | Contents |
|---|---|
| 1-14 | Provenance header added at cleaning. |
| 15-18 | `library()` calls: dplyr, ggplot2, ggpubr, readxl (ggpubr and readxl are never used). |
| 19-29 | Data loading: disabled `setwd()` at line 20 (argument replaced by the placeholder `data`), four cohort-wide tables with `read.csv2()` (21-24) and their four CENTRE_A homologues (26-29). |
| 33-342 | Cohort overview: 16 stacked bar charts, two per variant (Gender by Treatment, Genotype by Treatment): 33-70 base, 71-108 treated versus untreated, 109-146 treated versus untreated with VARIANT merged into TN, 147-185 VARIANT merged into TN, 188-225 CENTRE_A, 226-263 CENTRE_A treated versus untreated, 265-302 CENTRE_A treated versus untreated with VARIANT merged into TN, 304-341 CENTRE_A with VARIANT merged into TN. |
| 346-466 | CD61: eight sub-blocks (headers at 347, 362, 378, 393, 408, 423, 438, 453), each a box or violin plot by Treatment facetted by Genotype plus `aov(CD61 ~ Genotype * Treatment)`, `summary()` and `TukeyHSD()`. |
| 471-590 | CD41: same (the ANOVA at 574 fits the wrong object and duplicates 588). |
| 595-715 | CD49B. |
| 720-839 | GPVI (measured only in CENTRE_A rows). |
| 844-959 | CD42A (measured only in CENTRE_A rows). |
| 964-1079 | CD42B. |
| 1084-1199 | CD31. |
| 1204-1319 | CD36. |
| 1323-1438 | CD9 (measured only in CENTRE_A rows). |
| 1443-1558 | FSC.unstained; last `TukeyHSD()` at 1558. |

Totals: 96 `ggplot()` calls (16 bar charts, 41 boxplots, 39 violins) and 80
`aov()` fits (10 markers by 8 variants, 79 distinct). The RAW.FSC column is
read but never used. Twenty-seven section comments still name aggregation
objects, a trace of the copy from the aggregation template.

### pipeline_2021-03.R

| Lines | Contents |
|---|---|
| 1-14 | Provenance header added at cleaning. |
| 15-25 | `library(gmodels)` (never used), `read.delim2()` of the first table, `summary()` and `View()` of the whole table, six auxiliary data frames (one per agonist, with sex, genotype, treatment, centre and the agonist column) and a seventh with the nine numeric measures for the PCA. |
| 26-39 | PMA: `View()`, `summary()`, `sd()`, histogram, index plot, boxplot with jittered `stripchart()` by sex, genotype, treatment and centre. |
| 41-53 | CVX: same descriptive sequence. |
| 55-67 | RISTO: same. |
| 69-81 | AGGA: same (y-axis label typo at 80). |
| 83-95 | COL: same. |
| 97-109 | TRAP: same (`sd()` on a misspelled column at 99, returns NA). |
| 112-117 | PCA: `library(FactoMineR)`, redundant `library(stats)`, `FactoMineR::PCA()` on the nine measures with default plots. |
| 119-135 | Control subset selected by `grep("CNTRL", ...)` on Genotype; boxplot plus stripchart of each agonist by treatment. |
| 136-144 | Contingency table Treatment by Genotype on the full table and grouped `barplot()` with legend. |
| 145-153 | Second input table (VARIANT label merged into TN), same table and barplot. |
| 155-160 | Boxplot plus stripchart of the three time measures by Genotype on the full table. |
| 162-167 | Same three measures on the merged table. |

Totals: 52 on-screen figures and console descriptives; no statistical test.

## The provenance header

Each cleaned file starts with the same 14-line comment block, added at
cleaning and absent from the delivered originals (which had no header, author,
date or description). It records:

1. the nature of the code (legacy script of a commissioned analysis, 2021,
   published with the written authorization of the principal investigator)
   and the article it relates to (journal reference and DOI), lines 2-6;
2. the original file name and version (delivery or cut-off date, centres
   covered), line 7 (lines 7-8 in `pipeline_2021-03.R`, where the statement
   that the name is withheld runs on to the encoding line);
3. the original text encoding (UTF-8 for `Agonistas_2021-11-04.R`, ASCII for
   the other four) and the original line-ending convention (CRLF, except LF
   for `Agonistas_2021-11-09.R`), line 8;
4. the exhaustive list of changes made at cleaning (paths, `setwd()`, the
   two centre tokens, the VARIANT label and the category renamed
   `CALR Type_Other`), with a pointer to `../docs/cleaning.md`, lines 9-12;
5. the statement that no other change was made and that the code is not
   executable without the private input data, together with the SHA-256
   digest of the delivered original, lines 12-13.

The header text was rewritten before the public release to list the two
label substitutions; it kept its fourteen lines, so no line number of the
code moved.

The SHA-256 digest is the anchor of the provenance: anyone holding the
delivered file can hash it and compare it with the header, and anyone holding
the cleaned file can reverse the cleaning (see below) and obtain a file with
that digest.

## Original environment

The delivered scripts do not record the R version, the package versions or
the operating system they were run on: there is no `sessionInfo()` output, no
`renv` or `packrat` lockfile, no comment with a version number and no date in
the code. The only environment facts that can be stated are these.

- Packages attached with `library()`: dplyr, ggplot2, ggpubr and readxl in the
  four 2021-11 scripts; gmodels, FactoMineR and stats in
  `pipeline_2021-03.R`. Base R functions from stats, graphics and utils are
  used without attachment. The test block of `Agonistas_2021-11-04.R` calls
  FactoMineR, factoextra and missMDA functions without ever loading them.
- Of these, ggpubr is used only in `Agonistas_2021-11-04.R` (two
  `theme_pubclean()` calls), readxl only in the two `Agonistas` files, dplyr
  not at all in `hemogram.R`, and gmodels not at all.
- The ggplot2 syntax (`fun.y`, the `..ymax..` notation, `vjust` inside
  `aes()`) follows conventions that ggplot2 deprecated from version 3.3.0
  (released in 2020) onwards. This dates the style of the code, not the
  installed version: the scripts run, with deprecation warnings, on current
  ggplot2 releases.
- The delivered scripts set the working directory with `setwd()` to absolute
  paths on the author's workstation or external drive (the four calls are
  disabled in the cleaned files and their arguments replaced by the
  placeholder `data`, so no original location survives anywhere in the five
  files; see `../docs/cleaning.md`) and ran in an interactive RStudio session
  (five `View()` calls in the pipeline, four in the first `Agonistas`
  version). No version of R or RStudio can be given with confidence.

Because the versions are unknown and the scripts have no seed, no run on
current software can be expected to reproduce the 2021 figures pixel for
pixel; the ANOVA tables, which do not depend on random numbers, should match
for any fit that is valid (see `../docs/limitations.md`).

## What the cleaning changed, and how to check that nothing else did

The cleaning made exactly eight kinds of change (numbered 1 to 8 in
`../docs/cleaning.md`), applied mechanically and recorded per file in that
log; they are grouped below under six headings, the three token substitutions
(transformations 3 to 5 of the log) being described together:

1. **Provenance header.** Fourteen comment lines prepended to every file.
2. **Paths.** Absolute paths replaced by `data/<file>`, and the argument of
   each disabled `setwd()` call by the placeholder `data`: 11 in
   `Agonistas_2021-11-04.R` (the ten `read.csv2()` calls plus the `setwd()`
   argument), 1 in `Agonistas_2021-11-09.R` (the `setwd()` argument only;
   its reads already used bare relative names), 9 in `hemogram.R` and 9 in
   `surfacemarkers.R` (the eight `read.csv2()` calls plus the `setwd()`
   argument) and 2 in `pipeline_2021-03.R` (its two `read.delim2()` calls;
   it had no `setwd()`). The file names themselves were kept.
3. **`setwd()` disabled.** The single `setwd()` call of each of the four
   2021-11 scripts (line 20 in all of them) was commented out with a trailing
   note; `pipeline_2021-03.R` had none. All four comments now read
   `# setwd("data")` followed by the note, so no original location survives
   anywhere in the five files.
4. **Token substitution.** Three literal tokens were replaced wherever they
   occurred (object names, file names, comments, figure titles, filter
   labels): the token of the first centre by `CENTRE_A`, the token of the
   second centre by `CENTRE_B`, and one genotype label by `VARIANT`.
5. **Compound label reduced.** In the genotype filter lists of
   `surfacemarkers.R` (lines 54, 92, 209 and 247) and in the name of the
   second input file of `pipeline_2021-03.R` (line 145) the label that
   paired a gene name with the variant was reduced to the bare placeholder
   `VARIANT`; object names such as `TNMPL.VARIANT` were not touched. These
   five edits add no occurrence of the token and are counted separately.
6. **Genotype category renamed.** One category of the genotype filter lists
   of `surfacemarkers.R` was renamed `CALR Type_Other` (8 occurrences, lines
   54, 92, 130, 169, 209, 247, 286 and 325). It occurs in no other script.

Occurrences replaced per file:

| File | First centre to `CENTRE_A` | Second centre to `CENTRE_B` | Genotype label to `VARIANT` | Compound label reduced | Category to `CALR Type_Other` |
|---|---|---|---|---|---|
| `Agonistas_2021-11-04.R` | 171 | 245 | 125 | 0 | 0 |
| `Agonistas_2021-11-09.R` | 218 | 0 | 64 | 0 | 0 |
| `hemogram.R` | 344 | 0 | 0 | 0 | 0 |
| `surfacemarkers.R` | 264 | 0 | 13 | 4 | 8 |
| `pipeline_2021-03.R` | 0 | 0 | 16 | 1 | 0 |

Each cleaned file contains exactly these numbers of occurrences plus one of
each placeholder in the header (`CENTRE_A`, `CENTRE_B` and `VARIANT` at line
11, `CALR Type_Other` at line 12), which is how the counts above can be
re-derived from the repository alone with `grep -o <token> <file> | wc -l`;
the reduced compound labels add nothing to the `VARIANT` count, because they
already contained the placeholder. The cleaning summary records zero
residual occurrences of the original tokens, of the original compound label
and of the original category name in every file. Because every substitution
is a plain, case-sensitive string replacement that never overlaps with any
other identifier in the code, it is invertible without ambiguity.

**Reverse substitution check.** Anyone holding the delivered original can
verify that nothing else was touched:

1. remove lines 1-14 of the cleaned file;
2. replace `CENTRE_A`, `CENTRE_B` and `VARIANT` by the original tokens, put
   the gene name back in front of the variant in the four filter lists of
   `surfacemarkers.R` and in the file name at line 145 of
   `pipeline_2021-03.R`, and restore the original name of the category now
   called `CALR Type_Other` in the eight filter lists of `surfacemarkers.R`
   (the cleaning summary states which is which, and a reader with authorized
   access knows them);
3. restore the read paths, that is, strip the `data/` prefix that was put in
   front of the file names and put back the original absolute paths, and
   restore the `setwd()` line with its original argument in place of the
   placeholder `data` (known to a reader holding the delivered file),
   removing the trailing note added at cleaning;
4. make sure the line endings and the encoding are those stated in the
   header. The cleaned files keep them as delivered (CRLF for four files, LF
   for `Agonistas_2021-11-09.R`; UTF-8 without BOM for
   `Agonistas_2021-11-04.R`, ASCII for the rest), but a git checkout with
   end-of-line conversion enabled may alter them, so normalise before
   comparing bytes;
5. compute the SHA-256 and compare with line 13 of the header.

The only character outside ASCII in the five cleaned files is at line 1919 of
`Agonistas_2021-11-04.R`, inside the original comment that closes the
delivered analysis: an accented letter stored as the UTF-8 byte pair `C3 A1`,
exactly as in the delivered file. In an editor that assumes a Latin-1 or
Windows-1252 encoding it shows as two garbled characters. This artefact is
part of the original and was deliberately kept. Everything else in the five
files is plain ASCII, with the original Spanish comments left without
accents, as the author wrote them.

What the cleaning did **not** do: it did not fix any defect, did not add
`print()`, `ggsave()` or seeds, did not remove unused `library()` calls, did
not rename objects, did not re-indent or re-format a single line, and did not
execute any script.

## How to run the scripts

Short answer: not from this repository. The input tables are private and are
never distributed (see `../data/README.md` and the privacy note there). The
instructions below are for a reader who has obtained the tables through the
study's own data access process.

### Prerequisites

- R (any reasonably recent 4.x release; see the caveat on versions above)
  with the packages dplyr, ggplot2, ggpubr and readxl installed. For
  `pipeline_2021-03.R` add FactoMineR and gmodels (gmodels is loaded and
  never used, but `library(gmodels)` at line 15 fails if it is absent). The
  test block of `Agonistas_2021-11-04.R` (lines 1921-1960) would additionally
  need FactoMineR, factoextra and missMDA, but it does not run in any case.
- An interactive session (RStudio or the R console). The scripts rely on
  auto-printing at the top level and on `View()`: sourced with `source()` or
  run with `Rscript` they produce no figure and no table. If sourcing is
  preferred, use `source("<script>", echo = TRUE, print.eval = TRUE)` and
  accept that `View()` calls warn or fail outside RStudio.

### Placing the input files

Put the tables in `data/` at the project root (the folder is listed in
`.gitignore`, so nothing placed there can be committed by accident), with the
file names exactly as referenced in each script and with the following
adjustments:

- Files whose original names carried the real token of the first centre
  must be renamed so that the name contains `CENTRE_A` instead (four files in
  `hemogram.R`, lines 26-29; four in `surfacemarkers.R`, lines 26-29; the
  `CENTRE_A*.csv` and `CENTRE_B*.csv` files of both `Agonistas` versions).
  Alternatively, edit the read lines to point at the original names.
- The values of the `Centro.Analisis` column should be recoded to `CENTRE_A`
  and `CENTRE_B`. This only changes the per-point labels in the figures,
  except in `Agonistas_2021-11-04.R`, where three `grep()` filters select
  rows by the centre tokens (lines 1928 and 1964 on `CENTRE_B`, line 1936 on
  `CENTRE_A`) and would return nothing on the original labels.
- The second table of `pipeline_2021-03.R` is referenced as
  `data/FCA PLT aggregationTNVARIANT.txt`; the original name carried the
  full genotype label (gene name and variant) where `VARIANT` now stands.
- The `Genotype` values of the surface marker tables must be recoded so that
  the variant reads `VARIANT` and the category now called `CALR Type_Other`
  reads that placeholder; otherwise the overview bar charts of
  `surfacemarkers.R`, whose filter lists (lines 54 to 325) keep rows by
  exact label, drop those rows. The ANOVA fits do not filter on labels and
  are unaffected.

### Working directory per script

- `hemogram.R`, `surfacemarkers.R` and `pipeline_2021-03.R` read everything
  from `data/` and are run with the working directory at the project root
  (open the `.Rproj` file, or `setwd()` to the root).
- `Agonistas_2021-11-04.R` reads the ten CSV files from `data/` but the two
  XLSX workbooks (lines 21-22) by bare name from the working directory. Either
  place those two workbooks at the project root or edit lines 21-22 to add the
  `data/` prefix.
- `Agonistas_2021-11-09.R` reads all eight files by bare name from the working
  directory (the cleaning replaced only the `setwd()` argument in this file,
  not a read path). Either run it with
  the working directory set to `data/` (`setwd("data")` and then
  `source("../legacy/Agonistas_2021-11-09.R", echo = TRUE, print.eval = TRUE)`),
  or edit lines 21-28 to add the `data/` prefix.

### What to expect

- Many ggplot2 warnings (deprecated `fun.y` and `..ymax..`, unknown
  `outlier.*` parameters in `geom_violin()`, rows with missing values
  removed) and dplyr grouping messages. They are harmless.
- Hard stops when sourcing. `Agonistas_2021-11-09.R` stops at line 386 (an
  object name with a typo) and would stop again at 687, 937, 1058, 1317 and
  1445 (the figures drawn from an object that is never read; their fits at
  697, 947, 1068, 1327 and 1455 are never reached). `Agonistas_2021-11-04.R`
  stops in the TRAP block on the CENTRE_B tables (1381-1434, response entirely
  missing) and in the test block (1921-1960) and the leftover lines 2201-2204.
  `hemogram.R`, `surfacemarkers.R` and `pipeline_2021-03.R` are expected to
  run from start to end. Running block by block is the intended mode of use;
  the section maps above give the boundaries.
- Fits that run but are not valid: in `Agonistas_2021-11-09.R` the two MPLSTN
  tables are read with `read.csv(sep = ";")` without `dec = ","`, so their
  measurement columns are character and the 18 fits on them (slots 3 and 4 of
  every variable) are meaningless. The full list of such cases is in
  `../docs/limitations.md`.
- Nothing is saved. To keep a figure, wrap the block in `pdf()` and
  `dev.off()` or call `ggsave()` after it; to keep a table, use `sink()` or
  capture the `summary()` and `TukeyHSD()` objects. Jittered labels have no
  seed, so label positions change between runs.
- The figures print the centre of every sample and the size of every group,
  including the smallest groups. They are exploratory outputs for the
  analyst and must not be published as produced from real data.

No script in this folder has been executed as part of this release.
