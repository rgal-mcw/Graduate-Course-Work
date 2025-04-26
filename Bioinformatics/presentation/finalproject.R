########################################################
# Final Project
########################################################
# Gene expression PCA plot ME180 and SiHa

library(tidyverse)
setwd("C:/Users/rache/Desktop/Biostats MCW/Courses/Bioinformatics Omics class Fall23/final project")
me180_exprs <- read.csv("ME180_GSE235366_gene_expression.xls.csv")
siha_exprs <- read.csv("SiHa_GSE235466_gene_expression.xls.csv")
colnames(me180_exprs) = paste0("me180_", colnames(me180_exprs))
colnames(siha_exprs) = paste0("siha_", colnames(siha_exprs))

me180_exprs=me180_exprs[,1:15]
siha_exprs=siha_exprs[,1:15]

me180_exprs = me180_exprs %>% rename(st_rna_id = me180_st_rna_id, rna_id=me180_rna_id, gene_id=me180_gene_id)
siha_exprs = siha_exprs %>% rename(st_rna_id = siha_st_gene_id, rna_id=siha_gene_id, gene_id=siha_gene_symbol)

combo_exprs=inner_join(me180_exprs,siha_exprs, by=c('st_rna_id', 'rna_id', 'gene_id'))

dim(me180_exprs)
#There are 18358 genes
dim(siha_exprs)
#There are 17156 genes
summary(combo_exprs)

names=colnames(combo_exprs)
rownames(combo_exprs) = combo_exprs$gene_id
combo_exprs=combo_exprs[,4:27]

count_zeros = combo_exprs %>%
  rowwise() %>% 
  summarize(has_zero = any(c_across(everything()) == 0)) %>%
  summarize(count = sum(has_zero))
#2438 zeros

combo_exprs_1 = combo_exprs %>%
  mutate(across(everything(), ~na_if(.x, 0)))

combo_exprs_matrix<-as.matrix(combo_exprs_1)
library(impute)
set.seed(1234)
combo_exprs_matrix=impute.knn(combo_exprs_matrix, k=10)
combo_exprs_df<-as.data.frame(combo_exprs_matrix$data)
# Warning message:
#   In knnimp(x, k, maxmiss = rowmax, maxp = maxp) :
#   1153 rows with more than 50 % entries missing;
# mean imputation used for these rows

count_zeros = combo_exprs_df %>%
  rowwise() %>% 
  summarize(has_zero = any(c_across(everything()) == 0)) %>%
  summarize(count = sum(has_zero))
#No zeros

combo_exprs<-combo_exprs_df
combo_exprs<-log2(combo_exprs)
combo.pca <- prcomp(t(combo_exprs), scale=TRUE)

Sample_Names=names[-c(1:3)]
Cell_line=c("me180", "me180", "me180", "me180", "me180", "me180", "me180", "me180", "me180", "me180", 
            "me180", "me180", "siHa", "siHa", "siHa", "siHa", "siHa", "siHa", "siHa", "siHa", "siHa", "siHa", "siHa", "siHa")
Treatment=c("sgVPS13C", "sgVPS13C", "sgVPS13C", "vector", "vector", "vector","sgVPS13C", "sgVPS13C", "sgVPS13C", "vector", "vector", "vector", 
            "shVPS13C", "shVPS13C", "shVPS13C", "control", "control", "control", "shVPS13C", "shVPS13C", "shVPS13C", "control", "control", "control")
annotations=cbind(Sample_Names, Cell_line, Treatment)
annotations=as.data.frame(annotations)
anno=unite(annotations, ID, Cell_line, Treatment, sep="_", remove=FALSE)
anno=as.matrix(anno)

library(plotly)
library(ggfortify)
library(ggplot2)

autoplot(combo.pca)

#PCA color coded by each sample
plot1 <- autoplot(combo.pca, 
                  data=anno,
                  color="Sample_Names",
                  #labs=TRUE 
                  ggtitle="This is the title" ) 
                 # + labs(x="x-axis label of fig1", y="y-axis label of fig1", title="Fig1 plot"))

ggplotly(plot1) 

# PCA color coded by Cell line & Treatment
plot2 <- autoplot(combo.pca, 
                  data=anno,
                  color="ID",
                  labs=TRUE)
ggplotly(plot2)

# PCA color coded by Cell line
plot3 <- autoplot(combo.pca, 
                  data=anno,
                  color="Cell_line",
                  labs=TRUE)
ggplotly(plot3) 

#################################################################################
######################################################################
#Survival KM Plots

library(TCGAbiolinks)
library(survminer)
library(survival)
library(SummarizedExperiment)
library(tidyverse)
library(DESeq2)
library(dplyr)

#Breast Cancer (BRCA)
#GDC search terms
#Project Id IS TCGA-BRCA AND Gene IS VPS13C
#n=352 for tcga
#n=4929 for kmplot website
clinical_brca <- readr::read_tsv('brca_clinical.tsv')
colnames(clinical_brca)
any(colnames(clinical_brca) %in% c("vital_status", "days_to_last_follow_up", "days_to_death"))
which(colnames(clinical_brca) %in% c("vital_status", "days_to_last_follow_up", "days_to_death"))
clinical_brca[,c(9,39,45)]
table(clinical_brca$vital_status)
clinical_brca$deceased <- ifelse(clinical_brca$vital_status == "Alive", FALSE, TRUE)

# create an "overall survival" variable that is equal to days_to_death
# for dead patients, and to days_to_last_follow_up for patients who
# are still alive
clinical_brca$overall_survival <- ifelse(clinical_brca$vital_status == "Alive",
                                         clinical_brca$days_to_last_follow_up,
                                         clinical_brca$days_to_death)

kmdata_brca<-subset(clinical_brca, select = c("overall_survival", "deceased"))
kmdata_brca$overall_survival<-as.numeric(kmdata_brca$overall_survival)

kmdata_brca <- kmdata_brca %>% mutate(deceased = as.numeric(deceased))
kmdata_brca
#true=1 yes they are deceased
#no=0 no they are alive
# fitting survival curve -----------
fit <- survfit(Surv(overall_survival, deceased) ~ 1, data = kmdata_brca)
fit

ggsurvplot(fit, data = kmdata_brca, risk.table = TRUE,  palette = c("#e0218a"),
           conf.int = TRUE, xlab="Time (days) ", conf.int.style = "step", title= "TCGA-BRCA survival with VSP13C Mutations")
#survdiff(Survoverall_survival, deceased)~1, data=kmdata_brca))

######################################################################

# Lung Cancer (LUSC) Lung Squamous Cell Carcinoma
#GDC search terms
#Project Id IS TCGA-LUSC AND Gene IS VPS13C
clinical_lung <- readr::read_tsv('clinical_lusc.tsv')
colnames(clinical_lung)
#n=2166 for kmplot website
#n=227 for tcga-lusc 

any(colnames(clinical_lung) %in% c("vital_status", "days_to_last_follow_up", "days_to_death"))
which(colnames(clinical_lung) %in% c("vital_status", "days_to_last_follow_up", "days_to_death"))
clinical_lung[,c(9,39,45)]
table(clinical_lung$vital_status)
clinical_lung$deceased <- ifelse(clinical_lung$vital_status == "Alive", FALSE, TRUE)

# create an "overall survival" variable that is equal to days_to_death
# for dead patients, and to days_to_last_follow_up for patients who
# are still alive
clinical_lung$overall_survival <- ifelse(clinical_lung$vital_status == "Alive",
                                         clinical_lung$days_to_last_follow_up,
                                         clinical_lung$days_to_death)

kmdata_lung<-subset(clinical_lung, select = c("overall_survival", "deceased"))
kmdata_lung$overall_survival<-as.numeric(kmdata_lung$overall_survival)
kmdata_lung <- kmdata_lung %>% mutate(deceased = as.numeric(deceased))
kmdata_lung
#true=1 yes they are deceased
#no=0 no they are alive
# fitting survival curve -----------
fit <- survfit(Surv(overall_survival, deceased) ~ 1, data = kmdata_lung)
fit

ggsurvplot(fit, data = kmdata_lung, risk.table = TRUE,  palette = c("#A020F0"),
           conf.int = TRUE, xlab="Time (days) ", conf.int.style = "step", title= "TCGA-LUSC survival with VSP13C Mutations")
#survdiff(Survoverall_survival, deceased)~1, data=kmdata_lung))
######################################################################
# Lung AdenoCarcinoma (LUAD)
#GDC search terms
#Project Id IS TCGA-LUAD AND Gene IS VPS13C
#no plot on kmplot website
#n=229
clinical_luad <- readr::read_tsv('clinical_luad.tsv')
colnames(clinical_luad)

any(colnames(clinical_luad) %in% c("vital_status", "days_to_last_follow_up", "days_to_death"))
which(colnames(clinical_luad) %in% c("vital_status", "days_to_last_follow_up", "days_to_death"))
clinical_luad[,c(9,39,45)]
table(clinical_luad$vital_status)
clinical_luad$deceased <- ifelse(clinical_luad$vital_status == "Alive", FALSE, TRUE)

# create an "overall survival" variable that is equal to days_to_death
# for dead patients, and to days_to_last_follow_up for patients who
# are still alive
clinical_luad$overall_survival <- ifelse(clinical_luad$vital_status == "Alive",
                                         clinical_luad$days_to_last_follow_up,
                                         clinical_luad$days_to_death)

kmdata_luad<-subset(clinical_luad, select = c("overall_survival", "deceased"))
kmdata_luad$overall_survival<-as.numeric(kmdata_luad$overall_survival)
kmdata_luad <- kmdata_luad %>% mutate(deceased = as.numeric(deceased))
kmdata_luad
#true=1 yes they are deceased
#no=0 no they are alive
# fitting survival curve -----------
fit <- survfit(Surv(overall_survival, deceased) ~ 1, data = kmdata_luad)
fit

ggsurvplot(fit, data = kmdata_luad, risk.table = TRUE,  palette = c("#4169e1"),
           conf.int = TRUE, xlab="Time (days) ", conf.int.style = "step", title= "TCGA-LUAD survival with VSP13C Mutations")
#survdiff(Survoverall_survival, deceased)~1, data=kmdata_luad))

###################################################################

#Gastric Cancer (Stomach Adenocarcinoma - STAD)
#GDC search terms
#Project Id IS TCGA-STAD AND Gene IS VPS13C
clinical_stad <- readr::read_tsv('clinical_stad.tsv')
colnames(clinical_stad)
#n=141 for tcga
#n= for kmplot website
any(colnames(clinical_stad) %in% c("vital_status", "days_to_last_follow_up", "days_to_death"))
which(colnames(clinical_stad) %in% c("vital_status", "days_to_last_follow_up", "days_to_death"))
clinical_stad[,c(9,39,45)]
table(clinical_stad$vital_status)
clinical_stad$deceased <- ifelse(clinical_stad$vital_status == "Alive", FALSE, TRUE)

# create an "overall survival" variable that is equal to days_to_death
# for dead patients, and to days_to_last_follow_up for patients who
# are still alive
clinical_stad$overall_survival <- ifelse(clinical_stad$vital_status == "Alive",
                                         clinical_stad$days_to_last_follow_up,
                                         clinical_stad$days_to_death)

kmdata_stad<-subset(clinical_stad, select = c("overall_survival", "deceased"))
kmdata_stad$overall_survival<-as.numeric(kmdata_stad$overall_survival)
kmdata_stad <- kmdata_stad %>% mutate(deceased = as.numeric(deceased))
kmdata_stad
#true=1 yes they are deceased
#no=0 no they are alive
# fitting survival curve -----------
fit <- survfit(Surv(overall_survival, deceased) ~ 1, data = kmdata_stad)
fit

ggsurvplot(fit, data = kmdata_stad, risk.table = TRUE,  palette = c("#CCCCFF"),
           conf.int = TRUE, xlab="Time (days) ", conf.int.style = "step", title= "TCGA-STAD survival with VSP13C Mutations")
#survdiff(Survoverall_survival, deceased)~1, data=kmdata_stad))
###################################################################
# Additionally - Not done in paper
# Cervix Cancer (CESC)
#GDC search terms
#Project Id IS TCGA-CESC AND Gene IS VPS13C
#n=96

clinical_cesc <- readr::read_tsv('clinical_cesc.tsv')
colnames(clinical_cesc)
any(colnames(clinical_cesc) %in% c("vital_status", "days_to_last_follow_up", "days_to_death"))
which(colnames(clinical_cesc) %in% c("vital_status", "days_to_last_follow_up", "days_to_death"))
clinical_cesc[,c(9,39,45)]
table(clinical_cesc$vital_status)
clinical_cesc$deceased <- ifelse(clinical_cesc$vital_status == "Alive", FALSE, TRUE)

# create an "overall survival" variable that is equal to days_to_death
# for dead patients, and to days_to_last_follow_up for patients who
# are still alive
clinical_cesc$overall_survival <- ifelse(clinical_cesc$vital_status == "Alive",
                                         clinical_cesc$days_to_last_follow_up,
                                         clinical_cesc$days_to_death)

kmdata_cesc<-subset(clinical_cesc, select = c("overall_survival", "deceased"))
kmdata_cesc$overall_survival<-as.numeric(kmdata_cesc$overall_survival)
kmdata_cesc <- kmdata_cesc %>% mutate(deceased = as.numeric(deceased))
kmdata_cesc
#true=1 yes they are deceased
#no=0 no they are alive
# fitting survival curve -----------
fit <- survfit(Surv(overall_survival, deceased) ~ 1, data = kmdata_cesc)
fit

ggsurvplot(fit, data = kmdata_cesc, risk.table = TRUE,  palette = c("#008080"),
           conf.int = TRUE, xlab="Time (days) ", conf.int.style = "step", title= "TCGA-CESC survival with VSP13C Mutations")
#survdiff(Survoverall_survival, deceased)~1, data=kmdata_cesc))

