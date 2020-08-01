#!/bin/sh

# Using cellranger from 10x genomics (downloaded and uncompressed)
# https://support.10xgenomics.com/single-cell-gene-expression/software

# Top notes: setting --localmem=28 when runnning cellranger

binDir=/hps/nobackup/stegle/users/huangh/10xtools/cellranger-2.1.0
refDir=/hps/nobackup/stegle/users/huangh/10xtools/refdata-cellranger-GRCh38-1.2.0

#### 1. cellranger on single cell data
datDir=/hps/nobackup/stegle/users/huangh/msclerosis
cd $datDir/crRun

for lane in TU629 12765 14076 14077 14091 14092 14097 14100 14101 14102 \
    14615 14616 14617 14618 14619 14764 14962 15203 15204 \
    15208 15291 15297 15299 15405 15406 15409 15425 15737 \
    15844 15850 15924 16802 16803 16857 16898 16899 16961
do
    for fPath in `ls -d $datDir/fastq/S$lane*`
    do
        sample=`basename $fPath`
        sample_old=SIGA`echo $sample | awk -F"-" '{print $2}'`

        echo $sample $sample_old
        # mkdir $datDir/crRun/$sample

        MEM=64000
        err=$sample/_my_errs
        log=$sample/_my_logs
        RUN="$binDir/cellranger count --id $sample --sample $sample_old \
            --fastqs $datDir/fastq/$sample --transcriptome $refDir --localmem=56"
        bsub -J $sample -M $MEM -R "rusage[mem=$MEM]" -o $log -e $err $RUN #-q highpri
    done
done
