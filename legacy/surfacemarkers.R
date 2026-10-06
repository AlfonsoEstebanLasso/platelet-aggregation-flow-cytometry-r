# ----------------------------------------------------------------------------
# Legacy script from a commissioned analysis of platelet function by flow
# cytometry in essential thrombocythemia (2021), published with the written
# authorization of the principal investigator of the study. Analyses related
# to: Molecular & Cellular Proteomics 25(8):101617, 2026,
# https://doi.org/10.1016/j.mcpro.2026.101617
# Original file: surfacemarkers.R (2021-11-09 data cut-off),
# original encoding ASCII, CRLF line endings.
# Changes with respect to the delivered file (see docs/cleaning.md): absolute
# paths replaced by data/<file>, setwd() calls disabled, the two centres
# renamed CENTRE_A and CENTRE_B, one genotype label renamed VARIANT and one
# genotype category renamed CALR Type_Other. No other change was made; the
# code is not executable without the private input data. Original SHA-256: 45ded76458081c30c31a74f3cb1cb1a94cb404392e25741abe0521a1ee6a8bd0
# ----------------------------------------------------------------------------
library(dplyr) 
library(ggplot2)
library(ggpubr)
library(readxl)
###Marcadores:
# setwd("data")  # setwd() disabled in this release: run from the project root
SurfaceMarkers_ALL_Nov9_2021 <- read.csv2("data/SurfaceMarkers_ALL_Nov9_2021.csv")
SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados <- read.csv2("data/SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados.csv")
SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN <- read.csv2("data/SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN.csv")
SurfaceMarkers_ALL_Nov9_2021MPLSTN <- read.csv2("data/SurfaceMarkers_ALL_Nov9_2021MPLSTN.csv")

CENTRE_A <- read.csv2("data/SurfaceMarkers_ALL_Nov9_2021CENTRE_A.csv")
CENTRE_Atratadosnotratados <- read.csv2("data/SurfaceMarkers_ALL_Nov9_2021_CENTRE_Atratadosnotratados.csv")
CENTRE_AtratadosnotratadosMPLCONTN <- read.csv2("data/SurfaceMarkers_ALL_Nov9_2021_CENTRE_AtratadosnotratadosMPLSTN.csv")
CENTRE_ATNCONMPL <- read.csv2("data/SurfaceMarkers_ALL_Nov9_2021CENTRE_ATNCONMPL.csv")



#Overview genero/tratamiento PTRESGRUPOS:
df <- SurfaceMarkers_ALL_Nov9_2021 %>%
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
df1 <- SurfaceMarkers_ALL_Nov9_2021 %>%
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN", "VARIANT", "CALR Type_Other")) %>%
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
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B5A2B", "#8B2252"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B5A2B", "#8B2252")) + 
  ggtitle("genotipo/tratamiento")
#Overview genero/tratamiento tratadosnotratados:
df <- SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados %>%
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
df1 <- SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados %>%
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN", "VARIANT", "CALR Type_Other")) %>%
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
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B5A2B", "#8B2252"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B5A2B", "#8B2252")) + 
  ggtitle("genotipo/tratamiento tratadosVSnotratados")
#Overview genero/tratamiento  SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
df <- SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN %>%
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
  ggtitle("genero/tratamiento tratadosVSnotratados MPL CON TN")
#Overview genotipo/tratamiento  SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
df1 <- SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN %>%
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN", "CALR Type_Other")) %>%
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
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B2252"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B2252")) + 
  ggtitle("genotipo/tratamiento  tratadosVSnotratados MPL CON TN")
#Overview genero/tratamiento SurfaceMarkers_ALL_Nov9_2021MPLSTN:
df <- SurfaceMarkers_ALL_Nov9_2021MPLSTN %>%
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
  ggtitle("genero/tratamiento MPL CON TN")

#Overview genotipo/tratamiento SurfaceMarkers_ALL_Nov9_2021MPLSTN:
df1 <- SurfaceMarkers_ALL_Nov9_2021MPLSTN %>%
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN", "CALR Type_Other")) %>%
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
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B2252"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B2252")) + 
  ggtitle("genotipo/tratamiento MPL CON TN")


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
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN", "VARIANT", "CALR Type_Other")) %>%
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
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B5A2B", "#8B2252"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B5A2B", "#8B2252")) + 
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
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN", "VARIANT", "CALR Type_Other")) %>%
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
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B5A2B", "#8B2252"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B5A2B", "#8B2252")) + 
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
  ggtitle("genero/tratamiento CENTRE_A tratadosVS notratados MPL CON TN")
#Overview genotipo/tratamiento CENTRE_AtratadosnotratadosMPLCONTN:
df1 <- CENTRE_AtratadosnotratadosMPLCONTN %>%
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN", "CALR Type_Other")) %>%
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
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B2252"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B2252")) + 
  ggtitle(" genotipo/tratamiento CENTRE_A tratadosVSnotratados MPL CON TN")

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
  ggtitle("genero/tratamiento CENTRE_A MPL CON TN")
#Overview genotipo/tratamiento CENTRE_ATNCONMPL:
df1 <- CENTRE_ATNCONMPL %>%
  filter(Genotype %in% c("CALR Type I", "CALR Type II", "CNTRL", "JAK2 V617F", "MPL W515", "TN", "CALR Type_Other")) %>%
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
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B2252"))+
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A", "#8B2252")) + 
  ggtitle(" genotipo/tratamiento CENTRE_A MPL CON TN")




###CD61:
###CD61 TRESGRUPOS:
ggplot(SurfaceMarkers_ALL_Nov9_2021,aes(factor(Treatment),CD61,label=SurfaceMarkers_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("CD61")
#Analisis de Anova TRESGRUPOS:
anova_CD61 <- aov(CD61 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021)
summary(anova_CD61)
TukeyHSD(anova_CD61)

###tratadosnotratados:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados,aes(factor(Treatment),CD61,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("CD61 tratadosVSnotratados")

#Analisis de Anova tratadosnotratados:
anova_CD61 <- aov(CD61 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados)
summary(anova_CD61)
TukeyHSD(anova_CD61)

###SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Treatment),CD61,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)+ 
  ggtitle("CD61 tratadosVSnotratados MPL CON TN")
#Analisis de Anova SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN:
anova_CD61 <- aov(CD61 ~ Genotype * Treatment, data =SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_CD61)
TukeyHSD(anova_CD61)

###CD61 SurfaceMarkers_ALL_Nov9_2021MPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021MPLSTN,aes(factor(Treatment),CD61,label=SurfaceMarkers_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("CD61 MPL CON TN")
#Analisis de Anova SurfaceMarkers_ALL_Nov9_2021MPLSTN:
anova_CD61 <- aov(CD61 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021MPLSTN)
summary(anova_CD61)
TukeyHSD(anova_CD61)

###CD61 CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),CD61,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("CD61 CENTRE_A")
#Analisis de Anova CENTRE_A:
anova_CD61 <- aov(CD61 ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_CD61)
TukeyHSD(anova_CD61)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),CD61,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("CD61 CENTRE_A tratadosVSnotratados")
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_CD61 <- aov(CD61 ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_CD61)
TukeyHSD(anova_CD61)

###CD61 CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Treatment),CD61,label=CENTRE_AtratadosnotratadosMPLCONTN $Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("CD61 CENTRE_A tratadosVSnotratados MPL CON TN")
#Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN :
anova_CD61 <- aov(CD61 ~ Genotype * Treatment, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_CD61)
TukeyHSD(anova_CD61)

###CD61 CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),CD61,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("CD61 CENTRE_A MPL CON TN")
#Analisis de Anova CENTRE_ATNCONMPL:
anova_CD61 <- aov(CD61 ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_CD61)
TukeyHSD(anova_CD61)




###CD41:
###CD41 TRESGRUPOS:
ggplot(SurfaceMarkers_ALL_Nov9_2021,aes(factor(Treatment),CD41,label=SurfaceMarkers_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20) + 
  ggtitle("CD41")
##Analisis de Anova TRESGRUPOS:
anova_CD41 <- aov(CD41 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021)
summary(anova_CD41)
TukeyHSD(anova_CD41)

###tratadosnotratados:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados,aes(factor(Treatment),CD41,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20) + 
  ggtitle("CD41 tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_CD41 <- aov(CD41 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados)
summary(anova_CD41)
TukeyHSD(anova_CD41)
###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Treatment),CD41,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20) + 
  ggtitle("CD41 tratadosVSnotratados MPL CON TN")
##Analisis de Anova tratadosnotratados MPLSTN:
anova_CD41 <- aov(CD41 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_CD41)
TukeyHSD(anova_CD41)

###CD41 SurfaceMarkers_ALL_Nov9_2021MPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021MPLSTN,aes(factor(Treatment),CD41,label=SurfaceMarkers_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0) + 
  ggtitle("CD41 MPL CON TN")
#Analisis de Anova SurfaceMarkers_ALL_Nov9_2021MPLSTN:
anova_CD41 <- aov(CD41 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021MPLSTN)
summary(anova_CD41)
TukeyHSD(anova_CD41)

###CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),CD41,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20) + 
  ggtitle("CD41 CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_CD41 <- aov(CD41 ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_CD41)
TukeyHSD(anova_CD41)


###CD41 CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),CD41,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20) + 
  ggtitle("CD41 CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_CD41 <- aov(CD41 ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_CD41)
TukeyHSD(anova_CD41)


###CENTRE_AtratadosnotratadosMPLCONTN :
ggplot(CENTRE_AtratadosnotratadosMPLCONTN ,aes(factor(Treatment),CD41,label=CENTRE_AtratadosnotratadosMPLCONTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20) + 
  ggtitle("CD41 CENTRE_A tratadosVSnotratados MPL CON TN")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_CD41 <- aov(CD41 ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_CD41)
TukeyHSD(anova_CD41)
###CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),CD41,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20) + 
  ggtitle("CD41 CENTRE_A MPL CON TN")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_CD41 <- aov(CD41 ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_CD41)
TukeyHSD(anova_CD41)




###CD49B:
###CD49B TRESGRUPOS:
ggplot(SurfaceMarkers_ALL_Nov9_2021,aes(factor(Treatment),CD49B,label=SurfaceMarkers_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("CD49B")
##Analisis de Anova TRESGRUPOS:
anova_CD49B <- aov(CD49B ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021)
summary(anova_CD49B)
TukeyHSD(anova_CD49B)

###tratadosnotratados:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados,aes(factor(Treatment),CD49B,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("CD49B tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_CD49B <- aov(CD49B ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados)
summary(anova_CD49B)
TukeyHSD(anova_CD49B)

###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Treatment),CD49B,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("CD49B tratadosVSnotratados MPL CON TN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_CD49B <- aov(CD49B ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_CD49B)
TukeyHSD(anova_CD49B)
###CD49B FCA.PLT.aggregationTNMPL.VARIANTMPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021MPLSTN,aes(factor(Treatment),CD49B,label=SurfaceMarkers_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("CD49B MPL CON TN")
##Analisis de Anova FCA.PLT.aggregationTNMPL.VARIANTMPLSTN:
anova_CD49B <- aov(CD49B ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021MPLSTN )
summary(anova_CD49B)
TukeyHSD(anova_CD49B)



###CD49B CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),CD49B,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("CD49B CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_CD49B <- aov(CD49B ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_CD49B)
TukeyHSD(anova_CD49B)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),CD49B,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("CD49B CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_CD49B <- aov(CD49B ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_CD49B)
TukeyHSD(anova_CD49B)

###FCA_aggregation_filtered_NA9112021_tratadosnotratadosTNCONMPL:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN,aes(factor(Treatment),CD49B,label=CENTRE_AtratadosnotratadosMPLCONTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("CD49B tratadosVSnotratados MPL CON TN")
##Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN:
anova_CD49B <- aov(CD49B ~ Genotype * Treatment, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_CD49B)
TukeyHSD(anova_CD49B)

###CD49B CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),CD49B,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20) + 
  ggtitle("CD49B CENTRE_A MPL CON TN")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_CD49B <- aov(CD49B ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_CD49B)
TukeyHSD(anova_CD49B)




###GPVI:
###GPVI TRESGRUPOS:
ggplot(SurfaceMarkers_ALL_Nov9_2021,aes(factor(Treatment),GPVI,label=SurfaceMarkers_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("GPVI")
##Analisis de Anova TRESGRUPOS:
anova_GPVI <- aov(GPVI ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021)
summary(anova_GPVI)
TukeyHSD(anova_GPVI)

###tratadosnotratados:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados,aes(factor(Treatment),GPVI,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("GPVI tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_GPVI <- aov(GPVI ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados)
summary(anova_GPVI)
TukeyHSD(anova_GPVI)

###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Treatment),GPVI,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("GPVI tratadosVSnotratados MPL CON TN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_GPVI <- aov(GPVI ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_GPVI)
TukeyHSD(anova_GPVI)

###GPVI SurfaceMarkers_ALL_Nov9_2021MPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021MPLSTN,aes(factor(Treatment),GPVI,label=SurfaceMarkers_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("GPVI MPL CON TN")
##Analisis de Anova FCA.PLT.aggregationTNMPL.VARIANTSurfaceMarkers_ALL_Nov9_2021MPLSTN:
anova_GPVI <- aov(GPVI ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021MPLSTN)
summary(anova_GPVI)
TukeyHSD(anova_GPVI)

###GPVI CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),GPVI,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("GPVI CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_GPVI <- aov(GPVI ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_GPVI)
TukeyHSD(anova_GPVI)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),GPVI,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("GPVI CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_GPVI <- aov(GPVI ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_GPVI)
TukeyHSD(anova_GPVI)

###GPVI CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN,aes(factor(Treatment),GPVI,label=CENTRE_AtratadosnotratadosMPLCONTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("GPVI CENTRE_A MPL CON TN")
##Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN:
anova_GPVI <- aov(GPVI ~ Genotype * Treatment, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_GPVI)
TukeyHSD(anova_GPVI)

###GPVI CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),GPVI,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16) + 
  ggtitle("GPVI CENTRE_A MPL CON TN")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_GPVI <- aov(GPVI ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_GPVI)
TukeyHSD(anova_GPVI)




###CD42A:
###CD42A TRESGRUPOS:
ggplot(SurfaceMarkers_ALL_Nov9_2021,aes(factor(Treatment),CD42A,label=SurfaceMarkers_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42A")
##Analisis de Anova TRESGRUPOS:
anova_CD42A <- aov(CD42A ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021)
summary(anova_CD42A)
TukeyHSD(anova_CD42A)

###tratadosnotratados:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados,aes(factor(Treatment),CD42A,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42A tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_CD42A <- aov(CD42A ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados)
summary(anova_CD42A)
TukeyHSD(anova_CD42A)
###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Treatment),CD42A,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42A tratadosVSnotratados MPL CON TN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_CD42A <- aov(CD42A ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_CD42A)
TukeyHSD(anova_CD42A)
###CD42A FCA.PLT.aggregationTNMPL.VARIANTSurfaceMarkers_ALL_Nov9_2021MPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021MPLSTN,aes(factor(Treatment),CD42A,label=SurfaceMarkers_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42A MPL CON TN")
##Analisis de Anova SurfaceMarkers_ALL_Nov9_2021MPLSTN:
anova_CD42A <- aov(CD42A ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021MPLSTN )
summary(anova_CD42A)
TukeyHSD(anova_CD42A)

###CD42A CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),CD42A,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42A CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_CD42A <- aov(CD42A ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_CD42A)
TukeyHSD(anova_CD42A)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),CD42A,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42A CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_CD42A <- aov(CD42A ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_CD42A)
TukeyHSD(anova_CD42A)
###CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN,aes(factor(Treatment),CD42A,label=CENTRE_AtratadosnotratadosMPLCONTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42A tratadosVSnotratados MPL CON TN")
##Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN:
anova_CD42A <- aov(CD42A ~ Genotype * Treatment, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_CD42A)
TukeyHSD(anova_CD42A)
###CD42A CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),CD42A,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42A CENTRE_A MPL CON TN")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_CD42A <- aov(CD42A ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_CD42A)
TukeyHSD(anova_CD42A)




###CD42B:
###CD42B TRESGRUPOS:
ggplot(SurfaceMarkers_ALL_Nov9_2021,aes(factor(Treatment),CD42B,label=SurfaceMarkers_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42B")
##Analisis de Anova TRESGRUPOS:
anova_CD42B <- aov(CD42B ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021)
summary(anova_CD42B)
TukeyHSD(anova_CD42B)

###tratadosnotratados:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados,aes(factor(Treatment),CD42B,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42B tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_CD42B <- aov(CD42B ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados)
summary(anova_CD42B)
TukeyHSD(anova_CD42B)
###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Treatment),CD42B,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42B tratadosVSnotratados MPL CON TN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_CD42B <- aov(CD42B ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_CD42B)
TukeyHSD(anova_CD42B)
###CD42B FCA.PLT.aggregationTNMPL.VARIANTSurfaceMarkers_ALL_Nov9_2021MPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021MPLSTN,aes(factor(Treatment),CD42B,label=SurfaceMarkers_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42B MPL CON TN")
##Analisis de Anova SurfaceMarkers_ALL_Nov9_2021MPLSTN:
anova_CD42B <- aov(CD42B ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021MPLSTN )
summary(anova_CD42B)
TukeyHSD(anova_CD42B)

###CD42B CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),CD42B,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42B CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_CD42B <- aov(CD42B ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_CD42B)
TukeyHSD(anova_CD42B)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),CD42B,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42B CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_CD42B <- aov(CD42B ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_CD42B)
TukeyHSD(anova_CD42B)
###CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN,aes(factor(Treatment),CD42B,label=CENTRE_AtratadosnotratadosMPLCONTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42B tratadosVSnotratados MPL CON TN")
##Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN:
anova_CD42B <- aov(CD42B ~ Genotype * Treatment, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_CD42B)
TukeyHSD(anova_CD42B)
###CD42B CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),CD42B,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD42B CENTRE_A MPL CON TN")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_CD42B <- aov(CD42B ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_CD42B)
TukeyHSD(anova_CD42B)




###CD31:
###CD31 TRESGRUPOS:
ggplot(SurfaceMarkers_ALL_Nov9_2021,aes(factor(Treatment),CD31,label=SurfaceMarkers_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD31")
##Analisis de Anova TRESGRUPOS:
anova_CD31 <- aov(CD31 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021)
summary(anova_CD31)
TukeyHSD(anova_CD31)

###tratadosnotratados:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados,aes(factor(Treatment),CD31,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD31 tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_CD31 <- aov(CD31 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados)
summary(anova_CD31)
TukeyHSD(anova_CD31)
###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Treatment),CD31,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD31 tratadosVSnotratados MPL CON TN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_CD31 <- aov(CD31 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_CD31)
TukeyHSD(anova_CD31)
###CD31 FCA.PLT.aggregationTNMPL.VARIANTSurfaceMarkers_ALL_Nov9_2021MPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021MPLSTN,aes(factor(Treatment),CD31,label=SurfaceMarkers_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD31 MPL CON TN")
##Analisis de Anova SurfaceMarkers_ALL_Nov9_2021MPLSTN:
anova_CD31 <- aov(CD31 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021MPLSTN )
summary(anova_CD31)
TukeyHSD(anova_CD31)

###CD31 CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),CD31,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD31 CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_CD31 <- aov(CD31 ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_CD31)
TukeyHSD(anova_CD31)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),CD31,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD31 CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_CD31 <- aov(CD31 ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_CD31)
TukeyHSD(anova_CD31)
###CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN,aes(factor(Treatment),CD31,label=CENTRE_AtratadosnotratadosMPLCONTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD31 tratadosVSnotratados MPL CON TN")
##Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN:
anova_CD31 <- aov(CD31 ~ Genotype * Treatment, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_CD31)
TukeyHSD(anova_CD31)
###CD31 CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),CD31,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD31 CENTRE_A MPL CON TN")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_CD31 <- aov(CD31 ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_CD31)
TukeyHSD(anova_CD31)




###CD36:
###CD36 TRESGRUPOS:
ggplot(SurfaceMarkers_ALL_Nov9_2021,aes(factor(Treatment),CD36,label=SurfaceMarkers_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD36")
##Analisis de Anova TRESGRUPOS:
anova_CD36 <- aov(CD36 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021)
summary(anova_CD36)
TukeyHSD(anova_CD36)

###tratadosnotratados:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados,aes(factor(Treatment),CD36,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD36 tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_CD36 <- aov(CD36 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados)
summary(anova_CD36)
TukeyHSD(anova_CD36)
###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Treatment),CD36,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD36 tratadosVSnotratados MPL CON TN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_CD36 <- aov(CD36 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_CD36)
TukeyHSD(anova_CD36)
###CD36 FCA.PLT.aggregationTNMPL.VARIANTSurfaceMarkers_ALL_Nov9_2021MPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021MPLSTN,aes(factor(Treatment),CD36,label=SurfaceMarkers_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD36 MPL CON TN")
##Analisis de Anova SurfaceMarkers_ALL_Nov9_2021MPLSTN:
anova_CD36 <- aov(CD36 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021MPLSTN )
summary(anova_CD36)
TukeyHSD(anova_CD36)

###CD36 CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),CD36,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD36 CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_CD36 <- aov(CD36 ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_CD36)
TukeyHSD(anova_CD36)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),CD36,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD36 CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_CD36 <- aov(CD36 ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_CD36)
TukeyHSD(anova_CD36)
###CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN,aes(factor(Treatment),CD36,label=CENTRE_AtratadosnotratadosMPLCONTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD36 tratadosVSnotratados MPL CON TN")
##Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN:
anova_CD36 <- aov(CD36 ~ Genotype * Treatment, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_CD36)
TukeyHSD(anova_CD36)
###CD36 CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),CD36,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD36 CENTRE_A MPL CON TN")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_CD36 <- aov(CD36 ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_CD36)
TukeyHSD(anova_CD36)



###CD9:
###CD9 TRESGRUPOS:
ggplot(SurfaceMarkers_ALL_Nov9_2021,aes(factor(Treatment),CD9,label=SurfaceMarkers_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD9")
##Analisis de Anova TRESGRUPOS:
anova_CD9 <- aov(CD9 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021)
summary(anova_CD9)
TukeyHSD(anova_CD9)

###tratadosnotratados:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados,aes(factor(Treatment),CD9,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD9 tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_CD9 <- aov(CD9 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados)
summary(anova_CD9)
TukeyHSD(anova_CD9)
###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Treatment),CD9,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD9 tratadosVSnotratados MPL CON TN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_CD9 <- aov(CD9 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_CD9)
TukeyHSD(anova_CD9)
###CD9 FCA.PLT.aggregationTNMPL.VARIANTSurfaceMarkers_ALL_Nov9_2021MPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021MPLSTN,aes(factor(Treatment),CD9,label=SurfaceMarkers_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD9 MPL CON TN")
##Analisis de Anova SurfaceMarkers_ALL_Nov9_2021MPLSTN:
anova_CD9 <- aov(CD9 ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021MPLSTN )
summary(anova_CD9)
TukeyHSD(anova_CD9)

###CD9 CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),CD9,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD9 CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_CD9 <- aov(CD9 ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_CD9)
TukeyHSD(anova_CD9)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),CD9,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD9 CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_CD9 <- aov(CD9 ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_CD9)
TukeyHSD(anova_CD9)
###CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN,aes(factor(Treatment),CD9,label=CENTRE_AtratadosnotratadosMPLCONTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD9 tratadosVSnotratados MPL CON TN")
##Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN:
anova_CD9 <- aov(CD9 ~ Genotype * Treatment, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_CD9)
TukeyHSD(anova_CD9)
###CD9 CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),CD9,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("CD9 CENTRE_A MPL CON TN")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_CD9 <- aov(CD9 ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_CD9)
TukeyHSD(anova_CD9)




###FSC.unstained:
###FSC.unstained TRESGRUPOS:
ggplot(SurfaceMarkers_ALL_Nov9_2021,aes(factor(Treatment),FSC.unstained,label=SurfaceMarkers_ALL_Nov9_2021$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("FSC.unstained")
##Analisis de Anova TRESGRUPOS:
anova_FSC.unstained <- aov(FSC.unstained ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021)
summary(anova_FSC.unstained)
TukeyHSD(anova_FSC.unstained)

###tratadosnotratados:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados,aes(factor(Treatment),FSC.unstained,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("FSC.unstained tratadosVSnotratados")
##Analisis de Anova tratadosnotratados:
anova_FSC.unstained <- aov(FSC.unstained ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratados)
summary(anova_FSC.unstained)
TukeyHSD(anova_FSC.unstained)
###FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN,aes(factor(Treatment),FSC.unstained,label=SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("FSC.unstained tratadosVSnotratados MPL CON TN")
##Analisis de Anova FCA_aggregation_filtered_NA9112021_tratadosnotratadosMPLSTN:
anova_FSC.unstained <- aov(FSC.unstained ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021_tratadosnotratadosMPLSTN)
summary(anova_FSC.unstained)
TukeyHSD(anova_FSC.unstained)
###FSC.unstained FCA.PLT.aggregationTNMPL.VARIANTSurfaceMarkers_ALL_Nov9_2021MPLSTN:
ggplot(SurfaceMarkers_ALL_Nov9_2021MPLSTN,aes(factor(Treatment),FSC.unstained,label=SurfaceMarkers_ALL_Nov9_2021MPLSTN$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("FSC.unstained MPL CON TN")
##Analisis de Anova SurfaceMarkers_ALL_Nov9_2021MPLSTN:
anova_FSC.unstained <- aov(FSC.unstained ~ Genotype * Treatment, data = SurfaceMarkers_ALL_Nov9_2021MPLSTN )
summary(anova_FSC.unstained)
TukeyHSD(anova_FSC.unstained)

###FSC.unstained CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),FSC.unstained,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("FSC.unstained CENTRE_A")
##Analisis de Anova CENTRE_A:
anova_FSC.unstained <- aov(FSC.unstained ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_FSC.unstained)
TukeyHSD(anova_FSC.unstained)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),FSC.unstained,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("FSC.unstained CENTRE_A tratadosVSnotratados")
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_FSC.unstained <- aov(FSC.unstained ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_FSC.unstained)
TukeyHSD(anova_FSC.unstained)
###CENTRE_AtratadosnotratadosMPLCONTN:
ggplot(CENTRE_AtratadosnotratadosMPLCONTN,aes(factor(Treatment),FSC.unstained,label=CENTRE_AtratadosnotratadosMPLCONTN$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("FSC.unstained tratadosVSnotratados MPL CON TN")
##Analisis de Anova CENTRE_AtratadosnotratadosMPLCONTN:
anova_FSC.unstained <- aov(FSC.unstained ~ Genotype * Treatment, data = CENTRE_AtratadosnotratadosMPLCONTN)
summary(anova_FSC.unstained)
TukeyHSD(anova_FSC.unstained)
###FSC.unstained CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),FSC.unstained,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2) + 
  ggtitle("FSC.unstained CENTRE_A MPL CON TN")
##Analisis de Anova CENTRE_ATNCONMPL:
anova_FSC.unstained <- aov(FSC.unstained ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_FSC.unstained)
TukeyHSD(anova_FSC.unstained)
