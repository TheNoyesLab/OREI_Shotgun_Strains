#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=40
#SBATCH --mem=400g
#SBATCH -t 24:00:00
#SBATCH --mail-type=END 
#SBATCH --mail-user=elder099@umn.edu
#


rundir='/scratch.global/elder099/project019'
reads="$rundir/project019_reads"
coReads="$rundir/coReads"
assemblies="$rundir/assemblies"
coassemblies="$assemblies/coassemblies"
coReads="$rundir/coReads"
indiv_reads="$rundir/indiv_read_list.txt"
coRead_list="$rundir/coRead_list.txt"
#coRead_list="$rundir/tmp_coRead_list.txt" #Temporary coReads that failed the first run

# Activate conda
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/conda.sh
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/mamba.sh

#Spades is in mag_taxon environment
mamba activate mag_taxon #megahit is in here

cd $rundir
file=$(sed -n ${SLURM_ARRAY_TASK_ID}p $coRead_list)

cd $assemblies
mkdir -p coassemblies


#Only run assembly on samples that haven't been run
#assembly_path="$assemblies/spades_${file}_output"
#if [ ! -d "$assembly_path" ]; then

#	#Run assembly w/MEGAHIT
#	megahit -m 0.9 -t 20 -1 $reads/$file.R1.fastq.gz -2 $reads/$file.R2.fastq.gz -o $assemblies/spades_${file}_output
#	#spades.py --meta -t 128 -1 $reads/$file.R1.fastq.gz -2 $reads/$file.R2.fastq.gz -o $assemblies/spades_${file}_output
#
#	#Remove excess intermediates
#	cd $assemblies/spades_${file}_output
#	rm -fr intermediate_contigs
#	cd $rundir
#
#else
#	echo "File $file exists!"
#
#fi

###MEGAHIT coReads coassembly

#Only run assembly on samples that haven't been run
assembly_path="$coassemblies/megahit_${file}_output"
if [ ! -d "$assembly_path" ]; then

       #Run assembly w/MEGAHIT
       megahit -m 0.9 -t 40 -1 $coReads/$file.R1.fastq.gz -2 $coReads/$file.R2.fastq.gz -o $coassemblies/megahit_${file}_output

       #Remove excess intermediate files
	cd $coassemblies/megahit_${file}_output
        rm -fr intermediate_contigs
else
       echo "File $file exists!"

fi
