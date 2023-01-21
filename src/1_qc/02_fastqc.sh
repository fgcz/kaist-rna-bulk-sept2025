#!/usr/bin/bash

# Make 
PROCESSED_FASTQC=results/1_qc/fastqc/
mkdir -p $PROCESSED_FASTQC

/opt/FastQC/fastqc --extract -o $PROCESSED_FASTQC \
  -t 4 -a data/supplementary-files/adapter_list.txt --kmers 7 \
  data/tmp/yeast_fastq_full/*fastq.gz \
  > $PROCESSED_FASTQC/fastqc.out 2> $PROCESSED_FASTQC/fastqc.err