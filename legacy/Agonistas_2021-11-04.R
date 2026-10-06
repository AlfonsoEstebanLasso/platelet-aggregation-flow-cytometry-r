# ----------------------------------------------------------------------------
# Legacy script from a commissioned analysis of platelet function by flow
# cytometry in essential thrombocythemia (2021), published with the written
# authorization of the principal investigator of the study. Analyses related
# to: Molecular & Cellular Proteomics 25(8):101617, 2026,
# https://doi.org/10.1016/j.mcpro.2026.101617
# Original file: Agonistas.R, the version delivered on 2021-11-04 (data cut-off 2021-10-27, both centres),
# original encoding UTF-8, CRLF line endings.
# Changes with respect to the delivered file (see docs/cleaning.md): absolute
# paths replaced by data/<file>, setwd() calls disabled, the two centres
# renamed CENTRE_A and CENTRE_B, one genotype label renamed VARIANT and one
# genotype category renamed CALR Type_Other. No other change was made; the
# code is not executable without the private input data. Original SHA-256: 740aac956a924daa28569f869287388a5d48a3a004f209b0a324c6ed65d2e692
# ----------------------------------------------------------------------------
library(dplyr) 
library(ggplot2)
library(ggpubr)
library(readxl)
###Agonistas:
# setwd("data")  # setwd() disabled in this release: run from the project root
FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS <-read_excel("FCA_aggregation_filtered_NA27102021.xlsx")#Este dataset agrupa tratamientos en ASA, Anagrelide y HU.
FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados <- read_excel("FCA_aggregation_filtered_NA27102021_tratadosnotratados.xlsx")##Este dataset es juntando todos los tratamientos para ver las comparaciones entre tratados y no tratados.
TNCONMPL <- read.csv2("data/TNCONMPL.csv")
FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL <- read.csv2("data/FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL.csv")
CENTRE_A <- read.csv2("data/CENTRE_A.csv")
CENTRE_Atratadosnotratados <- read.csv2("data/CENTRE_Atratadosnotratados.csv")
CENTRE_ATNCONMPL <- read.csv2("data/CENTRE_ATNCONMPL.csv")
FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL <- read.csv2("data/FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL.csv")
CENTRE_B <- read.csv2("data/CENTRE_B.csv")
CENTRE_Btratadosnotratados <- read.csv2("data/CENTRE_Btratadosnotratados.csv")
CENTRE_BTNCONMPL <- read.csv2("data/CENTRE_BTNCONMPL.csv")
CENTRE_BtratadosnotratadosTNCONMPL <- read.csv2("data/CENTRE_BtratadosnotratadosTNCONMPL.csv")
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) 

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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) 


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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) 

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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) 

#Overview genero/tratamiento TNCONMPL:
df <- TNCONMPL %>%
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) 

#Overview genotipo/tratamiento TNCONMPL:
df1 <- TNCONMPL %>%
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A"))

#Overview genero/tratamiento tratadosnotratadosTNCONMPL:
df <- FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL %>%
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) 

#Overview genotipo/tratamiento tratadosnotratadosTNCONMPL:
df1 <- FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL %>%
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) 
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) 

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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) 
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) 

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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) 
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) 

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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) 
#Overview genero/tratamiento FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
df <- FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL %>%
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) 

#Overview genotipo/tratamiento FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
df1 <- FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL %>%
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) 
#Overview genero/tratamiento CENTRE_B:
df <- CENTRE_B %>%
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) 

#Overview genotipo/tratamiento CENTRE_B:
df1 <- CENTRE_B %>%
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) 
#Overview genero/tratamiento CENTRE_Btratadosnotratados:
df <- CENTRE_Btratadosnotratados %>%
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) 

#Overview genotipo/tratamiento CENTRE_Btratadosnotratados:
df1 <- CENTRE_Btratadosnotratados %>%
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) 
#Overview genero/tratamiento CENTRE_BTNCONMPL:
df <- CENTRE_BTNCONMPL %>%
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) 

#Overview genotipo/tratamiento CENTRE_BTNCONMPL:
df1 <- CENTRE_BTNCONMPL %>%
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) 
#Overview genero/tratamiento CENTRE_BtratadosnotratadosTNCONMPL:
df <- CENTRE_BtratadosnotratadosTNCONMPL %>%
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) 

#Overview genotipo/tratamiento CENTRE_BtratadosnotratadosTNCONMPL:
df1 <- CENTRE_BtratadosnotratadosTNCONMPL %>%
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
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF","#009999","#0000FF", "#FF1493", "#E9967A")) 

###PMA PTRESGRUPOS:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS,aes(factor(Treatment),PMA,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)
###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),PMA,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)
#Analisis de Anova PTRESGRUPOS:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_PMA)
TukeyHSD(anova_PMA)
#Analisis de Anova tratadosnotratados:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_PMA)
TukeyHSD(anova_PMA)

###PMA TNCONMPL:
ggplot(TNCONMPL,aes(factor(Treatment),PMA,label=TNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)
###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),PMA,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)
#Analisis de Anova TNCONMPL:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = TNCONMPL)
summary(anova_PMA)
TukeyHSD(anova_PMA)
#Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = 0)
###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),PMA,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)
#Analisis de Anova CENTRE_A:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_PMA)
TukeyHSD(anova_PMA)
#Analisis de Anova CENTRE_Atratadosnotratados:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
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
               geom = "text", aes(label = ..ymax..), vjust = 0)
###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),PMA,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)
#Analisis de Anova CENTRE_ATNCONMPL:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_PMA)
TukeyHSD(anova_PMA)
#Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
summary(anova_PMA)
TukeyHSD(anova_PMA)
###PMA CENTRE_B:
ggplot(CENTRE_B,aes(factor(Treatment),PMA,label=CENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)
###CENTRE_Btratadosnotratados:
ggplot(CENTRE_Btratadosnotratados,aes(factor(Treatment),PMA,label=CENTRE_Btratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)
#Analisis de Anova CENTRE_B:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = CENTRE_B)
summary(anova_PMA)
TukeyHSD(anova_PMA)
#Analisis de Anova CENTRE_Btratadosnotratados:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = CENTRE_Btratadosnotratados)
summary(anova_PMA)
TukeyHSD(anova_PMA)
###PMA CENTRE_BTNCONMPL:
ggplot(CENTRE_BTNCONMPL,aes(factor(Treatment),PMA,label=CENTRE_BTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)
###CENTRE_BtratadosnotratadosTNCONMPL:
ggplot(CENTRE_BtratadosnotratadosTNCONMPL,aes(factor(Treatment),PMA,label=CENTRE_BtratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)
#Analisis de Anova CENTRE_BTNCONMPL:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = CENTRE_BTNCONMPL)
summary(anova_PMA)
TukeyHSD(anova_PMA)
#Analisis de Anova CENTRE_BtratadosnotratadosTNCONMPL:
anova_PMA <- aov(PMA ~ Genotype * Treatment, data = CENTRE_BtratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = 20)

###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),CVX,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20)
##Analisis de Anova PTRESGRUPOS:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_CVX)
TukeyHSD(anova_CVX)
##Analisis de Anova tratadosnotratados:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_CVX)
TukeyHSD(anova_CVX)

###TNCONMPL:
ggplot(TNCONMPL,aes(factor(Treatment),CVX,label=TNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20)

##Analisis de Anova TNCONMPL:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = TNCONMPL)
summary(anova_CVX)
TukeyHSD(anova_CVX)
###CVX FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),CVX,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20)

###CENTRE_A:
ggplot(CENTRE_A,aes(factor(Treatment),CVX,label=CENTRE_A$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
summary(anova_CVX)
TukeyHSD(anova_CVX)
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
               geom = "text", aes(label = ..ymax..), vjust = 20)

###CENTRE_ATNCONMPL:
ggplot(CENTRE_ATNCONMPL,aes(factor(Treatment),CVX,label=CENTRE_ATNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20)
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
summary(anova_CVX)
TukeyHSD(anova_CVX)
##Analisis de Anova CENTRE_ATNCONMPL:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_CVX)
TukeyHSD(anova_CVX)
###CVX FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),CVX,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20)

###CENTRE_B:
ggplot(CENTRE_B,aes(factor(Treatment),CVX,label=CENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
summary(anova_CVX)
TukeyHSD(anova_CVX)
##Analisis de Anova CENTRE_B:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = CENTRE_B)
summary(anova_CVX)
TukeyHSD(anova_CVX)
###CVX CENTRE_Btratadosnotratados:
ggplot(CENTRE_Btratadosnotratados,aes(factor(Treatment),CVX,label=CENTRE_Btratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20)

###CENTRE_BTNCONMPL:
ggplot(CENTRE_BTNCONMPL,aes(factor(Treatment),CVX,label=CENTRE_BTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20)
##Analisis de Anova CENTRE_Btratadosnotratados:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = CENTRE_Btratadosnotratados)
summary(anova_CVX)
TukeyHSD(anova_CVX)
##Analisis de Anova CENTRE_BTNCONMPL:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = CENTRE_BTNCONMPL)
summary(anova_CVX)
TukeyHSD(anova_CVX)
###CENTRE_BtratadosnotratadosTNCONMPL:
ggplot(CENTRE_BtratadosnotratadosTNCONMPL,aes(factor(Treatment),CVX,label=CENTRE_BtratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20)
##Analisis de Anova CENTRE_BtratadosnotratadosTNCONMPL:
anova_CVX <- aov(CVX ~ Genotype * Treatment, data = CENTRE_BtratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = -20)
###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),RISTO,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20)
##Analisis de Anova PTRESGRUPOS:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)
##Analisis de Anova tratadosnotratados:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)
###RISTO TNCONMPL:
ggplot(TNCONMPL,aes(factor(Treatment),RISTO,label=TNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20)
###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),RISTO,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20)
##Analisis de Anova TNCONMPL:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = TNCONMPL)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = -20)
###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),RISTO,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20)
##Analisis de Anova CENTRE_A:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
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
               geom = "text", aes(label = ..ymax..), vjust = -20)
###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),RISTO,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20)
##Analisis de Anova CENTRE_ATNCONMPL:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)
###RISTO CENTRE_B:
ggplot(CENTRE_B,aes(factor(Treatment),RISTO,label=CENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20)
###CENTRE_Btratadosnotratados:
ggplot(CENTRE_Btratadosnotratados,aes(factor(Treatment),RISTO,label=CENTRE_Btratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20)
##Analisis de Anova CENTRE_B:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = CENTRE_B)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)
##Analisis de Anova CENTRE_Btratadosnotratados:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = CENTRE_Btratadosnotratados)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)
###RISTO CENTRE_BTNCONMPL:
ggplot(CENTRE_BTNCONMPL,aes(factor(Treatment),RISTO,label=CENTRE_BTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20)
###CENTRE_BtratadosnotratadosTNCONMPL:
ggplot(CENTRE_BtratadosnotratadosTNCONMPL,aes(factor(Treatment),RISTO,label=CENTRE_BtratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20)
##Analisis de Anova CENTRE_BTNCONMPL:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = CENTRE_BTNCONMPL)
summary(anova_RISTO)
TukeyHSD(anova_RISTO)
##Analisis de Anova CENTRE_BtratadosnotratadosTNCONMPL:
anova_RISTO <- aov(RISTO ~ Genotype * Treatment, data = CENTRE_BtratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = -16)
###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),AGGA,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16)
##Analisis de Anova TRESGRUPOS:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)
##Analisis de Anova tratadosnotratados:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)
###AGGA TNCONMPL:
ggplot(TNCONMPL,aes(factor(Treatment),AGGA,label=TNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16)
###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),AGGA,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16)
##Analisis de Anova TNCONMPL:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = TNCONMPL)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = -16)
###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),AGGA,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16)
##Analisis de Anova CENTRE_A:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
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
               geom = "text", aes(label = ..ymax..), vjust = -16)
###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),AGGA,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16)
##Analisis de Anova CENTRE_ATNCONMPL:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)
###AGGA CENTRE_B:
ggplot(CENTRE_B,aes(factor(Treatment),AGGA,label=CENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16)
###CENTRE_Btratadosnotratados:
ggplot(CENTRE_Btratadosnotratados,aes(factor(Treatment),AGGA,label=CENTRE_Btratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16)
##Analisis de Anova CENTRE_B:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = CENTRE_B)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)
##Analisis de Anova CENTRE_Btratadosnotratados:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = CENTRE_Btratadosnotratados)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)
###AGGA CENTRE_BTNCONMPL:
ggplot(CENTRE_BTNCONMPL,aes(factor(Treatment),AGGA,label=CENTRE_BTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16)
###CENTRE_BtratadosnotratadosTNCONMPL:
ggplot(CENTRE_BtratadosnotratadosTNCONMPL,aes(factor(Treatment),AGGA,label=CENTRE_BtratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16)
##Analisis de Anova CENTRE_BTNCONMPL:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = CENTRE_BTNCONMPL)
summary(anova_AGGA)
TukeyHSD(anova_AGGA)
##Analisis de Anova CENTRE_BtratadosnotratadosTNCONMPL:
anova_AGGA <- aov(AGGA ~ Genotype * Treatment, data = CENTRE_BtratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = -17)
###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),COL,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
##Analisis de Anova PTRESGRUPOS:
anova_COL <- aov(COL ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_COL)
TukeyHSD(anova_COL)
##Analisis de Anova tratadosnotratados:
anova_COL <- aov(COL ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_COL)
TukeyHSD(anova_COL)
###COL TNCONMPL:
ggplot(TNCONMPL,aes(factor(Treatment),COL,label=TNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),COL,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
##Analisis de Anova TNCONMPL:
anova_COL <- aov(COL ~ Genotype * Treatment, data = TNCONMPL)
summary(anova_COL)
TukeyHSD(anova_COL)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_COL <- aov(COL ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = -17)
###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),COL,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
##Analisis de Anova CENTRE_A:
anova_COL <- aov(COL ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_COL)
TukeyHSD(anova_COL)
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_COL <- aov(COL ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
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
               geom = "text", aes(label = ..ymax..), vjust = -17)
###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),COL,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
##Analisis de Anova CENTRE_ATNCONMPL:
anova_COL <- aov(COL ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_COL)
TukeyHSD(anova_COL)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_COL <- aov(COL ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
summary(anova_COL)
TukeyHSD(anova_COL)
###COL CENTRE_B:
ggplot(CENTRE_B,aes(factor(Treatment),COL,label=CENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
###CENTRE_Btratadosnotratados:
ggplot(CENTRE_Btratadosnotratados,aes(factor(Treatment),COL,label=CENTRE_Btratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
##Analisis de Anova CENTRE_B:
anova_COL <- aov(COL ~ Genotype * Treatment, data = CENTRE_B)
summary(anova_COL)
TukeyHSD(anova_COL)
##Analisis de Anova CENTRE_Btratadosnotratados:
anova_COL <- aov(COL ~ Genotype * Treatment, data = CENTRE_Btratadosnotratados)
summary(anova_COL)
TukeyHSD(anova_COL)
###COL CENTRE_BTNCONMPL:
ggplot(CENTRE_BTNCONMPL,aes(factor(Treatment),COL,label=CENTRE_BTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
###CENTRE_BtratadosnotratadosTNCONMPL:
ggplot(CENTRE_BtratadosnotratadosTNCONMPL,aes(factor(Treatment),COL,label=CENTRE_BtratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
##Analisis de Anova CENTRE_BTNCONMPL:
anova_COL <- aov(COL ~ Genotype * Treatment, data = CENTRE_BTNCONMPL)
summary(anova_COL)
TukeyHSD(anova_COL)
##Analisis de Anova CENTRE_BtratadosnotratadosTNCONMPL:
anova_COL <- aov(COL ~ Genotype * Treatment, data = CENTRE_BtratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = 2)

###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),TRAP,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2)
##Analisis de Anova PTRESGRUPOS:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)
##Analisis de Anova tratadosnotratados:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)
###TRAP TNCONMPL:
ggplot(TNCONMPL,aes(factor(Treatment),TRAP,label=TNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2)

###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),TRAP,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2)
##Analisis de Anova TNCONMPL:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = TNCONMPL)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = 2)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),TRAP,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2)
##Analisis de Anova CENTRE_A:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
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
               geom = "text", aes(label = ..ymax..), vjust = 2)

###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),TRAP,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2)
##Analisis de Anova CENTRE_ATNCONMPL:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)
###TRAP CENTRE_B:
ggplot(CENTRE_B,aes(factor(Treatment),TRAP,label=CENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2)

###CENTRE_Btratadosnotratados:
ggplot(CENTRE_Btratadosnotratados,aes(factor(Treatment),TRAP,label=CENTRE_Btratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2)
##Analisis de Anova CENTRE_B:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = CENTRE_B)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)
##Analisis de Anova CENTRE_Btratadosnotratados:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = CENTRE_Btratadosnotratados)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)
###TRAP CENTRE_BTNCONMPL:
ggplot(CENTRE_BTNCONMPL,aes(factor(Treatment),TRAP,label=CENTRE_BTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2)

###CENTRE_BtratadosnotratadosTNCONMPL:
ggplot(CENTRE_BtratadosnotratadosTNCONMPL,aes(factor(Treatment),TRAP,label=CENTRE_BtratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2)
##Analisis de Anova CENTRE_BTNCONMPL:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = CENTRE_BTNCONMPL)
summary(anova_TRAP)
TukeyHSD(anova_TRAP)
##Analisis de Anova CENTRE_BtratadosnotratadosTNCONMPL:
anova_TRAP <- aov(TRAP ~ Genotype * Treatment, data = CENTRE_BtratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = -22)
###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),UNSTIMULATED.10min,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22)
##Analisis de Anova TRESGRUPOS:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)
##Analisis de Anova tratadosnotratados:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)
###UNSTIMULATED.10min TNCONMPL:
ggplot(TNCONMPL,aes(factor(Treatment),UNSTIMULATED.10min,label=TNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22)
###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),UNSTIMULATED.10min,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22)
##Analisis de Anova TNCONMPL:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = TNCONMPL)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = -22)
###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),UNSTIMULATED.10min,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22)
##Analisis de Anova CENTRE_A:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
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
               geom = "text", aes(label = ..ymax..), vjust = -22)
###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),UNSTIMULATED.10min,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22)
##Analisis de Anova CENTRE_ATNCONMPL:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)
###UNSTIMULATED.10min CENTRE_B:
ggplot(CENTRE_B,aes(factor(Treatment),UNSTIMULATED.10min,label=CENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22)
###CENTRE_Btratadosnotratados:
ggplot(CENTRE_Btratadosnotratados,aes(factor(Treatment),UNSTIMULATED.10min,label=CENTRE_Btratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22)
##Analisis de Anova CENTRE_B:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = CENTRE_B)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)
##Analisis de Anova CENTRE_Btratadosnotratados:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = CENTRE_Btratadosnotratados)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)
###UNSTIMULATED.10min CENTRE_BTNCONMPL:
ggplot(CENTRE_BTNCONMPL,aes(factor(Treatment),UNSTIMULATED.10min,label=CENTRE_BTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22)
###CENTRE_BtratadosnotratadosTNCONMPL:
ggplot(CENTRE_BtratadosnotratadosTNCONMPL,aes(factor(Treatment),UNSTIMULATED.10min,label=CENTRE_BtratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22)
##Analisis de Anova CENTRE_BTNCONMPL:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = CENTRE_BTNCONMPL)
summary(anova_UNSTIMULATED.10min)
TukeyHSD(anova_UNSTIMULATED.10min)
##Analisis de Anova CENTRE_BtratadosnotratadosTNCONMPL:
anova_UNSTIMULATED.10min <- aov(UNSTIMULATED.10min ~ Genotype * Treatment, data = CENTRE_BtratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = -17)

###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),Time.0min,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
##Analisis de Anova PTRESGRUPOS:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)
##Analisis de Anova tratadosnotratados:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)
###Time.0min TNCONMPL:
ggplot(TNCONMPL,aes(factor(Treatment),Time.0min,label=TNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)

###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),Time.0min,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
##Analisis de Anova TNCONMPL:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = TNCONMPL)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = -17)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),Time.0min,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
##Analisis de Anova CENTRE_A:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
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
               geom = "text", aes(label = ..ymax..), vjust = -17)

###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),Time.0min,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
##Analisis de Anova CENTRE_ATNCONMPL:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)
###Time.0min CENTRE_B:
ggplot(CENTRE_B,aes(factor(Treatment),Time.0min,label=CENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)

###CENTRE_Btratadosnotratados:
ggplot(CENTRE_Btratadosnotratados,aes(factor(Treatment),Time.0min,label=CENTRE_Btratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
##Analisis de Anova CENTRE_B:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = CENTRE_B)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)
##Analisis de Anova CENTRE_Btratadosnotratados:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = CENTRE_Btratadosnotratados)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)
###Time.0min CENTRE_BTNCONMPL:
ggplot(CENTRE_BTNCONMPL,aes(factor(Treatment),Time.0min,label=CENTRE_BTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)

###CENTRE_BtratadosnotratadosTNCONMPL:
ggplot(CENTRE_BtratadosnotratadosTNCONMPL,aes(factor(Treatment),Time.0min,label=CENTRE_BtratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)
##Analisis de Anova CENTRE_BTNCONMPL:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = CENTRE_BTNCONMPL)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)
##Analisis de Anova CENTRE_BtratadosnotratadosTNCONMPL:
anova_Time.0min <- aov(Time.0min ~ Genotype * Treatment, data = CENTRE_BtratadosnotratadosTNCONMPL)
summary(anova_Time.0min)
TukeyHSD(anova_Time.0min)

###UNS.Time.10min.vs.Time.0 PTRESGRUPOS:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12)

###tratadosnotratados:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12)
##Analisis de Anova TRESGRUPOS:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)
##Analisis de Anova tratadosnotratados:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = FCA.PLT.aggregationTNMPL.VARIANTtratadosnotratados)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)
###UNS.Time.10min.vs.Time.0 TNCONMPL:
ggplot(TNCONMPL,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=TNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12)

###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12)
##Analisis de Anova TNCONMPL:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = TNCONMPL)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
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
               geom = "text", aes(label = ..ymax..), vjust = -12)

###CENTRE_Atratadosnotratados:
ggplot(CENTRE_Atratadosnotratados,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=CENTRE_Atratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12)
##Analisis de Anova CENTRE_A:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = CENTRE_A)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)
##Analisis de Anova CENTRE_Atratadosnotratados:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = CENTRE_Atratadosnotratados)
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
               geom = "text", aes(label = ..ymax..), vjust = -12)

###FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
ggplot(FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12)
##Analisis de Anova CENTRE_ATNCONMPL:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = CENTRE_ATNCONMPL)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)
##Analisis de Anova FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = FCA_aggregation_filtered_NA27102021_tratadosnotratadosTNCONMPL)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)
###UNS.Time.10min.vs.Time.0 CENTRE_B:
ggplot(CENTRE_B,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=CENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12)

###CENTRE_Btratadosnotratados:
ggplot(CENTRE_Btratadosnotratados,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=CENTRE_Btratadosnotratados$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12)
##Analisis de Anova CENTRE_B:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = CENTRE_B)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)
##Analisis de Anova CENTRE_Btratadosnotratados:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = CENTRE_Btratadosnotratados)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)
###UNS.Time.10min.vs.Time.0 CENTRE_BTNCONMPL:
ggplot(CENTRE_BTNCONMPL,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=CENTRE_BTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12)

###CENTRE_BtratadosnotratadosTNCONMPL:
ggplot(CENTRE_BtratadosnotratadosTNCONMPL,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=CENTRE_BtratadosnotratadosTNCONMPL$Centro.Analisis, vjust= -1)) +
  geom_violin(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12)
##Analisis de Anova CENTRE_BTNCONMPL:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = CENTRE_BTNCONMPL)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)
##Analisis de Anova CENTRE_BtratadosnotratadosTNCONMPL:
anova_UNS.Time.10min.vs.Time.0 <- aov(UNS.Time.10min.vs.Time.0 ~ Genotype * Treatment, data = CENTRE_BtratadosnotratadosTNCONMPL)
summary(anova_UNS.Time.10min.vs.Time.0)
TukeyHSD(anova_UNS.Time.10min.vs.Time.0)
#########Algunas pruebas que hice. El análisis terminaria aqui######################

##PCA:
datosparapca2 <- data.frame(Centro=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Centro.Analisis, PMA=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$PMA, CVX=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$CVX, RISTO=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$RISTO, AGGA=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$AGGA, COL=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$COL, TRAP=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$TRAP, UNSTIMULATED.10min=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$UNSTIMULATED.10min, Time.0min=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Time.0min, UNS.Time.10min.vs.Time.0=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$UNS.Time.10min.vs.Time.0)
datossincentro2 <-data.frame(CD61=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$CD61, CD41=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$CD41, CD49B=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$CD49B, GPVI=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$GPVI, CD42A=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$CD42A, CD42B=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$CD42B, CD31=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$CD31, CD36=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$CD36, CD9=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$CD9)

View(datosparapca2)

#CENTRE_B:
filtro02 <- grep("CENTRE_B", datosparapca2$Centro, ignore.case=TRUE)
CENTRE_B2 <- datosparapca2[filtro0,]
CENTRE_B2 <- data.frame(PMA=CENTRE_B2$PMA, CVX=CENTRE_B2$CVX, RISTO=CENTRE_B2$RISTO, AGGA=CENTRE_B2$AGGA, COL=CENTRE_B2$COL, UNSTIMULATED.10min=CENTRE_B2$UNSTIMULATED.10min, Time.0min=CENTRE_B2$Time.0min, UNS.Time.10min.vs.Time.0=CENTRE_B2$UNS.Time.10min.vs.Time.0)
View(CENTRE_B2)
pca2.CENTRE_B_agonist <- PCA(X = CENTRE_B2, scale.unit = TRUE, ncp = 64, graph = FALSE)
print(pca2.CENTRE_B_agonist$eig)
a2<-fviz_pca_var(pca2.CENTRE_B_agonist, title = "CENTRE_B-Agonist:PCA - Biplot")
#CENTRE_A:
filtro12 <- grep("CENTRE_A", datosparapca2$Centro, ignore.case=TRUE)
CENTRE_A2 <- datosparapca2[filtro1,]
CENTRE_A2 <- data.frame(PMA=CENTRE_A2$PMA, CVX=CENTRE_A2$CVX, RISTO=CENTRE_A2$RISTO, AGGA=CENTRE_A2$AGGA, COL=CENTRE_A2$COL, UNSTIMULATED.10min=CENTRE_A2$UNSTIMULATED.10min, Time.0min=CENTRE_A2$Time.0min, UNS.Time.10min.vs.Time.0=CENTRE_A2$UNS.Time.10min.vs.Time.0)
View(CENTRE_A)
pca2.CENTRE_A_agonist <- PCA(X = CENTRE_A, scale.unit = TRUE, ncp = 64, graph = FALSE)
print(pca2.CENTRE_A_agonist$eig)
b2<-fviz_pca_var(pca2.CENTRE_A_degranulacion, title = "CENTRE_A-Agonist:PCA - Biplot")


###prueba:
View(datosparapca2)
res.comp2 <- imputePCA(datossincentro2,ncp=2)
res.pca2 <- PCA(res.comp2$completeObs)
fviz_pca_ind(res.pca2, label="none", habillage=datosparapca$Centro)
p1 <- fviz_pca_ind(res.pca2, label="none", habillage=datosparapca$Centro,
                   addEllipses=TRUE)


###graficas:
par(mfrow=c(1,3))
plot(a2)
x11()
plot(b2)
x11()
plot(p2)


##Ctrls UntreatedCENTRE_B vs ASACENTRE_B:
filtro1 <- grep("CENTRE_B", FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Centro.Analisis, ignore.case=TRUE)
FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B <- FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS[filtro1,]
df3 <- FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B %>%
  group_by(Treatment) %>%
  summarise(counts = n())

ggplot(df3, aes(x = Treatment, y = counts)) +
  geom_bar(fill = "#0073C2FF", stat = "identity") +
  geom_text(aes(label = counts), vjust = -0.3) + 
  theme_pubclean()
###PMA:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B,aes(factor(Treatment),PMA,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)




###CVX:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B,aes(factor(Treatment),CVX,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20)



###RISTO:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B,aes(factor(Treatment),RISTO,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20)



###AGGA:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B,aes(factor(Treatment),AGGA,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16)



###COL:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B,aes(factor(Treatment),COL,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)



###TRAP(NO HAY):
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B,aes(factor(Treatment),TRAP,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2)



###UNSTIMULATED.10min:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B,aes(factor(Treatment),UNSTIMULATED.10min,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22)



###Time.0min:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B,aes(factor(Treatment),Time.0min,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)


###UNS.Time.10min.vs.Time.0:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSCENTRE_B$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12)

##Ctrls UntreatedJAK2 vs ASAJAK2:
filtro2 <- grep("JAK2 V617F", FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS$Genotype, ignore.case=TRUE)
FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2 <- FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS[filtro2,]
df4 <- FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2 %>%
  group_by(Treatment) %>%
  summarise(counts = n())

ggplot(df4, aes(x = Treatment, y = counts)) +
  geom_bar(fill = "#0073C2FF", stat = "identity") +
  geom_text(aes(label = counts), vjust = -0.3) + 
  theme_pubclean()
###PMA:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2,aes(factor(Treatment),PMA,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 0)




###CVX:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2,aes(factor(Treatment),CVX,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 20)



###RISTO:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2,aes(factor(Treatment),RISTO,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -20)



###AGGA:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2,aes(factor(Treatment),AGGA,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -16)



###COL:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2,aes(factor(Treatment),COL,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)



###TRAP:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2,aes(factor(Treatment),TRAP,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = 2)



###UNSTIMULATED.10min:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2,aes(factor(Treatment),UNSTIMULATED.10min,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -22)



###Time.0min:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2,aes(factor(Treatment),Time.0min,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -17)


###UNS.Time.10min.vs.Time.0:
ggplot(FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2,aes(factor(Treatment),UNS.Time.10min.vs.Time.0,label=FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOSJAK2$Centro.Analisis, vjust= -1)) +
  geom_boxplot(aes(fill=factor(Treatment)), outlier.size=4, outlier.color="red", outlier.fill="red") +
  facet_grid(.~Genotype) +
  geom_point(size = 1) +
  geom_text(check_overlap = TRUE,
            position=position_jitter(width=0.15))+
  stat_summary(fun.y = median, fun.max = length,
               geom = "text", aes(label = ..ymax..), vjust = -12)

###ANOVA:
pma <- aov(PMA ~ Gender + Treatment+ Genotype+ Centro.Analisis, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)
summary(pma)
coefficients(pma)
shapiro.test(fm$residuals)
bartlett.test(fm$residuals ~ colores)
kruskal.test(insectos, colores)
qchisq(0.05, 3-1, lower.tail = F)
pma2 <- aov(PMA ~ Gender*Treatment*Genotype*Centro.Analisis, data = FCA.PLT.aggregationTNMPL.VARIANTTRESGRUPOS)

