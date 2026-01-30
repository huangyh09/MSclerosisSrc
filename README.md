# MSclerosisSrc
Analysis scripts and notebooks for the Multiple Sclerosis project

* Source codes on GitHub: https://github.com/huangyh09/MSclerosisSrc
* Data on sourceforge: https://sourceforge.net/projects/ms-csf-singlecell/files/
* Danila's source codes: https://github.com/gtca/csf_ms

## scRNA-seq Data

Notebook for visualizing the released data: [./release_viz.ipynb](https://github.com/huangyh09/MSclerosisSrc/blob/master/release_viz.ipynb)

* `expr_csf_annot_clean_rc5.h5ad` [2.7Gb]: Processed scRNA-seq data
* `expr_csf_annot_clean_rc5.noRaw.h5ad` [700Mb]: Processed scRNA-seq data without raw count matrices (gzip compressed)
* `expr_csf_annot_clean_rc5.sub10k.h5ad` [53Mb]: Processed scRNA-seq data with subsetting to 10k cells balanced between donor and celltype (gzip compressed)

#### Fetch and load the adata from the URL:

```python
# the file will be downloaded to your current work directory
adata_sub = sc.read('expr_csf_annot_clean_rc5.sub10k.h5ad',
    backup_url='https://sourceforge.net/projects/ms-csf-singlecell/files/expr_csf_annot_clean_rc5.sub10k.h5ad')

# adata5_lite = sc.read('expr_csf_annot_clean_rc5.noRaw.h5ad',
#     backup_url='https://sourceforge.net/projects/ms-csf-singlecell/files/expr_csf_annot_clean_rc5.noRaw.h5ad')
```

## Genetic data

* GWAS SNPs (n=200) and their cis genes (930): https://github.com/huangyh09/MSclerosisSrc/blob/master/genetics/MS_GWAS_200SNPs_930genes.tsv
* Raw genotypes: `ms.imputed.geno.HRC.81.vcf.gz` [1.7Gb] to be request from EGA [EGAS00001007478](https://ega-archive.org/studies/EGAS00001007478)

## Viral mapping data

* processed count matrix: `virus833_xf25.tar.gz` [10Mb]
* Download commandline `wget https://sourceforge.net/projects/ms-csf-singlecell/files/virus833_xf25.tar.gz`
