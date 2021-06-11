#!/usr/bin/env bash
#SBATCH -p defq # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 4 # number of cores
#SBATCH --mem 2000 # memory pool for all cores
#SBATCH -t 0-2:00 # time (D-HH:MM)
#SBATCH -o slurm.%N.%j.out # STDOUT
#SBATCH -e slurm.%N.%j.err # STDERR
#SBATCH --job-name="pharmcat"
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=tizatt@tgen.org # send-to

BAM=$1
OUT=$2 # 
OUTDIR=$3

BED=/home/tizatt/pgx/pharmcat_convert/pharmcat.b37.bed
ASTROLABE_SH=/home/tizatt/pgx/astrolabe_runs/run.sh
BCFTOOLS_CALL=/home/tizatt/pgx/pharmcat_convert/bcftools_call.sh
#PHARMCAT_JAR=/home/tizatt/pgx/tools/PharmCAT/build/libs/pharmcat-0.7.1-all.jar
PHARMCAT_JAR=/home/tizatt/pgx/tools/pharmcat-0.8.0-all.jar
ASTROLABE_TSV=${OUTDIR}/${OUT}.astrolabe.tsv
PHARMCAT_VCF37=${OUTDIR}/${OUT}.pharmcat.37.vcf
PHARMCAT_VCF38=${OUTDIR}/${OUT}.pharmcat.vcf
REF=/home/tgenref/homo_sapiens/grch37_hg19/hs37d5/genome_reference/hs37d5.fa
CHAIN=/home/tizatt/pgx/b37ToHg38.over.chain
REF_B38=/home/tgenref/homo_sapiens/grch38_hg38/hg38tgen/genome_reference/GRCh38tgen_decoy_alts_hla.fa

# convert cram file to a "corrected" pharmcat vcf file

${BCFTOOLS_CALL} ${BAM} ${BED} ${PHARMCAT_VCF37} ${REF}

# liftover b37 to GRCH38
/packages/gatk/4.1.4.0/gatk LiftoverVcf \
        --CHAIN $CHAIN \
        --INPUT ${PHARMCAT_VCF37} \
        -O ${PHARMCAT_VCF38} \
        --REJECT reject.vcf \
        --REFERENCE_SEQUENCE ${REF_B38}


${ASTROLABE_SH} ${BAM} ${PHARMCAT_VCF38} ${ASTROLABE_TSV}
sed -i '/CYP2C19/d' ${ASTROLABE_TSV}
sed -i '/CYP2C9/d' ${ASTROLABE_TSV}

# Run pharmcat

java -jar ${PHARMCAT_JAR} -a ${ASTROLABE_TSV} -f ${OUT} -j -o ${OUTDIR}/${OUT} -vcf ${PHARMCAT_VCF38}
#java -jar ${PHARMCAT_JAR} -f ${OUT} -j -o ${OUTDIR}/${OUT} -vcf ${PHARMCAT_VCF38}



 
