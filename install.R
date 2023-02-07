# This file contains packages which should be added to the notebook
# during the build process. It is standard R code which is run during
# the build process and typically comprises a set of `install.packages()`
# commands.
#
# For example, remove the comment from the line below if you wish to
# install the `ggplot2` package.
#

if (!require("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

biocPackages <- c(
  "clusterProfiler",
  "Rsubread",
  "rtracklayer",
  "SummarizedExperiment",
  "DESeq2",
  "edgeR",
  "tximport",
  "EnhancedVolcano",
  "WGCNA"
)
BiocManager::install(biocPackages)

cranPackages <- c(
  "ggplot2",
  "tidyverse",
  "plotly",
  "pheatmap"
)
install.packages(cranPackages)
