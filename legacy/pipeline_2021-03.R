# ----------------------------------------------------------------------------
# Legacy script from a commissioned analysis of platelet function by flow
# cytometry in essential thrombocythemia (2021), published with the written
# authorization of the principal investigator of the study. Analyses related
# to: Molecular & Cellular Proteomics 25(8):101617, 2026,
# https://doi.org/10.1016/j.mcpro.2026.101617
# Original file: exploratory pipeline of March 2021 (original file name withheld,
# it included a first name; R base, no tests), original encoding ASCII, CRLF line endings.
# Changes with respect to the delivered file (see docs/cleaning.md): absolute
# paths replaced by data/<file>, setwd() calls disabled, the two centres
# renamed CENTRE_A and CENTRE_B, one genotype label renamed VARIANT and one
# genotype category renamed CALR Type_Other. No other change was made; the
# code is not executable without the private input data. Original SHA-256: e9c433a8565414f0b9a58af4023ce6dd6b6891c58002d2d10d0ad25e3a4c39e1
# ----------------------------------------------------------------------------
library(gmodels)
FCA.PLT.aggregation <- read.delim2("data/FCA PLT aggregation.txt")
summary(FCA.PLT.aggregation)
View(FCA.PLT.aggregation)
primeraPMA <- data.frame(SEXO=FCA.PLT.aggregation$Gender, GENOTIPO=FCA.PLT.aggregation$Genotype, TRATAMIENTO=FCA.PLT.aggregation$Treatment, CENTRO=FCA.PLT.aggregation$Centro.Analisis, AUCPMA=FCA.PLT.aggregation$PMA)
segundaCVX <- data.frame(SEXO=FCA.PLT.aggregation$Gender, GENOTIPO=FCA.PLT.aggregation$Genotype, TRATAMIENTO=FCA.PLT.aggregation$Treatment, CENTRO=FCA.PLT.aggregation$Centro.Analisis, AUCCVX=FCA.PLT.aggregation$CVX)
terceraRISTO <- data.frame(SEXO=FCA.PLT.aggregation$Gender, GENOTIPO=FCA.PLT.aggregation$Genotype, TRATAMIENTO=FCA.PLT.aggregation$Treatment, CENTRO=FCA.PLT.aggregation$Centro.Analisis, AUCRISTO=FCA.PLT.aggregation$RISTO)
cuartaAGGA <- data.frame(SEXO=FCA.PLT.aggregation$Gender, GENOTIPO=FCA.PLT.aggregation$Genotype, TRATAMIENTO=FCA.PLT.aggregation$Treatment, CENTRO=FCA.PLT.aggregation$Centro.Analisis, AUCAGGA=FCA.PLT.aggregation$AGGA)
quintaCOL <- data.frame(SEXO=FCA.PLT.aggregation$Gender, GENOTIPO=FCA.PLT.aggregation$Genotype, TRATAMIENTO=FCA.PLT.aggregation$Treatment, CENTRO=FCA.PLT.aggregation$Centro.Analisis, AUCCOL=FCA.PLT.aggregation$COL)
sextaTRAP <- data.frame(SEXO=FCA.PLT.aggregation$Gender, GENOTIPO=FCA.PLT.aggregation$Genotype, TRATAMIENTO=FCA.PLT.aggregation$Treatment, CENTRO=FCA.PLT.aggregation$Centro.Analisis, AUCTRAP=FCA.PLT.aggregation$TRAP)
septimaPCA <- data.frame(AUCPMA=FCA.PLT.aggregation$PMA, AUCCVX=FCA.PLT.aggregation$CVX, AUCRISTO=FCA.PLT.aggregation$RISTO, AUCAGGA=FCA.PLT.aggregation$AGGA, AUCCOL=FCA.PLT.aggregation$COL, AUCTRAP=FCA.PLT.aggregation$TRAP, diezmin=FCA.PLT.aggregation$UNSTIMULATED.10min, ceromin=FCA.PLT.aggregation$Time.0min, cerodiezmin=FCA.PLT.aggregation$UNS.Time.10min.vs.Time.0)
#PMA:
View(primeraPMA)
summary(primeraPMA)
sd(primeraPMA$AUCPMA, na.rm = T)
hist(primeraPMA$AUCPMA)
plot(primeraPMA$AUCPMA)
boxplot(primeraPMA$AUCPMA ~ primeraPMA$SEXO, las = 2, xlab = "SEXO", ylab = "AUCPMA")
stripchart(primeraPMA$AUCPMA ~ primeraPMA$SEXO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(primeraPMA$AUCPMA ~primeraPMA$GENOTIPO, xlab = "GENOTIPO", ylab = "AUCPMA")
stripchart(primeraPMA$AUCPMA ~primeraPMA$GENOTIPO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(primeraPMA$AUCPMA ~primeraPMA$TRATAMIENTO, xlab = "TRATAMIENTO", ylab = "AUCPMA")
stripchart(primeraPMA$AUCPMA ~primeraPMA$TRATAMIENTO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(primeraPMA$AUCPMA ~primeraPMA$CENTRO, xlab = "CENTRO", ylab = "AUCPMA")
stripchart(primeraPMA$AUCPMA ~primeraPMA$CENTRO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)

#CVX:
summary(segundaCVX)
sd(segundaCVX$AUCCVX, na.rm = T)
hist(segundaCVX$AUCCVX)
plot(segundaCVX$AUCCVX)
boxplot(segundaCVX$AUCCVX ~segundaCVX$SEXO, xlab = "SEXO", ylab = "AUCCVX")
stripchart(segundaCVX$AUCCVX ~segundaCVX$SEXO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(segundaCVX$AUCCVX ~segundaCVX$GENOTIPO, xlab = "GENOTIPO", ylab = "AUCCVX")
stripchart(segundaCVX$AUCCVX ~segundaCVX$GENOTIPO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(segundaCVX$AUCCVX ~segundaCVX$TRATAMIENTO, xlab = "TRATAMIENTO", ylab = "AUCCVX")
stripchart(segundaCVX$AUCCVX ~segundaCVX$TRATAMIENTO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(segundaCVX$AUCCVX ~segundaCVX$CENTRO, xlab = "CENTRO", ylab = "AUCCVX")
stripchart(segundaCVX$AUCCVX ~segundaCVX$CENTRO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)

#RISTO:
summary(terceraRISTO)
sd(terceraRISTO$AUCRISTO, na.rm = T)
hist(terceraRISTO$AUCRISTO)
plot(terceraRISTO$AUCRISTO)
boxplot(terceraRISTO$AUCRISTO ~terceraRISTO$SEXO, xlab = "SEXO", ylab = "AUCRISTO")
stripchart(terceraRISTO$AUCRISTO ~terceraRISTO$SEXO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(terceraRISTO$AUCRISTO ~terceraRISTO$GENOTIPO, xlab = "GENOTIPO", ylab = "AUCRISTO")
stripchart(terceraRISTO$AUCRISTO ~terceraRISTO$GENOTIPO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(terceraRISTO$AUCRISTO ~terceraRISTO$TRATAMIENTO, xlab = "TRATAMIENTO", ylab = "AUCRISTO")
stripchart(terceraRISTO$AUCRISTO ~terceraRISTO$TRATAMIENTO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(terceraRISTO$AUCRISTO ~terceraRISTO$CENTRO, xlab = "CENTRO", ylab = "AUCRISTO")
stripchart(terceraRISTO$AUCRISTO ~terceraRISTO$CENTRO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)

#AGGA:
summary(cuartaAGGA)
sd(cuartaAGGA$AUCAGGA, na.rm = T)
hist(cuartaAGGA$AUCAGGA)
plot(cuartaAGGA$AUCAGGA)
boxplot(cuartaAGGA$AUCAGGA ~cuartaAGGA$SEXO, xlab = "SEXO", ylab = "AUCAGGA")
stripchart(cuartaAGGA$AUCAGGA ~cuartaAGGA$SEXO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(cuartaAGGA$AUCAGGA ~cuartaAGGA$GENOTIPO, xlab = "GENOTIPO", ylab = "AUCAGGA")
stripchart(cuartaAGGA$AUCAGGA ~cuartaAGGA$GENOTIPO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(cuartaAGGA$AUCAGGA ~cuartaAGGA$TRATAMIENTO, xlab = "TRATAMIENTO", ylab = "AUCAGGA")
stripchart(cuartaAGGA$AUCAGGA ~cuartaAGGA$TRATAMIENTO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(cuartaAGGA$AUCAGGA ~cuartaAGGA$CENTRO, xlab = "CENTRO", ylab = "AAUCAGGA")
stripchart(cuartaAGGA$AUCAGGA ~cuartaAGGA$CENTRO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)

#COL:
summary(quintaCOL)
sd(quintaCOL$AUCCOL, na.rm = T)
hist(quintaCOL$AUCCOL)
plot(quintaCOL$AUCCOL)
boxplot(quintaCOL$AUCCOL ~quintaCOL$SEXO, xlab = "SEXO", ylab = "AUCCOL")
stripchart(quintaCOL$AUCCOL ~quintaCOL$SEXO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(quintaCOL$AUCCOL ~quintaCOL$GENOTIPO, xlab = "GENOTIPO", ylab = "AUCCOL")
stripchart(quintaCOL$AUCCOL ~quintaCOL$GENOTIPO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(quintaCOL$AUCCOL ~quintaCOL$TRATAMIENTO, xlab = "TRATAMIENTO", ylab = "AUCCOL")
stripchart(quintaCOL$AUCCOL ~quintaCOL$TRATAMIENTO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(quintaCOL$AUCCOL ~quintaCOL$CENTRO, xlab = "CENTRO", ylab = "AUCCOL")
stripchart(quintaCOL$AUCCOL ~quintaCOL$CENTRO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)

#TRAP:
summary(sextaTRAP)
sd(sextaTRAP$AUTRAP, na.rm = T)
hist(sextaTRAP$AUCTRAP)
plot(sextaTRAP$AUCTRAP)
boxplot(sextaTRAP$AUCTRAP ~sextaTRAP$SEXO, xlab = "SEXO", ylab = "AUCTRAP")
stripchart(sextaTRAP$AUCTRAP ~sextaTRAP$SEXO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(sextaTRAP$AUCTRAP ~sextaTRAP$GENOTIPO, xlab = "GENOTIPO", ylab = "AUCTRAP")
stripchart(sextaTRAP$AUCTRAP ~sextaTRAP$GENOTIPO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(sextaTRAP$AUCTRAP ~sextaTRAP$TRATAMIENTO, xlab = "TRATAMIENTO", ylab = "AUCTRAP")
stripchart(sextaTRAP$AUCTRAP ~sextaTRAP$TRATAMIENTO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(sextaTRAP$AUCTRAP ~sextaTRAP$CENTRO, xlab = "CENTRO", ylab = "AUCTRAP")
stripchart(sextaTRAP$AUCTRAP ~sextaTRAP$CENTRO, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)


#PCA:
library(FactoMineR)
library(stats)
View(septimaPCA)
pcaprueba2 <- PCA(septimaPCA)
pcaprueba2$call

#Separar los controles del resto del database:+
filtro <- grep("CNTRL", FCA.PLT.aggregation$Genotype, ignore.case=TRUE)
solocontroles<- FCA.PLT.aggregation[filtro,]
View(solocontroles)
primerahipotesis <- data.frame(Tratamiento=solocontroles$Treatment, PMA=solocontroles$PMA, CVX=solocontroles$CVX, RISTO=solocontroles$RISTO, AGGA=solocontroles$AGGA, COL=solocontroles$COL, TRAP=solocontroles$TRAP)
boxplot(primerahipotesis$PMA ~primerahipotesis$Tratamiento, xlab = "TRATAMIENTO", ylab = "AUCPMA")
stripchart(primerahipotesis$PMA ~primerahipotesis$Tratamiento, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(primerahipotesis$CVX ~primerahipotesis$Tratamiento, xlab = "TRATAMIENTO", ylab = "AUCCVX")
stripchart(primerahipotesis$CVX ~primerahipotesis$Tratamiento, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(primerahipotesis$RISTO ~primerahipotesis$Tratamiento, xlab = "TRATAMIENTO", ylab = "AUCRISTO")
stripchart(primerahipotesis$RISTO ~primerahipotesis$Tratamiento, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(primerahipotesis$AGGA ~primerahipotesis$Tratamiento, xlab = "TRATAMIENTO", ylab = "AUCAGGA")
stripchart(primerahipotesis$AGGA ~primerahipotesis$Tratamiento, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(primerahipotesis$COL ~primerahipotesis$Tratamiento, xlab = "TRATAMIENTO", ylab = "AUCCOL")
stripchart(primerahipotesis$COL ~primerahipotesis$Tratamiento, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(primerahipotesis$TRAP ~primerahipotesis$Tratamiento, xlab = "TRATAMIENTO", ylab = "AUCTRAP")
stripchart(primerahipotesis$TRAP ~primerahipotesis$Tratamiento, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
segundahipotesis <- data.frame(Tratamiento= FCA.PLT.aggregation$Treatment, Genotipo=FCA.PLT.aggregation$Genotype)
tabla2 <- table(segundahipotesis$Tratamiento, segundahipotesis$Genotipo)
View(tabla2)
barplot(tabla2, beside = TRUE, las=1, 
        xlab='Genotipo', ylab='Tratamiento',
        col = c("lightblue", "mistyrose", "red", "orange", "grey", "black", "yellow", "brown", "pink", "purple", "white", "darkgoldenrod3"),
        ylim = c(0, 50))
legend('topleft', legend=rownames(tabla2), bty='n',
       fill=c("lightblue", "mistyrose", "red", "orange", "grey", "black", "yellow", "brown", "pink", "purple", "white", "darkgoldenrod3"))
FCA.PLT.aggregationTNMPL.VARIANT <- read.delim2("data/FCA PLT aggregationTNVARIANT.txt")
segundahipotesisb <- data.frame(Tratamiento= FCA.PLT.aggregationTNMPL.VARIANT$Treatment, Genotipo=FCA.PLT.aggregationTNMPL.VARIANT$Genotype)
tabla3 <- table(segundahipotesisb$Tratamiento, segundahipotesisb$Genotipo)
barplot(tabla3, beside = TRUE, las=1, 
        xlab='Genotipo', ylab='Tratamiento',
        col = c("lightblue", "mistyrose", "red", "orange", "grey", "black", "yellow", "brown", "pink", "purple", "white", "darkgoldenrod3"),
        ylim = c(0, 50))
legend('topleft', legend=rownames(tabla3), bty='n',
       fill=c("lightblue", "mistyrose", "red", "orange", "grey", "black", "yellow", "brown", "pink", "purple", "white", "darkgoldenrod3"))

boxplot(FCA.PLT.aggregation$UNSTIMULATED.10min ~FCA.PLT.aggregation$Genotype, xlab = "Genotipo", ylab = "Tiempo 10")
stripchart(FCA.PLT.aggregation$UNSTIMULATED.10min ~FCA.PLT.aggregation$Genotype, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(FCA.PLT.aggregation$Time.0min ~FCA.PLT.aggregation$Genotype, xlab = "Genotipo", ylab = "Tiempo 0")
stripchart(FCA.PLT.aggregation$Time.0min ~FCA.PLT.aggregation$Genotype, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(FCA.PLT.aggregation$UNS.Time.10min.vs.Time.0 ~FCA.PLT.aggregation$Genotype, xlab = "Genotipo", ylab = "Tiempo 10 vs 0")
stripchart(FCA.PLT.aggregation$UNS.Time.10min.vs.Time.0 ~FCA.PLT.aggregation$Genotype, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)

boxplot(FCA.PLT.aggregationTNMPL.VARIANT$UNSTIMULATED.10min ~FCA.PLT.aggregationTNMPL.VARIANT$Genotype, xlab = "Genotipo", ylab = "Tiempo 10")
stripchart(FCA.PLT.aggregationTNMPL.VARIANT$UNSTIMULATED.10min ~FCA.PLT.aggregationTNMPL.VARIANT$Genotype, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(FCA.PLT.aggregationTNMPL.VARIANT$Time.0min ~FCA.PLT.aggregationTNMPL.VARIANT$Genotype, xlab = "Genotipo", ylab = "Tiempo 0")
stripchart(FCA.PLT.aggregationTNMPL.VARIANT$Time.0min ~FCA.PLT.aggregationTNMPL.VARIANT$Genotype, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
boxplot(FCA.PLT.aggregationTNMPL.VARIANT$UNS.Time.10min.vs.Time.0 ~FCA.PLT.aggregationTNMPL.VARIANT$Genotype, xlab = "Genotipo", ylab = "Tiempo 10 vs 0")
stripchart(FCA.PLT.aggregationTNMPL.VARIANT$UNS.Time.10min.vs.Time.0 ~FCA.PLT.aggregationTNMPL.VARIANT$Genotype, vertical = TRUE, method = "jitter",pch = 19,add = TRUE)
