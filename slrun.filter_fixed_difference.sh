#!/bin/bash

#SBATCH --get-user-env
#SBATCH --mem=10G
#SBATCH --time 22:00:00
#SBATCH --qos=1day
#SBATCH --output=slrun.filter_fixed_differences.%A_%a.o
source ~/.bashrc

date
echo Create Allele_Info file
vcftools --gzvcf /scratch/tmp/abwolf/NeanderthalSeq/filtered_vcfs.all.gz \
	--get-INFO 1000gALT \
	--get-INFO CAnc \
	--get-INFO AF1000g \
	--get-INFO AMR_AF \
	--get-INFO ASN_AF \
	--get-INFO AFR_AF \
	--get-INFO EUR_AF \
	--get-INFO AC \
	--stdout \
	| gzip -c - \
	> /scratch/tmp/abwolf/NeanderthalSeq/altai_neand_filtered_vcfs.all.allele_info.gz

echo ''
echo Filter for Fixed Differences
python ~/NeanderthalSeq/FixedDiff/bin/filter_fixed_differences.py \
	/scratch/tmp/abwolf/NeanderthalSeq/altai_neand_filtered_vcfs.all.allele_info.gz \
	| gzip -c - \
	> /Genomics/akeylab/abwolf/NeanderthalSeq/FixedDiff/altai_neand_filtered_vcfs.all.allele_info.FD.gz

echo FIN
date



