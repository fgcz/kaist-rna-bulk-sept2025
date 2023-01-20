# First we make a directory to house our data
YEAST_DIR=data/tmp/yeast_fastq_full
mkdir -p $YEAST_DIR
cd $YEAST_DIR
curl -O https://fgcz-gstore.uzh.ch/public/yeast_full.tar
tar -xvf yeast_full.tar
rm -f yeast_full.tar
