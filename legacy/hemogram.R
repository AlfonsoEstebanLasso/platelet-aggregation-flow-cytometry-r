# ----------------------------------------------------------------------------
# Legacy script from a commissioned analysis of platelet function by flow
# cytometry in essential thrombocythemia (2021), published with the written
# authorization of the principal investigator of the study. Analyses related
# to: Molecular & Cellular Proteomics 25(8):101617, 2026,
# https://doi.org/10.1016/j.mcpro.2026.101617
# Original file: hemogram.R (2021-11-09 data cut-off),
# original encoding ASCII, CRLF line endings.
# Changes with respect to the delivered file (see docs/cleaning.md): absolute
# paths replaced by data/<file>, setwd() calls disabled, the two centres
# renamed CENTRE_A and CENTRE_B, one genotype label renamed VARIANT and one
# genotype category renamed CALR Type_Other. No other change was made; the
# code is not executable without the private input data. Original SHA-256: d6d6f8667511ec95b982e6539fcf134add17fce0c0d78a2a064dcbb165e49268
# ----------------------------------------------------------------------------
library(dplyr) 
library(ggplot2)
library(ggpubr)
library(readxl)
###Hemograma:
# setwd("data")  # setwd() disabled in this release: run from the project root
Hemograma_ALL_Nov9_2021 <- read.csv2("data/Hemograma_ALL_Nov9_2021.csv")
Hemograma_ALL_Nov9_2021_tratadosnotratados <- read.csv2("data/Hemograma_ALL_Nov9_2021_tratadosnotratados.csv")
Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN <- read.csv2("data/Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN.csv")
Hemograma_ALL_Nov9_2021MPLSTN <- read.csv2("data/Hemograma_ALL_Nov9_2021MPLSTN.csv")

CENTRE_A <- read.csv2("data/Hemograma_ALL_Nov9_2021CENTRE_A.csv")
CENTRE_Atratadosnotratados <- read.csv2("data/Hemograma_ALL_Nov9_2021_CENTRE_Atratadosnotratados.csv")
CENTRE_AtratadosnotratadosMPLCONTN <- read.csv2("data/Hemograma_ALL_Nov9_2021_CENTRE_AtratadosnotratadosMPLSTN.csv")
CENTRE_ATNCONMPL <- read.csv2("data/Hemograma_ALL_Nov9_2021CENTRE_AMPLSTN.csv")


###EPO..mlU.ml.:
###EPO..mlU.ml. TRESGRUPOS:
ggplot(Hemograma_ALL_Nov9_2021,aes(factor(Genotype),EPO..mlU.ml.,label=Hemograma_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("EPO..mlU.ml.")
#Analisis de Anova TRESGRUPOS:
anova_EPO..mlU.ml. <- aov(EPO..mlU.ml. ~ Genotype, data = Hemograma_ALL_Nov9_2021)
summary(anova_EPO..mlU.ml.)
TukeyHSD(anova_EPO..mlU.ml.)

###tratadosnotratados:
ggplot( Hemograma_ALL_Nov9_2021_tratadosnotratados,aes(factor(Genotype),EPO..mlU.ml.,label= Hemograma_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("EPO..mlU.ml. tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_EPO..mlU.ml. <- aov(EPO..mlU.ml. ~ Genotype, data =  Hemograma_ALL_Nov9_2021_tratadosnotratados)
summary(anova_EPO..mlU.ml.)
TukeyHSD(anova_EPO..mlU.ml.)

###Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Genotype),EPO..mlU.ml.,label=Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("EPO..mlU.ml. tratadosVSnotratados MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_EPO..mlU.ml. <- aov(EPO..mlU.ml. ~ Genotype, data =Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_EPO..mlU.ml.)
TukeyHSD(anova_EPO..mlU.ml.)

###EPO..mlU.ml. Hemograma_ALL_Nov9_2021MPLSTN:
ggplot(Hemograma_ALL_Nov9_2021MPLSTN,aes(factor(Genotype),EPO..mlU.ml.,label=Hemograma_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("EPO..mlU.ml. MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021MPLSTN:
anova_EPO..mlU.ml. <- aov(EPO..mlU.ml. ~ Genotype, data = Hemograma_ALL_Nov9_2021MPLSTN)
summary(anova_EPO..mlU.ml.)
TukeyHSD(anova_EPO..mlU.ml.)

###EPO..mlU.ml. CENTRE_A:
ggplot(CENTRE_A,aes(factor(Genotype),EPO..mlU.ml.,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("EPO..mlU.ml. CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_EPO..mlU.ml. <- aov(EPO..mlU.ml. ~ Genotype * Genotype, data = CENTRE_A)
summary(anova_EPO..mlU.ml.)
TukeyHSD(anova_EPO..mlU.ml.)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Genotype),EPO..mlU.ml.,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("EPO..mlU.ml. CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_EPO..mlU.ml. <- aov(EPO..mlU.ml. ~ Genotype, data = CENTRE_Atratadosnotratados)
summary(anova_EPO..mlU.ml.)
TukeyHSD(anova_EPO..mlU.ml.)

###EPO..mlU.ml. CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Genotype),EPO..mlU.ml.,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("EPO..mlU.ml. CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_EPO..mlU.ml. <- aov(EPO..mlU.ml. ~ Genotype, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_EPO..mlU.ml.)
TukeyHSD(anova_EPO..mlU.ml.)

###EPO..mlU.ml. CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Genotype),EPO..mlU.ml.,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("EPO..mlU.ml. CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_EPO..mlU.ml. <- aov(EPO..mlU.ml. ~ Genotype, data = CENTRE_ATNCONMPL)
summary(anova_EPO..mlU.ml.)
TukeyHSD(anova_EPO..mlU.ml.)





###TPO..pg.ml. TRESGRUPOS:
ggplot(Hemograma_ALL_Nov9_2021,aes(factor(Genotype),TPO..pg.ml.,label=Hemograma_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("TPO..pg.ml.")
#Analisis de Anova TRESGRUPOS:
anova_TPO..pg.ml. <- aov(TPO..pg.ml. ~ Genotype, data = Hemograma_ALL_Nov9_2021)
summary(anova_TPO..pg.ml.)
TukeyHSD(anova_TPO..pg.ml.)

###tratadosnotratados:
ggplot( Hemograma_ALL_Nov9_2021_tratadosnotratados,aes(factor(Genotype),TPO..pg.ml.,label= Hemograma_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("TPO..pg.ml. tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_TPO..pg.ml. <- aov(TPO..pg.ml. ~ Genotype, data =  Hemograma_ALL_Nov9_2021_tratadosnotratados)
summary(anova_TPO..pg.ml.)
TukeyHSD(anova_TPO..pg.ml.)

###Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Genotype),TPO..pg.ml.,label=Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("TPO..pg.ml. tratadosVSnotratados MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_TPO..pg.ml. <- aov(TPO..pg.ml. ~ Genotype, data =Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_TPO..pg.ml.)
TukeyHSD(anova_TPO..pg.ml.)

###TPO..pg.ml. Hemograma_ALL_Nov9_2021MPLSTN:
ggplot(Hemograma_ALL_Nov9_2021MPLSTN,aes(factor(Genotype),TPO..pg.ml.,label=Hemograma_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("TPO..pg.ml. MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021MPLSTN:
anova_TPO..pg.ml. <- aov(TPO..pg.ml. ~ Genotype, data = Hemograma_ALL_Nov9_2021MPLSTN)
summary(anova_TPO..pg.ml.)
TukeyHSD(anova_TPO..pg.ml.)

###TPO..pg.ml. CENTRE_A:
ggplot(CENTRE_A,aes(factor(Genotype),TPO..pg.ml.,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("TPO..pg.ml. CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_TPO..pg.ml. <- aov(TPO..pg.ml. ~ Genotype, data = CENTRE_A)
summary(anova_TPO..pg.ml.)
TukeyHSD(anova_TPO..pg.ml.)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Genotype),TPO..pg.ml.,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("TPO..pg.ml. CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_TPO..pg.ml. <- aov(TPO..pg.ml. ~ Genotype, data = CENTRE_Atratadosnotratados)
summary(anova_TPO..pg.ml.)
TukeyHSD(anova_TPO..pg.ml.)

###TPO..pg.ml. CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Genotype),TPO..pg.ml.,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("TPO..pg.ml. CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_TPO..pg.ml. <- aov(TPO..pg.ml. ~ Genotype, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_TPO..pg.ml.)
TukeyHSD(anova_TPO..pg.ml.)

###TPO..pg.ml. CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Genotype),TPO..pg.ml.,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("TPO..pg.ml. CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_TPO..pg.ml. <- aov(TPO..pg.ml. ~ Genotype, data = CENTRE_ATNCONMPL)
summary(anova_TPO..pg.ml.)
TukeyHSD(anova_TPO..pg.ml.)





###HGB.gr.dl. TRESGRUPOS:
ggplot(Hemograma_ALL_Nov9_2021,aes(factor(Genotype),HGB.gr.dl.,label=Hemograma_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("HGB.gr.dl.")
#Analisis de Anova TRESGRUPOS:
anova_HGB.gr.dl. <- aov(HGB.gr.dl. ~ Genotype, data = Hemograma_ALL_Nov9_2021)
summary(anova_HGB.gr.dl.)
TukeyHSD(anova_HGB.gr.dl.)

###tratadosnotratados:
ggplot( Hemograma_ALL_Nov9_2021_tratadosnotratados,aes(factor(Genotype),HGB.gr.dl.,label= Hemograma_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("HGB.gr.dl. tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_HGB.gr.dl. <- aov(HGB.gr.dl. ~ Genotype, data =  Hemograma_ALL_Nov9_2021_tratadosnotratados)
summary(anova_HGB.gr.dl.)
TukeyHSD(anova_HGB.gr.dl.)

###Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Genotype),HGB.gr.dl.,label=Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("HGB.gr.dl. tratadosVSnotratados MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_HGB.gr.dl. <- aov(HGB.gr.dl. ~ Genotype, data =Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_HGB.gr.dl.)
TukeyHSD(anova_HGB.gr.dl.)

###HGB.gr.dl. Hemograma_ALL_Nov9_2021MPLSTN:
ggplot(Hemograma_ALL_Nov9_2021MPLSTN,aes(factor(Genotype),HGB.gr.dl.,label=Hemograma_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("HGB.gr.dl. MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021MPLSTN:
anova_HGB.gr.dl. <- aov(HGB.gr.dl. ~ Genotype, data = Hemograma_ALL_Nov9_2021MPLSTN)
summary(anova_HGB.gr.dl.)
TukeyHSD(anova_HGB.gr.dl.)

###HGB.gr.dl. CENTRE_A:
ggplot(CENTRE_A,aes(factor(Genotype),HGB.gr.dl.,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("HGB.gr.dl. CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_HGB.gr.dl. <- aov(HGB.gr.dl. ~ Genotype, data = CENTRE_A)
summary(anova_HGB.gr.dl.)
TukeyHSD(anova_HGB.gr.dl.)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Genotype),HGB.gr.dl.,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("HGB.gr.dl. CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_HGB.gr.dl. <- aov(HGB.gr.dl. ~ Genotype, data = CENTRE_Atratadosnotratados)
summary(anova_HGB.gr.dl.)
TukeyHSD(anova_HGB.gr.dl.)

###HGB.gr.dl. CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Genotype),HGB.gr.dl.,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("HGB.gr.dl. CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_HGB.gr.dl. <- aov(HGB.gr.dl. ~ Genotype, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_HGB.gr.dl.)
TukeyHSD(anova_HGB.gr.dl.)

###HGB.gr.dl. CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Genotype),HGB.gr.dl.,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("HGB.gr.dl. CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_HGB.gr.dl. <- aov(HGB.gr.dl. ~ Genotype, data = CENTRE_ATNCONMPL)
summary(anova_HGB.gr.dl.)
TukeyHSD(anova_HGB.gr.dl.)






###HCT.... TRESGRUPOS:
ggplot(Hemograma_ALL_Nov9_2021,aes(factor(Genotype),HCT....,label=Hemograma_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("HCT....")
#Analisis de Anova TRESGRUPOS:
anova_HCT.... <- aov(HCT.... ~ Genotype, data = Hemograma_ALL_Nov9_2021)
summary(anova_HCT....)
TukeyHSD(anova_HCT....)

###tratadosnotratados:
ggplot( Hemograma_ALL_Nov9_2021_tratadosnotratados,aes(factor(Genotype),HCT....,label= Hemograma_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("HCT.... tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_HCT.... <- aov(HCT.... ~ Genotype, data =  Hemograma_ALL_Nov9_2021_tratadosnotratados)
summary(anova_HCT....)
TukeyHSD(anova_HCT....)

###Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Genotype),HCT....,label=Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("HCT.... tratadosVSnotratados MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_HCT.... <- aov(HCT.... ~ Genotype, data =Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_HCT....)
TukeyHSD(anova_HCT....)

###HCT.... Hemograma_ALL_Nov9_2021MPLSTN:
ggplot(Hemograma_ALL_Nov9_2021MPLSTN,aes(factor(Genotype),HCT....,label=Hemograma_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("HCT.... MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021MPLSTN:
anova_HCT.... <- aov(HCT.... ~ Genotype, data = Hemograma_ALL_Nov9_2021MPLSTN)
summary(anova_HCT....)
TukeyHSD(anova_HCT....)

###HCT.... CENTRE_A:
ggplot(CENTRE_A,aes(factor(Genotype),HCT....,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("HCT.... CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_HCT.... <- aov(HCT.... ~ Genotype, data = CENTRE_A)
summary(anova_HCT....)
TukeyHSD(anova_HCT....)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Genotype),HCT....,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("HCT.... CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_HCT.... <- aov(HCT.... ~ Genotype, data = CENTRE_Atratadosnotratados)
summary(anova_HCT....)
TukeyHSD(anova_HCT....)

###HCT.... CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Genotype),HCT....,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("HCT.... CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_HCT.... <- aov(HCT.... ~ Genotype, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_HCT....)
TukeyHSD(anova_HCT....)

###HCT.... CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Genotype),HCT....,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("HCT.... CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_HCT.... <- aov(HCT.... ~ Genotype, data = CENTRE_ATNCONMPL)
summary(anova_HCT....)
TukeyHSD(anova_HCT....)






###MCH..pg. TRESGRUPOS:
ggplot(Hemograma_ALL_Nov9_2021,aes(factor(Genotype),MCH..pg.,label=Hemograma_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("MCH..pg.")
#Analisis de Anova TRESGRUPOS:
anova_MCH..pg. <- aov(MCH..pg. ~ Genotype, data = Hemograma_ALL_Nov9_2021)
summary(anova_MCH..pg.)
TukeyHSD(anova_MCH..pg.)

###tratadosnotratados:
ggplot( Hemograma_ALL_Nov9_2021_tratadosnotratados,aes(factor(Genotype),MCH..pg.,label= Hemograma_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("MCH..pg. tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_MCH..pg. <- aov(MCH..pg. ~ Genotype, data =  Hemograma_ALL_Nov9_2021_tratadosnotratados)
summary(anova_MCH..pg.)
TukeyHSD(anova_MCH..pg.)

###Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Genotype),MCH..pg.,label=Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("MCH..pg. tratadosVSnotratados MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_MCH..pg. <- aov(MCH..pg. ~ Genotype, data =Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_MCH..pg.)
TukeyHSD(anova_MCH..pg.)

###MCH..pg. Hemograma_ALL_Nov9_2021MPLSTN:
ggplot(Hemograma_ALL_Nov9_2021MPLSTN,aes(factor(Genotype),MCH..pg.,label=Hemograma_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("MCH..pg. MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021MPLSTN:
anova_MCH..pg. <- aov(MCH..pg. ~ Genotype, data = Hemograma_ALL_Nov9_2021MPLSTN)
summary(anova_MCH..pg.)
TukeyHSD(anova_MCH..pg.)

###MCH..pg. CENTRE_A:
ggplot(CENTRE_A,aes(factor(Genotype),MCH..pg.,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("MCH..pg. CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_MCH..pg. <- aov(MCH..pg. ~ Genotype, data = CENTRE_A)
summary(anova_MCH..pg.)
TukeyHSD(anova_MCH..pg.)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Genotype),MCH..pg.,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("MCH..pg. CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_MCH..pg. <- aov(MCH..pg. ~ Genotype, data = CENTRE_Atratadosnotratados)
summary(anova_MCH..pg.)
TukeyHSD(anova_MCH..pg.)

###MCH..pg. CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Genotype),MCH..pg.,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("MCH..pg. CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_MCH..pg. <- aov(MCH..pg. ~ Genotype, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_MCH..pg.)
TukeyHSD(anova_MCH..pg.)

###MCH..pg. CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Genotype),MCH..pg.,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("MCH..pg. CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_MCH..pg. <- aov(MCH..pg. ~ Genotype, data = CENTRE_ATNCONMPL)
summary(anova_MCH..pg.)
TukeyHSD(anova_MCH..pg.)






###MCHC..gr.dl. TRESGRUPOS:
ggplot(Hemograma_ALL_Nov9_2021,aes(factor(Genotype),MCHC..gr.dl.,label=Hemograma_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("MCHC..gr.dl.")
#Analisis de Anova TRESGRUPOS:
anova_MCHC..gr.dl. <- aov(MCHC..gr.dl. ~ Genotype, data = Hemograma_ALL_Nov9_2021)
summary(anova_MCHC..gr.dl.)
TukeyHSD(anova_MCHC..gr.dl.)

###tratadosnotratados:
ggplot( Hemograma_ALL_Nov9_2021_tratadosnotratados,aes(factor(Genotype),MCHC..gr.dl.,label= Hemograma_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("MCHC..gr.dl. tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_MCHC..gr.dl. <- aov(MCHC..gr.dl. ~ Genotype, data =  Hemograma_ALL_Nov9_2021_tratadosnotratados)
summary(anova_MCHC..gr.dl.)
TukeyHSD(anova_MCHC..gr.dl.)

###Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Genotype),MCHC..gr.dl.,label=Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("MCHC..gr.dl. tratadosVSnotratados MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_MCHC..gr.dl. <- aov(MCHC..gr.dl. ~ Genotype, data =Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_MCHC..gr.dl.)
TukeyHSD(anova_MCHC..gr.dl.)

###MCHC..gr.dl. Hemograma_ALL_Nov9_2021MPLSTN:
ggplot(Hemograma_ALL_Nov9_2021MPLSTN,aes(factor(Genotype),MCHC..gr.dl.,label=Hemograma_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("MCHC..gr.dl. MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021MPLSTN:
anova_MCHC..gr.dl. <- aov(MCHC..gr.dl. ~ Genotype, data = Hemograma_ALL_Nov9_2021MPLSTN)
summary(anova_MCHC..gr.dl.)
TukeyHSD(anova_MCHC..gr.dl.)

###MCHC..gr.dl. CENTRE_A:
ggplot(CENTRE_A,aes(factor(Genotype),MCHC..gr.dl.,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("MCHC..gr.dl. CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_MCHC..gr.dl. <- aov(MCHC..gr.dl. ~ Genotype, data = CENTRE_A)
summary(anova_MCHC..gr.dl.)
TukeyHSD(anova_MCHC..gr.dl.)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Genotype),MCHC..gr.dl.,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("MCHC..gr.dl. CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_MCHC..gr.dl. <- aov(MCHC..gr.dl. ~ Genotype, data = CENTRE_Atratadosnotratados)
summary(anova_MCHC..gr.dl.)
TukeyHSD(anova_MCHC..gr.dl.)

###MCHC..gr.dl. CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Genotype),MCHC..gr.dl.,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("MCHC..gr.dl. CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_MCHC..gr.dl. <- aov(MCHC..gr.dl. ~ Genotype, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_MCHC..gr.dl.)
TukeyHSD(anova_MCHC..gr.dl.)

###MCHC..gr.dl. CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Genotype),MCHC..gr.dl.,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("MCHC..gr.dl. CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_MCHC..gr.dl. <- aov(MCHC..gr.dl. ~ Genotype, data = CENTRE_ATNCONMPL)
summary(anova_MCHC..gr.dl.)
TukeyHSD(anova_MCHC..gr.dl.)






###Lymph. TRESGRUPOS:
ggplot(Hemograma_ALL_Nov9_2021,aes(factor(Genotype),Lymph.,label=Hemograma_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Lymph.")
#Analisis de Anova TRESGRUPOS:
anova_Lymph. <- aov(Lymph. ~ Genotype, data = Hemograma_ALL_Nov9_2021)
summary(anova_Lymph.)
TukeyHSD(anova_Lymph.)

###tratadosnotratados:
ggplot( Hemograma_ALL_Nov9_2021_tratadosnotratados,aes(factor(Genotype),Lymph.,label= Hemograma_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Lymph. tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_Lymph. <- aov(Lymph. ~ Genotype, data =  Hemograma_ALL_Nov9_2021_tratadosnotratados)
summary(anova_Lymph.)
TukeyHSD(anova_Lymph.)

###Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Genotype),Lymph.,label=Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Lymph. tratadosVSnotratados MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_Lymph. <- aov(Lymph. ~ Genotype, data =Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_Lymph.)
TukeyHSD(anova_Lymph.)

###Lymph. Hemograma_ALL_Nov9_2021MPLSTN:
ggplot(Hemograma_ALL_Nov9_2021MPLSTN,aes(factor(Genotype),Lymph.,label=Hemograma_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Lymph. MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021MPLSTN:
anova_Lymph. <- aov(Lymph. ~ Genotype, data = Hemograma_ALL_Nov9_2021MPLSTN)
summary(anova_Lymph.)
TukeyHSD(anova_Lymph.)

###Lymph. CENTRE_A:
ggplot(CENTRE_A,aes(factor(Genotype),Lymph.,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Lymph. CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_Lymph. <- aov(Lymph. ~ Genotype, data = CENTRE_A)
summary(anova_Lymph.)
TukeyHSD(anova_Lymph.)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Genotype),Lymph.,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Lymph. CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_Lymph. <- aov(Lymph. ~ Genotype, data = CENTRE_Atratadosnotratados)
summary(anova_Lymph.)
TukeyHSD(anova_Lymph.)

###Lymph. CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Genotype),Lymph.,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Lymph. CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_Lymph. <- aov(Lymph. ~ Genotype, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_Lymph.)
TukeyHSD(anova_Lymph.)

###Lymph. CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Genotype),Lymph.,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Lymph. CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_Lymph. <- aov(Lymph. ~ Genotype, data = CENTRE_ATNCONMPL)
summary(anova_Lymph.)
TukeyHSD(anova_Lymph.)






###Mono. TRESGRUPOS:
ggplot(Hemograma_ALL_Nov9_2021,aes(factor(Genotype),Mono.,label=Hemograma_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Mono.")
#Analisis de Anova TRESGRUPOS:
anova_Mono. <- aov(Mono. ~ Genotype, data = Hemograma_ALL_Nov9_2021)
summary(anova_Mono.)
TukeyHSD(anova_Mono.)

###tratadosnotratados:
ggplot( Hemograma_ALL_Nov9_2021_tratadosnotratados,aes(factor(Genotype),Mono.,label= Hemograma_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Mono. tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_Mono. <- aov(Mono. ~ Genotype, data =  Hemograma_ALL_Nov9_2021_tratadosnotratados)
summary(anova_Mono.)
TukeyHSD(anova_Mono.)

###Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Genotype),Mono.,label=Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Mono. tratadosVSnotratados MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_Mono. <- aov(Mono. ~ Genotype, data =Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_Mono.)
TukeyHSD(anova_Mono.)

###Mono. Hemograma_ALL_Nov9_2021MPLSTN:
ggplot(Hemograma_ALL_Nov9_2021MPLSTN,aes(factor(Genotype),Mono.,label=Hemograma_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Mono. MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021MPLSTN:
anova_Mono. <- aov(Mono. ~ Genotype, data = Hemograma_ALL_Nov9_2021MPLSTN)
summary(anova_Mono.)
TukeyHSD(anova_Mono.)

###Mono. CENTRE_A:
ggplot(CENTRE_A,aes(factor(Genotype),Mono.,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Mono. CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_Mono. <- aov(Mono. ~ Genotype, data = CENTRE_A)
summary(anova_Mono.)
TukeyHSD(anova_Mono.)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Genotype),Mono.,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Mono. CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_Mono. <- aov(Mono. ~ Genotype, data = CENTRE_Atratadosnotratados)
summary(anova_Mono.)
TukeyHSD(anova_Mono.)

###Mono. CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Genotype),Mono.,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Mono. CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_Mono. <- aov(Mono. ~ Genotype, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_Mono.)
TukeyHSD(anova_Mono.)

###Mono. CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Genotype),Mono.,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Mono. CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_Mono. <- aov(Mono. ~ Genotype, data = CENTRE_ATNCONMPL)
summary(anova_Mono.)
TukeyHSD(anova_Mono.)






###Eos. TRESGRUPOS:
ggplot(Hemograma_ALL_Nov9_2021,aes(factor(Genotype),Eos.,label=Hemograma_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Eos.")
#Analisis de Anova TRESGRUPOS:
anova_Eos. <- aov(Eos. ~ Genotype, data = Hemograma_ALL_Nov9_2021)
summary(anova_Eos.)
TukeyHSD(anova_Eos.)

###tratadosnotratados:
ggplot( Hemograma_ALL_Nov9_2021_tratadosnotratados,aes(factor(Genotype),Eos.,label= Hemograma_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Eos. tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_Eos. <- aov(Eos. ~ Genotype, data =  Hemograma_ALL_Nov9_2021_tratadosnotratados)
summary(anova_Eos.)
TukeyHSD(anova_Eos.)

###Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Genotype),Eos.,label=Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Eos. tratadosVSnotratados MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_Eos. <- aov(Eos. ~ Genotype, data =Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_Eos.)
TukeyHSD(anova_Eos.)

###Eos. Hemograma_ALL_Nov9_2021MPLSTN:
ggplot(Hemograma_ALL_Nov9_2021MPLSTN,aes(factor(Genotype),Eos.,label=Hemograma_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Eos. MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021MPLSTN:
anova_Eos. <- aov(Eos. ~ Genotype, data = Hemograma_ALL_Nov9_2021MPLSTN)
summary(anova_Eos.)
TukeyHSD(anova_Eos.)

###Eos. CENTRE_A:
ggplot(CENTRE_A,aes(factor(Genotype),Eos.,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Eos. CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_Eos. <- aov(Eos. ~ Genotype, data = CENTRE_A)
summary(anova_Eos.)
TukeyHSD(anova_Eos.)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Genotype),Eos.,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Eos. CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_Eos. <- aov(Eos. ~ Genotype, data = CENTRE_Atratadosnotratados)
summary(anova_Eos.)
TukeyHSD(anova_Eos.)

###Eos. CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Genotype),Eos.,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Eos. CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_Eos. <- aov(Eos. ~ Genotype, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_Eos.)
TukeyHSD(anova_Eos.)

###Eos. CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Genotype),Eos.,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Eos. CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_Eos. <- aov(Eos. ~ Genotype, data = CENTRE_ATNCONMPL)
summary(anova_Eos.)
TukeyHSD(anova_Eos.)







###Baso. TRESGRUPOS:
ggplot(Hemograma_ALL_Nov9_2021,aes(factor(Genotype),Baso.,label=Hemograma_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Baso.")
#Analisis de Anova TRESGRUPOS:
anova_Baso. <- aov(Baso. ~ Genotype, data = Hemograma_ALL_Nov9_2021)
summary(anova_Baso.)
TukeyHSD(anova_Baso.)

###tratadosnotratados:
ggplot( Hemograma_ALL_Nov9_2021_tratadosnotratados,aes(factor(Genotype),Baso.,label= Hemograma_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Baso. tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_Baso. <- aov(Baso. ~ Genotype, data =  Hemograma_ALL_Nov9_2021_tratadosnotratados)
summary(anova_Baso.)
TukeyHSD(anova_Baso.)

###Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Genotype),Baso.,label=Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Baso. tratadosVSnotratados MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_Baso. <- aov(Baso. ~ Genotype, data =Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_Baso.)
TukeyHSD(anova_Baso.)

###Baso. Hemograma_ALL_Nov9_2021MPLSTN:
ggplot(Hemograma_ALL_Nov9_2021MPLSTN,aes(factor(Genotype),Baso.,label=Hemograma_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Baso. MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021MPLSTN:
anova_Baso. <- aov(Baso. ~ Genotype, data = Hemograma_ALL_Nov9_2021MPLSTN)
summary(anova_Baso.)
TukeyHSD(anova_Baso.)

###Baso. CENTRE_A:
ggplot(CENTRE_A,aes(factor(Genotype),Baso.,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Baso. CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_Baso. <- aov(Baso. ~ Genotype, data = CENTRE_A)
summary(anova_Baso.)
TukeyHSD(anova_Baso.)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Genotype),Baso.,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Baso. CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_Baso. <- aov(Baso. ~ Genotype, data = CENTRE_Atratadosnotratados)
summary(anova_Baso.)
TukeyHSD(anova_Baso.)

###Baso. CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Genotype),Baso.,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Baso. CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_Baso. <- aov(Baso. ~ Genotype, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_Baso.)
TukeyHSD(anova_Baso.)

###Baso. CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Genotype),Baso.,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Baso. CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_Baso. <- aov(Baso. ~ Genotype, data = CENTRE_ATNCONMPL)
summary(anova_Baso.)
TukeyHSD(anova_Baso.)





###Lymph..10.6.ml. TRESGRUPOS:
ggplot(Hemograma_ALL_Nov9_2021,aes(factor(Genotype),Lymph..10.6.ml.,label=Hemograma_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Lymph..10.6.ml.")
#Analisis de Anova TRESGRUPOS:
anova_Lymph..10.6.ml. <- aov(Lymph..10.6.ml. ~ Genotype, data = Hemograma_ALL_Nov9_2021)
summary(anova_Lymph..10.6.ml.)
TukeyHSD(anova_Lymph..10.6.ml.)

###tratadosnotratados:
ggplot( Hemograma_ALL_Nov9_2021_tratadosnotratados,aes(factor(Genotype),Lymph..10.6.ml.,label= Hemograma_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Lymph..10.6.ml. tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_Lymph..10.6.ml. <- aov(Lymph..10.6.ml. ~ Genotype, data =  Hemograma_ALL_Nov9_2021_tratadosnotratados)
summary(anova_Lymph..10.6.ml.)
TukeyHSD(anova_Lymph..10.6.ml.)

###Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Genotype),Lymph..10.6.ml.,label=Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Lymph..10.6.ml. tratadosVSnotratados MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_Lymph..10.6.ml. <- aov(Lymph..10.6.ml. ~ Genotype, data =Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_Lymph..10.6.ml.)
TukeyHSD(anova_Lymph..10.6.ml.)

###Lymph..10.6.ml. Hemograma_ALL_Nov9_2021MPLSTN:
ggplot(Hemograma_ALL_Nov9_2021MPLSTN,aes(factor(Genotype),Lymph..10.6.ml.,label=Hemograma_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Lymph..10.6.ml. MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021MPLSTN:
anova_Lymph..10.6.ml. <- aov(Lymph..10.6.ml. ~ Genotype, data = Hemograma_ALL_Nov9_2021MPLSTN)
summary(anova_Lymph..10.6.ml.)
TukeyHSD(anova_Lymph..10.6.ml.)

###Lymph..10.6.ml. CENTRE_A:
ggplot(CENTRE_A,aes(factor(Genotype),Lymph..10.6.ml.,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Lymph..10.6.ml. CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_Lymph..10.6.ml. <- aov(Lymph..10.6.ml. ~ Genotype, data = CENTRE_A)
summary(anova_Lymph..10.6.ml.)
TukeyHSD(anova_Lymph..10.6.ml.)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Genotype),Lymph..10.6.ml.,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Lymph..10.6.ml. CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_Lymph..10.6.ml. <- aov(Lymph..10.6.ml. ~ Genotype, data = CENTRE_Atratadosnotratados)
summary(anova_Lymph..10.6.ml.)
TukeyHSD(anova_Lymph..10.6.ml.)

###Lymph..10.6.ml. CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Genotype),Lymph..10.6.ml.,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Lymph..10.6.ml. CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_Lymph..10.6.ml. <- aov(Lymph..10.6.ml. ~ Genotype, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_Lymph..10.6.ml.)
TukeyHSD(anova_Lymph..10.6.ml.)

###Lymph..10.6.ml. CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Genotype),Lymph..10.6.ml.,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Lymph..10.6.ml. CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_Lymph..10.6.ml. <- aov(Lymph..10.6.ml. ~ Genotype, data = CENTRE_ATNCONMPL)
summary(anova_Lymph..10.6.ml.)
TukeyHSD(anova_Lymph..10.6.ml.)






###Mono..10.6.ml. TRESGRUPOS:
ggplot(Hemograma_ALL_Nov9_2021,aes(factor(Genotype),Mono..10.6.ml.,label=Hemograma_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Mono..10.6.ml.")
#Analisis de Anova TRESGRUPOS:
anova_Mono..10.6.ml. <- aov(Mono..10.6.ml. ~ Genotype, data = Hemograma_ALL_Nov9_2021)
summary(anova_Mono..10.6.ml.)
TukeyHSD(anova_Mono..10.6.ml.)

###tratadosnotratados:
ggplot( Hemograma_ALL_Nov9_2021_tratadosnotratados,aes(factor(Genotype),Mono..10.6.ml.,label= Hemograma_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Mono..10.6.ml. tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_Mono..10.6.ml. <- aov(Mono..10.6.ml. ~ Genotype, data =  Hemograma_ALL_Nov9_2021_tratadosnotratados)
summary(anova_Mono..10.6.ml.)
TukeyHSD(anova_Mono..10.6.ml.)

###Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Genotype),Mono..10.6.ml.,label=Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Mono..10.6.ml. tratadosVSnotratados MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_Mono..10.6.ml. <- aov(Mono..10.6.ml. ~ Genotype, data =Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_Mono..10.6.ml.)
TukeyHSD(anova_Mono..10.6.ml.)

###Mono..10.6.ml. Hemograma_ALL_Nov9_2021MPLSTN:
ggplot(Hemograma_ALL_Nov9_2021MPLSTN,aes(factor(Genotype),Mono..10.6.ml.,label=Hemograma_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Mono..10.6.ml. MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021MPLSTN:
anova_Mono..10.6.ml. <- aov(Mono..10.6.ml. ~ Genotype, data = Hemograma_ALL_Nov9_2021MPLSTN)
summary(anova_Mono..10.6.ml.)
TukeyHSD(anova_Mono..10.6.ml.)

###Mono..10.6.ml. CENTRE_A:
ggplot(CENTRE_A,aes(factor(Genotype),Mono..10.6.ml.,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Mono..10.6.ml. CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_Mono..10.6.ml. <- aov(Mono..10.6.ml. ~ Genotype, data = CENTRE_A)
summary(anova_Mono..10.6.ml.)
TukeyHSD(anova_Mono..10.6.ml.)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Genotype),Mono..10.6.ml.,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Mono..10.6.ml. CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_Mono..10.6.ml. <- aov(Mono..10.6.ml. ~ Genotype, data = CENTRE_Atratadosnotratados)
summary(anova_Mono..10.6.ml.)
TukeyHSD(anova_Mono..10.6.ml.)

###Mono..10.6.ml. CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Genotype),Mono..10.6.ml.,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Mono..10.6.ml. CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_Mono..10.6.ml. <- aov(Mono..10.6.ml. ~ Genotype, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_Mono..10.6.ml.)
TukeyHSD(anova_Mono..10.6.ml.)

###Mono..10.6.ml. CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Genotype),Mono..10.6.ml.,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Mono..10.6.ml. CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_Mono..10.6.ml. <- aov(Mono..10.6.ml. ~ Genotype, data = CENTRE_ATNCONMPL)
summary(anova_Mono..10.6.ml.)
TukeyHSD(anova_Mono..10.6.ml.)





###Eos..10.6.ml. TRESGRUPOS:
ggplot(Hemograma_ALL_Nov9_2021,aes(factor(Genotype),Eos..10.6.ml.,label=Hemograma_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Eos..10.6.ml.")
#Analisis de Anova TRESGRUPOS:
anova_Eos..10.6.ml. <- aov(Eos..10.6.ml. ~ Genotype, data = Hemograma_ALL_Nov9_2021)
summary(anova_Eos..10.6.ml.)
TukeyHSD(anova_Eos..10.6.ml.)

###tratadosnotratados:
ggplot( Hemograma_ALL_Nov9_2021_tratadosnotratados,aes(factor(Genotype),Eos..10.6.ml.,label= Hemograma_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Eos..10.6.ml. tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_Eos..10.6.ml. <- aov(Eos..10.6.ml. ~ Genotype, data =  Hemograma_ALL_Nov9_2021_tratadosnotratados)
summary(anova_Eos..10.6.ml.)
TukeyHSD(anova_Eos..10.6.ml.)

###Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Genotype),Eos..10.6.ml.,label=Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Eos..10.6.ml. tratadosVSnotratados MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_Eos..10.6.ml. <- aov(Eos..10.6.ml. ~ Genotype, data =Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_Eos..10.6.ml.)
TukeyHSD(anova_Eos..10.6.ml.)

###Eos..10.6.ml. Hemograma_ALL_Nov9_2021MPLSTN:
ggplot(Hemograma_ALL_Nov9_2021MPLSTN,aes(factor(Genotype),Eos..10.6.ml.,label=Hemograma_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Eos..10.6.ml. MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021MPLSTN:
anova_Eos..10.6.ml. <- aov(Eos..10.6.ml. ~ Genotype, data = Hemograma_ALL_Nov9_2021MPLSTN)
summary(anova_Eos..10.6.ml.)
TukeyHSD(anova_Eos..10.6.ml.)

###Eos..10.6.ml. CENTRE_A:
ggplot(CENTRE_A,aes(factor(Genotype),Eos..10.6.ml.,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Eos..10.6.ml. CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_Eos..10.6.ml. <- aov(Eos..10.6.ml. ~ Genotype, data = CENTRE_A)
(anova_Eos..10.6.ml.)
TukeyHSD(anova_Eos..10.6.ml.)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Genotype),Eos..10.6.ml.,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Eos..10.6.ml. CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_Eos..10.6.ml. <- aov(Eos..10.6.ml. ~ Genotype, data = CENTRE_Atratadosnotratados)
summary(anova_Eos..10.6.ml.)
TukeyHSD(anova_Eos..10.6.ml.)

###Eos..10.6.ml. CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Genotype),Eos..10.6.ml.,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Eos..10.6.ml. CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_Eos..10.6.ml. <- aov(Eos..10.6.ml. ~ Genotype, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_Eos..10.6.ml.)
TukeyHSD(anova_Eos..10.6.ml.)

###Eos..10.6.ml. CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Genotype),Eos..10.6.ml.,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Eos..10.6.ml. CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_Eos..10.6.ml. <- aov(Eos..10.6.ml. ~ Genotype, data = CENTRE_ATNCONMPL)
summary(anova_Eos..10.6.ml.)
TukeyHSD(anova_Eos..10.6.ml.)






###Baso..10.6.ml. TRESGRUPOS:
ggplot(Hemograma_ALL_Nov9_2021,aes(factor(Genotype),Baso..10.6.ml.,label=Hemograma_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Baso..10.6.ml.")
#Analisis de Anova TRESGRUPOS:
anova_Baso..10.6.ml. <- aov(Baso..10.6.ml. ~ Genotype, data = Hemograma_ALL_Nov9_2021)
summary(anova_Baso..10.6.ml.)
TukeyHSD(anova_Baso..10.6.ml.)

###tratadosnotratados:
ggplot( Hemograma_ALL_Nov9_2021_tratadosnotratados,aes(factor(Genotype),Baso..10.6.ml.,label= Hemograma_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Baso..10.6.ml. tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_Baso..10.6.ml. <- aov(Baso..10.6.ml. ~ Genotype, data =  Hemograma_ALL_Nov9_2021_tratadosnotratados)
summary(anova_Baso..10.6.ml.)
TukeyHSD(anova_Baso..10.6.ml.)

###Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Genotype),Baso..10.6.ml.,label=Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("Baso..10.6.ml. tratadosVSnotratados MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_Baso..10.6.ml. <- aov(Baso..10.6.ml. ~ Genotype, data =Hemograma_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_Baso..10.6.ml.)
TukeyHSD(anova_Baso..10.6.ml.)

###Baso..10.6.ml. Hemograma_ALL_Nov9_2021MPLSTN:
ggplot(Hemograma_ALL_Nov9_2021MPLSTN,aes(factor(Genotype),Baso..10.6.ml.,label=Hemograma_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Baso..10.6.ml. MPL CON TN")
#Analisis de Anova Hemograma_ALL_Nov9_2021MPLSTN:
anova_Baso..10.6.ml. <- aov(Baso..10.6.ml. ~ Genotype, data = Hemograma_ALL_Nov9_2021MPLSTN)
summary(anova_Baso..10.6.ml.)
TukeyHSD(anova_Baso..10.6.ml.)

###Baso..10.6.ml. CENTRE_A:
ggplot(CENTRE_A,aes(factor(Genotype),Baso..10.6.ml.,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Baso..10.6.ml. CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_Baso..10.6.ml. <- aov(Baso..10.6.ml. ~ Genotype, data = CENTRE_A)
summary(anova_Baso..10.6.ml.)
TukeyHSD(anova_Baso..10.6.ml.)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Genotype),Baso..10.6.ml.,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Baso..10.6.ml. CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_Baso..10.6.ml. <- aov(Baso..10.6.ml. ~ Genotype, data = CENTRE_Atratadosnotratados)
summary(anova_Baso..10.6.ml.)
TukeyHSD(anova_Baso..10.6.ml.)

###Baso..10.6.ml. CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Genotype),Baso..10.6.ml.,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Baso..10.6.ml. CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_Baso..10.6.ml. <- aov(Baso..10.6.ml. ~ Genotype, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_Baso..10.6.ml.)
TukeyHSD(anova_Baso..10.6.ml.)

###Baso..10.6.ml. CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Genotype),Baso..10.6.ml.,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Genotype)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid() +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("Baso..10.6.ml. CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_Baso..10.6.ml. <- aov(Baso..10.6.ml. ~ Genotype, data = CENTRE_ATNCONMPL)
summary(anova_Baso..10.6.ml.)
TukeyHSD(anova_Baso..10.6.ml.)

