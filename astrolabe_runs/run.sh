#!/bin/bash

bam_cram=$1
vcf=$2
reference=/home/tgenref/homo_sapiens/grch38_hg38/hg38tgen/genome_reference/GRCh38tgen_decoy_alts_hla.fa
out=$3

/labs/byron/tizatt/projects/pgx/tools/astrolabe-0.8.7.0.test/astrolabe-0.8.7.0/run-astrolabe.sh \
	-conf /labs/byron/tizatt/projects/pgx/tools/astrolabe-0.8.7.0.test/astrolabe-0.8.7.0/astrolabe.ini \
	-ref GRCh38 \
	-inputVCF ${vcf} \
	-fasta ${reference} \
	-outFile ${out} \
	-skipBamQC \
	-skipVcfQC
