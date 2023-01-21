#!/usr/bin/bash

# Make directories
PROCESSED_FASTQC=results/1_qc/fastqc
PROCESSED_MULTIQC=results/1_qc/multiqc
mkdir -p $PROCESSED_FASTQC $PROCESSED_MULTIQC

# Process with FastQC
/opt/FastQC/fastqc --extract -o $PROCESSED_FASTQC \
  -t 4 -a data/supplementary-files/adapter_list.txt --kmers 7 \
  data/tmp/yeast_fastq_full/*fastq.gz
  
# Combine result with multiqc
multiqc --outdir $PROCESSED_MULTIQC $PROCESSED_FASTQC