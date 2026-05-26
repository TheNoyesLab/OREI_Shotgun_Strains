#!/bin/bash

rundir='/scratch.global/elder099/project019'
reads="$rundir/project019_reads"
coReads="$rundir/coReads"

# Activate conda
#. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh
#. /home/noyes046/elder099/anaconda3/etc/profile.d/mamba.sh

cd $rundir

#Search for full file names
ls project019_reads/ | grep -f indiv_read_list.txt > indiv_read_files.txt

#Trim file names, keeping only Sample IDs
#sed -n 's/.non.host.R[12].fastq.gz//p' file_nm.txt > file_name_trim.txt
sed -n 's/.R[12].fastq.gz//p' indiv_read_files.txt > indiv_read_files_trim.txt

#Sort and deduplicate list
sort -u indiv_read_files_trim.txt > indiv_read_files.txt #full list of coReads

rm indiv_read_files_trim.txt



