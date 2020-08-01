#!/bin/sh

dat_dir=$HOME/links/msData/genotype/vcf

### make plink files from VCF
plink --vcf $dat_dir/ms.batch1to4.raw.use.vcf.gz \
    --make-bed --out $dat_dir/plink/ms.batch1to4.raw.use.hg19 --noweb

### run HIBAG with plink files
Rscript HIBAG_bin.R $dat_dir/plink/ms.batch1to4.raw.use.hg19
