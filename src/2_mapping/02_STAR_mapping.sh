TRIMMED_FASTQS=results/1_qc/fastp
OUTPUT_DIR=results/2_mapping/STAR_alignment

# Start processing with fastp
for FASTQ in $TRIMMED_FASTQS/*_R1.fastq.gz
  do SAMPLE_NAME=$(basename ${FASTQ%_R1.fastq.gz})
  echo $SAMPLE_NAME
  STAR \
    --genomeDir data/supplementary-files/Ensembl_R64_genes_STARIndex \
    --readFilesIn $FASTQ --twopassMode None --runThreadN 4 \
    --sjdbOverhang 150 --outFilterType BySJout --outFilterMatchNmin 30 \
    --outFilterMismatchNmax 10 --outFilterMismatchNoverLmax 0.05 \
    --outMultimapperOrder Random --alignSJDBoverhangMin 1 \
    --alignSJoverhangMin 8 --alignIntronMax 100000 --alignMatesGapMax 100000 \
    --outFilterMultimapNmax 50 --chimSegmentMin 15 \
    --chimJunctionOverhangMin 15 --chimScoreMin 15 --chimScoreSeparation 10 \
    --outSAMstrandField intronMotif --alignEndsProtrude 3 ConcordantPair \
    --outSAMattributes All --outStd BAM_Unsorted --outSAMtype BAM Unsorted \
    --outSAMattrRGline ID:GE4 SM:GE4 --readFilesCommand zcat \
    > $OUTPUT_DIR/$SAMPLE_NAME.out.bam
done