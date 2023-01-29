# Download the data
STAR_OUTDIR=results/2_mapping/STAR_alignment
mkdir -p $STAR_OUTDIR
cd $STAR_OUTDIR
echo "Depositing data in "$STAR_OUTDIR
curl -O https://fgcz-gstore.uzh.ch/public/RNASeqCourse/processed_yeast_STAR_aligned.tar

# Extract data
tar -xvf processed_yeast_STAR_aligned.tar
rm -f processed_yeast_STAR_aligned.tar