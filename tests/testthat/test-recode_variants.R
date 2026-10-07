# tests/testthat/test-recode_variants.R
#
# Purpose: checks of variant_table(), recode_variants() and the three
#   recoding operations (docs/v1_spec.md, sections 5 and 8.2) on the
#   synthetic aggregation table.
# Inputs: data/synthetic/synthetic_aggregation.csv through read_inputs().
# Outputs: none.

variant_ids <- c("CENTRE_A", "CENTRE_Atratadosnotratados",
                 "CENTRE_AtratadosnotratadosMPLCONTN", "CENTRE_ATNCONMPL")
genotype_levels <- c("CNTRL", "JAK2 V617F", "CALR Type I", "CALR Type II",
                     "CALR Type_Other", "MPL W515", "TN", "VARIANT")

master <- master_data("aggregation")
measures <- panel_spec("aggregation")$measures
centre_a <- master[master$Centro.Analisis == "CENTRE_A", ]

test_that("variant_table() has the four ids in order with the flags of section 5", {
  vt <- variant_table()
  expect_s3_class(vt, "data.frame")
  expect_identical(vt$variant, variant_ids)
  expect_identical(vt$centre, c(TRUE, TRUE, TRUE, TRUE))
  expect_identical(vt$treatment, c(FALSE, TRUE, TRUE, FALSE))
  expect_identical(vt$genotype, c(FALSE, FALSE, TRUE, TRUE))
  expect_identical(vt$geom, c("box", "violin", "box", "box"))
  expect_identical(vt$legacy_object, variant_ids)
  expect_true(all(c("legacy_file_aggregation", "legacy_file_hemogram",
                    "legacy_file_markers", "legacy_title_suffix") %in% names(vt)))
  expect_identical(vt$legacy_file_hemogram[4], "Hemograma_ALL_Nov9_2021CENTRE_AMPLSTN.csv")
  expect_identical(vt$legacy_title_suffix[2], "CENTRE_A tratadosVSnotratados")
})

test_that("CENTRE_A keeps exactly the 75 CENTRE_A rows and leaves every measurement unchanged", {
  rec <- recode_variants(master, "CENTRE_A")
  expect_equal(nrow(rec), 75)
  expect_equal(nrow(rec), nrow(centre_a))
  expect_true(all(rec$Centro.Analisis == "CENTRE_A"))
  expect_identical(rec$Codigo.Estudio, centre_a$Codigo.Estudio)
  for (m in measures) {
    expect_equal(rec[[m]], centre_a[[m]], info = m)
  }
  expect_identical(levels(rec$Treatment), c("Untreated", "ASA", "Anagrelide", "HU"))
  expect_identical(levels(rec$Genotype), genotype_levels[genotype_levels %in% rec$Genotype])
})

test_that("CENTRE_Atratadosnotratados collapses Treatment to Untreated and Treated", {
  rec <- recode_variants(master, "CENTRE_Atratadosnotratados")
  expect_equal(nrow(rec), 75)
  expect_identical(levels(rec$Treatment), c("Untreated", "Treated"))
  expect_equal(sum(rec$Treatment == "Treated"),
               sum(centre_a$Treatment %in% c("ASA", "Anagrelide", "HU")))
  expect_equal(sum(rec$Treatment == "Untreated"), sum(centre_a$Treatment == "Untreated"))
  expect_true("VARIANT" %in% levels(rec$Genotype))
})

test_that("CENTRE_ATNCONMPL merges VARIANT into TN", {
  rec <- recode_variants(master, "CENTRE_ATNCONMPL")
  expect_equal(nrow(rec), 75)
  expect_false("VARIANT" %in% levels(rec$Genotype))
  expect_false(any(rec$Genotype == "VARIANT"))
  expect_equal(sum(rec$Genotype == "TN"),
               sum(centre_a$Genotype %in% c("TN", "VARIANT")))
  expect_identical(levels(rec$Treatment), c("Untreated", "ASA", "Anagrelide", "HU"))
  expect_identical(levels(rec$Genotype), genotype_levels[genotype_levels %in% rec$Genotype])
})

test_that("CENTRE_AtratadosnotratadosMPLCONTN applies both recodings", {
  rec <- recode_variants(master, "CENTRE_AtratadosnotratadosMPLCONTN")
  expect_equal(nrow(rec), 75)
  expect_identical(levels(rec$Treatment), c("Untreated", "Treated"))
  expect_false("VARIANT" %in% levels(rec$Genotype))
  expect_equal(sum(rec$Treatment == "Treated"),
               sum(centre_a$Treatment %in% c("ASA", "Anagrelide", "HU")))
  expect_equal(sum(rec$Genotype == "TN"),
               sum(centre_a$Genotype %in% c("TN", "VARIANT")))
})

test_that("the recoding attribute lists the operations in order", {
  expect_identical(attr(recode_variants(master, "CENTRE_A"), "recoding"), "centre")
  expect_identical(attr(recode_variants(master, "CENTRE_Atratadosnotratados"), "recoding"),
                   c("centre", "treatment"))
  expect_identical(attr(recode_variants(master, "CENTRE_AtratadosnotratadosMPLCONTN"), "recoding"),
                   c("centre", "treatment", "genotype"))
  expect_identical(attr(recode_variants(master, "CENTRE_ATNCONMPL"), "recoding"),
                   c("centre", "genotype"))
  rec <- recode_variants(master, "CENTRE_ATNCONMPL")
  expect_identical(attr(rec, "variant"), "CENTRE_ATNCONMPL")
  expect_identical(attr(rec, "panel"), "aggregation")
  expect_identical(attr(rec, "data_label"), attr(master, "data_label"))
})

test_that("an unknown variant id errors", {
  expect_error(recode_variants(master, "CENTRE_B"))
  expect_error(recode_variants(master, "nonsense"))
})

test_that("filter_centre() errors when no row matches", {
  centre_b <- master[master$Centro.Analisis == "CENTRE_B", ]
  expect_error(filter_centre(centre_b))
  expect_equal(nrow(filter_centre(master)), 75)
  lv <- variant_levels()
  expect_identical(lv$centre_column, "Centro.Analisis")
  expect_identical(lv$centre_keep, "CENTRE_A")
  expect_identical(lv$treatment_levels, c("Untreated", "ASA", "Anagrelide", "HU"))
  expect_identical(lv$genotype_levels, genotype_levels)
  collapsed <- collapse_treatment(master)
  expect_identical(levels(collapsed$Treatment), c("Untreated", "Treated"))
  merged <- merge_variant_genotype(master)
  expect_false("VARIANT" %in% levels(merged$Genotype))
  expect_equal(sum(merged$Genotype == "TN"), sum(master$Genotype %in% c("TN", "VARIANT")))
})
