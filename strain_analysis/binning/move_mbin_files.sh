rundir='/scratch.global/elder099/project019'
reads="$rundir/project019_reads"
coReads="$rundir/coReads"
assemblies="$rundir/assemblies"
coassemblies="$assemblies/coassemblies"
binning="$rundir/binning"
coReads="$rundir/coReads"
indiv_reads="$rundir/indiv_read_files.txt"
coRead_list="$rundir/coRead_list.txt"



# Activate conda
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/conda.sh
. /projects/standard/noyes046/elder099/miniforge3/etc/profile.d/mamba.sh

#metabinner environment
mamba activate metabinner #metabinner is in here



cat $indiv_reads | while read file
#tail $indiv_reads -n +2 | while read file
do

	output_dir=$binning/metabinner/${file}_bins
	cd $output_dir
	mkdir final_bins	


	#move bins from filepath depths to output_dir
	cp -r $output_dir/metabinner_res/ensemble_res/greedy_cont_weight_3_mincomp_50.0_maxcont_15.0_bins/ensemble_3logtrans/addrefined2and3comps/greedy_cont_weight_3_mincomp_50.0_maxcont_15.0_bins $output_dir/final_bins	
	


done
