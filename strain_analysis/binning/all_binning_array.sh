#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=40
#SBATCH --mem=200g
#SBATCH -t 12:00:00
#SBATCH --mail-type=END 
#SBATCH --mail-user=elder099@umn.edu
#



#Establish file paths
rundir='/scratch.global/elder099/project019'
reads="$rundir/project019_reads"
coReads="$rundir/coReads"
assemblies="$rundir/assemblies"
coassemblies="$assemblies/coassemblies"
binning="$rundir/binning"
work="$binning/metabat2/work_files"
indiv_reads="$rundir/indiv_read_files.txt"
coRead_list="$rundir/coRead_list.txt"

# Activate conda
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/conda.sh
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/mamba.sh



#Test run for one file only
#indiv_reads="$rundir/one_file2.txt"

###
cd $rundir
file=$(sed -n ${SLURM_ARRAY_TASK_ID}p $indiv_reads)





#####
#####METABAT2
#####

#binning environment
mamba activate binning


cd $rundir
mkdir -p "binning"

cd $binning
mkdir -p "metabat2"
cd metabat2
mkdir "work_files" #Create work directory


#Only run binning on existing assemblies
assembly_path="$assemblies/megahit_${file}_output"
if [ -d "$assembly_path" ]; then
	
	###Align original reads to generated scaffold
	echo "alignment"

	#Index scaffold file
	bwa index $assemblies/megahit_${file}_output/final.contigs.fa
	

	#Make SAM of dehosted reads vs Scaffold
	bwa mem -t 40 $assemblies/megahit_${file}_output/final.contigs.fa $reads/$file.R1.fastq.gz $reads/$file.R2.fastq.gz | samtools view -b > $work/$file.bam

	echo "sorting"

	#Sort BAM file
	samtools sort -@ 40 $work/$file.bam -o $work/${file}_sorted.bam

	echo "depth file"
	#Grab depth file from BAM
	jgi_summarize_bam_contig_depths --outputDepth $work/depth.txt $work/${file}_sorted.bam

	###Run actual binning using metabat2
	echo "Bins directory: $binning/metabat2/${file}_bins"
	mkdir -p $binning/metabat2/${file}_bins	

	metabat2 -i $assemblies/megahit_${file}_output/final.contigs.fa -a $work/depth.txt -o $binning/metabat2/${file}_bins/${file}_metabat2_bin -t 40 -m 1500
	
else
	#If not present, do nothing
	echo "File does not exist!"
	
fi
	
###Complete binning script by deleting work files
cd $binning/metabat2
rm -fr work_files





#####
#####MAXBIN2
#####

#Establish file paths

#binning environment
mamba activate binning


cd $binning
mkdir -p "maxbin2"


#####
#####BINNING INDIVIDUAL ASSEMBLIES
#####



	
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




#####
#####METABINNER
#####


path_to_MetaBinner="/projects/standard/noyes046/elder099/miniforge3/envs/metabinner/bin"
#metabinner_path=$(dirname $(which run_metabinner.sh))

#metabinner environment
mamba activate metabinner #metabinner is in here


#file="USDA1008_S155.non.host"

#Filepath setup
cd $binning
mkdir -p metabinner
cd metabinner

output_dir=$binning/metabinner/${file}_bins

###Reads/Assemblies first

#Generate coverage file (bam) from contigs and reads and make output directory
gen_coverage_file.sh -a $assemblies/megahit_${file}_output/final.contigs.fa -o ${file}_bins -f .R1.fastq.gz -r .R2.fastq.gz -t 40 $reads/$file.*.fastq.gz 

#Keep only contigs >1500
cat $output_dir/work_files/mb2_master_depth.txt | awk '{if ($2>1500) print $0 }' | cut -f -1,4- > $output_dir/coverage_profile_f1500.tsv


#Generate composition profile (k-mers) from contigs
gen_kmer.py $assemblies/megahit_${file}_output/final.contigs.fa 1500 4 
#Note that output goes to assembly location


#Create fasta that only keeps >1500 contigs
Filter_tooshort.py $assemblies/megahit_${file}_output/final.contigs.fa 1500



###Perform binning
cd $binning/metabinner

bash run_metabinner.sh -a $assemblies/megahit_${file}_output/final.contigs_1500.fa -o $output_dir -d $output_dir/coverage_profile_f1500.tsv -k $assemblies/megahit_${file}_output/final.contigs_kmer_4_f1500.csv -p $path_to_MetaBinner -t 40



