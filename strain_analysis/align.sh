#!/bin/bash


og_bins="/projects/standard/noyes046/elder099/OREI_Shotgun_Strains_Data/orei_strain_analysis/binning/dRep_output/dereplicated_genomes"
rename="/projects/standard/noyes046/elder099/OREI_Shotgun_Strains_Data/orei_strain_analysis/binning/renaming/"
bins="/projects/standard/noyes046/elder099/OREI_Shotgun_Strains_Data/orei_strain_analysis/binning/renaming/binrename.txt"
reads="/projects/standard/noyes046/elder099/OREI_Shotgun_Strains_Data/orei_strain_analysis/binning/reads"

# Activate conda
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/conda.sh
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/mamba.sh

mamba activate align

cd $rename

#bowtie2-build --threads 60 reference/all_renamed.fa all_renamed

#Fix location of all_renamed index


bowtie2 -x $rename/reference/index/all_renamed -1 $reads/USDA1000_S24.non.host.R1.fastq.gz -2 $reads/USDA1000_S24.non.host.R2.fastq.gz --threads 60 | 
	samtools sort -@ 60 -o USDA1000_S24_aligned_sorted.bam



#bowtie2 -x all_MAGs -1 sample_R1.fastq.gz -2 sample_R2.fastq.gz -p 40 | 
#	samtools sort -o sample.allMAGs.bam


