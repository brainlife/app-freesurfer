#!/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
base_dir <- args[1]
temp_dir <- args[2]

wd <- getwd()
setwd(base_dir)

files<-c(
    "Aparc_CInd.r",
    "Aparc_ThxAvg.r",
    "Aparc_FInd.r",
    "Aparc_GCurv.r",
    "Aparc_GVol.r",
    "Aparc_MCurv.r",
    "Aparc_SArea.r",
    "Aparc_ThxStd.r",
    "Aseg_IntMax.r",
    "Aseg_IntMean.r",
    "Aseg_IntMin.r",
    "Aseg_IntRange.r",
    "Aseg_IntStdDev.r",
    "Aseg_Vol.r",
    "BA_CInd.r",
    "BA_FInd.r",
    "BA_GCurv.r",
    "BA_GVol.r",
    "BA_MCurv.r",
#    "BA_NumVert.R",
    "BA_SArea.r",
    "BA_ThxAvg.r",
    "BA_ThxStd.r",
    "Wmparc_IntMax.r",
    "Wmparc_IntMean.r",
    "Wmparc_IntMin.r",
    "Wmparc_IntRag.r",
    "Wmparc_StdDev.r",
    "Wmparc_Vol.r"
)
for(file in files) {
    print(file)
    source(paste(wd, file, sep="/"))
}


