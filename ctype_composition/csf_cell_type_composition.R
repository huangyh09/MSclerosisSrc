# R scripts for differential compositions of cell types between MS and control
## Required packages: 
##   - DCATS: https://github.com/holab-hku/DCATS
##   - aod: https://www.rdocumentation.org/packages/aod/versions/1.3.1/topics/betabin
## remotes::install_github("holab-hku/DCATS", build_vignettes = FALSE)

## Run this script:
## /storage/yhhuang/systems/condaEnv/r_4.3/bin/Rscript fig1d-csf_cell_type_composition.R

library(DCATS)
library(ggplot2)

## Load data
fig_dir  <- "/usersdata/yuanhua/msNewData/figures/"
anno_file <- "/usersdata/yuanhua/msNewData/data_release/expr_csf_annot_clean_rc3_obs.csv"

df_ms <- read.table(anno_file, sep = ",", header = TRUE)
df_ms[["celltype2"]] = df_ms$celltype
df_ms$celltype2[df_ms$T_HAVCR2 == "True"] = "T_HAVCR2"

## Get cell counts
ct_level <- "celltype2"

ct_orders <- c("CD4+ T cell", "CD4+ Treg cell", "CD8+ T cell", "CD8+ gd T cell",
               "T_HAVCR2",
               "NK cell", "B cell", "plasma cell", "monocyte", "macrophage", 
               "MALAT1low myeloid cell", "cDC1", "cDC2", "pDC")

## extract cell count and donor disease
cell_count <- as.data.frame.matrix(table(df_ms[, c("patient_id", ct_level)]))
cell_count <- cell_count[, rev(ct_orders)]

disease <- as.data.frame.matrix(table(df_ms[, c("patient_id", "disease")]))
disease[,] <- (disease > 0) * 1.0
mean(rownames(disease) == rownames(cell_count))

## donor mata info
donors <- sort(unique(df_ms$patient_id))
df_donor <- df_ms[match(donors, df_ms$patient_id), ]
mean(donors == rownames(cell_count))

## add treated info
is_treated <- 1 - disease$MS
is_treated[is_treated == 1] <- NA
is_treated[df_donor$donorseq %in% c("S12765-B2", "S15737-E10")] <- 1
df_donor['treated'] <- is_treated

## define design matrix
factor_pool <- cbind(disease$MS, disease$MS, disease$MS, disease$MS,
                     1 - disease$IIH, 1 - disease$IIH, 1 - disease$IIH, 
                     1 - disease$NIND, 1 - disease$OIND)

factor_pool[!(disease$IIH | disease$MS), 2]  <- NA
factor_pool[!(disease$NIND | disease$MS), 3] <- NA
factor_pool[!(disease$OIND | disease$MS), 4] <- NA

factor_pool[!(disease$NIND | disease$IIH), 6] <- NA
factor_pool[!(disease$OIND | disease$IIH), 7] <- NA

colnames(factor_pool) <- c('MS_vs_rest', 'MS_vs_IIH', 'MS_vs_NIND', 
                           'MS_vs_OIND', 'rest_vs_IIH', 'NIND_vs_IIH',
                           'OIND_vs_IIH', 'rest_vs_NIND', 'rest_vs_OIND')

factor_pool <- factor_pool[, c('MS_vs_rest', 'MS_vs_IIH', 'MS_vs_NIND', 
                               'MS_vs_OIND', 'NIND_vs_IIH', 'OIND_vs_IIH')]

factor2 <- cbind(df_donor$oligoclonal, df_donor$active, 
                 df_donor$treated, df_donor$gender - 1)
colnames(factor2) <- c('oligoclonal', 'active', 'treated', 'sex')

factor_pool <- cbind(factor_pool, factor2)




### Run dcats
res_beta <- DCATS::dcats_GLM(count_mat = cell_count, design_mat = factor_pool)


### Plot results
source('../ctype_composition/dcats_plottings.R')
matrix_dotplot(size_mat = -log10(res_beta$fdr), color_mat = res_beta$ceoffs,
               size_title = '-log10(FDR)', color_title = 'Effect size', 
               color_limits=c(-2,2)) +
  theme(axis.text.x=element_text(angle=45, hjust=1)) +
  scale_size(limits = c(0.1, 4), range = c(0.1, 4), name='-log10(FDR)')

ggsave(filename = paste0(fig_dir, ct_level, ".rc3-DCATS", ".pdf"),
       width = 6, height = 6, dpi = 300)


### Generate volcano plot
prop_ctrl = colMeans(cell_count[factor_pool[,1]==0,] / 
                     rowSums(cell_count[factor_pool[,1]==0,]))
res_df = data.frame(
    names=rownames(res_beta$LRT_pvals),
    prop_ctrl=prop_ctrl, 
    pval=res_beta$LRT_pvals[, 1], 
    effsize=res_beta$ceoffs[, 1], 
    effsize_err=res_beta$coeffs_err[,1]
)

library(ggplot2)
ggplot(res_df, aes(x = effsize, y=-log10(pval), label=names, color=names)) +
  geom_point(aes(size = prop_ctrl)) +
  ggrepel::geom_text_repel(size = 2.5) +
  geom_errorbarh(aes(xmin=effsize-effsize_err, 
                     xmax=effsize+effsize_err, height = .0)) +
  geom_hline(yintercept=-log10(0.05), color='red', linewidth=0.3) + 
  geom_vline(xintercept=0, linewidth=0.3) +
  xlab("MS effect size, logit scale") + guides(color="none") + xlim(-1.7, 2.3)

ggsave(filename = paste0(fig_dir, ct_level, ".rc3-DCATS-vocalno", ".pdf"),
       width = 6, height = 5, dpi = 300)
