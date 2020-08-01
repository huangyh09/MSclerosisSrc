# Running HIBAG for MS data
# Author: Yuanhua Huang
# Date: 02/12/2019

## HIBAG usage
# Models: http://public-html.biostat.washington.edu/~bsweir/HIBAG/param/European-HLA4.html
# Examples: http://zhengxwen.github.io/HIBAG/hibag_index.html

## Pre-step:
# PLINK files are generated from VCF file:
# plink --vcf dir/imputed.vcf.gz --make-bed --out dir/MS_imputed --noweb

## Load arguments
args <- commandArgs(TRUE)

plink_file <- "~/links/msData/genotype/vcf/plink/my_plink_prefix"
if (length(args) >= 1) {
    plink_file <- args[1]
}
out_file <- paste0(plink_file, ".HIBAG.")
if (length(args) >= 2) {
    out_file <- args[2]
}
model_file <- "~/links/msData/genotype/hibag/European-HLA4-hg19.RData"
if (length(args) >= 3) {
    model_file <- args[3]
}

library(HIBAG)

model.list <- get(load(model_file))

MHC_geno <- hlaBED2Geno(bed.fn=paste0(plink_file, ".bed"), 
                        fam.fn=paste0(plink_file, ".fam"), 
                        bim.fn=paste0(plink_file, ".bim"), 
                        assembly="hg19")
summary(MHC_geno)


## HLA imputation at HLA-A
hla.ids <- c("A", "B", "C", "DRB1", "DQA1", "DQB1", "DPB1")

pred_list <- list()
for (hla.id in hla.ids) {
    model <- hlaModelFromObj(model.list[[hla.id]])
    pred_list[[hla.id]] <- predict(model, MHC_geno, 
                                   type="response+prob")
}

head(pred_list[["A"]]$value)

## Save results
for (hla.id in hla.ids) {
    write.table(pred_list[[hla.id]]$value, 
                file=paste0(out_file, hla.id, ".tsv"), 
                sep="\t", quote=FALSE, row.names=FALSE)
}
