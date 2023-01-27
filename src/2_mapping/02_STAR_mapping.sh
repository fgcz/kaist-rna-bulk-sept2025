TRIMMED_FASTQS=results/1_qc/fastp_downsampled
OUTPUT_DIR=results/2_mapping/STAR_alignment
mkdir -p $OUTPUT_DIR
echo $(pwd)

# Start processing with fastp
for FASTQ in $TRIMMED_FASTQS/*_trimmed_R1.fastq.gz
  do SAMPLE_NAME=$(basename ${FASTQ%_R1.fastq.gz})
  echo $FASTQ
  
  # First do alignment with STAR using a pre-built index
  /opt/STAR \
    --genomeDir data/supplementary-files/Ensembl_R64_genes_STARIndex \
    --outFileNamePrefix $OUTPUT_DIR/$SAMPLE_NAME"_" \
    --readFilesIn $FASTQ --twopassMode None --runThreadN 4 \
    --sjdbOverhang 150 --outFilterType BySJout --outFilterMatchNmin 30 \
    --outFilterMismatchNmax 10 --outFilterMismatchNoverLmax 0.05 \
    --outMultimapperOrder Random --alignSJDBoverhangMin 1 \
    --alignSJoverhangMin 8 --alignIntronMax 100000 --alignMatesGapMax 100000 \
    --outFilterMultimapNmax 50 --chimSegmentMin 15 \
    --chimJunctionOverhangMin 15 --chimScoreMin 15 --chimScoreSeparation 10 \
    --outSAMstrandField intronMotif --alignEndsProtrude 3 ConcordantPair \
    --outSAMattributes All --outStd BAM_Unsorted --outSAMtype BAM Unsorted \
    --outSAMattrRGline ID:GE4 SM:GE4 --readFilesCommand zcat > $OUTPUT_DIR/$SAMPLE_NAME.out.bam
  
  # Sort and index
  samtools sort -l 9 -m 2625M -@ 4 $OUTPUT_DIR/$SAMPLE_NAME.out.bam -o $OUTPUT_DIR/$SAMPLE_NAME.bam
  rm -f $OUTPUT_DIR/$SAMPLE_NAME.out.bam
  samtools index $OUTPUT_DIR/$SAMPLE_NAME.bam
  
  # “Guess” how RNA-seq sequencing were configured
  infer_experiment.py -r data/supplementary-files/Ensembl_R64_genes/genes.bed \
    -i $OUTPUT_DIR/$SAMPLE_NAME.bam -s 200000 > $OUTPUT_DIR/$SAMPLE_NAME"_inferred.txt"
done