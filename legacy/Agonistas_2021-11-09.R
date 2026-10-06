# ----------------------------------------------------------------------------
# Legacy script from a commissioned analysis of platelet function by flow
# cytometry in essential thrombocythemia (2021), published with the written
# authorization of the principal investigator of the study. Analyses related
# to: Molecular & Cellular Proteomics 25(8):101617, 2026,
# https://doi.org/10.1016/j.mcpro.2026.101617
# Original file: Agonistas.R, later version with the 2021-11-09 data cut-off (first centre only),
# original encoding ASCII, LF line endings.
# Changes with respect to the delivered file (see docs/cleaning.md): absolute
# paths replaced by data/<file>, setwd() calls disabled, the two centres
# renamed CENTRE_A and CENTRE_B, one genotype label renamed VARIANT and one
# genotype category renamed CALR Type_Other. No other change was made; the
# code is not executable without the private input data. Original SHA-256: a73fe339f0c4dcb14398eca90613578f74f5b638ea9422bf77d3675029b95077
# ----------------------------------------------------------------------------
library(dplyr) 
library(ggplot2)
library(ggpubr)
library(readxl)
###Agonistas:
# setwd("data")  # setwd() disabled in this release: run from the project root
FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS <-read_excel("FCA_aggregation_filtered_NA9112021.xlsx")#Este dataset agrupa tratamientos en ASA, Anagrelide y HU.
FCA_aggregation_filtered_NA9112021MPLSTN <- read.csv("FCA_aggregation_filtered_NA9112021MPLSTN.csv", sep=";")
FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados <- read_excel("FCA_aggregation_filtered_NA9112021_tratadosnotratados.xlsx")##Este dataset es juntando todos los tratamientos para ver las comparaciones entre tratados y no tratados.
FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN <- read.csv("FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN.csv", sep=";")
CENTRE_A <- read.csv2("CENTRE_A.csv")
CENTRE_ATNCONMPL <- read.csv2("CENTRE_ATNCONMPL.csv")
CENTRE_Atratadosnotratados <- read.csv2("CENTRE_Atratadosnotratados.csv")
CENTRE_AtratadosnotratadosMPLCONTN <- read.csv2("CENTRE_AtratadosnotratadosMPLCONTN.csv")

#Overview genero/tratamiento PTRESGRUPOS:
df <- FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS %>%
  filter(Gender %in% c("F", "M", " ")) %>%
  group_by(Treatment, Gender) %>%
  summarise(counts = n())

df <- df %>%
  arrange(Treatment, desc(Gender)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Gender, fill = Gender), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Gender),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) + 
  ggtitle("genero/tratamiento")
#Overview genotipo/tratamiento PTRESGRUPOS:
df1 <- FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS %>%
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN")) %>%
  group_by(Treatment, Genotype) %>%
  summarise(counts = n())

df1 <- df1 %>%
  arrange(Treatment, desc(Genotype)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df1, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Genotype, fill = Genotype), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Genotype),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) + 
  ggtitle("genotipo/tratamiento")
#Overview genero/tratamiento tratadosnotratados:
df <- FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados %>%
  filter(Gender %in% c("F", "M", " ")) %>%
  group_by(Treatment, Gender) %>%
  summarise(counts = n())

df <- df %>%
  arrange(Treatment, desc(Gender)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Gender, fill = Gender), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Gender),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) + 
  ggtitle("genero/tratamiento tratadosVSnotratados")
#Overview genotipo/tratamiento tratadosnotratados:
df1 <- FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados %>%
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN")) %>%
  group_by(Treatment, Genotype) %>%
  summarise(counts = n())

df1 <- df1 %>%
  arrange(Treatment, desc(Genotype)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df1, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Genotype, fill = Genotype), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Genotype),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) + 
  ggtitle("genero/tratamiento tratadosVSnotratados")
#Overview genero/tratamiento  FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
df <- FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN %>%
  filter(Gender %in% c("F", "M", " ")) %>%
  group_by(Treatment, Gender) %>%
  summarise(counts = n())

df <- df %>%
  arrange(Treatment, desc(Gender)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Gender, fill = Gender), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Gender),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) + 
  ggtitle("genero/tratamiento tratadosVSnotratados MPLSTN")
#Overview genotipo/tratamiento  FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
df1 <- FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN %>%
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN")) %>%
  group_by(Treatment, Genotype) %>%
  summarise(counts = n())

df1 <- df1 %>%
  arrange(Treatment, desc(Genotype)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df1, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Genotype, fill = Genotype), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Genotype),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) + 
  ggtitle("genotipo/tratamiento  tratadosVSnotratados MPLSTN")
#Overview genero/tratamiento FCA_aggregation_filtered_NA9112021MPLSTN:
df <- FCA_aggregation_filtered_NA9112021MPLSTN %>%
  filter(Gender %in% c("F", "M", " ")) %>%
  group_by(Treatment, Gender) %>%
  summarise(counts = n())

df <- df %>%
  arrange(Treatment, desc(Gender)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Gender, fill = Gender), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Gender),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) + 
  ggtitle("genero/tratamiento MPLSTN")

#Overview genotipo/tratamiento FCA_aggregation_filtered_NA91120211MPLSTN:
df1 <- FCA_aggregation_filtered_NA9112021MPLSTN %>%
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN")) %>%
  group_by(Treatment, Genotype) %>%
  summarise(counts = n())

df1 <- df1 %>%
  arrange(Treatment, desc(Genotype)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df1, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Genotype, fill = Genotype), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Genotype),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) + 
  ggtitle("genotipo/tratamiento MPLSTN")


#Overview genero/tratamiento CENTRE_A:
df <- CENTRE_A %>%
  filter(Gender %in% c("F", "M", " ")) %>%
  group_by(Treatment, Gender) %>%
  summarise(counts = n())

df <- df %>%
  arrange(Treatment, desc(Gender)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Gender, fill = Gender), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Gender),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) + 
  ggtitle("genero/tratamiento CENTRE_A")
#Overview genotipo/tratamiento CENTRE_A:
df1 <- CENTRE_A %>%
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN")) %>%
  group_by(Treatment, Genotype) %>%
  summarise(counts = n())

df1 <- df1 %>%
  arrange(Treatment, desc(Genotype)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df1, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Genotype, fill = Genotype), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Genotype),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) + 
  ggtitle("genotipo/tratamiento CENTRE_A")
#Overview genero/tratamiento CENTRE_Atratadosnotratados:
df <- CENTRE_Atratadosnotratados %>%
  filter(Gender %in% c("F", "M", " ")) %>%
  group_by(Treatment, Gender) %>%
  summarise(counts = n())

df <- df %>%
  arrange(Treatment, desc(Gender)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Gender, fill = Gender), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Gender),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) + 
  ggtitle("genero/tratamiento CENTRE_A tratadosVSnotratados")
#Overview genotipo/tratamiento CENTRE_Atratadosnotratados:
df1 <- CENTRE_Atratadosnotratados %>%
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN")) %>%
  group_by(Treatment, Genotype) %>%
  summarise(counts = n())

df1 <- df1 %>%
  arrange(Treatment, desc(Genotype)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df1, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Genotype, fill = Genotype), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Genotype),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) + 
  ggtitle("genotipo/tratamiento CENTRE_A tratadosVSnotratados")

#Overview genero/tratamiento CENTRE_AtratadosnotratadosMPLCONTN:
df <- CENTRE_AtratadosnotratadosMPLCONTN %>%
  filter(Gender %in% c("F", "M", " ")) %>%
  group_by(Treatment, Gender) %>%
  summarise(counts = n())

df <- df %>%
  arrange(Treatment, desc(Gender)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Gender, fill = Gender), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Gender),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) + 
  ggtitle("genero/tratamiento CENTRE_A tratadosVS notratados MPLCONTN")
#Overview genotipo/tratamiento CENTRE_AtratadosnotratadosMPLCONTN:
df1 <- CENTRE_AtratadosnotratadosMPLCONTN %>%
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN")) %>%
  group_by(Treatment, Genotype) %>%
  summarise(counts = n())

df1 <- df1 %>%
  arrange(Treatment, desc(Genotype)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df1, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Genotype, fill = Genotype), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Genotype),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) + 
  ggtitle(" genotipo/tratamiento CENTRE_A tratadosVSnotratados MPLCONTN")

#Overview genero/tratamiento CENTRE_ATNCONMPL:
df <- CENTRE_ATNCONMPL %>%
  filter(Gender %in% c("F", "M", " ")) %>%
  group_by(Treatment, Gender) %>%
  summarise(counts = n())

df <- df %>%
  arrange(Treatment, desc(Gender)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Gender, fill = Gender), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Gender),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) + 
  ggtitle("genero/tratamiento CENTRE_A TNCONMPL")
#Overview genotipo/tratamiento CENTRE_ATNCONMPL:
df1 <- CENTRE_ATNCONMPL %>%
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN")) %>%
  group_by(Treatment, Genotype) %>%
  summarise(counts = n())

df1 <- df1 %>%
  arrange(Treatment, desc(Genotype)) %>%
  mutate(lab_ypos = cumsum(counts) - 0.5 * counts) 

ggplot(df1, aes(x = Treatment, y = counts)) +
  geom_bar(aes(color = Genotype, fill = Genotype), stat = "identity") +
  geom_text(
    aes(y = lab_ypos, label = counts, group = Genotype),
    color = "white"
  ) + 
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) + 
  ggtitle(" genotipo/tratamiento CENTRE_A TNCONMPL")





###PMA PTRESGRUPOS:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS,aes(factor(Treatment),PMA,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("PMA")
#Analisis de Anova PTRESGRUPOS:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_PMA)
TukeyHSD(anova_PMA)

###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),PMA,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("PMA tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_PMA)
TukeyHSD(anova_PMA)

###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTNs:
ggplot(FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN,aes(factor(Treatment),PMA,label=FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("PMA tratadosVSnotratados MPLSTNs")
#Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTNs:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data =FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTNs)
summary(anova_PMA)
TukeyHSD(anova_PMA)

###PMA FCA_aggregation_filtered_NA9112021MPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021MPLSTN,aes(factor(Treatment),PMA,label=FCA_aggregation_filtered_NA9112021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("PMA MPLSTN")
#Analisis de Anova FCA_aggregation_filtered_NA9112021MPLSTN:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021MPLSTN)
summary(anova_PMA)
TukeyHSD(anova_PMA)

###PMA CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),PMA,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("PMA CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_PMA)
TukeyHSD(anova_PMA)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),PMA,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("PMA CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_PMA)
TukeyHSD(anova_PMA)

###PMA CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Treatment),PMA,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("PMA CENTRE_A tratadosVSnotratados MPLCONTN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_PMA)
TukeyHSD(anova_PMA)

###PMA CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),PMA,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("PMA CENTRE_A TNCONMPL")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_PMA)
TukeyHSD(anova_PMA)




###CVX PTRESGRUPOS:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS,aes(factor(Treatment),CVX,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20) + 
  ggtitle("CVX")
##Analisis de Anova PTRESGRUPOS:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_CVX)
TukeyHSD(anova_CVX)

###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),CVX,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20) + 
  ggtitle("CVX tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_CVX)
TukeyHSD(anova_CVX)
###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN,aes(factor(Treatment),CVX,label=FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20) + 
  ggtitle("CVX tratadosVSnotratados MPLSTN")
##Analisis de Anova tratadosnotratados MPLSTN:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN)
summary(anova_CVX)
TukeyHSD(anova_CVX)

###CVX FCA_aggregation_filtered_NA9112021MPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021MPLSTN,aes(factor(Treatment),CVX,label=FCA_aggregation_filtered_NA9112021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("CVX MPLSTN")
#Analisis de Anova FCA_aggregation_filtered_NA9112021MPLSTN:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021MPLSTN)
summary(anova_CVX)
TukeyHSD(anova_CVX)

###CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),CVX,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20) + 
  ggtitle("CVX CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_CVX)
TukeyHSD(anova_CVX)


###CVX CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),CVX,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20) + 
  ggtitle("CVX CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_CVX)
TukeyHSD(anova_CVX)


###CENTRE_AtratadosnotratadosMPLCONTN :
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Treatment),CVX,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20) + 
  ggtitle("CVX CENTRE_A tratadosVSnotratados MPLCONTN")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_CVX)
TukeyHSD(anova_CVX)
###CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),CVX,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20) + 
  ggtitle("CVX CENTRE_A TNCONMPL")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_CVX)
TukeyHSD(anova_CVX)








###RISTO PTRESGRUPOS:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS,aes(factor(Treatment),RISTO,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("RISTO")
##Analisis de Anova PTRESGRUPOS:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)

###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),RISTO,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("RISTO tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)

###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN,aes(factor(Treatment),RISTO,label=FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("RISTO tratadosVSnotratados MPLSTN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)
###RISTO FCA.PLT.aggregationTNMPL.VARIANTMPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021MPLSTN,aes(factor(Treatment),RISTO,label=FCA_aggregation_filtered_NA9112021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("RISTO MPLSTN")
##Analisis de Anova FCA.PLT.aggregationTNMPL.VARIANTMPLSTN:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021MPLSTN )
summary(anova_RISTO)
TukeyHSD(anova_RISTO)



###RISTO CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),RISTO,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("RISTO CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),RISTO,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("RISTO CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)

###FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),RISTO,label=FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("RISTO tratadosVSnotratados TNCONMPL")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)

###RISTO CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),RISTO,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("RISTO CENTRE_A TNCONMPL")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)





###AGGA PTRESGRUPOS:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS,aes(factor(Treatment),AGGA,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("AGGA")
##Analisis de Anova TRESGRUPOS:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)

###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),AGGA,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("AGGA tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)

###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN,aes(factor(Treatment),AGGA,label=FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("AGGA tratadosVSnotratados MPLSTN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)

###AGGA FCA_aggregation_filtered_NA9112021MPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021MPLSTN,aes(factor(Treatment),AGGA,label=FCA_aggregation_filtered_NA9112021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("AGGA MPLSTN")
##Analisis de Anova FCA.PLT.aggregationTNMPL.VARIANTFCA_aggregation_filtered_NA9112021MPLSTN:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021MPLSTN)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)

###AGGA CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),AGGA,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("AGGA CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),AGGA,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("AGGA CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)

###AGGA CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN,aes(factor(Treatment),AGGA,label=CENTRE_AtratadosnotratadosMPLCONTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("AGGA CENTRE_A TNCONMPL")
##Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)

###AGGA CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),AGGA,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("AGGA CENTRE_A TNCONMPL")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)






###COL TRESGRUPOS:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS,aes(factor(Treatment),COL,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("COL")
##Analisis de Anova PTRESGRUPOS:
anova_COL <- aov(COL ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_COL)
TukeyHSD(anova_COL)

###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),COL,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("COL tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_COL <- aov(COL ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_COL)
TukeyHSD(anova_COL)

###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN,aes(factor(Treatment),COL,label=FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("COL tratadosVSnotratados MPLSTN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_COL <- aov(COL ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN)
summary(anova_COL)
TukeyHSD(anova_COL)

###FCA_aggregation_filtered_NA9112021MPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021MPLSTN,aes(factor(Treatment),COL,label=FCA_aggregation_filtered_NA9112021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("COL MPLSTN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021MPLSTN:
anova_COL <- aov(COL ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021MPLSTN)
summary(anova_COL)
TukeyHSD(anova_COL)


###COL CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),COL,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("COL CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_COL <- aov(COL ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_COL)
TukeyHSD(anova_COL)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),COL,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("COL CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_COL <- aov(COL ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_COL)
TukeyHSD(anova_COL)

###FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),COL,label=FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("COL tratadosVSnotratados TNCONMPL")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL:
anova_COL <- aov(COL ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL)
summary(anova_COL)
TukeyHSD(anova_COL)

###COL CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),COL,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("COL CENTRE_A TNCONMPL")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_COL <- aov(COL ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_COL)
TukeyHSD(anova_COL)





###TRAP PTRESGRUPOS:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS,aes(factor(Treatment),TRAP,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("TRAP")
##Analisis de Anova PTRESGRUPOS:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)

###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),TRAP,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("TRAP tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)
###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN,aes(factor(Treatment),TRAP,label=FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("TRAP tratadosVSnotratados MPLSTN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)
###TRAP FCA.PLT.aggregationTNMPL.VARIANTFCA_aggregation_filtered_NA9112021MPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021MPLSTN,aes(factor(Treatment),TRAP,label=FCA_aggregation_filtered_NA9112021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("TRAP MPLSTN ")
##Analisis de Anova FCA_aggregation_filtered_NA9112021MPLSTN:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021MPLSTN )
summary(anova_TRAP)
TukeyHSD(anova_TRAP)

###TRAP CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),TRAP,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("TRAP CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),TRAP,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("TRAP CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)
###FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),TRAP,label=FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("TRAP tratadosVSnotratados TNCONMPL")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)
###TRAP CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),TRAP,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("TRAP CENTRE_A TNCONMPL")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)







###UNSTIMULATED.10min PTRESGRUPOS:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS,aes(factor(Treatment),UNSTIMULATED.10min,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22) + 
  ggtitle("UNSTIMULATED.10min")
##Analisis de Anova TRESGRUPOS:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)

###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),UNSTIMULATED.10min,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22) + 
  ggtitle("UNSTIMULATED.10min tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)

###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN,aes(factor(Treatment),UNSTIMULATED.10min,label=FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22) + 
  ggtitle("UNSTIMULATED.10min tratadosVSnotratados MPLSTN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)

###UNSTIMULATED.10min FCA_aggregation_filtered_NA9112021MPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021MPLSTN,aes(factor(Treatment),UNSTIMULATED.10min,label=FCA_aggregation_filtered_NA9112021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22) + 
  ggtitle("UNSTIMULATED.10min MPLSTN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021MPLSTN:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021MPLSTN)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)





###UNSTIMULATED.10min CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),UNSTIMULATED.10min,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22) + 
  ggtitle("UNSTIMULATED.10min CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),UNSTIMULATED.10min,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22) + 
  ggtitle("UNSTIMULATED.10min CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)


###UNSTIMULATED.10min CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN, aes(factor(Treatment),UNSTIMULATED.10min,label=CENTRE_AtratadosnotratadosMPLCONTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22) + 
  ggtitle("UNSTIMULATED.10min CENTRE_A tratadosVSnotratados MPLCONTN")
##Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)


###UNSTIMULATED.10min CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),UNSTIMULATED.10min,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22) + 
  ggtitle("UNSTIMULATED.10min CENTRE_A TNCONMPL")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)









###Time.0min TRESGRUPOS:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS,aes(factor(Treatment),Time.0min,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("Time.0min")
##Analisis de Anova PTRESGRUPOS:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)

###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),Time.0min,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("Time.0min tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)
###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN,aes(factor(Treatment),Time.0min,label=FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("Time.0min tratadosVSnotratados MPLSTN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)

###Time.0min FCA_aggregation_filtered_NA9112021MPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021MPLSTN,aes(factor(Treatment),Time.0min,label=FCA_aggregation_filtered_NA9112021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("Time.0min MPLSTN ")
##Analisis de Anova FCA_aggregation_filtered_NA9112021MPLSTN:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021MPLSTN)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)


###Time.0min CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),Time.0min,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("Time.0min CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),Time.0min,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("Time.0min CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)

###FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),Time.0min,label=FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("Time.0min tratadosVSnotratados TNCONMPL")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)

###Time.0min CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),Time.0min,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17) + 
  ggtitle("Time.0min CENTRE_A TNCONMPL")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)






###UNS.Time.10min.vs.Time.0 TRESGRUPOS:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12) + 
  ggtitle("UNS.Time.10min.vs.Time.0")
##Analisis de Anova TRESGRUPOS:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)

###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12) + 
  ggtitle("UNS.Time.10min.vs.Time.0 tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)

###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12) + 
  ggtitle("UNS.Time.10min.vs.Time.0 tratadosVSnotratados MPLSTN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)

###FCA_aggregation_filtered_NA9112021MPLSTN:
ggplot(FCA_aggregation_filtered_NA9112021MPLSTN,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=FCA_aggregation_filtered_NA9112021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12) + 
  ggtitle("UNS.Time.10min.vs.Time.0 MPLSTN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021MPLSTN:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021MPLSTN)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)




###UNS.Time.10min.vs.Time.0 CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12) + 
  ggtitle("UNS.Time.10min.vs.Time.0 CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12) + 
  ggtitle("UNS.Time.10min.vs.Time.0 CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)

###FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12) + 
  ggtitle("UNS.Time.10min.vs.Time.0 tratadosVSnotratados TNCONMPL")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)

###UNS.Time.10min.vs.Time.0 CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12) + 
  ggtitle("UNS.Time.10min.vs.Time.0 CENTRE_A TNCONMPL")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)





