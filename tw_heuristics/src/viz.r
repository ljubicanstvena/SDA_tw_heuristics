#library(tidyverse)

getwd()

setwd("C:/Users/Anita/Documents/tu/master/StructuralDecompositionsAlg/ss24/project/SDA_tw_heuristics/tw_heuristics/output/statistics/total/10")

df_gmc <- read.csv("statistics_gmc.csv", header = TRUE, sep = ";")
colnames(df_gmc)[colnames(df_gmc) == 'tw'] <- 'gmc'
View(df_gmc)

df_gmd <- read.csv("statistics_gmd.csv", header = TRUE, sep = ";")
colnames(df_gmd)[colnames(df_gmd) == 'tw'] <- 'gmd'
View(df_gmd)

df_gmf <- read.csv("statistics_gmf.csv", header = TRUE, sep = ";")
colnames(df_gmf)[colnames(df_gmf) == 'tw'] <- 'gmf'
View(df_gmf)

df = merge(x=df_gmc, y=df_gmd, by=c("name", "n", "p", "num"))
View(df)
df = merge(x=df, y=df_gmf, by=c("name", "n", "p", "num"))
View(df)

df_10_025 = df[df[3]==0.25, c("num", "gmc", "gmd", "gmf")]
View(df_10_025)

#plot(x=df_10_025$num, y=df_10_025$gmc,
#     xlab = "instance", ylab = "treewidth", 
#     xlim = c(1,100), ylim = c(0,10), main = "n=10 p=0.25")

install.packages("ggplot2")
#library(ggplot2)
