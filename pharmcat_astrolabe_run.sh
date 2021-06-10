#!/bin/bash
#SBATCH -p defq # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 4 # number of cores
#SBATCH --mem 2000
#SBATCH -t 0-2:00 # wall-time (D-HH:MM)
#SBATCH -o slurm.%N.%j.out # STDOUT
#SBATCH -e slurm.%N.%j.out # STDERR
#SBATCH --job-name="pharmcat"

BAM=$1
VCF=$2
OUT=$3 # 
OUTDIR=$4

#BED=/home/tizatt/pgx/pharmcat_convert/pharmcat.bed
BED=/home/tizatt/pgx/pharmcat_convert/pharmcat_intervals_0.8.0.txt
ASTROLABE_SH=/home/tizatt/pgx/astrolabe_runs/run.sh
BCFTOOLS_CALL=/home/tizatt/pgx/pharmcat_convert/bcftools_call.sh
#PHARMCAT_JAR=/home/tizatt/pgx/tools/PharmCAT/build/libs/pharmcat-0.7.1-all.jar
PHARMCAT_JAR=/home/tizatt/pgx/tools/pharmcat-0.8.0-all.jar
ASTROLABE_TSV=${OUTDIR}/${OUT}.astrolabe.tsv
PHARMCAT_VCF=${OUTDIR}/${OUT}.pharmcat.vcf
REF=/home/tgenref/homo_sapiens/grch38_hg38/hg38tgen/genome_reference/GRCh38tgen_decoy_alts_hla.fa


# Run astrolabe.  The output of this (tsv file) goes into pharmcat

${ASTROLABE_SH} ${BAM} ${VCF} ${ASTROLABE_TSV}


# convert cram file to a "corrected" pharmcat vcf file

${BCFTOOLS_CALL} ${BAM} ${BED} ${PHARMCAT_VCF} ${REF}


# Run pharmcat

#java -jar ${PHARMCAT_JAR} -a ${ASTROLABE_TSV} -f ${OUT} -j -o ${OUTDIR}/${OUT} -vcf ${PHARMCAT_VCF}

java -jar ${PHARMCAT_JAR} -f ${OUT} -j -o ${OUTDIR}/${OUT} -vcf ${PHARMCAT_VCF}



 
