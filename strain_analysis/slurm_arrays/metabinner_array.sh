#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --mem=200g
#SBATCH -t 18:00:00
#SBATCH --mail-type=END 
#

rundir='/scratch.global/elder099/project019'
reads="$rundir/project019_reads"
coReads="$rundir/coReads"
assemblies="$rundir/assemblies"
coassemblies="$assemblies/coassemblies"
binning="$rundir/binning"
coReads="$rundir/coReads"
indiv_reads="$rundir/indiv_read_files.txt"
coRead_list="$rundir/coRead_list.txt"


path_to_MetaBinner="/projects/standard/noyes046/elder099/miniforge3/envs/metabinner/bin"
#metabinner_path=$(dirname $(which run_metabinner.sh))

# Activate conda
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/conda.sh
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/mamba.sh

#metabinner environment
mamba activate metabinner #metabinner is in here


#Establish list of files for binning
cd $rundir
file=$(sed -n ${SLURM_ARRAY_TASK_ID}p $indiv_reads)
#file="USDA1008_S155"


#Filepath setup
cd $binning
mkdir -p metabinner
cd metabinner

output_dir=$binning/metabinner/${file}_bins

if [! -d "$output_dir" ]; then

###Reads/Assemblies first

#Generate coverage file (bam) from contigs and reads
gen_coverage_file.sh -a $assemblies/megahit_$file.non.host_output/final.contigs.fa -o ${file}_bins -f .R1.fastq.gz -r .R2.fastq.gz -t 40 $reads/$file.non.host.*.fastq.gz 

#Keep only contigs >1500
cat $output_dir/work_files/mb2_master_depth.txt | awk '{if ($2>1500) print $0 }' | cut -f -1,4- > $output_dir/coverage_profile_f1500.tsv


#Generate composition profile (k-mers) from contigs
gen_kmer.py $assemblies/megahit_$file.non.host_output/final.contigs.fa 1500 4 
#Note that output goes to assembly location


#Create fasta that only keeps >1500 contigs
Filter_tooshort.py $assemblies/megahit_$file.non.host_output/final.contigs.fa 1500


#Perform binning
cd $binning/metabinner

bash run_metabinner.sh -a $assemblies/megahit_$file.non.host_output/final.contigs_1500.fa -o $output_dir -d $output_dir/coverage_profile_f1500.tsv -k $assemblies/megahit_$file.non.host_output/final.contigs_kmer_4_f1500.csv -p $path_to_MetaBinner -t 50

#bash run_metabinner.sh -a $assemblies/megahit_$file.non.host_output/final.contigs_1500.fa -o $binning/metabinner/${file}_bins -d $binning/metabinner/coverage_profile_f1500.tsv -k $assemblies/megahit_$file.non.host_output/final.contigs_kmer_4_f1500.csv -p $path_to_MetaBinner -t 50

#Actual ouput bins here: /scratch.global/elder099/project019/binning/metabinner/metabinner_out/metabinner_res/ensemble_res/greedy_cont_weight_3_mincomp_50.0_maxcont_15.0_bins/ensemble_3logtrans/addrefined2and3comps/greedy_cont_weight_3_mincomp_50.0_maxcont_15.0_bins


else
	echo "File $file exists!"

fi





###coReads/Coassemblies second


