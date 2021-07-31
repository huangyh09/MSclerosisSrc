#!/bin/sh

dat_dir=/hps/nobackup/stegle/users/huangh/msclerosis
bin_dir=/homes/huangh/MyGit/ebicodes/dev/scutils

min_count=500

# counter=0
# for samp in `ls $dat_dir/crRun`
# do
#     echo $samp
#     dir_in=$dat_dir/crRun/$samp/outs/raw_gene_bc_matrices/GRCh38
#     dir_out=$dat_dir/crRun/$samp/outs/matrices_UMI$min_count
#     python $bin_dir/filter_10x_raw.py -i $dir_in -o $dir_out --minCount $min_count &
    
#     if (( ++counter % 15 == 0 ))
#     then
#         echo $counter "Waiting..."
#         wait
#     fi
# done



# for samp_file in barcodes.S16803-F12.tsv #`ls $dat_dir/doublet/emptyDrops/`
# do
#     samp=`echo $samp_file | awk -F"." '{print $2}'`
#     echo $samp $samp_file
    
#     cell_use=$dat_dir/doublet/emptyDrops/$samp_file
#     dir_in=$dat_dir/crRun/$samp/outs/raw_gene_bc_matrices/GRCh38
#     dir_out=$dat_dir/crRun/$samp/outs/emptyDrops_mat
#     python $bin_dir/filter_10x_raw.py -i $dir_in -o $dir_out --barcodes $cell_use
# done
# barcodes.S15409-D2.tsv


# for samp_file in barcodes.S16803-F12.tsv #`ls $dat_dir/doublet/emptyDrops/`
# do
#     samp=`echo $samp_file | awk -F"." '{print $2}'`
#     echo $samp $samp_file
    
#     cp -p -r $dat_dir/crRun/$samp/outs/emptyDrops_mat $dat_dir/emptyDrops_mat/$samp
#     cp -p $dat_dir/doublet/dbltQC/$samp.combined.tsv $dat_dir/emptyDrops_mat/$samp/doublet.combined.tsv
# done


# counter=0
# for samp in `ls $dat_dir/crRun`
# do
#     echo $samp
#     # cp -p -r $dat_dir/crRun/$samp/outs/matrices_UMI500 $dat_dir/UMI500_mat/$samp
#     cp -p $dat_dir/doublet/UMI500/$samp.combined.tsv $dat_dir/UMI500_mat/$samp/doublet.combined.tsv
# done




# for samp in `ls $dat_dir/cr3Union/`
# do
#     echo $samp
    
#     cell_use=$dat_dir/cr3Union/$samp/filtered_feature_bc_matrix/cell_called.tsv
#     dir_in=$dat_dir/CRv3/$samp/outs/raw_feature_bc_matrix
#     dir_out=$dat_dir/cr3Union/$samp/filtered_feature_bc_matrix
#     python $bin_dir/filter_10x_raw.py -i $dir_in -o $dir_out --barcodes $cell_use -3
# done


for samp in `ls $dat_dir/cr3Union/`
do
    echo $samp
    cd $dat_dir/cr3Union/$samp/filtered_feature_bc_matrix/
    
#     cp -r $dat_dir/CRv3/$samp/outs/raw_feature_bc_matrix ../.
    
#     mv genes.tsv features.tsv
#     gzip cell_called.tsv features.tsv matrix.mtx barcodes.tsv
    
#     cp $dat_dir/doublet/cr3Union/$samp.combined.tsv doublets.combined.tsv
#     gzip doublets.combined.tsv
    rm Rplots.pdf
done
