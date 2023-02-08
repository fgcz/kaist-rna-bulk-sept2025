FASTP_OUTDIR=results/1_qc/fastp
mkdir -p $FASTP_OUTDIR

# Start processing with fastp
for FASTQ in data/tmp/yeast_fastq_full/*_R1.fastq.gz
  do SAMPLE_NAME=$(basename ${FASTQ%_R1.fastq.gz})
  echo $SAMPLE_NAME
  /opt/fastp --in1 $FASTQ \
    --out1 $FASTP_OUTDIR/$SAMPLE_NAME"_trimmed_R1.fastq.gz" \
    --thread 4 --trim_front1 4 --trim_tail1 0 \
    --adapter_fasta data/supplementary-files/allIllumina-forTrimmomatic-20160202.fa \
    --max_len1 0 --max_len2 0 --trim_poly_x --average_qual 20 \
    --poly_x_min_len 10 --length_required 30 --compression 2 \
    2> $FASTP_OUTDIR/$SAMPLE_NAME"_preprocessing.log"
  rm -f $FASTQ
done
