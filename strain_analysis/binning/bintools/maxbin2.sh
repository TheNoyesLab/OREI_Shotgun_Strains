#!/bin/bash

#Establish file paths
rundir='/scratch.global/elder099/project019'
reads="$rundir/project019_reads"
coReads="$rundir/coReads"
assemblies="$rundir/assemblies"
coassemblies="$assemblies/coassemblies"
binning="$rundir/binning"
work="$binning/work_files"
indiv_reads="$rundir/indiv_read_files.txt"
coRead_list="$rundir/coRead_list.txt"

# Activate conda
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/conda.sh
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/mamba.sh

#binning environment
mamba activate binning


mkdir -p "$rundir/binning"
mkdir -p "$binning/maxbin2"

indiv_reads="$rundir/one_file.txt"

#####
#####BINNING INDIVIDUAL ASSEMBLIES
#####
cat $indiv_reads | while read file
#tail $indiv_reads -n +2 | while read file
do



	echo "$file"
	#mkdir "$binning/work_files" #Create work directory
	
	
	assembly_path="$assemblies/megahit_${file}_output"
	
	#Only run binning on existing assemblies
	if [ -d "$assembly_path" ]; then
		
		cd $binning/maxbin2
		mkdir ${file}_bins		

		run_MaxBin.pl -contig $assemblies/megahit_${file}_output/final.contigs.fa -reads $reads/$file.R1.fastq.gz -reads2 $reads/$file.R2.fastq.gz -thread 40 -min_contig_length 1500 -out $binning/maxbin2/${file}_bins/${file}_maxbin_bin
		

	else
		#If not present, do nothing
  		echo "File does not exist!"
	
	
	fi
	

	###Complete binning script by deleting work files
	#cd $binning
	#rm -fr work_files

done



#####
#####BINNING COASSEMBLIES
#####

#cat $coRead_list | while read file
#tail $coRead_list -n +2 | while read file
#do
#        echo "$file"
#	mkdir "$binning/work_files" #Create work directory
	

	###Align original reads to generated scaffold
#	echo "alignment"
	#Index scaffold file
#	bwa index $assemblies/spades_${file}_output/scaffolds.fasta
	
	#Make SAM of dehosted reads vs Scaffold
#	bwa mem -t 80 $assemblies/spades_${file}_output/scaffolds.fasta $coReads/$file.R1.fastq.gz $coReads/$file.R2.fastq.gz > $work/$file.sam
	
	#Make BAM from SAM
#	samtools view -@ 50 -bS $work/$file.sam > $work/$file.bam
	
#	echo "sorting"
	#Sort BAM file
#	samtools sort -@ 50 $work/$file.bam -o $work/${file}_sorted.bam

#	echo "depth file"
	#Grab depth file from BAM
#	jgi_summarize_bam_contig_depths -t 50 --outputDepth $work/depth.txt $work/${file}_sorted.bam




	###Run actual binning using metabat2
#	echo "Binning"
#	echo "Bins directory: $binning/metabat2/${file}_bins"
#	mkdir -p $binning/metabat2/${file}_bins
	
#	metabat2 -i $assemblies/spades_${file}_output/scaffolds.fasta -a $work/depth.txt -o $binning/metabat2/${file}_bins/${file}_bin -t 80 -m 1500
	

	###Complete binning script by deleting work files
#	cd $binning
#	rm -fr work_files

#done

