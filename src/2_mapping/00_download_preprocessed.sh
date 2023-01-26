# Download the data
FASTP_OUTDIR=results/1_qc/fastp_downsampled
mkdir -p $FASTP_OUTDIR
cd $FASTP_OUTDIR
echo "Depositing data in "$FASTP_OUTDIR
curl -O https://fgcz-gstore.uzh.ch/public/RNASeqCourse/yeast_fastp_downsampled_for_STAR.tar

# Extract data
tar -xvf yeast_fastp_downsampled_for_STAR.tar
rm -f yeast_fastp_downsampled_for_STAR.tar