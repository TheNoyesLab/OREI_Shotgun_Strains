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
coReads="$rundir/coReads"
indiv_reads="$rundir/indiv_read_files.txt"
coRead_list="$rundir/coRead_list.txt"

# Activate conda
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/conda.sh
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/mamba.sh

#Spades is in mag_taxon environment
mamba activate mag_taxon #megahit is in here

cd $rundir
file=$(sed -n ${SLURM_ARRAY_TASK_ID}p $indiv_reads)



#Only run assembly on samples that haven't been run
assembly_path="$assemblies/megahit_${file}_output"
if [ ! -d "$assembly_path" ]; then

	#Run assembly w/MEGAHIT
	megahit -m 0.9 -t 20 -1 $reads/$file.R1.fastq.gz -2 $reads/$file.R2.fastq.gz -o $assemblies/megahit_${file}_output
	#spades.py --meta -t 128 -1 $reads/$file.R1.fastq.gz -2 $reads/$file.R2.fastq.gz -o $assemblies/spades_${file}_output

	#Remove excess intermediates
	cd $assemblies/megahit_${file}_output
	rm -fr intermediate_contigs
	cd $rundir

else
	echo "File $file exists!"

fi


