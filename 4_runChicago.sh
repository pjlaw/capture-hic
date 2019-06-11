#!/bin/bash
#BSUB -J chicago
#BSUB -n 12
#BSUB -R "span[hosts=1]"
#BSUB -P 
#BSUB -W 168:00
#BSUB -q normal
#BSUB -o chicago_%J.output
#BSUB -e chicago_%J.error

module load R

output_prefix="LCL_bw2_build37"
#root directory of the design directories
DIR_G="/scratch/DGE/MOPOPGEN/plaw/cyberman/chicago/results"/"$output_prefix"
#the directory of one of the chinput input (any, doesn't matter which)
DIR_DESIGN="$DIR_G"/chicago_designDir_20170901/
OUTPUT_DIR=/path/to/chicago_output/

#list of the .chinput files
f1=$DIR_G\/chicago_designDir_20170901/LCL_bw2_build37_1/LCL_bw2_build37_1.chinput
f2=$DIR_G\/chicago_designDir_20170922/LCL_bw2_build37_2/LCL_bw2_build37_2.chinput
f3=$DIR_G\/chicago_designDir_20170923/LCL_bw2_build37_3/LCL_bw2_build37_3.chinput

input_files="${f1},${f2},${f3}"

Rscript /scratch/DGE/MOPOPGEN/plaw/cyberman/chicago/scripts/chicagoTools/runChicago.R --design-dir $DIR_DESIGN --cutoff 1 --export-format seqMonk,interBed,washU_text,washU_track --output-dir $OUTPUT_DIR --rda $input_files $output_prefix
