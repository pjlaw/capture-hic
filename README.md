# Capture HiC

Scripts to process the CHiC data

Consists of two phases:
1.  Run HiCUP
2.  Run Chicago


## HiCUP
HiCUP: pipeline for mapping and processing Hi-C data. 
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4706059/

Probably worth getting the latest version:
https://www.bioinformatics.babraham.ac.uk/projects/hicup/

Edit the HiCUP .conf file to point to the correct .fastq files. Also change the 
relevant output paths. Check the relevant genome reference and digest files
Build 38 data:
/scratch/DGE/MOPOPGEN/gorlando/HiC/reference_b38_dan_bowtie2/

**NOTE** This genome reference only contains the primary chromosomes (1-22, X, Y).
For a more comprehensive analysis you may want to keep the decoy/alt contigs, 
then remove any that did map to these before processing with CHiCAGO.

Edit the submission script with the correct .conf script.

Submit to HPC!

## CHiCAGO
CHiCAGO: robust detection of DNA looping interactions in Capture Hi-C data.
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4908757/

https://bitbucket.org/chicagoTeam/chicago/src/master/

Bait map and rmap files:
/scratch/DGE/MOPOPGEN/plaw/cyberman/chicago/reference_data

Create chinput files for each bam file (replicate)

Edit the filenames of the chinput files in the submit script (runChicago.sh)

Submit to HPC!

---

### TODO
TAD calling

