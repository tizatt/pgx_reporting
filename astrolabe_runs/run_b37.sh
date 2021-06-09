#!/bin/bash

bam_cram=$1
vcf=$2
reference=/home/tgenref/homo_sapiens/grch37_hg19/hs37d5/genome_reference/hs37d5.fa
chain=/labs/byron/tizatt/projects/liftover/b37ToHg38.over.chain
out=$3

b37_vcf=${out/.vcf/.b37.vcf}
/labs/byron/tizatt/projects/pgx/tools/astrolabe-0.8.7.0.test/astrolabe-0.8.7.0/run-astrolabe.sh \
	-conf /labs/byron/tizatt/projects/pgx/tools/astrolabe-0.8.7.0.test/astrolabe-0.8.7.0/astrolabe.ini \
	-ref GRCh37 \
	-inputVCF ${vcf} \
	-fasta ${reference} \
	-outFile ${b37_vcf} \
	-skipBamQC \
	-skipVcfQC


/packages/gatk/4.1.4.0/gatk LiftoverVcf \
        --CHAIN $chain \
        --INPUT ${b37_vcf} \
        -O ${out} \
        --REJECT reject.vcf \
        --REFERENCE_SEQUENCE ${reference}
