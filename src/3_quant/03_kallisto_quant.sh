FASTP_OUTDIR=results/1_qc/fastp
KALLISTO_OUTDIR=results/3_quant/kallisto
mkdir -p $KALLISTO_OUTDIR

# Start processing with kallisto
for FASTQ in $FASTP_OUTDIR/*_R1.fastq.gz
  do SAMPLE_NAME=$(basename ${FASTQ%_trimmed_R1.fastq.gz})
  echo $SAMPLE_NAME
  /opt/kallisto quant \
    -i data/supplementary-files/Ensembl_R64_genes_protein_coding_kallistoIndex/transcripts.idx \
    -o $KALLISTO_OUTDIR -t 4 --bias --bootstrap-samples 10 --seed 42 \
    --single --rf-stranded --fragment-length 180 --sd 50 $FASTQ \
    2> $KALLISTO_OUTDIR/$SAMPLE_NAME"_kallisto.stderr" > $KALLISTO_OUTDIR/$SAMPLE_NAME"_kallisto.stdout"
  mv $KALLISTO_OUTDIR/abundance.tsv $KALLISTO_OUTDIR/$SAMPLE_NAME".txt"
  mv $KALLISTO_OUTDIR/run_info.json $KALLISTO_OUTDIR/$SAMPLE_NAME".json"
done
