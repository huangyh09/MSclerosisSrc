# MSclerosisSrc
Analysis scripts and notebooks for the Multiple Sclerosis project

* Source codes on GitHub: [https://github.com/huangyh09/MSclerosisSrc](https://github.com/huangyh09/MSclerosisSrc)
* Data on sourceforge: [https://sourceforge.net/projects/ms-csf-singlecell/files/](https://sourceforge.net/projects/ms-csf-singlecell/files/)

## scRNA-seq Data

* Processed scRNA-seq data `expr_csf_annot_clean_rc2.h5ad` [1.9Gb]:
* Download commandline `wget https://sourceforge.net/projects/ms-csf-singlecell/files/expr_csf_annot_clean_rc2.h5ad`
* Load the data and fetch the raw counts of all genes
 
```python
# all data focusing on highly variable genes
adata = scanpy.read('expr_csf_annot_clean_rc2.h5ad')
adata

# all genes in raw counts
adata_raw = adata.raw.to_adata()
adata_raw
```

## Genetic data

* GWAS SNPs (n=200) and their cis genes (930): https://github.com/huangyh09/MSclerosisSrc/blob/master/genetics/MS_GWAS_200SNPs_930genes.tsv
* Raw genotypes: `ms.imputed.geno.HRC.81.vcf.gz` [1.7Gb] to be request from EGA [EGAS00001007478](https://ega-archive.org/studies/EGAS00001007478)

## Viral mapping data

* processed count matrix: `virus833_xf25.tar.gz` [10Mb]
* Download commandline `wget https://sourceforge.net/projects/ms-csf-singlecell/files/virus833_xf25.tar.gz`
