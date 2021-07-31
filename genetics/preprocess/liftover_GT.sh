#!/bin/sh

DAT_DIR=/hps/nobackup/stegle/users/huangh/msclerosis/genotype/vcf
cd $DAT_DIR

CHAIN=/hps/nobackup/stegle/users/huangh/annotation/human/liftOver/hg19ToHg38.over.chain.gz
BIN_DIR=/homes/huangh/MyGit/cellSNP/liftOver

# python $BIN_DIR/liftOver_vcf.py -c $CHAIN -i $DAT_DIR/ms.batch1to4.imputed.use.vcf.gz \
#     -o $DAT_DIR/ms.batch1to4.imputed.use.hg38.vcf.gz


CHAIN2=/hps/nobackup/stegle/users/huangh/annotation/human/liftOver/hg38ToHg19.over.chain.gz
# python $BIN_DIR/liftOver_vcf.py -c $CHAIN2 \
#     -i $DAT_DIR/../../cellSNP/ms10x.72donors.GT.aggr.vcf.gz \
#     -o $DAT_DIR/../../cellSNP/ms10x.72donors.GT.aggr.hg19.vcf.gz

python $BIN_DIR/liftOver_vcf.py -c $CHAIN2 \
    -i $DAT_DIR/../../gwas/eQTLgenes_biallele.hg38.vcf.gz \
    -o $DAT_DIR/../../gwas/eQTLgenes_biallele.hg19.vcf.gz
    

### CrossMap: fail to work on our vcf file
## install with Python2: https://anaconda.org/bioconda/crossmap
## source activate Py2
# FASTA=/hps/nobackup/stegle/users/huangh/10xtools/refdata-cellranger-GRCh38-1.2.0/fasta/genome.fa
# crossmap=/nfs/software/stegle/users/huangh/anaconda3/envs/Py2/bin/CrossMap.py

# DAT_DIR=/hps/nobackup/stegle/users/huangh/msclerosis/genotype/vcf
# cd $DAT_DIR

# CHAIN=hg19ToHg38.NOchr.over.chain.gz
# # CrossMap.py bed $CHAIN ms.positions.hg19.bed ms.positions.hg38.bed
# # CrossMap.py vcf $CHAIN ms.batch1_2_3.chrAll.imputed.vcf.gz $FASTA ms.positions.hg38.vcf.gz



### picard: fail to work on our vcf file
# FASTA=/hps/nobackup/stegle/users/huangh/10xtools/refdata-cellranger-GRCh38-1.2.0/fasta/genome
# java -jar picard.jar CreateSequenceDictionary R=$FASTA.fa O=$FASTA.dict

# java -jar $DAT_DIR/picard.jar LiftoverVcf \
#     I=ms.batch1_2_3.chrAll.imputed.vcf.gz \
#     O=ms.positions.hg38.vcf \
#     CHAIN=$CHAIN \
#     REJECT=ms.positions.hg38.reject.vcf \
#     R=$FASTA


