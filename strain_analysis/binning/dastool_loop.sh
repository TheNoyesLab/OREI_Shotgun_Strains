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

#binning environment
mamba activate binning #dastool is in here


#file="USDA1008_S155.non.host"
#file="USDA1348_S234.non.host"
#file="USDA1308_S168.non.host"
cd $rundir
#indiv_reads="one_file2.txt"

cat $indiv_reads | while read file
#tail $indiv_reads -n +2 | while read file
do

cd $rundir


#Manually-made helper tool to format tsvs
./Fasta_to_Contig2Bin.sh -i $binning/metabat2/${file}_bins -e fa > $binning/metabat2/${file}_bins/metabat2.contigs2bin.tsv
./Fasta_to_Contig2Bin.sh -i $binning/maxbin2/${file}_bins -e fasta > $binning/maxbin2/${file}_bins/maxbin2.contigs2bin.tsv
./Fasta_to_Contig2Bin.sh -i $binning/metabinner/${file}_bins/metabinner_res/ensemble_res/greedy_cont_weight_3_mincomp_50.0_maxcont_15.0_bins/ensemble_3logtrans/addrefined2and3comps/greedy_cont_weight_3_mincomp_50.0_maxcont_15.0_bins -e fna > $binning/metabinner/${file}_bins/metabinner.contigs2bin.tsv


#Fix metabat2 tsv file
cd $binning
awk -F'\t' '{OFS="\t"} {print $1, $4}' $binning/metabat2/${file}_bins/metabat2.contigs2bin.tsv > tmp
mv tmp $binning/metabat2/${file}_bins/metabat2.contigs2bin.tsv



mkdir -p dastool
cd $binning/dastool
mkdir ${file}_bins

#Run consensus binning
DAS_Tool -i $binning/metabat2/${file}_bins/metabat2.contigs2bin.tsv,$binning/maxbin2/${file}_bins/maxbin2.contigs2bin.tsv,$binning/metabinner/${file}_bins/metabinner.contigs2bin.tsv \
	-l metabat2,maxbin2,metabinner \
	-c $assemblies/megahit_${file}_output/final.contigs.fa \
	-o $binning/dastool/${file}_bins/${file} -t 50 \
	--write_bins


cd $binning/dastool/${file}_bins
cd ${file}_DASTool_bins

echo "$file made THIS MANY BINS:\n"
ls | grep ".fa" | wc -l

done









#####
#####Coassembly bins next
#####



cat $coRead_list | while read file
#tail $indiv_reads -n +2 | while read file
do

cd $rundir


#Manually-made helper tool to format tsvs
./Fasta_to_Contig2Bin.sh -i $binning/metabat2/${file}_bins -e fa > $binning/metabat2/${file}_bins/metabat2.contigs2bin.tsv
./Fasta_to_Contig2Bin.sh -i $binning/maxbin2/${file}_bins -e fasta > $binning/maxbin2/${file}_bins/maxbin2.contigs2bin.tsv
./Fasta_to_Contig2Bin.sh -i $binning/metabinner/${file}_bins/metabinner_res/ensemble_res/greedy_cont_weight_3_mincomp_50.0_maxcont_15.0_bins/ensemble_3logtrans/addrefined2and3comps/greedy_cont_weight_3_mincomp_50.0_maxcont_15.0_bins -e fna > $binning/metabinner/${file}_bins/metabinner.contigs2bin.tsv


#Fix metabat2 tsv file
cd $binning
awk -F'\t' '{OFS="\t"} {print $1, $4}' $binning/metabat2/${file}_bins/metabat2.contigs2bin.tsv > tmp
mv tmp $binning/metabat2/${file}_bins/metabat2.contigs2bin.tsv



mkdir -p dastool
cd $binning/dastool
mkdir ${file}_bins

#Run consensus binning
DAS_Tool -i $binning/metabat2/${file}_bins/metabat2.contigs2bin.tsv,$binning/maxbin2/${file}_bins/maxbin2.contigs2bin.tsv,$binning/metabinner/${file}_bins/metabinner.contigs2bin.tsv \
	-l metabat2,maxbin2,metabinner \
	-c $coassemblies/megahit_${file}_output/final.contigs.fa \
	-o $binning/dastool/${file}_bins/${file} -t 50 \
	--write_bins


cd $binning/dastool/${file}_bins
cd ${file}_DASTool_bins

echo "$file made THIS MANY BINS:\n"
ls | grep ".fa" | wc -l

done







#cd $rundir

#Generate coverage file (bam) from contigs and reads
#ls $reads | grep $file
#cd $binning/metabinner
#bash run_metabinner.sh -a $assemblies/megahit_$file.non.host_output/final.contigs_1500.fa -o $binning/metabinner/metabinner_out -d $binning/metabinner/coverage_profile_f1500.tsv -k $assemblies/megahit_$file.non.host_output/final.contigs_kmer_4_f1500.csv -p $path_to_MetaBinner -t 50






