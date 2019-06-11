#!/bin/bash
#BSUB -J HiCUP[1-8]
#BSUB -n 6
#BSUB -R "span[hosts=1]"
#BSUB -P prepay-houlston
#BSUB -W 168:00
#BSUB -o /scratch/cancgene/plaw/scripts/tmp/hicup_precapture_%J_%I_stdout.txt
#BSUB -e /scratch/cancgene/plaw/scripts/tmp/hicup_precapture_%J_%I_stderr.txt

#[1-4]
#i=3

i=${LSB_JOBINDEX}

#allfiles=( hicup_GO30_PC_PEILM_HiSeq_build38.conf hicup_GO33_PC_PEILM_HiSeq_build38.conf hicup_GO34_PC_PEILM_HiSeq_build38.conf hicup_GO30_PC_PEILM_HiSeq.conf hicup_GO33_PC_PEILM_HiSeq.conf hicup_GO34_PC_PEILM_HiSeq.conf )
#allfiles=( hicup_GO30_PC_PEILM_HiSeq.conf hicup_GO33_PC_PEILM_HiSeq.conf hicup_GO34_PC_PEILM_HiSeq.conf )
allfiles=( hicup_ht29_1.conf hicup_ht29_2.conf hicup_lovo_1.conf  hicup_lovo_2.conf hicup_ht29_1_b38.conf hicup_ht29_2_b38.conf hicup_lovo_1_b38.conf  hicup_lovo_2_b38.conf )

fname=${allfiles[$i-1]}

module load samtools
module load R

#editted version which skips the mapping step
/scratch/DGE/MOPOPGEN/gorlando/HiC/HICUPP/hicup_v0.5.7/hicup --config /scratch/cancgene/plaw/crc/cHiC/HICUP_bowtie2/conf_files/$fname


