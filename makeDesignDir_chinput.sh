#!/bin/bash
#BSUB -J "chinput_lcl_2"
#BSUB -P DMPGJMAAQ
#BSUB -W 100:00
#BSUB -n 2
#BSUB -R "span[hosts=1]"
#BSUB -q normal
#BSUB -o /scratch/DGE/MOPOPGEN/plaw/scripts/tmp/design.%J.output
#BSUB -e /scratch/DGE/MOPOPGEN/plaw/scripts/tmp/design.%J.error

# This is inteded as template for creating a single node cyberman HPC job.
# SUGGESTED USE: copy this template into the directory where the job logs will go, edit it to call the required scripts and run from that directory.
# INPUT: the scripts to be called with the parameters used to call them.

## INPUTS ##

# Base HiC directory on the system
DATETIME=`date +%Y%m%d_%H%M%S`
DIR_HIC="/scratch/DGE/MOPOPGEN/plaw/cyberman/chicago"
# Location of CHiCAGO tools directory
DIR_TOOLS="$DIR_HIC"/"scripts/chicagoTools/"
LOG_FILE="$DATETIME"_"designDir".log
# Set this to "nodelete" to keep intermediate files
NODELETE="nodelete"

#input files - CHANGE HERE
SAMPLE_NAME="LCL_bw2_build37_1"
# Input bam file
FILE_BAM="/scratch/DGE/MOPOPGEN/plaw/cyberman/crc/cHiC/HICUP_bowtie2/LCL_1_b37/GM_rep2_all_R1_2.hicup.bam" 
# Output file name without extension
FNAME_OUT="$SAMPLE_NAME"_"$DATETIME"
#output directory
DIR_DESIGN="$DIR_HIC"/"results"/"$SAMPLE_NAME"/"chicago_designDir_""$DATETIME"

# Reference files
FILE_RMAP="$DIR_HIC"/"reference_data/20160111_163319_HindIII.rmap"
#nwe baitmap file
#FILE_BAITMAP="$DIR_HIC"/"reference_data/20170324_updated_HindIII.baitmap"
#old baitmap file
FILE_BAITMAP="$DIR_HIC"/"reference_data/20160111_163319_HindIII.baitmap"

############

#### SCRIPT ####

echo "Running job with the following variables:" >> "$LOG_FILE"
echo "DATETIME = ""$DATETIME" >> "$LOG_FILE"
echo "DIR_HIC = ""$DIR_HIC" >> "$LOG_FILE"
echo "LOG_FILE = ""$LOG_FILE" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

module load python/2.7.11

mkdir -p "$DIR_DESIGN"
cp "$FILE_RMAP" "$DIR_DESIGN"/
cp "$FILE_BAITMAP" "$DIR_DESIGN"/

# Run CHiCAGO tools to produce the files required by the CHiCAGO R scripts.
echo "Running makeDesignFiles.py from chicago tools"
python "$DIR_TOOLS"/makeDesignFiles.py \
	--designDir="$DIR_DESIGN" \
	--rmapfile="$FILE_RMAP" \
	--baitmapfile="$FILE_BAITMAP" \
	--outfilePrefix="$DIR_DESIGN"/"$FNAME_OUT"\
#extra parameters - add these if so desired
#[--minFragLen=150] [--maxFragLen=40000] [--maxLBrownEst=1500000] [--binsize=20000] [--removeb2b=True] [--removeAdjacent=True]

# Load modules needed by bam2chicago.sh
module load bedtools
# use bam2chicago.sh to generate .chinput files
SCRP_BAM2CHICAGO="$DIR_TOOLS"/bam2chicago.sh
echo "Running script: ""$SCRP_BAM2CHICAGO"
CURRENT_DIRECTORY=$(pwd)
echo "Current working directory: "${CURRENT_DIRECTORY}
echo "Changing working directory to \"design directory\" because the bam2chicago.sh script uses the \"samplename\" variable in both the directory and a the file name."
cd "$DIR_DESIGN"
echo "         Design directory: ""$DIR_DESIGN"
echo "Current working directory: "$(pwd)
bash "$SCRP_BAM2CHICAGO" \
  "$FILE_BAM" \
  "$FILE_BAITMAP" \
  "$FILE_RMAP" \
  "$SAMPLE_NAME" \
  "$NODELETE"
echo "Finished running bam2chicago, changing back to initial working directory: "
cd "$CURRENT_DIRECTORY"
echo "       Starting directory: ""$CURRENT_DIRECTORY"
echo "Current working directory: "$(pwd)



# EOF
