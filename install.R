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

install.packages(c("remotes"))
remotes::install_version("ggplot2", version = "3.4.0", repos = "http://cran.us.r-project.org")
remotes::install_version("gson", version = "0.0.7", repos = "http://cran.us.r-project.org")

cranPackages <- c(
  "tidyverse",
  "plotly",
  "pheatmap",
  "patchwork",
  "Seurat"
)
install.packages(cranPackages)

biocPackages <- c(
  "clusterProfiler",
  "org.Sc.sgd.db",
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
