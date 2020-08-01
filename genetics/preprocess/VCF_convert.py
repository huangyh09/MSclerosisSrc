# Convert Montreal GT file to VCF
# Author: Yuanhua Huang
# Date: 25/12/2019
# Version: 0.1.0

import sys
import gzip
from datetime import date
from optparse import OptionParser

VCF_HEADER = (
    '##fileformat=VCFv4.2\n'
    '##fileDate=' + ("".join(str(date.today()).split("-"))) + '\n'
    '##source=MS_Merck_phased_genotype_chr\n'
    '##Converted from Montreal format to VCF by VCF_convert.py\n'
    '##FILTER=<ID=PASS,Description="All filters passed">\n'
    '##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">\n')

CONTIG = "".join(['##contig=<ID=%d,length=2147483647>\n' %x for x in range(1,23)])
header_line="#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT"

def vcf_convert(file_list, out_file, is_imputed, is_gzip=None):
    fid_out = open(out_file, "w")
    fid_out.writelines(VCF_HEADER + CONTIG)
    
    if is_gzip is None and file_list[0].endswith("gz"):
        is_gzip = True
    
    for a_file in file_list:
        print(a_file)
        if is_gzip:
            infile = gzip.open(a_file, "rb")
        else:
            infile = open(a_file, "rb")
        for line in infile:
            try:
                line = line.decode('utf-8')
            except:
                continue
                
            #print(line)
            if a_file == file_list[0] and line.startswith("#sample"):
                gt_sample = line.rstrip().split()[1:]
                fid_out.writelines(header_line + "\t" + "\t".join(gt_sample) + "\n")
            if line.startswith("#"):
                continue
                
            if is_imputed:
                _list = line.rstrip().split(" ")
                _info = "\t".join([_list[1], _list[2], _list[0], 
                                   _list[3][0], _list[3][1]])
                _info += "\t.\t.\t.\tGT"

                for _gt in _list[5:]:
                    _gt_vcf = []
                    if _gt[0] == _list[3][0]:
                        _gt_vcf.append("0")
                    elif _gt[0] == _list[3][1]:
                        _gt_vcf.append("1")
                    elif _gt[0] == "N":
                        _gt_vcf.append(".")
                    else:
                        print("unexpected allele")

                    if _gt[1] == _list[3][0]:
                        _gt_vcf.append("0")
                    elif _gt[1] == _list[3][1]:
                        _gt_vcf.append("1")
                    elif _gt[1] == "N":
                        _gt_vcf.append(".")
                    else:
                        print("unexpected allele")
                        
                    _info += "\t" + "|".join(_gt_vcf)
            else:
                _list = line.rstrip().split(" ")
                _info = "\t".join([_list[1], _list[2], _list[0], 
                                   _list[3], _list[4]])
                _info += "\t.\t.\t.\tGT"
                
                for _gt in _list[5:]:
                    _gt_vcf = []
                    if _gt[0] == _list[3]:
                        _gt_vcf.append("0")
                    elif _gt[0] == _list[4]:
                        _gt_vcf.append("1")
                    elif _gt[0] == "N":
                        _gt_vcf.append(".")
                    else:
                        print("unexpected allele")

                    if _gt[1] == _list[3]:
                        _gt_vcf.append("0")
                    elif _gt[1] == _list[4]:
                        _gt_vcf.append("1")
                    elif _gt[1] == "N":
                        _gt_vcf.append(".")
                    else:
                        print("unexpected allele")
                        
                    _info += "\t" + "|".join(_gt_vcf)
            fid_out.writelines(_info + "\n")
        infile.close()
    fid_out.close()
    
    
def main():
    # import warnings
    # warnings.filterwarnings('error')

    # parse command line options
    parser = OptionParser()
    parser.add_option("--chromFileList", "-i", dest="file_list", default=None,
        help=("Comma separated file list for each chromosome"))
    parser.add_option("--outFile", "-o", dest="out_file", default=None,
        help=("Full path for output files"))
    parser.add_option("--gzipInput", "-g", dest="gzip_input", default=None,
        help=("gzip Input: False, True, None [default: %default]"))
    parser.add_option("--imputed", dest="is_imputed", default=False, 
        action="store_true", help="For imputed genotype, please use this arg.")
    
    (options, args) = parser.parse_args()
    
    if options.gzip_input is not None:
        gzip_input = options.gzip_input != "False"
    else:
        gzip_input = None
    
    vcf_convert(options.file_list.split(","), options.out_file, 
                options.is_imputed, is_gzip=gzip_input)
    
    
if __name__ == "__main__":
    main()
