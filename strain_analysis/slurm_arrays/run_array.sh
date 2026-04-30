#!/bin/bash

#Create array, job number = line in coRead_list.txt
#211 jobs, 211 coReads
#Create array, job number = line in indiv_read_files.txt
#106 jobs, 106 readsets
#sbatch --array=1-106 megahit_array.sh

#sbatch --array=1-211 megahit_coassembly_array.sh
sbatch --array=1-2 megahit_coassembly_array.sh #temporary list after first failure

#current job status:
#sacct -j 6056538
#sacct -j 6372817
#6396859
#8125138
