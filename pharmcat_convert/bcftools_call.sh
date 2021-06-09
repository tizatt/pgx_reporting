#!/bin/sh

# Usage : script.sh <bam_input> <bed_input>


#REF=/home/tgenref/homo_sapiens/grch38_hg38/hg38tgen/genome_reference/GRCh38tgen_decoy_alts_hla.fa

BAM=$1
BED=$2
OUT=$3
REF=$4


#module load BCFtools/1.10.2-GCC-8.2.0-2.31.1


/home/tizatt/bin/bcftools mpileup \
	--no-BAQ \
	--max-depth 5000 \
	--min-MQ 0 \
	--min-BQ 13 \
	--fasta-ref ${REF} \
	--regions-file ${BED} \
	$BAM \
	| \
	/home/tizatt/bin/bcftools call \
	--consensus-caller \
	| \
	/home/tizatt/bin/bcftools sort \
	| \
	/home/tizatt/bin/bcftools annotate \
	--threads 2 \
	-x 'FORMAT','INFO' \
	--include 'INFO/DP >= 5' \
	--output-type v \
	--output ${OUT}
