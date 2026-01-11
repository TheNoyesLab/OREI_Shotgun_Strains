#!/bin/bash


og_bins="/projects/standard/noyes046/elder099/OREI_Shotgun_Strains_Data/orei_strain_analysis/binning/dRep_output/dereplicated_genomes"
rename="/projects/standard/noyes046/elder099/OREI_Shotgun_Strains_Data/orei_strain_analysis/binning/renaming/"
bins="/projects/standard/noyes046/elder099/OREI_Shotgun_Strains_Data/orei_strain_analysis/binning/renaming/binrename.txt"


#ls $og_bins | sed "s/fa$//g" | grep "USDA1000" > $bins
ls $og_bins | sed "s/fa$//g" > $bins


mkdir -p $rename/tmp

cat $bins | while read file
do
	echo $file
	
	#sed "s/^>/>${file}/g" renamed_drep/${file}fa | grep ">"
	
	#Prepend file/bin name to headers
	sed "s/^>/>${file}/g" $og_bins/${file}fa > $rename/tmp/renamed_${file}.fa
done


cd $rename/tmp

#Concatenate all into one database
cat * > $rename/all_renamed.fa

#grep ">" $rename/all_renamed.fa
#grep "USDA112" $rename/all_renamed.fa

rm -fr $rename/tmp
