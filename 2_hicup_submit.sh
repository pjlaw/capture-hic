#!/bin/bash
#BSUB -J HiCUP
#BSUB -n 6
#BSUB -R "span[hosts=1]"
#BSUB -P prepay-houlston
#BSUB -W 168:00
#BSUB -o hicup_%J_stdout.txt
#BSUB -e hicup_%J_stderr.txt

module load samtools
module load R

/scratch/DGE/MOPOPGEN/plaw/programs/hicup_v0.7.2/HiCUP-master/hicup --config /path/to/conf/1_hicup.conf


