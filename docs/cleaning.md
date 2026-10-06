# Cleaning log

This log records every transformation applied to the five R scripts of the
2021 analysis before their publication in `legacy/`. The purpose of the
cleaning was privacy, not correction: the code is published as delivered, and
no analytical statement was changed. The defects of the delivered code are
documented separately in `docs/limitations.md`.

## Source files

The five scripts were taken from the private working folders of the 2021
engagement. Only the bare original file names are recorded here; the private
folder structure is not reproduced. One original name embedded the first name
of a person and is withheld; its SHA-256 is recorded below.

| Published file | Original file name | Original encoding | Original line endings | Original lines | Published lines (with header) |
| --- | --- | --- | --- | --- | --- |
| `legacy/Agonistas_2021-11-04.R` | `Agonistas.R` (version delivered on 2021-11-04, data cut-off 2021-10-27, both centres) | UTF-8 without BOM | CRLF | 2,193 | 2,207 |
| `legacy/Agonistas_2021-11-09.R` | `Agonistas.R` (later copy kept in a different folder, data cut-off 2021-11-09, first centre only) | ASCII | LF | 1,464 | 1,478 |
| `legacy/hemogram.R` | `hemogram.R` (2021-11-09 export) | ASCII | CRLF | 1,775 | 1,789 |
| `legacy/surfacemarkers.R` | `surfacemarkers.R` (2021-11-09 export) | ASCII | CRLF | 1,545 | 1,559 |
| `legacy/pipeline_2021-03.R` | March 2021 exploratory pipeline (original file name withheld because it embeds a person's first name) | ASCII | CRLF | 154 | 168 |

Line counts follow the convention of the cleaning tool, which counts the
trailing newline as the end of a last empty line; `wc -l` reports one less for
each file (2,206, 1,477, 1,788, 1,558 and 167). The published name of the two
aggregation versions carries the delivery or cut-off date because both
originals were called `Agonistas.R`.

## SHA-256 of the originals

The following digests identify the delivered files before any change. They are
also quoted in line 13 of the provenance header of each published script, so
that anyone holding the original can confirm that the published file descends
from it.

| Original file | SHA-256 |
| --- | --- |
| `Agonistas.R` (2021-11-04 version) | `740aac956a924daa28569f869287388a5d48a3a004f209b0a324c6ed65d2e692` |
| `Agonistas.R` (2021-11-09 version) | `a73fe339f0c4dcb14398eca90613578f74f5b638ea9422bf77d3675029b95077` |
| `hemogram.R` | `d6d6f8667511ec95b982e6539fcf134add17fce0c0d78a2a064dcbb165e49268` |
| `surfacemarkers.R` | `45ded76458081c30c31a74f3cb1cb1a94cb404392e25741abe0521a1ee6a8bd0` |
| March 2021 pipeline (original name withheld) | `e9c433a8565414f0b9a58af4023ce6dd6b6891c58002d2d10d0ad25e3a4c39e1` |

## Transformations

Eight kinds of change were applied, in the order of the sections below, with a
script that performed literal substitutions and never reflowed, reindented or
reformatted any line. Transformations 1 to 5 and the header were applied in a
first pass; the replacement of the four `setwd()` arguments by the placeholder
`data` (counted under transformation 1), transformations 6 and 7 and the
rewriting of the header text were applied in a second pass before the public
release, with the same tool and without moving any line. Counts are
occurrences, not lines: several occurrences can share a line.

| Published file | Absolute paths replaced | `setwd()` calls disabled | First centre renamed CENTRE_A | Second centre renamed CENTRE_B | Genotype label renamed VARIANT | Compound label reduced to VARIANT | Category renamed CALR Type_Other | Residual occurrences after cleaning | Non-ASCII lines |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `Agonistas_2021-11-04.R` | 11 | 1 | 171 | 245 | 125 | 0 | 0 | 0 | 1 |
| `Agonistas_2021-11-09.R` | 1 | 1 | 218 | 0 | 64 | 0 | 0 | 0 | 0 |
| `hemogram.R` | 9 | 1 | 344 | 0 | 0 | 0 | 0 | 0 | 0 |
| `surfacemarkers.R` | 9 | 1 | 264 | 0 | 13 | 4 | 8 | 0 | 0 |
| `pipeline_2021-03.R` | 2 | 0 | 0 | 0 | 16 | 1 | 0 | 0 | 0 |
| Total | 32 | 4 | 997 | 245 | 218 | 5 | 8 | 0 | 1 |

### 1. Absolute paths replaced by `data/<file>`

The delivered scripts read their inputs from absolute paths on the author's
workstation or on an external drive. Each absolute path inside a read call was
replaced by the relative form `data/<file>`, keeping the file name exactly as
the code referenced it, and the absolute argument of each `setwd()` call by
the placeholder `data` (see transformation 2). The counts in the table are:
11 in `Agonistas_2021-11-04.R` (the ten `read.csv2()` calls at lines 23-32
plus the `setwd()` argument at line 20); 1 in `Agonistas_2021-11-09.R` (the
`setwd()` argument only); 9 in `hemogram.R` and 9 in `surfacemarkers.R` (the
eight `read.csv2()` calls plus the `setwd()` argument at line 20); 2 in
`pipeline_2021-03.R` (its two `read.delim2()` calls at lines 16 and 145; it
had no `setwd()`). In `Agonistas_2021-11-09.R` no read path was replaced,
because the original `setwd()` pointed at the folder holding the eight tables
(an absolute location on the author's external drive), so the read calls used
bare file names and contained no absolute path to replace; the eight inputs
are still read by bare file name. Two `read_excel()` calls in
`Agonistas_2021-11-04.R` (lines 21-22) also read bare file names; they were
left as found because they contained no absolute path. The `data/` folder of
the repository holds only `data/README.md`, which describes the expected
inputs; the folder is listed in `.gitignore` so that private tables placed
there for local execution are never committed.

### 2. `setwd()` calls disabled

Each `setwd()` call (one per script, at line 20 of the four 2021-11 scripts;
`pipeline_2021-03.R` had none) was commented out, with a trailing note, so
that the scripts run from the project root. The argument of every disabled
call, which in the delivered files was an absolute path on the author's
workstation or external drive, was replaced by the placeholder `data`, so
that line 20 of the four scripts now reads
`# setwd("data")  # setwd() disabled in this release: run from the project root`
and no original location survives anywhere in the five files. The four
argument replacements are counted among the paths replaced in the table
above (transformation 1). A previous version of this log recorded an open
item for the two `Agonistas` scripts, whose disabled calls still carried the
original text; that text was replaced by the placeholder in the second pass
and the item is closed.

### 3. First centre renamed CENTRE_A

Every occurrence of the identifying token of the first analysing centre, as it
appeared in the delivered files, was replaced by the placeholder `CENTRE_A`:
in object names, in the file names passed to the
read calls, in comments and in figure titles (171, 218, 344 and 264
occurrences in the four 2021-11 scripts; none in the March 2021 pipeline,
which never names a centre). Because the token was part of the delivered
file names, the published scripts now reference input files such as
`CENTRE_A.csv` or `Hemograma_ALL_Nov9_2021CENTRE_A.csv`; a reader with
authorized access to the private tables has to rename them accordingly, and
also to recode the values of the `Centro.Analisis` column, as explained in
`data/README.md`.

### 4. Second centre renamed CENTRE_B

Every occurrence of the identifying token of the second analysing centre, as
it appeared in the delivered files, was replaced by `CENTRE_B` (245
occurrences, all in `Agonistas_2021-11-04.R`, the only script
that handles the second centre's subsets). The other four scripts never name
the second centre; in `hemogram.R` and `surfacemarkers.R` it appears only as a
value inside the `Centro.Analisis` column of the private tables, not in the
code.

### 5. One genotype label renamed VARIANT

Every occurrence of one genotype label, which in the delivered code appeared
inside object names, file names, filter lists and comments, was replaced by
`VARIANT` (125, 64, 13 and 16 occurrences in `Agonistas_2021-11-04.R`,
`Agonistas_2021-11-09.R`, `surfacemarkers.R` and `pipeline_2021-03.R`; none in
`hemogram.R`). The genotype groups named in the article (MPL, CALR, TN and the
other common labels) were not touched, except for the category described in
transformation 7. After the substitution the cleaned code contains the
placeholder mostly inside object names, in the second file name of the March
pipeline and in genotype filter lists. The counts above include the
occurrences inside the compound label of transformation 6, which already
contained the placeholder after this step.

### 6. Compound label reduced to VARIANT

In the delivered code the variant appeared, in a few string literals, inside a
compound label that paired a gene name with the variant designation. After
transformation 5 those literals still carried the gene name in front of the
placeholder. In the second pass the gene name was removed, so that the literal
reads `VARIANT` alone: 4 occurrences in the genotype filter lists of
`surfacemarkers.R` (lines 54, 92, 209 and 247, the lists that keep the
variant as a separate level) and 1 in `pipeline_2021-03.R` (the name of the
second input file at line 145, now `data/FCA PLT aggregationTNVARIANT.txt`).
Object and file-name tokens such as `TNMPL.VARIANT`, in which the gene name
is part of the identifier, were not touched. These five edits add no
occurrence of the `VARIANT` token, which is why the column of transformation
5 did not change.

### 7. One genotype category renamed CALR Type_Other

One category of the genotype filter lists of `surfacemarkers.R`, a CALR
subtype whose original spelling is withheld, was renamed
`CALR Type_Other` (8 occurrences, one per filter list, at lines 54, 92, 130,
169, 209, 247, 286 and 325). The category occurs in no other script. The
labels `CALR Type I` and `CALR Type II` of the same lists were kept. A reader
with the private tables has to recode that category, and the variant, to the
placeholders before running the overview block of `surfacemarkers.R` (see
`data/README.md`).

### 8. Provenance header

A 14-line comment header was prepended to every script. It states, in English,
the origin of the code (commissioned analysis of 2021, published with the
written authorization of the principal investigator), the bibliographic
reference of the article, the original file name and its cut-off or date
(withheld for the March pipeline, lines 7-8), the original encoding and line
endings, the list of changes above with a pointer to this log (lines 9-12:
paths, `setwd()`, the two centres, the VARIANT label and the category renamed
`CALR Type_Other`), the statement that no other change was made and that the
code is not executable without the private input data (lines 12-13), and the
SHA-256 of the original (line 13). The header text was rewritten in the
second pass to list the two label substitutions, keeping its fourteen lines.
The header is the only addition to each file; all line numbers quoted in
`docs/limitations.md` and in `data/README.md` are those of the published
file, so the line of the delivered file is the published line minus 14.

## Encoding and line-ending policy

- Encoding. No file was re-encoded. Four originals were pure ASCII and remain
  so. `Agonistas_2021-11-04.R` was UTF-8 without BOM and keeps its single
  non-ASCII character: an accented a in the author's end-of-analysis comment
  at line 1919, stored as the byte pair C3 A1. Editors or R sessions that
  assume Latin-1 or Windows-1252 display it as two garbled characters; this is
  an artefact of the original and was kept as delivered (see
  `docs/limitations.md`). No byte order mark was added. The repository text
  written for this release (README, `data/README.md`, `docs/`) is UTF-8
  without BOM.
- Line endings. Each published script keeps the line endings of its original:
  CRLF in `Agonistas_2021-11-04.R`, `hemogram.R`, `surfacemarkers.R` and
  `pipeline_2021-03.R`, LF in `Agonistas_2021-11-09.R` (verified by counting
  carriage-return bytes in the published files: 2,206, 1,788, 1,558 and 167
  against zero). The prepended header follows the line endings of the file it
  was added to. The repository text written for this release (README,
  `data/README.md`, `docs/`) uses LF. Git is configured not to convert line
  endings (`core.autocrlf = false`), so the bytes committed are the bytes in
  the working tree.
- Characters. The published scripts contain no em dash, no en dash and no
  emoji. The original Spanish comments were left untouched, including their
  typos and missing accents.

## Verification performed

1. Syntax. Each cleaned file was parsed with R (`parse()`), which succeeded
   for the five scripts. Parsing checks syntax only: as documented in
   `docs/limitations.md`, two of the scripts stop at runtime on undefined
   objects, and none can run without the private tables. No script was
   executed for this release.
2. Reverse substitution. For each cleaned file the header was removed, the
   placeholders (`CENTRE_A`, `CENTRE_B`, `VARIANT`, the reduced compound
   label and `CALR Type_Other`) were substituted back by the original
   strings, the read paths and the `setwd()` line were restored with their
   original arguments (known to a reader holding the delivered file),
   removing the trailing note added at cleaning, and the result was compared
   line by line with the original (ignoring the line-ending difference). The
   only lines that differ before that restoration are those where a path was
   replaced, a `setwd()` call was disabled or a label was substituted (the
   read calls listed in transformation 1, the `setwd()` line of each 2021-11
   script and the lines listed in transformations 3 to 7). Every other line
   is byte for byte identical to the delivered code.
3. Residual search. A case-sensitive search for the three original tokens,
   the original compound label and the original category name over the five
   cleaned files returns no hit (residuals 0 in every file). The search was
   extended to e-mail addresses, phone numbers, account aliases, sample and
   subject identifiers, data values, birth years, absolute paths and the real
   names of the centres, with no hit in the code. The four disabled `setwd()`
   comments carry only the placeholder `data`.
4. Non-ASCII audit. A byte-level scan confirms one non-ASCII line in
   `Agonistas_2021-11-04.R` (line 1919) and none in the other four files.
5. Line-number mapping. Every original line number quoted in the private
   review of the code was checked against the published files and matches the
   published line minus 14, which confirms that the header is the only
   insertion and that no line was added or removed elsewhere.

## What was deliberately not changed

- No defect was fixed, no deprecated ggplot2 argument was updated, no unused
  `library()` call was removed and no duplicate block was collapsed. The
  scripts must stay identical to the code that produced the results of the
  study.
- Spanish comments, labels and titles were kept, including typos.
- Object names that encode the data variants (`tratadosnotratados`,
  `TNCONMPL`, `MPLCONTN`, `MPLSTN`, `PTRESGRUPOS`) were kept, since they
  document the analysis and contain no private information.
- The genotype labels named in the article (MPL, CALR, TN, CNTRL, JAK2 V617F,
  MPL W515, CALR Type I, CALR Type II) were kept; the only label changes are
  the variant placeholder (transformations 5 and 6) and the CALR category of
  transformation 7.

## Release information

- Version v0.1.0, released 2026-10-06: legacy scripts as delivered and
  cleaned, with documentation.
- Licence MIT, 2021-2026.
- Roadmap v1.0: refactored functions, exported figures and tables, synthetic
  example data with the schema described in `data/README.md`.
