#!/bin/bash
#BSUB -J "chicago_lovo"
#BSUB -n 12
#BSUB -R "span[hosts=1]"
#BSUB -P DMPGJMAAQ
#BSUB -W 168:00
#BSUB -q normal
#BSUB -o /scratch/DGE/MOPOPGEN/plaw/scripts/tmp/chicago_output.%J
#BSUB -e /scratch/DGE/MOPOPGEN/plaw/scripts/tmp/chicago_error.%J

module load R

output_prefix="LCL_bw2_build37"
DIR_G="/scratch/DGE/MOPOPGEN/plaw/cyberman/chicago/results"/"$output_prefix"
DIR_DESIGN="$DIR_G"/chicago_designDir_20170920_145714/
OUTPUT_DIR="$DIR_G"/chicago_output/


#list of the .chinput files
f1=$DIR_G\/chicago_designDir_20170925_102955/LCL_bw2_build37_1/LCL_bw2_build37_1.chinput
f2=$DIR_G\/chicago_designDir_20170920_145714/LCL_bw2_build37/LCL_bw2_build37.chinput

#input_files="${f1},${f2},${f3}"
input_files="${f1},${f2}"

Rscript /scratch/DGE/MOPOPGEN/plaw/cyberman/chicago/scripts/chicagoTools/runChicago.R --design-dir $DIR_DESIGN --cutoff 1 --export-format seqMonk,interBed,washU_text,washU_track --output-dir $OUTPUT_DIR --rda $input_files $output_prefix
