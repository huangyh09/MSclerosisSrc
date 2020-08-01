#!/bin/sh

bin_dir=/homes/huangh/MyGit/doubletQC/bin
dat_dir=/hps/nobackup/stegle/users/huangh/msclerosis

min_count=500
counter=0
for samp in `ls $dat_dir/crRun`
do  
    echo $counter $samp
    
    dat=$dat_dir/crRun/$samp/outs/matrices_UMI$min_count
    out=$dat_dir/doublet/UMI500/$samp.scrublet.tsv
    python $bin_dir/run_scrublet.py -i $dat -o $out -2 &
    
    out=$dat_dir/doublet/UMI500/$samp.dbfinder.tsv
    Rscript $bin_dir/run_doubletFinder.R $dat $out &

    python $bin_dir/run_combineResults.py \
        --dbFinder $dat_dir/doublet/UMI500/$samp.dbfinder.tsv \
        --scrublet $dat_dir/doublet/UMI500/$samp.scrublet.tsv \
        -o $dat_dir/doublet/UMI500/$samp.combined.tsv &
    
    if (( ++counter % 15 == 0 ))
    then
        echo $counter "Waiting..."
        wait
    fi
done


### emptyDrops
# counter=0
# for samp_file in `ls $dat_dir/doublet/emptyDrops/`
# do  
#     samp=`echo $samp_file | awk -F"." '{print $2}'`
#     echo $counter $samp $samp_file 
    
#     dat=$dat_dir/crRun/$samp/outs/emptyDrops_mat
#     out=$dat_dir/doublet/dbltQC/$samp.scrublet.tsv
#     python $bin_dir/run_scrublet.py -i $dat -o $out -2 #&
    
#     out=$dat_dir/doublet/dbltQC/$samp.dbfinder.tsv
#     Rscript $bin_dir/run_doubletFinder.R $dat $out #&

#     python $bin_dir/run_combineResults.py \
#         --dbFinder $dat_dir/doublet/dbltQC/$samp.dbfinder.tsv \
#         --scrublet $dat_dir/doublet/dbltQC/$samp.scrublet.tsv \
#         -o $dat_dir/doublet/dbltQC/$samp.combined.tsv #&
    
#     if (( ++counter % 13 == 0 ))
#     then
#         echo $counter "Waiting..."
#         wait
#     fi
# done
## barcodes.S16803-F12.tsv



### fileter cells with 500 UMIs
# filter=$HOME/MyGit/ebicodes/dev/scutils/filter_10x_raw.py
# min_count=500

# counter=0
# for samp in `ls $dat_dir/crRun`
# do
#     echo $samp
#     dir_in=$dat_dir/crRun/$samp/outs/raw_gene_bc_matrices/GRCh38
#     dir_out=$dat_dir/crRun/$samp/outs/matrices_UMI$min_count
#     python $filter -i $dir_in -o $dir_out --minCount $min_count &
    
#     if (( ++counter % 15 == 0 ))
#     then
#         echo $counter "Waiting..."
#         wait
#     fi
# done