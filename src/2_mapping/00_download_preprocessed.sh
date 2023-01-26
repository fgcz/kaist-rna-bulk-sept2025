# Download the data
FASTP_OUTDIR=results/1_qc/fastp
mkdir -p $FASTP_OUTDIR
cd $FASTP_OUTDIR
echo "Depositing data in "$FASTP_OUTDIR
curl -O https://fgcz-gstore.uzh.ch/public/processed_yeast_fastp.tar

# Extract data
tar -xvf processed_yeast_fastp.tar
rm -f processed_yeast_fastp.tar