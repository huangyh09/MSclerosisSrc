# R scripts for differential compositions of cell types between MS and control
## Required packages: 
##   - DCATS: https://github.com/huangyh09/DCATS
##   - aod: https://www.rdocumentation.org/packages/aod/versions/1.3.1/topics/betabin

library(DCATS)
library(ggplot2)

## Load data
# anno_dir <- "/usersdata/yuanhua/msclerosis/analysis/annoV33/"
anno_dir <- "/Users/yuanhua/research/msclerosis/data/celltype/"
fig_dir  <- "/Users/yuanhua/research/msclerosis/data/celltype/figures/"
anno_file <- "csf_v33_obs_with_celltyps.csv"


df_ms <- read.table(paste0(anno_dir, anno_file), sep = ",", header = TRUE)

### color files from GDrive, may use the config.toml in future
df_color <- read.table(paste0(anno_dir, "color_cellType.tsv"),
                       sep="\t", header = TRUE)

### Read config color in future
# colours <- RcppTOML::parseTOML('config/colours.toml')
# df_color <- data.frame("color" = unlist(colours[['celltypes']][['celltype']]),
# 						"celltype" = names(colours[['celltypes']][['celltype']]))


## remove treated donors
# df_ms$ms_treated <- df_ms$ms_treated == "True"
# df_ms <- droplevels(df_ms[!df_ms$ms_treated, ])

## remove sarcoid donor: TU0628
# df_ms <- droplevels(df_ms[df_ms$donor_id != "TU0628", ])

# df_ms <- droplevels(df_ms[df_ms$Celltypes_master == "Macrophage", ])
# df_ms <- droplevels(df_ms[df_ms$Celltypes_master_higher == "Myeloid", ])


## Get cell counts
# ct_level <- "Celltypes_master"
# ct_level <- "Celltypes"
ct_level <- "celltype"
ct_level <- "CellTypes_postsoupX_cleaner"

# there might be a file containing this
# ct_orders <- c("B cell", "CD4+ T cell", "CD4+ Treg cell", "CD8+ gd T cell",
#                "CD8+ T cell", "cDC1", "cDC2", "dividing NK cell", 
#                "dividing T cell", "macrophage", "MALAT1low myeloid cell", 
#                "monocyte", "NK cell", "pDC", "plasma cell")

ct_orders <- c("CD4+ T cell", "CD4+ Treg cell", "CD8+ T cell", "CD8+ gd T cell",
               "NK cell", "B cell", "plasma cell", "monocyte", "macrophage", 
               "MALAT1low myeloid cell", "cDC1", "cDC2", "pDC", 
               "dividing T cell", "dividing NK cell")

## extract cell count and donor disease
cell_count <- as.data.frame.matrix(table(df_ms[, c("donor_id", ct_level)]))
cell_count <- cell_count[, rev(ct_orders)]

disease <- as.data.frame.matrix(table(df_ms[, c("donor_id", "disease")]))
disease[,] <- (disease > 0) * 1.0
mean(rownames(disease) == rownames(cell_count))

## donor mata info
donors <- sort(unique(df_ms$donor_id))
df_donor <- df_ms[match(donors, df_ms$donor_id), ]
df_donor$burden_score <- as.numeric(gsub(',', '.', df_donor$burden_score))
mean(donors == rownames(cell_count))

## add treated info
is_treated <- 1 - disease$MS
is_treated[is_treated == 1] <- NA
is_treated[df_donor$donor_id %in% c("TU0517", "TU0589")] <- 1
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
colnames(factor2) <- c('oligoclonal', 'active', 'treated', 'gender')

factor_pool <- cbind(factor_pool, factor2)




### Run dcats
res_beta <- DCATS::dcats_GLM(count_mat = cell_count, design_mat = factor_pool)


### Plot results
source('~/MyGit/MSclerosisSrc/ctype_composition/dcats_plottings.R')
matrix_dotplot(size_mat = -log10(res_beta$fdr), color_mat = res_beta$ceoffs,
               size_title = '-log10(FDR)', color_title = 'Effect size', 
               color_limits=c(-2,2)) +
  theme(axis.text.x=element_text(angle=45, hjust=1)) +
  scale_size(limits = c(0.1, 4), range = c(0.1, 4), name='-log10(FDR)')

ggsave(filename = paste0(fig_dir, ct_level, ".betabin_w_Sarcoid", ".pdf"),
       width = 6, height = 6, dpi = 300)

