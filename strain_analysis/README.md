# Strain Analysis Directory

*Steps for Strain Analysis*
- Assembly:
  - Use your favorite assembler on each sample individually
  - Optional: also perform coassembly by merging all reads from all samples (catches low-abundance microbes) N/A
- Genome Binning:
  - Bin each assembly separately
- Dereplication:
  - Use dRep on all bins together to extract similar strains across samples
- Downstream Analysis
  - Perform downstream analyses on de-repped list of genomes


# Captain's Log:


Finished assembly of USDA USDA817 reads. Next step is to test them out, see if they look good. 2024-07-19
 
 * Corrected reads are in /home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/spades_output/corrected/
 * Assembled contigs are in /home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/spades_output/contigs.fasta
 * Assembled scaffolds are in /home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/spades_output/scaffolds.fasta
 * Paths in the assembly graph corresponding to the contigs are in /home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/spades_output/contigs.paths
 * Paths in the assembly graph corresponding to the scaffolds are in /home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/spades_output/scaffolds.paths
 * Assembly graph is in /home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/spades_output/assembly_graph.fastg
 * Assembly graph in GFA format is in /home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/spades_output/assembly_graph_with_scaffolds.gfa

======= SPAdes pipeline finished.

Completed QC of assemblies using QUAST. 2024-07-19

Finished binning of USDA817 reads. Next step is to dereplicate all bins (each bin?). 2024-08-10
 * Bin output of MetaWrap (which ran Metabat2) is in: /home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/binning_round1/metabat2_bins/.fa
 * All bins are multi-fastas in one directory
 * MetaWrap doesn't work with zipped reads, may need to pick another tool later -- runtime around 25 mins for one samples at 50 cpus
 * dRep failed when running on one bin, and subsequently failed when using multiple
 * dRep in strains conda env



Rerun of SPADES complete

Finished SPADESing of USDA996 and USDA898 reads

 * Assembled scaffolds are in:
   * USDA898: /home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/spades_USDA898_S127.non.host_output/scaffolds.fasta
   * USDA996: /home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/spades_USDA996_S67.non.host_output/scaffolds.fasta

Now time to run QUAST on both datasets

2024-08-19
MetaQUAST run complete
 * Files found here: /home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/quast_898_996_output

METABAT2 run on USDA898 and USDA996 is done -- 20 bins each
 * USDA898 bins here: /home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/binning_898_996/USDA898_S127.non.host_bins
 * USDA996 bins here: /home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/binning_898_996/USDA996_S67.non.host_bins


dRep run on USDA898 and USDA996 is done -- output is 12 derepped bins, 6 from each
 * Bins are here: /home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/binning_898_996/dRep_output/dereplicated_genomes

Notes: 
 - I had to rename and unzip all of the raw reads, but this isn't feasible in the future. Try METABAT2 raw.
 - I tarballed the USDA817 assemblies because they're huge and possible incorrect. Just use the two available.
 - nf-core/mag is a good template for code


Now that I have a dereplicated set of genomes I want to create a phylogeny out of these bins/MAGS. Next step is to try PhyloPhlan or GTDB-tk for phylogenetic placement.


2024-09-02

Downloaded GTDB-TK database in /home/noyes046/shared/databases/gtdb-tk/release220
 - This is a huge database used to assign taxonomic classifications to MAGs/bins
 - Must route to GTDB-TK database in mamba env't using ' mamba env config vars set GTDBTK_DATA_PATH="/home/noyes046/shared/databases/gtdb-tk/release220" '

Running GTDB-TK classify_wf overnight
 - gtdb-tk was giving package errors. Requires numpy<1.24 (mamba auto-install 1.24)

2024-09-09

GTDB-TK finished running
 - output directory at:/home/noyes046/elder099/OREI_Shotgun_AMR_Analyses/strain_analysis/gtdb-tk_output

GTDB-TK output:
 - output includes a summary file of all classifications: gtdbtk.bac120.summary.tsv
 - Also includes trees in /classify/ but trees aren't very useful...
   - Trees dropped into iTOL don't show input genomes (even though they should)
   - Known to be buggy, not intended to be used as a tree builder

Next steps:
Use FastTree to create a phylogenetic tree using output MSA from GTDB-TK
 - Output alignment at: gtdbtk.bac120.msa.fasta.gz (includes submitted and reference genomes)


2024-09-14

Ran FastTree on both all genome MSA and user-only MSA
 - Confusingly, only 5 bins included in user-only MSA
 - All genome MSA takes several hours to run (huge reference database?)
 - user-only tree looks great, but doesn't includes samples I think should be
   - possibly excluded due to some bins having no marker genes
 - Two kinds of Ornithinimicrobium kibberense found 


2024-10-05 & 2023-10-07

Working on file structure/maintenance and systematizing scripts
 - Binning step: *Success* ($straindir/binning_v3)
   - Switched to directly running MetaBat2
   - Got it to work on fastq.gz
   - organized files
   - Fixed naming to fit dRep
 - Dereplication step *Success* ($straindir/binning_v3i/dRep_output)
   - systematized to loop through each sample's bins to create a list for dRep

Next Steps:
 - Finish read concatenation by coassembly group
 - File management for Metaspades (remove K## directories and others)
 - Establish coassembly input for Metaspades


2024-10-14:

Wrapping up coassembly algorithm
 - Established coReads at $straindir/test_reads/coReads
   - coReads should be labled 'sample1_sample2_samplen.non.host.R[12].fastq.gz' 
   - loops through test cow group
 - MetaSPADES runs individual and coReads
   - currently running sans problems
 - High-level data structure reorganization
   - establish run directory and assembly directories

Next Steps:
 - Complete assembly
 - Run binning on all assembly/coassembly directories
 - Expand to additional binners (e.g. concoct) (optional)


2024-10-16:

Upgrading binning code
 - Loop binning tool through indiv_assemblies and coassemblies
 - Expand binning tools to Maxbin2
   - Wrote code, but haven't tested yet
   - Adjusted directory structure to have folder for each binner
 - dRep loops through indiv_bins and cobins

Next Steps:
 - Test current binners Metabat2, Maxbin2
 - Expand to additional binners (e.g. concoct, DasTool)
 - Run e.g. dRep, gtdbtk on Metabat2 bins
