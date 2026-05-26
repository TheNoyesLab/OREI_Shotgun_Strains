#!/bin/bash

#Create array, job number = line in coRead_list.txt
#211 jobs, 211 coReads
#Create array, job number = line in indiv_read_files.txt
#106 jobs, 106 readsets
#sbatch --array=1-106 megahit_array.sh

sbatch --array=1-211 megahit_coassembly_array.sh
#sbatch --array=1-2 megahit_coassembly_array.sh #temporary list after first failure

#Initial batch of 3 for testing
#Full batch of 106 individual reads
#sbatch --array=1-106 all_binning_array.sh 
#current job status:
#sacct -j 6056538
#sacct -j 6372817
#6396859
#8125138
#8608248
#9007450
#9109207
#9760858 #second coassembly
