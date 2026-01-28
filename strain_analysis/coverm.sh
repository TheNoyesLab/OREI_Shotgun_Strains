#!/bin/bash


og_bins="/projects/standard/noyes046/elder099/OREI_Shotgun_Strains_Data/orei_strain_analysis/binning/dRep_output/dereplicated_genomes"
rename="/projects/standard/noyes046/elder099/OREI_Shotgun_Strains_Data/orei_strain_analysis/binning/renaming"
bins="/projects/standard/noyes046/elder099/OREI_Shotgun_Strains_Data/orei_strain_analysis/binning/renaming/binrename.txt"
reads="/projects/standard/noyes046/elder099/OREI_Shotgun_Strains_Data/orei_strain_analysis/binning/reads"


# Activate conda
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/conda.sh
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/mamba.sh

mamba activate coverage

#coverm genome -b $reads/USDA1000_aligned_sorted.bam -r $rename/reference/all_renamed.fa -s '|' --min-covered-fraction 50 -o coverm_out.txt


#coverm genome -b $reads/USDA1000_aligned_sorted.bam -r $rename/reference/all_renamed.fa -s '|' -m mean relative_abundance covered_fraction --min-covered-fraction 5 -t 60 -o coverm_out.tsv


coverm genome -b $rename/USDA1000_S24_aligned_sorted.bam -s '|' -m mean trimmed_mean relative_abundance covered_fraction --min-covered-fraction 50 -t 10 -o coverm_out.tsv

#bowtie2-build $REFERENCE_MAGS (all_renamed.fa) all_renamed

#bowtie2 -x ../renaming/reference/index/all_renamed -1 USDA1000_S24.non.host.R1.fastq.gz -2 USDA1000_S24.non.host.R2.fastq.gz

#bowtie2 -x all_MAGs -1 sample_R1.fastq.gz -2 sample_R2.fastq.gz -p 40 | 
#	samtools sort -o sample.allMAGs.bam


