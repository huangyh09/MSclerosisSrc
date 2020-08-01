#!/bin/sh

DAT_DIR=/hps/nobackup/stegle/users/huangh/msclerosis/genotype


### Genotyped
## Batch01
out_file=$DAT_DIR/vcf/batches/ms.batch01.raw.original.vcf
chrFile_list=$DAT_DIR/batch01/raw/EMC_Merck_Mar28_forward_genotype_chr1
for chrom in `seq 2 22`
do
chrFile_list=$chrFile_list,$DAT_DIR/batch01/raw/EMC_Merck_Mar28_forward_genotype_chr$chrom
done
python VCF_convert.py -i $chrFile_list -o $out_file


## Batch02
out_file=$DAT_DIR/vcf/batches/ms.batch02.raw.original.vcf
chrFile_list=$DAT_DIR/batch02/Genotyped_Batch02/MS_all_genotype_July02_chr1
for chrom in `seq 2 22`
do
chrFile_list=$chrFile_list,$DAT_DIR/batch02/Genotyped_Batch02/MS_all_genotype_July02_chr$chrom
done
python VCF_convert.py -i $chrFile_list -o $out_file


## Batch03
out_file=$DAT_DIR/vcf/batches/ms.batch03.raw.original.vcf
chrFile_list=$DAT_DIR/batch03/Genotyped_Batch03/Merck_Aug_forward_genotype_chr1
for chrom in `seq 2 22`
do
chrFile_list=$chrFile_list,$DAT_DIR/batch03/Genotyped_Batch03/Merck_Aug_forward_genotype_chr$chrom
done
python VCF_convert.py -i $chrFile_list -o $out_file


## Batch04
out_file=$DAT_DIR/vcf/batches/ms.batch04.raw.original.vcf
chrFile_list=$DAT_DIR/batch04/Genotyped_Batch04/TU_Nov30_forward_genotype_chr1.gz
for chrom in `seq 2 22`
do
chrFile_list=$chrFile_list,$DAT_DIR/batch04/Genotyped_Batch04/TU_Nov30_forward_genotype_chr$chrom.gz
done
python VCF_convert.py -i $chrFile_list -o $out_file



### Imputed
## Batch01
out_file=$DAT_DIR/vcf/batches/ms.batch01.imputed.original.vcf
chrFile_list=$DAT_DIR/batch01/imputed/MS_Merck_imputed_phased_genotype_chr1_Mar_2018.txt
for chrom in `seq 2 22`
do
chrFile_list=$chrFile_list,$DAT_DIR/batch01/imputed/MS_Merck_imputed_phased_genotype_chr$chrom"_Mar_2018.txt"
done
python VCF_convert.py -i $chrFile_list -o $out_file --imputed


## Batch02
out_file=$DAT_DIR/vcf/batches/ms.batch02.imputed.original.vcf
chrFile_list=$DAT_DIR/batch02/Imputed_Batch02/MS_Merck_imputed_phased_genotype_chr1_2018.txt.gz
for chrom in `seq 2 22`
do
chrFile_list=$chrFile_list,$DAT_DIR/batch02/Imputed_Batch02/MS_Merck_imputed_phased_genotype_chr$chrom"_2018.txt.gz"
done
python VCF_convert.py -i $chrFile_list -o $out_file --imputed


## Batch03
out_file=$DAT_DIR/vcf/batches/ms.batch03.imputed.original.vcf
chrFile_list=$DAT_DIR/batch03/Imputed_Batch03/MS_Merck_Aug_imputed_phased_genotype_chr1.txt.gz
for chrom in `seq 2 22`
do
chrFile_list=$chrFile_list,$DAT_DIR/batch03/Imputed_Batch03/MS_Merck_Aug_imputed_phased_genotype_chr$chrom.txt.gz
done
python VCF_convert.py -i $chrFile_list -o $out_file -g False --imputed


## Batch04
out_file=$DAT_DIR/vcf/batches/ms.batch04.imputed.original.vcf
chrFile_list=$DAT_DIR/batch04/Imputed_Batch04/MS_Merck_Dec_imputed_phased_genotype_chr1.txt.gz
for chrom in `seq 2 22`
do
chrFile_list=$chrFile_list,$DAT_DIR/batch04/Imputed_Batch04/MS_Merck_Dec_imputed_phased_genotype_chr$chrom.txt.gz
done
python VCF_convert.py -i $chrFile_list -o $out_file --imputed

