getFeatureAnnotation = function(featAnnoFn, dataFeatureType=c("gene", "transcript", "isoform")){
  require(data.table)
  require(rtracklayer)
  dataFeatureType <- match.arg(dataFeatureType)

  if(dataFeatureType == "gene"){
    refAnnoGeneFn <- sub("(_byTranscript)*\\.txt$", "_byGene.txt", featAnnoFn)
    
    if(file.exists(refAnnoGeneFn)){
      message("Using gene level annotation: ", refAnnoGeneFn)
      seqAnno <- fread(refAnnoGeneFn, data.table=FALSE)
      ## replace the NA character columns with ""; 
      ## numeric columns shall not have NA.
      seqAnno[is.na(seqAnno)] <- ""
      rownames(seqAnno) <- seqAnno$gene_id
    }else{
      message("Using isoform level annotation and aggregating.")
      ## For compatibility of old annotation without _byGene.txt
      seqAnnoTx <- fread(featAnnoFn)
      ## replace the NA character columns with ""; 
      ## numeric columns shall not have NA.
      seqAnnoTx[is.na(seqAnnoTx)] <- ""
      ## historical reason: replace Identifier with transcript_id
      colnames(seqAnnoTx)[colnames(seqAnnoTx)=="Identifier"] <- "transcript_id"
      seqAnno <- aggregateFeatAnno(seqAnnoTx)
    }
  }else if(dataFeatureType %in% c("transcript", "isoform")){
    seqAnno <- fread(featAnnoFn, data.table=FALSE)
    ## replace the NA character columns with ""; 
    ## numeric columns shall not have NA.
    seqAnno[is.na(seqAnno)] <- ""
    ## historical reason: replace Identifier with transcript_id
    colnames(seqAnno)[colnames(seqAnno)=="Identifier"] <- "transcript_id"
    rownames(seqAnno) <- seqAnno$transcript_id
  }else{
    stop("Only support dataFeatureType in 'transcript', 'isoform', 'gene'")
  }
  minimalCols <- c("gene_id", "transcript_id", "gene_name", "type", "strand",
                   "seqid", "biotypes", "description", "start", "end",
                   "gc", "featWidth", "GO BP", "GO MF", "GO CC")
  if(!"featWidth" %in% colnames(seqAnno) && "width" %in% colnames(seqAnno)){
    # For back compatibility
    seqAnno$featWidth <- seqAnno$width
    seqAnno$width <- NULL
  }
  if(!"description" %in% colnames(seqAnno) || all(seqAnno$description == "")){
    message("Assigning description with gene_id.")
    seqAnno$description <- seqAnno$gene_id
  }
  if(!"type" %in% colnames(seqAnno) || all(seqAnno$type == "")){
    message("Assigning type with protein coding.")
    seqAnno$type <- "protein_coding"
  }
  if(!"biotypes" %in% colnames(seqAnno) || all(seqAnno$biotypes == "")){
    message("Assigning biotypes with protein coding.")
    seqAnno$biotypes <- "protein_coding"
  }
  if(!all(minimalCols %in% colnames(seqAnno))){
    stop(paste(minimalCols[!minimalCols %in% colnames(seqAnno)], collapse="; "),
         " must exist in annotation file!")
  }
  return(seqAnno)
}