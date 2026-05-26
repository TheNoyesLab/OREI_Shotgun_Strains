#!/bin/bash

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
indiv_reads="$rundir/one_file2.txt"

###
cd $rundir
#file=$(sed -n ${SLURM_ARRAY_TASK_ID}p $indiv_reads)
file="USDA1724_S215.non.host"




#####
#####METABAT2
#####

#binning environment
mamba activate binning

cd $binning/metabat2/
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

