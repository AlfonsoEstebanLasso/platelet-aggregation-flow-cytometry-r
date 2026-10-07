# From the 2021 code blocks to the v1.0 calls

This document maps every `aov()` fit of the three 2021-11 legacy scripts
(`legacy/Agonistas_2021-11-09.R`, `legacy/hemogram.R` and
`legacy/surfacemarkers.R`) to the v1.0 call that reproduces it, and lists
the methodological differences between the delivered analysis and v1.0. It
is the companion of `docs/limitations.md` (which lists the defects) and of
`docs/v1_spec.md` (which fixes what v1.0 implements): the counts of fits,
valid fits and broken slots stated there can be checked row by row against
the tables below.

Two statements frame the whole document.

- The mapping is between code blocks and calls, not between numbers. No
  numerical result of 2021 is reproduced in this repository, because the
  study data are not distributed; the committed example outputs under
  `outputs/example/` are produced from the synthetic tables of
  `data/synthetic/`, which carry no biological meaning. A reader holding the
  private tables can run the v1.0 call of a row on them and compare the
  result with the 2021 block, keeping in mind the differences of the closing
  section (type II sums of squares in particular).
- The scope of v1.0 is the first centre only (`CENTRE_A`) with the
  2021-11-09 data cut-off, that is, slots 5 to 8 of every measure. The
  cohort-wide variants (slots 1 to 4, including the MPLSTN subdivisions of
  the aggregation family), the 2021-10-27 cut-off (`Agonistas_2021-11-04.R`)
  and the March 2021 pipeline are out of scope and are only recorded here as
  such. The legacy scripts stay untouched.

Line numbers refer to the cleaned files in `legacy/`, which carry a 14-line
provenance header; subtract 14 to obtain the line of the delivered file.

## How to read the tables

One table per script, one row per `aov()` fit of that script (72, 112 and
80 rows). Columns:

| Column | Content |
| --- | --- |
| Measure | The response of the fit, by its R name (the column name after `read.csv2()`), which is also the value of the `measures` argument of `run_panel()`. |
| Slot | Position of the block within the measure, 1 to 8, in the variant order of `legacy/README.md` (see the slot table below). |
| Legacy variant | The object named in the `data` argument of the `aov()` call, as written in the script (so a typo or a wrong object appears here as written). |
| Figure lines | From the `ggplot(` call of the block to its `ggtitle()` line. |
| aov line | The line of the `aov()` call; `summary()` and `TukeyHSD()` follow on the next two lines. |
| Legacy geometry | `box` (`geom_boxplot()`) or `violin` (`geom_violin()`), read from the legacy file. |
| Legacy status | `valid`, `character columns`, `never-read object`, `duplicate fit`, `wrong object` or `cosmetic defect`, as in `docs/limitations.md`. A `cosmetic defect` is a defect in the `aov()` or `summary()` statement that does not change the fit (the two cases of `hemogram.R`); it counts as a valid fit. A defect in a figure title only is recorded in the Note and leaves the status `valid`. |
| Scope | `CENTRE_A` (slots 5 to 8, reproduced by v1.0) or `cohort-wide, out of scope` (slots 1 to 4). |
| v1.0 call | `run_panel("<panel>", variants = "<variant>", measures = "<R name>")` for the `CENTRE_A` slots, `none` otherwise. The call is run from the repository root after sourcing `R/`; `Rscript run_all.R --panel <panel> --variant <variant>` produces the same files for every measure of the panel. `p_holm`, `p_bh` and `family_size` are computed over the measures passed to the call; the corrected values of a single-measure or `--fast` run therefore differ from those of the full panel run under `outputs/example/`, while `p_raw`, the type II table, the Tukey table and the assumption tests are identical. Use the full panel run (or `anova_all.csv`) for the corrected p values. |
| v1.0 outputs | The four files of the measure under `<outdir>/<panel>/<variant>/` (the default `outdir` of `run_panel()` is `outputs`, which git ignores; `run_all.R` writes to `outputs/example` by default): `<slug>_figure.png`, `<slug>_anova.csv`, `<slug>_tukey.csv` and `<slug>_assumptions.csv`, where `<slug>` is the file token of the measure (`docs/v1_spec.md`, section 2). The per-variant cohort overview files and the panel-level tables are listed in the overview section. |
| Note | Defects of the block, `new in v1.0` where the v1.0 fit has no valid 2021 counterpart, and the geometry to pass when the legacy geometry differs from the v1.0 default. |

### Slots and variants

The eight slots of every measure follow the order of the input section of
each script. The v1.0 variant ids are the legacy object suffixes shared by
the three scripts; the recodings are applied in code by `recode_variants()`
from one master table per panel instead of being read from hand-prepared
files. The four v1.0 variant ids (`CENTRE_A`, `CENTRE_Atratadosnotratados`, `CENTRE_AtratadosnotratadosMPLCONTN`, `CENTRE_ATNCONMPL`) reuse the legacy object suffixes verbatim, including the Spanish token `tratadosnotratados`, so that each v1.0 directory and figure title can be matched to its 2021 block; they are identifiers, not prose.

| Slot | Legacy object, aggregation | Legacy object, hemogram and markers | v1.0 variant id | Recoding operations in v1.0 | v1.0 default geometry |
| --- | --- | --- | --- | --- | --- |
| 1 | `FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS` | `<Panel>_ALL_Nov9_2021` | none (out of scope) | | |
| 2 | `FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados` | `<Panel>_ALL_Nov9_2021_tratadosnotratados` | none (out of scope) | | |
| 3 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN` | `<Panel>_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | none (out of scope) | | |
| 4 | `FCA_aggregation_filtered_NA9112021MPLSTN` | `<Panel>_ALL_Nov9_2021MPLSTN` | none (out of scope) | | |
| 5 | `CENTRE_A` | `CENTRE_A` | `CENTRE_A` | centre | box |
| 6 | `CENTRE_Atratadosnotratados` | `CENTRE_Atratadosnotratados` | `CENTRE_Atratadosnotratados` | centre, treatment | violin |
| 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | `CENTRE_AtratadosnotratadosMPLCONTN` | `CENTRE_AtratadosnotratadosMPLCONTN` | centre, treatment, genotype | box |
| 8 | `CENTRE_ATNCONMPL` | `CENTRE_ATNCONMPL` | `CENTRE_ATNCONMPL` | centre, genotype | box |

`<Panel>` stands for `Hemograma` or `SurfaceMarkers`. The operations are:
`centre`, keep the rows whose `Centro.Analisis` equals `CENTRE_A`;
`treatment`, collapse `Treatment` to `Untreated` versus `Treated`;
`genotype`, replace the level `VARIANT` by `TN`. In the aggregation family
slots 3 and 4 are not merges but subdivisions of the genotype labels
(MPLSTN tables), which v1.0 does not implement; in the hemogram and marker
families the MPLSTN suffix names the same merge as MPLCONTN and TNCONMPL
(`data/README.md`). The legacy input files behind each `CENTRE_A` object are
listed in `docs/v1_spec.md`, section 5.

### Cohort overview charts

`Agonistas_2021-11-09.R` and `surfacemarkers.R` open with sixteen stacked
bar charts of counts (two per slot: Gender by Treatment, then Genotype by
Treatment); `hemogram.R` has none. v1.0 writes two overview figures and two
count tables per panel and variant, counting over all observed levels
(missing shown as `(missing)`) instead of filtering on hard-coded label
lists, and printing a count only when the segment has at least 5
observations.

| Script | Slot | Gender chart lines | Genotype chart lines | Scope | v1.0 outputs (`<outdir>/<panel>/<variant>/`) |
| --- | --- | --- | --- | --- | --- |
| `Agonistas_2021-11-09.R` | 1 | 30-48 | 49-67 | cohort-wide, out of scope | none |
| `Agonistas_2021-11-09.R` | 2 | 68-86 | 87-105 | cohort-wide, out of scope | none |
| `Agonistas_2021-11-09.R` | 3 | 106-124 | 125-143 | cohort-wide, out of scope | none |
| `Agonistas_2021-11-09.R` | 4 | 144-162 | 164-182 | cohort-wide, out of scope | none |
| `Agonistas_2021-11-09.R` | 5 | 185-203 | 204-222 | `CENTRE_A` | `aggregation/CENTRE_A/cohort_gender_figure.png`, `cohort_genotype_figure.png`, `cohort_gender_counts.csv`, `cohort_genotype_counts.csv` |
| `Agonistas_2021-11-09.R` | 6 | 223-241 | 242-260 | `CENTRE_A` | `aggregation/CENTRE_Atratadosnotratados/cohort_*` (same four files) |
| `Agonistas_2021-11-09.R` | 7 | 262-280 | 281-299 | `CENTRE_A` | `aggregation/CENTRE_AtratadosnotratadosMPLCONTN/cohort_*` (same four files) |
| `Agonistas_2021-11-09.R` | 8 | 301-319 | 320-338 | `CENTRE_A` | `aggregation/CENTRE_ATNCONMPL/cohort_*` (same four files) |
| `hemogram.R` | 1 to 4 | none | none | cohort-wide, out of scope | none |
| `hemogram.R` | 5 to 8 | none | none | `CENTRE_A` | new in v1.0: `hemogram/<variant>/cohort_*` (same four files per variant) |
| `surfacemarkers.R` | 1 | 33-51 | 52-70 | cohort-wide, out of scope | none |
| `surfacemarkers.R` | 2 | 71-89 | 90-108 | cohort-wide, out of scope | none |
| `surfacemarkers.R` | 3 | 109-127 | 128-146 | cohort-wide, out of scope | none |
| `surfacemarkers.R` | 4 | 147-165 | 167-185 | cohort-wide, out of scope | none |
| `surfacemarkers.R` | 5 | 188-206 | 207-225 | `CENTRE_A` | `markers/CENTRE_A/cohort_*` (same four files) |
| `surfacemarkers.R` | 6 | 226-244 | 245-263 | `CENTRE_A` | `markers/CENTRE_Atratadosnotratados/cohort_*` (same four files) |
| `surfacemarkers.R` | 7 | 265-283 | 284-302 | `CENTRE_A` | `markers/CENTRE_AtratadosnotratadosMPLCONTN/cohort_*` (same four files) |
| `surfacemarkers.R` | 8 | 304-322 | 323-341 | `CENTRE_A` | `markers/CENTRE_ATNCONMPL/cohort_*` (same four files) |

In addition, every v1.0 run of a panel writes the panel-level tables
`anova_all.csv`, `tukey_all.csv`, `assumptions_all.csv`, `cells_all.csv`
and `run_log.csv` and a `sessionInfo.txt` under `<outdir>/<panel>/`, which
have no 2021 counterpart (the delivered scripts wrote nothing to disk).

## Agonistas_2021-11-09.R

Nine aggregation measures, eight slots each, model `measure ~ Genotype * Treatment`. Slots 1 to 4 are the cohort-wide variants (slots 3 and 4 on the MPLSTN tables imported as text); slots 5 to 8 are the four `CENTRE_A` variants reproduced by v1.0 (panel `aggregation`). The legacy geometry alternates differently from one measure to the next; the v1.0 default per variant is box, violin, box, box.

| Measure | Slot | Legacy variant | Figure lines | aov line | Legacy geometry | Legacy status | Scope | v1.0 call | v1.0 outputs | Note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `PMA` | 1 | `FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS` | 345-353 | 355 | box | valid | cohort-wide, out of scope | none | none |  |
| `PMA` | 2 | `FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados` | 360-368 | 371 | violin | valid | cohort-wide, out of scope | none | none |  |
| `PMA` | 3 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTNs` | 376-384 | 386 | violin | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text; typo `MPLSTNs` in the `data` argument: object not found, first hard stop of a sequential run |
| `PMA` | 4 | `FCA_aggregation_filtered_NA9112021MPLSTN` | 391-399 | 401 | box | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `PMA` | 5 | `CENTRE_A` | 406-414 | 416 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_A", measures = "PMA")` | `aggregation/CENTRE_A/PMA_figure.png`, `PMA_anova.csv`, `PMA_tukey.csv`, `PMA_assumptions.csv` |  |
| `PMA` | 6 | `CENTRE_Atratadosnotratados` | 421-429 | 431 | violin | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_Atratadosnotratados", measures = "PMA")` | `aggregation/CENTRE_Atratadosnotratados/PMA_figure.png`, `PMA_anova.csv`, `PMA_tukey.csv`, `PMA_assumptions.csv` |  |
| `PMA` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 436-444 | 446 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "PMA")` | `aggregation/CENTRE_AtratadosnotratadosMPLCONTN/PMA_figure.png`, `PMA_anova.csv`, `PMA_tukey.csv`, `PMA_assumptions.csv` |  |
| `PMA` | 8 | `CENTRE_ATNCONMPL` | 451-459 | 461 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_ATNCONMPL", measures = "PMA")` | `aggregation/CENTRE_ATNCONMPL/PMA_figure.png`, `PMA_anova.csv`, `PMA_tukey.csv`, `PMA_assumptions.csv` |  |
| `CVX` | 1 | `FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS` | 469-477 | 479 | box | valid | cohort-wide, out of scope | none | none |  |
| `CVX` | 2 | `FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados` | 484-492 | 494 | violin | valid | cohort-wide, out of scope | none | none |  |
| `CVX` | 3 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN` | 498-506 | 508 | violin | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `CVX` | 4 | `FCA_aggregation_filtered_NA9112021MPLSTN` | 513-521 | 523 | box | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `CVX` | 5 | `CENTRE_A` | 528-536 | 538 | violin | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_A", measures = "CVX")` | `aggregation/CENTRE_A/CVX_figure.png`, `CVX_anova.csv`, `CVX_tukey.csv`, `CVX_assumptions.csv` | legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `CVX` | 6 | `CENTRE_Atratadosnotratados` | 544-552 | 554 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_Atratadosnotratados", measures = "CVX")` | `aggregation/CENTRE_Atratadosnotratados/CVX_figure.png`, `CVX_anova.csv`, `CVX_tukey.csv`, `CVX_assumptions.csv` | legacy geometry box, v1.0 default violin (pass `geom = "box"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `CVX` | 7 | `CENTRE_ATNCONMPL` | 560-568 | 570 | violin | duplicate fit | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "CVX")` | `aggregation/CENTRE_AtratadosnotratadosMPLCONTN/CVX_figure.png`, `CVX_anova.csv`, `CVX_tukey.csv`, `CVX_assumptions.csv` | new in v1.0: no valid 2021 counterpart for this measure and variant; figure drawn on `CENTRE_AtratadosnotratadosMPLCONTN`, model fitted on `CENTRE_ATNCONMPL`: duplicate of the fit at 584; legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `CVX` | 8 | `CENTRE_ATNCONMPL` | 574-582 | 584 | violin | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_ATNCONMPL", measures = "CVX")` | `aggregation/CENTRE_ATNCONMPL/CVX_figure.png`, `CVX_anova.csv`, `CVX_tukey.csv`, `CVX_assumptions.csv` | legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `RISTO` | 1 | `FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS` | 596-604 | 606 | box | valid | cohort-wide, out of scope | none | none |  |
| `RISTO` | 2 | `FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados` | 611-619 | 621 | violin | valid | cohort-wide, out of scope | none | none |  |
| `RISTO` | 3 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN` | 626-634 | 636 | violin | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `RISTO` | 4 | `FCA_aggregation_filtered_NA9112021MPLSTN` | 640-648 | 650 | box | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `RISTO` | 5 | `CENTRE_A` | 657-665 | 667 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_A", measures = "RISTO")` | `aggregation/CENTRE_A/RISTO_figure.png`, `RISTO_anova.csv`, `RISTO_tukey.csv`, `RISTO_assumptions.csv` |  |
| `RISTO` | 6 | `CENTRE_Atratadosnotratados` | 672-680 | 682 | violin | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_Atratadosnotratados", measures = "RISTO")` | `aggregation/CENTRE_Atratadosnotratados/RISTO_figure.png`, `RISTO_anova.csv`, `RISTO_tukey.csv`, `RISTO_assumptions.csv` |  |
| `RISTO` | 7 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL` | 687-695 | 697 | violin | never-read object | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "RISTO")` | `aggregation/CENTRE_AtratadosnotratadosMPLCONTN/RISTO_figure.png`, `RISTO_anova.csv`, `RISTO_tukey.csv`, `RISTO_assumptions.csv` | new in v1.0: no valid 2021 counterpart for this measure and variant; the object is never created (no read statement); figure and fit cannot run; legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `RISTO` | 8 | `CENTRE_ATNCONMPL` | 702-710 | 712 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_ATNCONMPL", measures = "RISTO")` | `aggregation/CENTRE_ATNCONMPL/RISTO_figure.png`, `RISTO_anova.csv`, `RISTO_tukey.csv`, `RISTO_assumptions.csv` |  |
| `AGGA` | 1 | `FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS` | 721-729 | 731 | box | valid | cohort-wide, out of scope | none | none |  |
| `AGGA` | 2 | `FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados` | 736-744 | 746 | violin | valid | cohort-wide, out of scope | none | none |  |
| `AGGA` | 3 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN` | 751-759 | 761 | violin | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `AGGA` | 4 | `FCA_aggregation_filtered_NA9112021MPLSTN` | 766-774 | 776 | box | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `AGGA` | 5 | `CENTRE_A` | 781-789 | 791 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_A", measures = "AGGA")` | `aggregation/CENTRE_A/AGGA_figure.png`, `AGGA_anova.csv`, `AGGA_tukey.csv`, `AGGA_assumptions.csv` |  |
| `AGGA` | 6 | `CENTRE_Atratadosnotratados` | 796-804 | 806 | violin | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_Atratadosnotratados", measures = "AGGA")` | `aggregation/CENTRE_Atratadosnotratados/AGGA_figure.png`, `AGGA_anova.csv`, `AGGA_tukey.csv`, `AGGA_assumptions.csv` |  |
| `AGGA` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 811-819 | 821 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "AGGA")` | `aggregation/CENTRE_AtratadosnotratadosMPLCONTN/AGGA_figure.png`, `AGGA_anova.csv`, `AGGA_tukey.csv`, `AGGA_assumptions.csv` | figure title reads `AGGA CENTRE_A TNCONMPL` (same as slot 8) although the figure is drawn on the MPLCONTN variant |
| `AGGA` | 8 | `CENTRE_ATNCONMPL` | 826-834 | 836 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_ATNCONMPL", measures = "AGGA")` | `aggregation/CENTRE_ATNCONMPL/AGGA_figure.png`, `AGGA_anova.csv`, `AGGA_tukey.csv`, `AGGA_assumptions.csv` |  |
| `COL` | 1 | `FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS` | 846-854 | 856 | box | valid | cohort-wide, out of scope | none | none |  |
| `COL` | 2 | `FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados` | 861-869 | 871 | violin | valid | cohort-wide, out of scope | none | none |  |
| `COL` | 3 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN` | 876-884 | 886 | violin | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `COL` | 4 | `FCA_aggregation_filtered_NA9112021MPLSTN` | 891-899 | 901 | violin | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `COL` | 5 | `CENTRE_A` | 907-915 | 917 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_A", measures = "COL")` | `aggregation/CENTRE_A/COL_figure.png`, `COL_anova.csv`, `COL_tukey.csv`, `COL_assumptions.csv` |  |
| `COL` | 6 | `CENTRE_Atratadosnotratados` | 922-930 | 932 | violin | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_Atratadosnotratados", measures = "COL")` | `aggregation/CENTRE_Atratadosnotratados/COL_figure.png`, `COL_anova.csv`, `COL_tukey.csv`, `COL_assumptions.csv` |  |
| `COL` | 7 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL` | 937-945 | 947 | violin | never-read object | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "COL")` | `aggregation/CENTRE_AtratadosnotratadosMPLCONTN/COL_figure.png`, `COL_anova.csv`, `COL_tukey.csv`, `COL_assumptions.csv` | new in v1.0: no valid 2021 counterpart for this measure and variant; the object is never created (no read statement); figure and fit cannot run; legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `COL` | 8 | `CENTRE_ATNCONMPL` | 952-960 | 962 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_ATNCONMPL", measures = "COL")` | `aggregation/CENTRE_ATNCONMPL/COL_figure.png`, `COL_anova.csv`, `COL_tukey.csv`, `COL_assumptions.csv` |  |
| `TRAP` | 1 | `FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS` | 971-979 | 981 | box | valid | cohort-wide, out of scope | none | none | TRAP measured at `CENTRE_A` only; `aov()` drops the empty `CENTRE_B` rows silently |
| `TRAP` | 2 | `FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados` | 986-994 | 996 | violin | valid | cohort-wide, out of scope | none | none | TRAP measured at `CENTRE_A` only; `aov()` drops the empty `CENTRE_B` rows silently |
| `TRAP` | 3 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN` | 1000-1008 | 1010 | violin | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text; TRAP measured at `CENTRE_A` only; `aov()` drops the empty `CENTRE_B` rows silently |
| `TRAP` | 4 | `FCA_aggregation_filtered_NA9112021MPLSTN` | 1014-1022 | 1024 | box | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text; TRAP measured at `CENTRE_A` only; `aov()` drops the empty `CENTRE_B` rows silently |
| `TRAP` | 5 | `CENTRE_A` | 1029-1037 | 1039 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_A", measures = "TRAP")` | `aggregation/CENTRE_A/TRAP_figure.png`, `TRAP_anova.csv`, `TRAP_tukey.csv`, `TRAP_assumptions.csv` |  |
| `TRAP` | 6 | `CENTRE_Atratadosnotratados` | 1044-1052 | 1054 | violin | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_Atratadosnotratados", measures = "TRAP")` | `aggregation/CENTRE_Atratadosnotratados/TRAP_figure.png`, `TRAP_anova.csv`, `TRAP_tukey.csv`, `TRAP_assumptions.csv` |  |
| `TRAP` | 7 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL` | 1058-1066 | 1068 | violin | never-read object | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "TRAP")` | `aggregation/CENTRE_AtratadosnotratadosMPLCONTN/TRAP_figure.png`, `TRAP_anova.csv`, `TRAP_tukey.csv`, `TRAP_assumptions.csv` | new in v1.0: no valid 2021 counterpart for this measure and variant; the object is never created (no read statement); figure and fit cannot run; legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `TRAP` | 8 | `CENTRE_ATNCONMPL` | 1072-1080 | 1082 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_ATNCONMPL", measures = "TRAP")` | `aggregation/CENTRE_ATNCONMPL/TRAP_figure.png`, `TRAP_anova.csv`, `TRAP_tukey.csv`, `TRAP_assumptions.csv` |  |
| `UNSTIMULATED.10min` | 1 | `FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS` | 1093-1101 | 1103 | box | valid | cohort-wide, out of scope | none | none |  |
| `UNSTIMULATED.10min` | 2 | `FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados` | 1108-1116 | 1118 | violin | valid | cohort-wide, out of scope | none | none |  |
| `UNSTIMULATED.10min` | 3 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN` | 1123-1131 | 1133 | violin | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `UNSTIMULATED.10min` | 4 | `FCA_aggregation_filtered_NA9112021MPLSTN` | 1138-1146 | 1148 | box | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `UNSTIMULATED.10min` | 5 | `CENTRE_A` | 1157-1165 | 1167 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_A", measures = "UNSTIMULATED.10min")` | `aggregation/CENTRE_A/UNSTIMULATED_10min_figure.png`, `UNSTIMULATED_10min_anova.csv`, `UNSTIMULATED_10min_tukey.csv`, `UNSTIMULATED_10min_assumptions.csv` |  |
| `UNSTIMULATED.10min` | 6 | `CENTRE_Atratadosnotratados` | 1172-1180 | 1182 | violin | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_Atratadosnotratados", measures = "UNSTIMULATED.10min")` | `aggregation/CENTRE_Atratadosnotratados/UNSTIMULATED_10min_figure.png`, `UNSTIMULATED_10min_anova.csv`, `UNSTIMULATED_10min_tukey.csv`, `UNSTIMULATED_10min_assumptions.csv` |  |
| `UNSTIMULATED.10min` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 1188-1196 | 1198 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "UNSTIMULATED.10min")` | `aggregation/CENTRE_AtratadosnotratadosMPLCONTN/UNSTIMULATED_10min_figure.png`, `UNSTIMULATED_10min_anova.csv`, `UNSTIMULATED_10min_tukey.csv`, `UNSTIMULATED_10min_assumptions.csv` |  |
| `UNSTIMULATED.10min` | 8 | `CENTRE_ATNCONMPL` | 1204-1212 | 1214 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_ATNCONMPL", measures = "UNSTIMULATED.10min")` | `aggregation/CENTRE_ATNCONMPL/UNSTIMULATED_10min_figure.png`, `UNSTIMULATED_10min_anova.csv`, `UNSTIMULATED_10min_tukey.csv`, `UNSTIMULATED_10min_assumptions.csv` |  |
| `Time.0min` | 1 | `FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS` | 1227-1235 | 1237 | box | valid | cohort-wide, out of scope | none | none |  |
| `Time.0min` | 2 | `FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados` | 1242-1250 | 1252 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Time.0min` | 3 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN` | 1256-1264 | 1266 | violin | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `Time.0min` | 4 | `FCA_aggregation_filtered_NA9112021MPLSTN` | 1271-1279 | 1281 | box | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `Time.0min` | 5 | `CENTRE_A` | 1287-1295 | 1297 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_A", measures = "Time.0min")` | `aggregation/CENTRE_A/Time_0min_figure.png`, `Time_0min_anova.csv`, `Time_0min_tukey.csv`, `Time_0min_assumptions.csv` |  |
| `Time.0min` | 6 | `CENTRE_Atratadosnotratados` | 1302-1310 | 1312 | violin | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_Atratadosnotratados", measures = "Time.0min")` | `aggregation/CENTRE_Atratadosnotratados/Time_0min_figure.png`, `Time_0min_anova.csv`, `Time_0min_tukey.csv`, `Time_0min_assumptions.csv` |  |
| `Time.0min` | 7 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL` | 1317-1325 | 1327 | violin | never-read object | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "Time.0min")` | `aggregation/CENTRE_AtratadosnotratadosMPLCONTN/Time_0min_figure.png`, `Time_0min_anova.csv`, `Time_0min_tukey.csv`, `Time_0min_assumptions.csv` | new in v1.0: no valid 2021 counterpart for this measure and variant; the object is never created (no read statement); figure and fit cannot run; legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `Time.0min` | 8 | `CENTRE_ATNCONMPL` | 1332-1340 | 1342 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_ATNCONMPL", measures = "Time.0min")` | `aggregation/CENTRE_ATNCONMPL/Time_0min_figure.png`, `Time_0min_anova.csv`, `Time_0min_tukey.csv`, `Time_0min_assumptions.csv` |  |
| `UNS.Time.10min.vs.Time.0` | 1 | `FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS` | 1352-1360 | 1362 | box | valid | cohort-wide, out of scope | none | none |  |
| `UNS.Time.10min.vs.Time.0` | 2 | `FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados` | 1367-1375 | 1377 | violin | valid | cohort-wide, out of scope | none | none |  |
| `UNS.Time.10min.vs.Time.0` | 3 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN` | 1382-1390 | 1392 | violin | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `UNS.Time.10min.vs.Time.0` | 4 | `FCA_aggregation_filtered_NA9112021MPLSTN` | 1397-1405 | 1407 | violin | character columns | cohort-wide, out of scope | none | none | input read with `read.csv(sep = ";")` without `dec = ","`, measurement columns imported as text |
| `UNS.Time.10min.vs.Time.0` | 5 | `CENTRE_A` | 1415-1423 | 1425 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_A", measures = "UNS.Time.10min.vs.Time.0")` | `aggregation/CENTRE_A/UNS_ratio_figure.png`, `UNS_ratio_anova.csv`, `UNS_ratio_tukey.csv`, `UNS_ratio_assumptions.csv` |  |
| `UNS.Time.10min.vs.Time.0` | 6 | `CENTRE_Atratadosnotratados` | 1430-1438 | 1440 | violin | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_Atratadosnotratados", measures = "UNS.Time.10min.vs.Time.0")` | `aggregation/CENTRE_Atratadosnotratados/UNS_ratio_figure.png`, `UNS_ratio_anova.csv`, `UNS_ratio_tukey.csv`, `UNS_ratio_assumptions.csv` |  |
| `UNS.Time.10min.vs.Time.0` | 7 | `FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL` | 1445-1453 | 1455 | violin | never-read object | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "UNS.Time.10min.vs.Time.0")` | `aggregation/CENTRE_AtratadosnotratadosMPLCONTN/UNS_ratio_figure.png`, `UNS_ratio_anova.csv`, `UNS_ratio_tukey.csv`, `UNS_ratio_assumptions.csv` | new in v1.0: no valid 2021 counterpart for this measure and variant; the object is never created (no read statement); figure and fit cannot run; legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `UNS.Time.10min.vs.Time.0` | 8 | `CENTRE_ATNCONMPL` | 1460-1468 | 1470 | box | valid | CENTRE_A | `run_panel("aggregation", variants = "CENTRE_ATNCONMPL", measures = "UNS.Time.10min.vs.Time.0")` | `aggregation/CENTRE_ATNCONMPL/UNS_ratio_figure.png`, `UNS_ratio_anova.csv`, `UNS_ratio_tukey.csv`, `UNS_ratio_assumptions.csv` |  |

## hemogram.R

Fourteen hemogram and hormone variables, eight slots each, model `measure ~ Genotype`. Slots 1 to 4 are the cohort-wide tables; slots 5 to 8 are the four `CENTRE_A` tables reproduced by v1.0 (panel `hemogram`). The legacy geometry is box, violin, violin, box, box, violin, box, box for every variable, so the four `CENTRE_A` slots coincide with the v1.0 default.

| Measure | Slot | Legacy variant | Figure lines | aov line | Legacy geometry | Legacy status | Scope | v1.0 call | v1.0 outputs | Note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `EPO..mlU.ml.` | 1 | `Hemograma_ALL_Nov9_2021` | 34-42 | 44 | box | valid | cohort-wide, out of scope | none | none |  |
| `EPO..mlU.ml.` | 2 | `Hemograma_ALL_Nov9_2021_tratadosnotratados` | 49-57 | 60 | violin | valid | cohort-wide, out of scope | none | none |  |
| `EPO..mlU.ml.` | 3 | `Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 65-73 | 75 | violin | valid | cohort-wide, out of scope | none | none |  |
| `EPO..mlU.ml.` | 4 | `Hemograma_ALL_Nov9_2021MPLSTN` | 80-88 | 90 | box | valid | cohort-wide, out of scope | none | none |  |
| `EPO..mlU.ml.` | 5 | `CENTRE_A` | 95-103 | 105 | box | cosmetic defect | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_A", measures = "EPO..mlU.ml.")` | `hemogram/CENTRE_A/EPO_figure.png`, `EPO_anova.csv`, `EPO_tukey.csv`, `EPO_assumptions.csv` | formula `EPO..mlU.ml. ~ Genotype * Genotype`; R drops the self-interaction, so the fit equals the one-way fit |
| `EPO..mlU.ml.` | 6 | `CENTRE_Atratadosnotratados` | 110-118 | 120 | violin | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_Atratadosnotratados", measures = "EPO..mlU.ml.")` | `hemogram/CENTRE_Atratadosnotratados/EPO_figure.png`, `EPO_anova.csv`, `EPO_tukey.csv`, `EPO_assumptions.csv` |  |
| `EPO..mlU.ml.` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 125-133 | 135 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "EPO..mlU.ml.")` | `hemogram/CENTRE_AtratadosnotratadosMPLCONTN/EPO_figure.png`, `EPO_anova.csv`, `EPO_tukey.csv`, `EPO_assumptions.csv` |  |
| `EPO..mlU.ml.` | 8 | `CENTRE_ATNCONMPL` | 140-148 | 150 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_ATNCONMPL", measures = "EPO..mlU.ml.")` | `hemogram/CENTRE_ATNCONMPL/EPO_figure.png`, `EPO_anova.csv`, `EPO_tukey.csv`, `EPO_assumptions.csv` |  |
| `TPO..pg.ml.` | 1 | `Hemograma_ALL_Nov9_2021` | 159-167 | 169 | box | valid | cohort-wide, out of scope | none | none |  |
| `TPO..pg.ml.` | 2 | `Hemograma_ALL_Nov9_2021_tratadosnotratados` | 174-182 | 185 | violin | valid | cohort-wide, out of scope | none | none |  |
| `TPO..pg.ml.` | 3 | `Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 190-198 | 200 | violin | valid | cohort-wide, out of scope | none | none |  |
| `TPO..pg.ml.` | 4 | `Hemograma_ALL_Nov9_2021MPLSTN` | 205-213 | 215 | box | valid | cohort-wide, out of scope | none | none |  |
| `TPO..pg.ml.` | 5 | `CENTRE_A` | 220-228 | 230 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_A", measures = "TPO..pg.ml.")` | `hemogram/CENTRE_A/TPO_figure.png`, `TPO_anova.csv`, `TPO_tukey.csv`, `TPO_assumptions.csv` |  |
| `TPO..pg.ml.` | 6 | `CENTRE_Atratadosnotratados` | 235-243 | 245 | violin | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_Atratadosnotratados", measures = "TPO..pg.ml.")` | `hemogram/CENTRE_Atratadosnotratados/TPO_figure.png`, `TPO_anova.csv`, `TPO_tukey.csv`, `TPO_assumptions.csv` |  |
| `TPO..pg.ml.` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 250-258 | 260 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "TPO..pg.ml.")` | `hemogram/CENTRE_AtratadosnotratadosMPLCONTN/TPO_figure.png`, `TPO_anova.csv`, `TPO_tukey.csv`, `TPO_assumptions.csv` |  |
| `TPO..pg.ml.` | 8 | `CENTRE_ATNCONMPL` | 265-273 | 275 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_ATNCONMPL", measures = "TPO..pg.ml.")` | `hemogram/CENTRE_ATNCONMPL/TPO_figure.png`, `TPO_anova.csv`, `TPO_tukey.csv`, `TPO_assumptions.csv` |  |
| `HGB.gr.dl.` | 1 | `Hemograma_ALL_Nov9_2021` | 284-292 | 294 | box | valid | cohort-wide, out of scope | none | none |  |
| `HGB.gr.dl.` | 2 | `Hemograma_ALL_Nov9_2021_tratadosnotratados` | 299-307 | 310 | violin | valid | cohort-wide, out of scope | none | none |  |
| `HGB.gr.dl.` | 3 | `Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 315-323 | 325 | violin | valid | cohort-wide, out of scope | none | none |  |
| `HGB.gr.dl.` | 4 | `Hemograma_ALL_Nov9_2021MPLSTN` | 330-338 | 340 | box | valid | cohort-wide, out of scope | none | none |  |
| `HGB.gr.dl.` | 5 | `CENTRE_A` | 345-353 | 355 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_A", measures = "HGB.gr.dl.")` | `hemogram/CENTRE_A/HGB_figure.png`, `HGB_anova.csv`, `HGB_tukey.csv`, `HGB_assumptions.csv` |  |
| `HGB.gr.dl.` | 6 | `CENTRE_Atratadosnotratados` | 360-368 | 370 | violin | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_Atratadosnotratados", measures = "HGB.gr.dl.")` | `hemogram/CENTRE_Atratadosnotratados/HGB_figure.png`, `HGB_anova.csv`, `HGB_tukey.csv`, `HGB_assumptions.csv` |  |
| `HGB.gr.dl.` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 375-383 | 385 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "HGB.gr.dl.")` | `hemogram/CENTRE_AtratadosnotratadosMPLCONTN/HGB_figure.png`, `HGB_anova.csv`, `HGB_tukey.csv`, `HGB_assumptions.csv` |  |
| `HGB.gr.dl.` | 8 | `CENTRE_ATNCONMPL` | 390-398 | 400 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_ATNCONMPL", measures = "HGB.gr.dl.")` | `hemogram/CENTRE_ATNCONMPL/HGB_figure.png`, `HGB_anova.csv`, `HGB_tukey.csv`, `HGB_assumptions.csv` |  |
| `HCT....` | 1 | `Hemograma_ALL_Nov9_2021` | 410-418 | 420 | box | valid | cohort-wide, out of scope | none | none |  |
| `HCT....` | 2 | `Hemograma_ALL_Nov9_2021_tratadosnotratados` | 425-433 | 436 | violin | valid | cohort-wide, out of scope | none | none |  |
| `HCT....` | 3 | `Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 441-449 | 451 | violin | valid | cohort-wide, out of scope | none | none |  |
| `HCT....` | 4 | `Hemograma_ALL_Nov9_2021MPLSTN` | 456-464 | 466 | box | valid | cohort-wide, out of scope | none | none |  |
| `HCT....` | 5 | `CENTRE_A` | 471-479 | 481 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_A", measures = "HCT....")` | `hemogram/CENTRE_A/HCT_figure.png`, `HCT_anova.csv`, `HCT_tukey.csv`, `HCT_assumptions.csv` |  |
| `HCT....` | 6 | `CENTRE_Atratadosnotratados` | 486-494 | 496 | violin | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_Atratadosnotratados", measures = "HCT....")` | `hemogram/CENTRE_Atratadosnotratados/HCT_figure.png`, `HCT_anova.csv`, `HCT_tukey.csv`, `HCT_assumptions.csv` |  |
| `HCT....` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 501-509 | 511 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "HCT....")` | `hemogram/CENTRE_AtratadosnotratadosMPLCONTN/HCT_figure.png`, `HCT_anova.csv`, `HCT_tukey.csv`, `HCT_assumptions.csv` |  |
| `HCT....` | 8 | `CENTRE_ATNCONMPL` | 516-524 | 526 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_ATNCONMPL", measures = "HCT....")` | `hemogram/CENTRE_ATNCONMPL/HCT_figure.png`, `HCT_anova.csv`, `HCT_tukey.csv`, `HCT_assumptions.csv` |  |
| `MCH..pg.` | 1 | `Hemograma_ALL_Nov9_2021` | 536-544 | 546 | box | valid | cohort-wide, out of scope | none | none |  |
| `MCH..pg.` | 2 | `Hemograma_ALL_Nov9_2021_tratadosnotratados` | 551-559 | 562 | violin | valid | cohort-wide, out of scope | none | none |  |
| `MCH..pg.` | 3 | `Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 567-575 | 577 | violin | valid | cohort-wide, out of scope | none | none |  |
| `MCH..pg.` | 4 | `Hemograma_ALL_Nov9_2021MPLSTN` | 582-590 | 592 | box | valid | cohort-wide, out of scope | none | none |  |
| `MCH..pg.` | 5 | `CENTRE_A` | 597-605 | 607 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_A", measures = "MCH..pg.")` | `hemogram/CENTRE_A/MCH_figure.png`, `MCH_anova.csv`, `MCH_tukey.csv`, `MCH_assumptions.csv` |  |
| `MCH..pg.` | 6 | `CENTRE_Atratadosnotratados` | 612-620 | 622 | violin | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_Atratadosnotratados", measures = "MCH..pg.")` | `hemogram/CENTRE_Atratadosnotratados/MCH_figure.png`, `MCH_anova.csv`, `MCH_tukey.csv`, `MCH_assumptions.csv` |  |
| `MCH..pg.` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 627-635 | 637 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "MCH..pg.")` | `hemogram/CENTRE_AtratadosnotratadosMPLCONTN/MCH_figure.png`, `MCH_anova.csv`, `MCH_tukey.csv`, `MCH_assumptions.csv` |  |
| `MCH..pg.` | 8 | `CENTRE_ATNCONMPL` | 642-650 | 652 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_ATNCONMPL", measures = "MCH..pg.")` | `hemogram/CENTRE_ATNCONMPL/MCH_figure.png`, `MCH_anova.csv`, `MCH_tukey.csv`, `MCH_assumptions.csv` |  |
| `MCHC..gr.dl.` | 1 | `Hemograma_ALL_Nov9_2021` | 662-670 | 672 | box | valid | cohort-wide, out of scope | none | none |  |
| `MCHC..gr.dl.` | 2 | `Hemograma_ALL_Nov9_2021_tratadosnotratados` | 677-685 | 688 | violin | valid | cohort-wide, out of scope | none | none |  |
| `MCHC..gr.dl.` | 3 | `Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 693-701 | 703 | violin | valid | cohort-wide, out of scope | none | none |  |
| `MCHC..gr.dl.` | 4 | `Hemograma_ALL_Nov9_2021MPLSTN` | 708-716 | 718 | box | valid | cohort-wide, out of scope | none | none |  |
| `MCHC..gr.dl.` | 5 | `CENTRE_A` | 723-731 | 733 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_A", measures = "MCHC..gr.dl.")` | `hemogram/CENTRE_A/MCHC_figure.png`, `MCHC_anova.csv`, `MCHC_tukey.csv`, `MCHC_assumptions.csv` |  |
| `MCHC..gr.dl.` | 6 | `CENTRE_Atratadosnotratados` | 738-746 | 748 | violin | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_Atratadosnotratados", measures = "MCHC..gr.dl.")` | `hemogram/CENTRE_Atratadosnotratados/MCHC_figure.png`, `MCHC_anova.csv`, `MCHC_tukey.csv`, `MCHC_assumptions.csv` |  |
| `MCHC..gr.dl.` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 753-761 | 763 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "MCHC..gr.dl.")` | `hemogram/CENTRE_AtratadosnotratadosMPLCONTN/MCHC_figure.png`, `MCHC_anova.csv`, `MCHC_tukey.csv`, `MCHC_assumptions.csv` |  |
| `MCHC..gr.dl.` | 8 | `CENTRE_ATNCONMPL` | 768-776 | 778 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_ATNCONMPL", measures = "MCHC..gr.dl.")` | `hemogram/CENTRE_ATNCONMPL/MCHC_figure.png`, `MCHC_anova.csv`, `MCHC_tukey.csv`, `MCHC_assumptions.csv` |  |
| `Lymph.` | 1 | `Hemograma_ALL_Nov9_2021` | 788-796 | 798 | box | valid | cohort-wide, out of scope | none | none |  |
| `Lymph.` | 2 | `Hemograma_ALL_Nov9_2021_tratadosnotratados` | 803-811 | 814 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Lymph.` | 3 | `Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 819-827 | 829 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Lymph.` | 4 | `Hemograma_ALL_Nov9_2021MPLSTN` | 834-842 | 844 | box | valid | cohort-wide, out of scope | none | none |  |
| `Lymph.` | 5 | `CENTRE_A` | 849-857 | 859 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_A", measures = "Lymph.")` | `hemogram/CENTRE_A/Lymph_pct_figure.png`, `Lymph_pct_anova.csv`, `Lymph_pct_tukey.csv`, `Lymph_pct_assumptions.csv` |  |
| `Lymph.` | 6 | `CENTRE_Atratadosnotratados` | 864-872 | 874 | violin | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_Atratadosnotratados", measures = "Lymph.")` | `hemogram/CENTRE_Atratadosnotratados/Lymph_pct_figure.png`, `Lymph_pct_anova.csv`, `Lymph_pct_tukey.csv`, `Lymph_pct_assumptions.csv` |  |
| `Lymph.` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 879-887 | 889 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "Lymph.")` | `hemogram/CENTRE_AtratadosnotratadosMPLCONTN/Lymph_pct_figure.png`, `Lymph_pct_anova.csv`, `Lymph_pct_tukey.csv`, `Lymph_pct_assumptions.csv` |  |
| `Lymph.` | 8 | `CENTRE_ATNCONMPL` | 894-902 | 904 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_ATNCONMPL", measures = "Lymph.")` | `hemogram/CENTRE_ATNCONMPL/Lymph_pct_figure.png`, `Lymph_pct_anova.csv`, `Lymph_pct_tukey.csv`, `Lymph_pct_assumptions.csv` |  |
| `Mono.` | 1 | `Hemograma_ALL_Nov9_2021` | 914-922 | 924 | box | valid | cohort-wide, out of scope | none | none |  |
| `Mono.` | 2 | `Hemograma_ALL_Nov9_2021_tratadosnotratados` | 929-937 | 940 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Mono.` | 3 | `Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 945-953 | 955 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Mono.` | 4 | `Hemograma_ALL_Nov9_2021MPLSTN` | 960-968 | 970 | box | valid | cohort-wide, out of scope | none | none |  |
| `Mono.` | 5 | `CENTRE_A` | 975-983 | 985 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_A", measures = "Mono.")` | `hemogram/CENTRE_A/Mono_pct_figure.png`, `Mono_pct_anova.csv`, `Mono_pct_tukey.csv`, `Mono_pct_assumptions.csv` |  |
| `Mono.` | 6 | `CENTRE_Atratadosnotratados` | 990-998 | 1000 | violin | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_Atratadosnotratados", measures = "Mono.")` | `hemogram/CENTRE_Atratadosnotratados/Mono_pct_figure.png`, `Mono_pct_anova.csv`, `Mono_pct_tukey.csv`, `Mono_pct_assumptions.csv` |  |
| `Mono.` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 1005-1013 | 1015 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "Mono.")` | `hemogram/CENTRE_AtratadosnotratadosMPLCONTN/Mono_pct_figure.png`, `Mono_pct_anova.csv`, `Mono_pct_tukey.csv`, `Mono_pct_assumptions.csv` |  |
| `Mono.` | 8 | `CENTRE_ATNCONMPL` | 1020-1028 | 1030 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_ATNCONMPL", measures = "Mono.")` | `hemogram/CENTRE_ATNCONMPL/Mono_pct_figure.png`, `Mono_pct_anova.csv`, `Mono_pct_tukey.csv`, `Mono_pct_assumptions.csv` |  |
| `Eos.` | 1 | `Hemograma_ALL_Nov9_2021` | 1040-1048 | 1050 | box | valid | cohort-wide, out of scope | none | none |  |
| `Eos.` | 2 | `Hemograma_ALL_Nov9_2021_tratadosnotratados` | 1055-1063 | 1066 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Eos.` | 3 | `Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 1071-1079 | 1081 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Eos.` | 4 | `Hemograma_ALL_Nov9_2021MPLSTN` | 1086-1094 | 1096 | box | valid | cohort-wide, out of scope | none | none |  |
| `Eos.` | 5 | `CENTRE_A` | 1101-1109 | 1111 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_A", measures = "Eos.")` | `hemogram/CENTRE_A/Eos_pct_figure.png`, `Eos_pct_anova.csv`, `Eos_pct_tukey.csv`, `Eos_pct_assumptions.csv` |  |
| `Eos.` | 6 | `CENTRE_Atratadosnotratados` | 1116-1124 | 1126 | violin | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_Atratadosnotratados", measures = "Eos.")` | `hemogram/CENTRE_Atratadosnotratados/Eos_pct_figure.png`, `Eos_pct_anova.csv`, `Eos_pct_tukey.csv`, `Eos_pct_assumptions.csv` |  |
| `Eos.` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 1131-1139 | 1141 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "Eos.")` | `hemogram/CENTRE_AtratadosnotratadosMPLCONTN/Eos_pct_figure.png`, `Eos_pct_anova.csv`, `Eos_pct_tukey.csv`, `Eos_pct_assumptions.csv` |  |
| `Eos.` | 8 | `CENTRE_ATNCONMPL` | 1146-1154 | 1156 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_ATNCONMPL", measures = "Eos.")` | `hemogram/CENTRE_ATNCONMPL/Eos_pct_figure.png`, `Eos_pct_anova.csv`, `Eos_pct_tukey.csv`, `Eos_pct_assumptions.csv` |  |
| `Baso.` | 1 | `Hemograma_ALL_Nov9_2021` | 1167-1175 | 1177 | box | valid | cohort-wide, out of scope | none | none |  |
| `Baso.` | 2 | `Hemograma_ALL_Nov9_2021_tratadosnotratados` | 1182-1190 | 1193 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Baso.` | 3 | `Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 1198-1206 | 1208 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Baso.` | 4 | `Hemograma_ALL_Nov9_2021MPLSTN` | 1213-1221 | 1223 | box | valid | cohort-wide, out of scope | none | none |  |
| `Baso.` | 5 | `CENTRE_A` | 1228-1236 | 1238 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_A", measures = "Baso.")` | `hemogram/CENTRE_A/Baso_pct_figure.png`, `Baso_pct_anova.csv`, `Baso_pct_tukey.csv`, `Baso_pct_assumptions.csv` |  |
| `Baso.` | 6 | `CENTRE_Atratadosnotratados` | 1243-1251 | 1253 | violin | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_Atratadosnotratados", measures = "Baso.")` | `hemogram/CENTRE_Atratadosnotratados/Baso_pct_figure.png`, `Baso_pct_anova.csv`, `Baso_pct_tukey.csv`, `Baso_pct_assumptions.csv` |  |
| `Baso.` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 1258-1266 | 1268 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "Baso.")` | `hemogram/CENTRE_AtratadosnotratadosMPLCONTN/Baso_pct_figure.png`, `Baso_pct_anova.csv`, `Baso_pct_tukey.csv`, `Baso_pct_assumptions.csv` |  |
| `Baso.` | 8 | `CENTRE_ATNCONMPL` | 1273-1281 | 1283 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_ATNCONMPL", measures = "Baso.")` | `hemogram/CENTRE_ATNCONMPL/Baso_pct_figure.png`, `Baso_pct_anova.csv`, `Baso_pct_tukey.csv`, `Baso_pct_assumptions.csv` |  |
| `Lymph..10.6.ml.` | 1 | `Hemograma_ALL_Nov9_2021` | 1292-1300 | 1302 | box | valid | cohort-wide, out of scope | none | none |  |
| `Lymph..10.6.ml.` | 2 | `Hemograma_ALL_Nov9_2021_tratadosnotratados` | 1307-1315 | 1318 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Lymph..10.6.ml.` | 3 | `Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 1323-1331 | 1333 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Lymph..10.6.ml.` | 4 | `Hemograma_ALL_Nov9_2021MPLSTN` | 1338-1346 | 1348 | box | valid | cohort-wide, out of scope | none | none |  |
| `Lymph..10.6.ml.` | 5 | `CENTRE_A` | 1353-1361 | 1363 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_A", measures = "Lymph..10.6.ml.")` | `hemogram/CENTRE_A/Lymph_abs_figure.png`, `Lymph_abs_anova.csv`, `Lymph_abs_tukey.csv`, `Lymph_abs_assumptions.csv` |  |
| `Lymph..10.6.ml.` | 6 | `CENTRE_Atratadosnotratados` | 1368-1376 | 1378 | violin | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_Atratadosnotratados", measures = "Lymph..10.6.ml.")` | `hemogram/CENTRE_Atratadosnotratados/Lymph_abs_figure.png`, `Lymph_abs_anova.csv`, `Lymph_abs_tukey.csv`, `Lymph_abs_assumptions.csv` |  |
| `Lymph..10.6.ml.` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 1383-1391 | 1393 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "Lymph..10.6.ml.")` | `hemogram/CENTRE_AtratadosnotratadosMPLCONTN/Lymph_abs_figure.png`, `Lymph_abs_anova.csv`, `Lymph_abs_tukey.csv`, `Lymph_abs_assumptions.csv` |  |
| `Lymph..10.6.ml.` | 8 | `CENTRE_ATNCONMPL` | 1398-1406 | 1408 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_ATNCONMPL", measures = "Lymph..10.6.ml.")` | `hemogram/CENTRE_ATNCONMPL/Lymph_abs_figure.png`, `Lymph_abs_anova.csv`, `Lymph_abs_tukey.csv`, `Lymph_abs_assumptions.csv` |  |
| `Mono..10.6.ml.` | 1 | `Hemograma_ALL_Nov9_2021` | 1418-1426 | 1428 | box | valid | cohort-wide, out of scope | none | none |  |
| `Mono..10.6.ml.` | 2 | `Hemograma_ALL_Nov9_2021_tratadosnotratados` | 1433-1441 | 1444 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Mono..10.6.ml.` | 3 | `Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 1449-1457 | 1459 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Mono..10.6.ml.` | 4 | `Hemograma_ALL_Nov9_2021MPLSTN` | 1464-1472 | 1474 | box | valid | cohort-wide, out of scope | none | none |  |
| `Mono..10.6.ml.` | 5 | `CENTRE_A` | 1479-1487 | 1489 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_A", measures = "Mono..10.6.ml.")` | `hemogram/CENTRE_A/Mono_abs_figure.png`, `Mono_abs_anova.csv`, `Mono_abs_tukey.csv`, `Mono_abs_assumptions.csv` |  |
| `Mono..10.6.ml.` | 6 | `CENTRE_Atratadosnotratados` | 1494-1502 | 1504 | violin | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_Atratadosnotratados", measures = "Mono..10.6.ml.")` | `hemogram/CENTRE_Atratadosnotratados/Mono_abs_figure.png`, `Mono_abs_anova.csv`, `Mono_abs_tukey.csv`, `Mono_abs_assumptions.csv` |  |
| `Mono..10.6.ml.` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 1509-1517 | 1519 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "Mono..10.6.ml.")` | `hemogram/CENTRE_AtratadosnotratadosMPLCONTN/Mono_abs_figure.png`, `Mono_abs_anova.csv`, `Mono_abs_tukey.csv`, `Mono_abs_assumptions.csv` |  |
| `Mono..10.6.ml.` | 8 | `CENTRE_ATNCONMPL` | 1524-1532 | 1534 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_ATNCONMPL", measures = "Mono..10.6.ml.")` | `hemogram/CENTRE_ATNCONMPL/Mono_abs_figure.png`, `Mono_abs_anova.csv`, `Mono_abs_tukey.csv`, `Mono_abs_assumptions.csv` |  |
| `Eos..10.6.ml.` | 1 | `Hemograma_ALL_Nov9_2021` | 1543-1551 | 1553 | box | valid | cohort-wide, out of scope | none | none |  |
| `Eos..10.6.ml.` | 2 | `Hemograma_ALL_Nov9_2021_tratadosnotratados` | 1558-1566 | 1569 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Eos..10.6.ml.` | 3 | `Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 1574-1582 | 1584 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Eos..10.6.ml.` | 4 | `Hemograma_ALL_Nov9_2021MPLSTN` | 1589-1597 | 1599 | box | valid | cohort-wide, out of scope | none | none |  |
| `Eos..10.6.ml.` | 5 | `CENTRE_A` | 1604-1612 | 1614 | box | cosmetic defect | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_A", measures = "Eos..10.6.ml.")` | `hemogram/CENTRE_A/Eos_abs_figure.png`, `Eos_abs_anova.csv`, `Eos_abs_tukey.csv`, `Eos_abs_assumptions.csv` | line 1615 prints the raw `aov` object instead of its summary; the Tukey table at 1616 is produced |
| `Eos..10.6.ml.` | 6 | `CENTRE_Atratadosnotratados` | 1619-1627 | 1629 | violin | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_Atratadosnotratados", measures = "Eos..10.6.ml.")` | `hemogram/CENTRE_Atratadosnotratados/Eos_abs_figure.png`, `Eos_abs_anova.csv`, `Eos_abs_tukey.csv`, `Eos_abs_assumptions.csv` |  |
| `Eos..10.6.ml.` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 1634-1642 | 1644 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "Eos..10.6.ml.")` | `hemogram/CENTRE_AtratadosnotratadosMPLCONTN/Eos_abs_figure.png`, `Eos_abs_anova.csv`, `Eos_abs_tukey.csv`, `Eos_abs_assumptions.csv` |  |
| `Eos..10.6.ml.` | 8 | `CENTRE_ATNCONMPL` | 1649-1657 | 1659 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_ATNCONMPL", measures = "Eos..10.6.ml.")` | `hemogram/CENTRE_ATNCONMPL/Eos_abs_figure.png`, `Eos_abs_anova.csv`, `Eos_abs_tukey.csv`, `Eos_abs_assumptions.csv` |  |
| `Baso..10.6.ml.` | 1 | `Hemograma_ALL_Nov9_2021` | 1669-1677 | 1679 | box | valid | cohort-wide, out of scope | none | none |  |
| `Baso..10.6.ml.` | 2 | `Hemograma_ALL_Nov9_2021_tratadosnotratados` | 1684-1692 | 1695 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Baso..10.6.ml.` | 3 | `Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 1700-1708 | 1710 | violin | valid | cohort-wide, out of scope | none | none |  |
| `Baso..10.6.ml.` | 4 | `Hemograma_ALL_Nov9_2021MPLSTN` | 1715-1723 | 1725 | box | valid | cohort-wide, out of scope | none | none |  |
| `Baso..10.6.ml.` | 5 | `CENTRE_A` | 1730-1738 | 1740 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_A", measures = "Baso..10.6.ml.")` | `hemogram/CENTRE_A/Baso_abs_figure.png`, `Baso_abs_anova.csv`, `Baso_abs_tukey.csv`, `Baso_abs_assumptions.csv` |  |
| `Baso..10.6.ml.` | 6 | `CENTRE_Atratadosnotratados` | 1745-1753 | 1755 | violin | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_Atratadosnotratados", measures = "Baso..10.6.ml.")` | `hemogram/CENTRE_Atratadosnotratados/Baso_abs_figure.png`, `Baso_abs_anova.csv`, `Baso_abs_tukey.csv`, `Baso_abs_assumptions.csv` |  |
| `Baso..10.6.ml.` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 1760-1768 | 1770 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "Baso..10.6.ml.")` | `hemogram/CENTRE_AtratadosnotratadosMPLCONTN/Baso_abs_figure.png`, `Baso_abs_anova.csv`, `Baso_abs_tukey.csv`, `Baso_abs_assumptions.csv` |  |
| `Baso..10.6.ml.` | 8 | `CENTRE_ATNCONMPL` | 1775-1783 | 1785 | box | valid | CENTRE_A | `run_panel("hemogram", variants = "CENTRE_ATNCONMPL", measures = "Baso..10.6.ml.")` | `hemogram/CENTRE_ATNCONMPL/Baso_abs_figure.png`, `Baso_abs_anova.csv`, `Baso_abs_tukey.csv`, `Baso_abs_assumptions.csv` |  |

## surfacemarkers.R

Ten surface markers, eight slots each, model `measure ~ Genotype * Treatment`. Slots 1 to 4 are the cohort-wide tables; slots 5 to 8 are the four `CENTRE_A` tables reproduced by v1.0 (panel `markers`). The legacy geometry is box, violin, violin, box, box, violin, violin, box for most markers, so slot 7 differs from the v1.0 default (box) for seven markers and CD41 differs in all four `CENTRE_A` slots.

| Measure | Slot | Legacy variant | Figure lines | aov line | Legacy geometry | Legacy status | Scope | v1.0 call | v1.0 outputs | Note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `CD61` | 1 | `SurfaceMarkers_ALL_Nov9_2021` | 348-356 | 358 | box | valid | cohort-wide, out of scope | none | none |  |
| `CD61` | 2 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados` | 363-371 | 374 | violin | valid | cohort-wide, out of scope | none | none |  |
| `CD61` | 3 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 379-387 | 389 | violin | valid | cohort-wide, out of scope | none | none |  |
| `CD61` | 4 | `SurfaceMarkers_ALL_Nov9_2021MPLSTN` | 394-402 | 404 | box | valid | cohort-wide, out of scope | none | none |  |
| `CD61` | 5 | `CENTRE_A` | 409-417 | 419 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_A", measures = "CD61")` | `markers/CENTRE_A/CD61_figure.png`, `CD61_anova.csv`, `CD61_tukey.csv`, `CD61_assumptions.csv` |  |
| `CD61` | 6 | `CENTRE_Atratadosnotratados` | 424-432 | 434 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_Atratadosnotratados", measures = "CD61")` | `markers/CENTRE_Atratadosnotratados/CD61_figure.png`, `CD61_anova.csv`, `CD61_tukey.csv`, `CD61_assumptions.csv` |  |
| `CD61` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 439-447 | 449 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "CD61")` | `markers/CENTRE_AtratadosnotratadosMPLCONTN/CD61_figure.png`, `CD61_anova.csv`, `CD61_tukey.csv`, `CD61_assumptions.csv` |  |
| `CD61` | 8 | `CENTRE_ATNCONMPL` | 454-462 | 464 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_ATNCONMPL", measures = "CD61")` | `markers/CENTRE_ATNCONMPL/CD61_figure.png`, `CD61_anova.csv`, `CD61_tukey.csv`, `CD61_assumptions.csv` |  |
| `CD41` | 1 | `SurfaceMarkers_ALL_Nov9_2021` | 473-481 | 483 | box | valid | cohort-wide, out of scope | none | none |  |
| `CD41` | 2 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados` | 488-496 | 498 | violin | valid | cohort-wide, out of scope | none | none |  |
| `CD41` | 3 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 502-510 | 512 | violin | valid | cohort-wide, out of scope | none | none |  |
| `CD41` | 4 | `SurfaceMarkers_ALL_Nov9_2021MPLSTN` | 517-525 | 527 | box | valid | cohort-wide, out of scope | none | none |  |
| `CD41` | 5 | `CENTRE_A` | 532-540 | 542 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_A", measures = "CD41")` | `markers/CENTRE_A/CD41_figure.png`, `CD41_anova.csv`, `CD41_tukey.csv`, `CD41_assumptions.csv` | legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `CD41` | 6 | `CENTRE_Atratadosnotratados` | 548-556 | 558 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_Atratadosnotratados", measures = "CD41")` | `markers/CENTRE_Atratadosnotratados/CD41_figure.png`, `CD41_anova.csv`, `CD41_tukey.csv`, `CD41_assumptions.csv` | legacy geometry box, v1.0 default violin (pass `geom = "box"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `CD41` | 7 | `CENTRE_ATNCONMPL` | 564-572 | 574 | violin | wrong object | CENTRE_A | `run_panel("markers", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "CD41")` | `markers/CENTRE_AtratadosnotratadosMPLCONTN/CD41_figure.png`, `CD41_anova.csv`, `CD41_tukey.csv`, `CD41_assumptions.csv` | new in v1.0: no valid 2021 counterpart for this measure and variant; figure drawn on `CENTRE_AtratadosnotratadosMPLCONTN`, model fitted on `CENTRE_ATNCONMPL`: duplicate of the fit at 588; legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `CD41` | 8 | `CENTRE_ATNCONMPL` | 578-586 | 588 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_ATNCONMPL", measures = "CD41")` | `markers/CENTRE_ATNCONMPL/CD41_figure.png`, `CD41_anova.csv`, `CD41_tukey.csv`, `CD41_assumptions.csv` | legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `CD49B` | 1 | `SurfaceMarkers_ALL_Nov9_2021` | 597-605 | 607 | box | valid | cohort-wide, out of scope | none | none |  |
| `CD49B` | 2 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados` | 612-620 | 622 | violin | valid | cohort-wide, out of scope | none | none |  |
| `CD49B` | 3 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 627-635 | 637 | violin | valid | cohort-wide, out of scope | none | none |  |
| `CD49B` | 4 | `SurfaceMarkers_ALL_Nov9_2021MPLSTN` | 641-649 | 651 | box | valid | cohort-wide, out of scope | none | none |  |
| `CD49B` | 5 | `CENTRE_A` | 658-666 | 668 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_A", measures = "CD49B")` | `markers/CENTRE_A/CD49B_figure.png`, `CD49B_anova.csv`, `CD49B_tukey.csv`, `CD49B_assumptions.csv` |  |
| `CD49B` | 6 | `CENTRE_Atratadosnotratados` | 673-681 | 683 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_Atratadosnotratados", measures = "CD49B")` | `markers/CENTRE_Atratadosnotratados/CD49B_figure.png`, `CD49B_anova.csv`, `CD49B_tukey.csv`, `CD49B_assumptions.csv` |  |
| `CD49B` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 688-696 | 698 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "CD49B")` | `markers/CENTRE_AtratadosnotratadosMPLCONTN/CD49B_figure.png`, `CD49B_anova.csv`, `CD49B_tukey.csv`, `CD49B_assumptions.csv` | figure title omits the `CENTRE_A` suffix (same title as the cohort-wide slot 3 figure); legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `CD49B` | 8 | `CENTRE_ATNCONMPL` | 703-711 | 713 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_ATNCONMPL", measures = "CD49B")` | `markers/CENTRE_ATNCONMPL/CD49B_figure.png`, `CD49B_anova.csv`, `CD49B_tukey.csv`, `CD49B_assumptions.csv` |  |
| `GPVI` | 1 | `SurfaceMarkers_ALL_Nov9_2021` | 722-730 | 732 | box | valid | cohort-wide, out of scope | none | none | marker missing for every `CENTRE_B` row, so this cohort-wide fit is in fact a `CENTRE_A` fit with the two-centre labels |
| `GPVI` | 2 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados` | 737-745 | 747 | violin | valid | cohort-wide, out of scope | none | none | marker missing for every `CENTRE_B` row, so this cohort-wide fit is in fact a `CENTRE_A` fit with the two-centre labels |
| `GPVI` | 3 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 752-760 | 762 | violin | valid | cohort-wide, out of scope | none | none | marker missing for every `CENTRE_B` row, so this cohort-wide fit is in fact a `CENTRE_A` fit with the two-centre labels |
| `GPVI` | 4 | `SurfaceMarkers_ALL_Nov9_2021MPLSTN` | 767-775 | 777 | box | valid | cohort-wide, out of scope | none | none | marker missing for every `CENTRE_B` row, so this cohort-wide fit is in fact a `CENTRE_A` fit with the two-centre labels |
| `GPVI` | 5 | `CENTRE_A` | 782-790 | 792 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_A", measures = "GPVI")` | `markers/CENTRE_A/GPVI_figure.png`, `GPVI_anova.csv`, `GPVI_tukey.csv`, `GPVI_assumptions.csv` |  |
| `GPVI` | 6 | `CENTRE_Atratadosnotratados` | 797-805 | 807 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_Atratadosnotratados", measures = "GPVI")` | `markers/CENTRE_Atratadosnotratados/GPVI_figure.png`, `GPVI_anova.csv`, `GPVI_tukey.csv`, `GPVI_assumptions.csv` |  |
| `GPVI` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 812-820 | 822 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "GPVI")` | `markers/CENTRE_AtratadosnotratadosMPLCONTN/GPVI_figure.png`, `GPVI_anova.csv`, `GPVI_tukey.csv`, `GPVI_assumptions.csv` | figure title `GPVI CENTRE_A MPL CON TN` is the same as the slot 8 title |
| `GPVI` | 8 | `CENTRE_ATNCONMPL` | 827-835 | 837 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_ATNCONMPL", measures = "GPVI")` | `markers/CENTRE_ATNCONMPL/GPVI_figure.png`, `GPVI_anova.csv`, `GPVI_tukey.csv`, `GPVI_assumptions.csv` |  |
| `CD42A` | 1 | `SurfaceMarkers_ALL_Nov9_2021` | 846-854 | 856 | box | valid | cohort-wide, out of scope | none | none | marker missing for every `CENTRE_B` row, so this cohort-wide fit is in fact a `CENTRE_A` fit with the two-centre labels |
| `CD42A` | 2 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados` | 861-869 | 871 | violin | valid | cohort-wide, out of scope | none | none | marker missing for every `CENTRE_B` row, so this cohort-wide fit is in fact a `CENTRE_A` fit with the two-centre labels |
| `CD42A` | 3 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 875-883 | 885 | violin | valid | cohort-wide, out of scope | none | none | marker missing for every `CENTRE_B` row, so this cohort-wide fit is in fact a `CENTRE_A` fit with the two-centre labels |
| `CD42A` | 4 | `SurfaceMarkers_ALL_Nov9_2021MPLSTN` | 889-897 | 899 | box | valid | cohort-wide, out of scope | none | none | marker missing for every `CENTRE_B` row, so this cohort-wide fit is in fact a `CENTRE_A` fit with the two-centre labels |
| `CD42A` | 5 | `CENTRE_A` | 904-912 | 914 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_A", measures = "CD42A")` | `markers/CENTRE_A/CD42A_figure.png`, `CD42A_anova.csv`, `CD42A_tukey.csv`, `CD42A_assumptions.csv` |  |
| `CD42A` | 6 | `CENTRE_Atratadosnotratados` | 919-927 | 929 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_Atratadosnotratados", measures = "CD42A")` | `markers/CENTRE_Atratadosnotratados/CD42A_figure.png`, `CD42A_anova.csv`, `CD42A_tukey.csv`, `CD42A_assumptions.csv` |  |
| `CD42A` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 933-941 | 943 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "CD42A")` | `markers/CENTRE_AtratadosnotratadosMPLCONTN/CD42A_figure.png`, `CD42A_anova.csv`, `CD42A_tukey.csv`, `CD42A_assumptions.csv` | figure title omits the `CENTRE_A` suffix (same title as the cohort-wide slot 3 figure); legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `CD42A` | 8 | `CENTRE_ATNCONMPL` | 947-955 | 957 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_ATNCONMPL", measures = "CD42A")` | `markers/CENTRE_ATNCONMPL/CD42A_figure.png`, `CD42A_anova.csv`, `CD42A_tukey.csv`, `CD42A_assumptions.csv` |  |
| `CD42B` | 1 | `SurfaceMarkers_ALL_Nov9_2021` | 966-974 | 976 | box | valid | cohort-wide, out of scope | none | none |  |
| `CD42B` | 2 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados` | 981-989 | 991 | violin | valid | cohort-wide, out of scope | none | none |  |
| `CD42B` | 3 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 995-1003 | 1005 | violin | valid | cohort-wide, out of scope | none | none |  |
| `CD42B` | 4 | `SurfaceMarkers_ALL_Nov9_2021MPLSTN` | 1009-1017 | 1019 | box | valid | cohort-wide, out of scope | none | none |  |
| `CD42B` | 5 | `CENTRE_A` | 1024-1032 | 1034 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_A", measures = "CD42B")` | `markers/CENTRE_A/CD42B_figure.png`, `CD42B_anova.csv`, `CD42B_tukey.csv`, `CD42B_assumptions.csv` |  |
| `CD42B` | 6 | `CENTRE_Atratadosnotratados` | 1039-1047 | 1049 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_Atratadosnotratados", measures = "CD42B")` | `markers/CENTRE_Atratadosnotratados/CD42B_figure.png`, `CD42B_anova.csv`, `CD42B_tukey.csv`, `CD42B_assumptions.csv` |  |
| `CD42B` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 1053-1061 | 1063 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "CD42B")` | `markers/CENTRE_AtratadosnotratadosMPLCONTN/CD42B_figure.png`, `CD42B_anova.csv`, `CD42B_tukey.csv`, `CD42B_assumptions.csv` | figure title omits the `CENTRE_A` suffix (same title as the cohort-wide slot 3 figure); legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `CD42B` | 8 | `CENTRE_ATNCONMPL` | 1067-1075 | 1077 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_ATNCONMPL", measures = "CD42B")` | `markers/CENTRE_ATNCONMPL/CD42B_figure.png`, `CD42B_anova.csv`, `CD42B_tukey.csv`, `CD42B_assumptions.csv` |  |
| `CD31` | 1 | `SurfaceMarkers_ALL_Nov9_2021` | 1086-1094 | 1096 | box | valid | cohort-wide, out of scope | none | none |  |
| `CD31` | 2 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados` | 1101-1109 | 1111 | violin | valid | cohort-wide, out of scope | none | none |  |
| `CD31` | 3 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 1115-1123 | 1125 | violin | valid | cohort-wide, out of scope | none | none |  |
| `CD31` | 4 | `SurfaceMarkers_ALL_Nov9_2021MPLSTN` | 1129-1137 | 1139 | box | valid | cohort-wide, out of scope | none | none |  |
| `CD31` | 5 | `CENTRE_A` | 1144-1152 | 1154 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_A", measures = "CD31")` | `markers/CENTRE_A/CD31_figure.png`, `CD31_anova.csv`, `CD31_tukey.csv`, `CD31_assumptions.csv` |  |
| `CD31` | 6 | `CENTRE_Atratadosnotratados` | 1159-1167 | 1169 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_Atratadosnotratados", measures = "CD31")` | `markers/CENTRE_Atratadosnotratados/CD31_figure.png`, `CD31_anova.csv`, `CD31_tukey.csv`, `CD31_assumptions.csv` |  |
| `CD31` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 1173-1181 | 1183 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "CD31")` | `markers/CENTRE_AtratadosnotratadosMPLCONTN/CD31_figure.png`, `CD31_anova.csv`, `CD31_tukey.csv`, `CD31_assumptions.csv` | figure title omits the `CENTRE_A` suffix (same title as the cohort-wide slot 3 figure); legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `CD31` | 8 | `CENTRE_ATNCONMPL` | 1187-1195 | 1197 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_ATNCONMPL", measures = "CD31")` | `markers/CENTRE_ATNCONMPL/CD31_figure.png`, `CD31_anova.csv`, `CD31_tukey.csv`, `CD31_assumptions.csv` |  |
| `CD36` | 1 | `SurfaceMarkers_ALL_Nov9_2021` | 1206-1214 | 1216 | box | valid | cohort-wide, out of scope | none | none |  |
| `CD36` | 2 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados` | 1221-1229 | 1231 | violin | valid | cohort-wide, out of scope | none | none |  |
| `CD36` | 3 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 1235-1243 | 1245 | violin | valid | cohort-wide, out of scope | none | none |  |
| `CD36` | 4 | `SurfaceMarkers_ALL_Nov9_2021MPLSTN` | 1249-1257 | 1259 | box | valid | cohort-wide, out of scope | none | none |  |
| `CD36` | 5 | `CENTRE_A` | 1264-1272 | 1274 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_A", measures = "CD36")` | `markers/CENTRE_A/CD36_figure.png`, `CD36_anova.csv`, `CD36_tukey.csv`, `CD36_assumptions.csv` |  |
| `CD36` | 6 | `CENTRE_Atratadosnotratados` | 1279-1287 | 1289 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_Atratadosnotratados", measures = "CD36")` | `markers/CENTRE_Atratadosnotratados/CD36_figure.png`, `CD36_anova.csv`, `CD36_tukey.csv`, `CD36_assumptions.csv` |  |
| `CD36` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 1293-1301 | 1303 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "CD36")` | `markers/CENTRE_AtratadosnotratadosMPLCONTN/CD36_figure.png`, `CD36_anova.csv`, `CD36_tukey.csv`, `CD36_assumptions.csv` | figure title omits the `CENTRE_A` suffix (same title as the cohort-wide slot 3 figure); legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `CD36` | 8 | `CENTRE_ATNCONMPL` | 1307-1315 | 1317 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_ATNCONMPL", measures = "CD36")` | `markers/CENTRE_ATNCONMPL/CD36_figure.png`, `CD36_anova.csv`, `CD36_tukey.csv`, `CD36_assumptions.csv` |  |
| `CD9` | 1 | `SurfaceMarkers_ALL_Nov9_2021` | 1325-1333 | 1335 | box | valid | cohort-wide, out of scope | none | none | marker missing for every `CENTRE_B` row, so this cohort-wide fit is in fact a `CENTRE_A` fit with the two-centre labels |
| `CD9` | 2 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados` | 1340-1348 | 1350 | violin | valid | cohort-wide, out of scope | none | none | marker missing for every `CENTRE_B` row, so this cohort-wide fit is in fact a `CENTRE_A` fit with the two-centre labels |
| `CD9` | 3 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 1354-1362 | 1364 | violin | valid | cohort-wide, out of scope | none | none | marker missing for every `CENTRE_B` row, so this cohort-wide fit is in fact a `CENTRE_A` fit with the two-centre labels |
| `CD9` | 4 | `SurfaceMarkers_ALL_Nov9_2021MPLSTN` | 1368-1376 | 1378 | box | valid | cohort-wide, out of scope | none | none | marker missing for every `CENTRE_B` row, so this cohort-wide fit is in fact a `CENTRE_A` fit with the two-centre labels |
| `CD9` | 5 | `CENTRE_A` | 1383-1391 | 1393 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_A", measures = "CD9")` | `markers/CENTRE_A/CD9_figure.png`, `CD9_anova.csv`, `CD9_tukey.csv`, `CD9_assumptions.csv` |  |
| `CD9` | 6 | `CENTRE_Atratadosnotratados` | 1398-1406 | 1408 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_Atratadosnotratados", measures = "CD9")` | `markers/CENTRE_Atratadosnotratados/CD9_figure.png`, `CD9_anova.csv`, `CD9_tukey.csv`, `CD9_assumptions.csv` |  |
| `CD9` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 1412-1420 | 1422 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "CD9")` | `markers/CENTRE_AtratadosnotratadosMPLCONTN/CD9_figure.png`, `CD9_anova.csv`, `CD9_tukey.csv`, `CD9_assumptions.csv` | figure title omits the `CENTRE_A` suffix (same title as the cohort-wide slot 3 figure); legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `CD9` | 8 | `CENTRE_ATNCONMPL` | 1426-1434 | 1436 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_ATNCONMPL", measures = "CD9")` | `markers/CENTRE_ATNCONMPL/CD9_figure.png`, `CD9_anova.csv`, `CD9_tukey.csv`, `CD9_assumptions.csv` |  |
| `FSC.unstained` | 1 | `SurfaceMarkers_ALL_Nov9_2021` | 1445-1453 | 1455 | box | valid | cohort-wide, out of scope | none | none |  |
| `FSC.unstained` | 2 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados` | 1460-1468 | 1470 | violin | valid | cohort-wide, out of scope | none | none |  |
| `FSC.unstained` | 3 | `SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN` | 1474-1482 | 1484 | violin | valid | cohort-wide, out of scope | none | none |  |
| `FSC.unstained` | 4 | `SurfaceMarkers_ALL_Nov9_2021MPLSTN` | 1488-1496 | 1498 | box | valid | cohort-wide, out of scope | none | none |  |
| `FSC.unstained` | 5 | `CENTRE_A` | 1503-1511 | 1513 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_A", measures = "FSC.unstained")` | `markers/CENTRE_A/FSC_unstained_figure.png`, `FSC_unstained_anova.csv`, `FSC_unstained_tukey.csv`, `FSC_unstained_assumptions.csv` |  |
| `FSC.unstained` | 6 | `CENTRE_Atratadosnotratados` | 1518-1526 | 1528 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_Atratadosnotratados", measures = "FSC.unstained")` | `markers/CENTRE_Atratadosnotratados/FSC_unstained_figure.png`, `FSC_unstained_anova.csv`, `FSC_unstained_tukey.csv`, `FSC_unstained_assumptions.csv` |  |
| `FSC.unstained` | 7 | `CENTRE_AtratadosnotratadosMPLCONTN` | 1532-1540 | 1542 | violin | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_AtratadosnotratadosMPLCONTN", measures = "FSC.unstained")` | `markers/CENTRE_AtratadosnotratadosMPLCONTN/FSC_unstained_figure.png`, `FSC_unstained_anova.csv`, `FSC_unstained_tukey.csv`, `FSC_unstained_assumptions.csv` | figure title omits the `CENTRE_A` suffix (same title as the cohort-wide slot 3 figure); legacy geometry violin, v1.0 default box (pass `geom = "violin"` to `plot_measure()` or edit the `geom` column of `variant_table()` to match) |
| `FSC.unstained` | 8 | `CENTRE_ATNCONMPL` | 1546-1554 | 1556 | box | valid | CENTRE_A | `run_panel("markers", variants = "CENTRE_ATNCONMPL", measures = "FSC.unstained")` | `markers/CENTRE_ATNCONMPL/FSC_unstained_figure.png`, `FSC_unstained_anova.csv`, `FSC_unstained_tukey.csv`, `FSC_unstained_assumptions.csv` |  |

## Summary

| Script | Legacy fits | Valid | `CENTRE_A` valid | Reproduced by v1.0 | New in v1.0 | Cohort-wide, out of scope |
| --- | --- | --- | --- | --- | --- | --- |
| `Agonistas_2021-11-09.R` | 72 | 48 | 30 | 30 | 6 | 36 (18 valid) |
| `hemogram.R` | 112 | 112 | 56 | 56 | 0 | 56 (56 valid) |
| `surfacemarkers.R` | 80 | 79 | 39 | 39 | 1 | 40 (40 valid) |
| Total | 264 | 239 | 125 | 125 | 7 | 132 (114 valid) |

Reading the table: `Valid` counts the fits whose status is `valid` or
`cosmetic defect`; `CENTRE_A valid` are the valid fits of slots 5 to 8;
`Reproduced by v1.0` are the `CENTRE_A` valid fits, each with one row above
carrying a v1.0 call; `New in v1.0` are the `CENTRE_A` slots whose 2021 fit
is broken (the never-read object and the duplicate fit of
`Agonistas_2021-11-09.R`, the wrong object of `surfacemarkers.R`), which v1.0
fits on the variant of their figure; `Cohort-wide, out of scope` are slots 1
to 4, with the number of them that were valid in 2021 (the 18 aggregation
fits on character columns are the invalid ones).

v1.0 therefore produces 36 + 56 + 40 = 132 measure-by-variant fits on the
four `CENTRE_A` variants: 125 of them reproduce a valid 2021 block and 7 are
new. The 48, 112 and 79 valid and distinct fits of `docs/limitations.md`
are the `Valid` column (the 80 marker fits are 79 distinct because the
wrong-object fit at 574 repeats 588).

## Methodological differences with respect to 2021

The differences below apply to every row mapped above. They are stated in
the order of `docs/v1_spec.md`, section 6, followed by the seed and version
rows.

| Topic | 2021 | v1.0 |
| --- | --- | --- |
| Sums of squares | Type I (sequential), from `summary(aov())`, so the p value of `Genotype` depended on it being first in the formula. | Type II (`car::Anova(lm, type = 2)`), invariant to the term order; with the unbalanced cells of this cohort the `Genotype` and `Treatment` p values differ from the 2021 ones, the interaction p value is identical. The `aov` object is still fitted for Tukey HSD. |
| Assumption checks | None. | Shapiro-Wilk on the residuals and Levene (median-centred) on the cells, reported in `<slug>_assumptions.csv` and never used to change the model. |
| Multiplicity | None. | Holm and Benjamini-Hochberg across the raw p values of every non-residual term of every fitted measure within a panel and variant, reported next to the raw p value (`p_holm`, `p_bh`, `family_size`) in `<slug>_anova.csv` and `anova_all.csv`. |
| Post hoc | Tukey HSD on `aov`, printed. | Same, exported as a long table (`<slug>_tukey.csv`, `tukey_all.csv`); Tukey p values are adjusted within the fit by the method itself and receive no further correction. |
| Recodings | By hand in spreadsheets, one file per variant. | In code from one master table per panel (`recode_variants()`: centre filter, treatment collapsed to `Untreated` versus `Treated`, `VARIANT` merged into `TN`). |
| Copy errors | 6 broken `CENTRE_A` slots in the aggregation script (5 on a never-read object, 1 duplicate; the 18 cohort-wide fits on character columns are out of scope), 1 in the marker script (CD41), 2 cosmetic in the hemogram script. | Every measure fitted on the variant its figure uses; the 7 broken `CENTRE_A` slots become the rows marked `new in v1.0`. |
| Figures | Points plus jittered centre labels with no seed, n printed for every cell, red outlier points, deprecated ggplot2 syntax. | Points jittered with a fixed seed, centre labels off by default (`label_points = FALSE`), n printed only when the cell has at least 5 observations (`min_cell = 5`), no duplicated outlier points, legend of the fill hidden. |
| Cohort overview | Bar charts filtered on hard-coded label lists; hemogram without overview. | Counts over all observed levels (missing shown as `(missing)`), overview for the three panels, counts printed only for segments of at least 5. |
| Outputs | Screen only. | PNG and CSV files with the naming scheme of `docs/v1_spec.md`, section 9; `sessionInfo.txt` with every run. |
| Cohort definition | Both centres in half of the variants. | `CENTRE_A` only, cut-off 2021-11-09. |
| Seeds | No `set.seed()`; jittered positions changed between runs. | Project seed 20211109 in the synthetic generator and in every jitter (`position_jitter(seed = 20211109)`). |
| Versions | No package versions recorded; R and package versions of 2021 unknown. | R 4.3.2 with dplyr, ggplot2, car and testthat recorded in `renv.lock`; `sessionInfo()` written with every run. |

Consequences for a reader comparing a 2021 block with its v1.0 call on the
private data: the `Genotype:Treatment` row of the ANOVA table and the Tukey
tables should match the 2021 output for every valid two-way fit; the
`Genotype` and `Treatment` rows will differ wherever the cells are
unbalanced (type II versus type I); the one-way hemogram fits are
unaffected by the change of sums of squares; and the figures will differ in
the jitter, the labels and the printed counts, by design.

## Notes

- The calls, variant ids, measure names and output files of the tables
  were checked against `R/run_panel.R`, `R/read_inputs.R` (`panel_spec()`)
  and the committed example run under `outputs/example/`: every `v1.0
  outputs` entry exists there and every call runs on the synthetic data.
- `docs/v1_spec.md`, section 15, lists both `duplicate fit` and `wrong
  object` among the status values. This document assigns `duplicate fit`
  to the CVX slot 7 of `Agonistas_2021-11-09.R` (line 570, the case that
  `docs/limitations.md` describes as a duplicate) and `wrong object` to the
  CD41 slot 7 of `surfacemarkers.R` (line 574, the case it describes as a
  fit on the wrong object). Both are the same kind of copy error: the model
  is fitted on `CENTRE_ATNCONMPL` while the figure is drawn on
  `CENTRE_AtratadosnotratadosMPLCONTN`.
- The two cosmetic defects of `hemogram.R` (line 105, `Genotype *
  Genotype`; line 1615, raw `aov` object printed) are counted as valid
  fits, as in `docs/limitations.md` and `docs/v1_spec.md`; the status
  `cosmetic defect` marks them so that the count of 112 valid fits can be
  recomposed as 110 `valid` plus 2 `cosmetic defect`.
- The figure-title defects of `Agonistas_2021-11-09.R` (line 819) and
  `surfacemarkers.R` (lines 696, 820, 941, 1061, 1181, 1301, 1420, 1540)
  concern the figure, not the fit, and are recorded in the Note column
  only.
