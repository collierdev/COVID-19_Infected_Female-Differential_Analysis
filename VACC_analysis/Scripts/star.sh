#!/bin/bash
#SBATCH --partition=bigmem
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=50G
#SBATCH --time=20:00:00
#SBATCH --job-name=STAR_test
# %x=job-name %j=jobid
#SBATCH --output=%x_%j.out
#SBATCH --mail-user=jwcollie@uvm.edu
#SBATCH --mail-type=ALL


echo "Starting sbatch script star.sh at:`date`"
echo "  running host:    ${SLURMD_NODENAME}"
echo "  assigned nodes:  ${SLURM_JOB_NODELIST}"
echo "  jobid:           ${SLURM_JOBID}"

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8
cd genomeDir/

for i in *-Seq_1.fastq.gz
do
SAMPLE=$(echo ${i} | sed "s/-Seq_1\.fastq.gz//")
echo ${SAMPLE}-Seq_1.fastq.gz ${SAMPLE}-Seq_2.fastq.gz

STAR  \
--genomeDir /gpfs1/cl/mmg232/MMG232/RNAseq/human_gencode_GRCh38/ \
--runMode alignReads \
--genomeLoad  LoadAndKeep \
--runThreadN 6 \
--readFilesIn ${SAMPLE}-Seq_1.fastq.gz ${SAMPLE}-Seq_2.fastq.gz \
--readFilesCommand zcat \
--outFileNamePrefix ${SAMPLE}_star_out \
--outSAMtype BAM SortedByCoordinate \
--outSAMunmapped Within \
--outSAMattributes Standard \
--limitBAMsortRAM 31000000000

done
