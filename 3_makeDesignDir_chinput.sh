#!/bin/bash
#BSUB -J chinput
#BSUB -P 
#BSUB -W 100:00
#BSUB -n 2
#BSUB -R "span[hosts=1]"
#BSUB -o design.%J.output
#BSUB -e design.%J.error


## INPUTS ##
# input files - CHANGE HERE
SAMPLE_NAME="LCL_bw2_build37_1"
# Input bam file
FILE_BAM="/scratch/DGE/MOPOPGEN/plaw/cyberman/crc/cHiC/HICUP_bowtie2/LCL_1_b37/GM_rep2_all_R1_2.hicup.bam" 
# output directory - where you want your output
OUTPUT="/scratch/DGE/MOPOPGEN/path/to/output/"

DATETIME=`date +%Y%m%d_%H%M%S`
OUT_DIR="$OUTPUT"/"results"/"$SAMPLE_NAME"/"chicago_designDir_""$DATETIME"
LOG_FILE="$OUT_DIR"/"$DATETIME"_"designDir.log"
FNAME_OUT="$SAMPLE_NAME"_"$DATETIME"

# Reference data
# Base HiC reference data directory
REF_DIR="/scratch/DGE/MOPOPGEN/plaw/cyberman/chicago"
# Reference files
FILE_RMAP="$REF_DIR"/"reference_data/20160111_163319_HindIII.rmap"
# Baitmap file
FILE_BAITMAP="$REF_DIR"/"reference_data/20170324_updated_HindIII.baitmap"
# Location of CHiCAGO tools directory
DIR_TOOLS="$REF_DIR"/"scripts/chicagoTools/"


# Set this to "nodelete" to keep intermediate files
NODELETE="nodelete"


############

#### SCRIPT ####

echo "Running job with the following variables:" >> "$LOG_FILE"
echo "DATETIME = ""$DATETIME" >> "$LOG_FILE"
echo "OUT_DIR = ""$OUT_DIR" >> "$LOG_FILE"
echo "FNAME_OUT = ""$FNAME_OUT" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

module load python/2.7.11

mkdir -p "$OUT_DIR"

#required for the run_chicago script (next stage)
cp "$FILE_RMAP" "$OUT_DIR"/
cp "$FILE_BAITMAP" "$OUT_DIR"/

# Run CHiCAGO tools to produce the files required by the CHiCAGO R scripts.
echo "Running makeDesignFiles.py from chicago tools"
python "$DIR_TOOLS"/makeDesignFiles.py \
	--designDir="$OUT_DIR" \
	--rmapfile="$FILE_RMAP" \
	--baitmapfile="$FILE_BAITMAP" \
	--outfilePrefix="$OUT_DIR"/"$FNAME_OUT"\
#extra parameters - add these if so desired
#[--minFragLen=150] [--maxFragLen=40000] [--maxLBrownEst=1500000] [--binsize=20000] [--removeb2b=True] [--removeAdjacent=True]

# Load modules needed by bam2chicago.sh - chicago does not support bedtools >= 2.26
module load bedtools/2.25.0
# use bam2chicago.sh to generate .chinput files
SCRP_BAM2CHICAGO="$DIR_TOOLS"/bam2chicago.sh
echo "Running script: ""$SCRP_BAM2CHICAGO"
CURRENT_DIRECTORY=$(pwd)
echo "Current working directory: "${CURRENT_DIRECTORY}
echo "Changing working directory to \"design directory\" because the bam2chicago.sh script uses the \"samplename\" variable in both the directory and a the file name."
cd "$OUT_DIR"
echo "         Design directory: ""$OUT_DIR"
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
