# #Package Installation
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("DESeq2")
# BiocManager::install("ROntoTools")

###################################################################################################################################
#This set of code downloads the pathways from keggs and updates them 
#ON THE FINAL VERSION, VERBOSE SHOULD BE OFF

#kpg <- keggPathwayGraphs("hsa",verbose = TRUE)

#Still the issue of a file delete, might have to look into the function itself
#In the event that we need to do this, use trace("keggPathwayGraphs",edit=TRUE)
#Copy the function and create your own version with a new name

#kpg <- keggPathwayGraphs("hsa", updateCache = TRUE, verbose = TRUE)

###################################################################################################################################

#Libraries for Deseq2 script
library( "DESeq2" )
library(ggplot2)
library(DESeq2)
library(apeglm)


###################################################################################################################################

#This segment will be the where the user inputs his data and preferences
###################################################################################################################################

#The two files that will be read (Each are in the git-folder for convenience)
File_1 <- read.csv(file = "C:\\Users\\yohan\\Desktop\\Analyse_Bioinformatique\\TCGA_GBM\\CSVs\\True_COUNTS_NORMAL_AGE_SUBSET_10_50_Formatted_CSV_VERSION.csv",check.names=FALSE)
File_2 <-read.csv(file = "C:\\Users\\yohan\\Desktop\\Analyse_Bioinformatique\\TCGA_GBM\\CSVs\\True_COUNTS_NORMAL_AGE_SUBSET_69_89_Formatted_CSV_VERSION.csv",check.names=FALSE)

#The conditions associated with the analysis, it could be control vs patient
variable_condition_1 <- "young"
variable_condition_2 <- "old"

#Do they wan to generate MA plots and volcano plots?
do_MA_plot <-TRUE
do_Volcano_Plot <- TRUE


#Directory set up, will it be usefull?
#Directory Workplace!
setwd("C:\\Users\\yohan\\Desktop")


#Create a new file in the selected directory, might not be usefull
maindir <- getwd()
dir.create(file.path(maindir, "Normal_Results"))
setwd(file.path(maindir, "Normal_Results"))

#Create the function for Deseq2
DESeq2_pre_processing <- function(File_1, File_2, variable_condition_1, variable_condition_2, do_MA_plot, do_Volcano_Plot)
{
  ###################################################################################################################################
  #File preperations for a file merge, i.e obtaining the necessary format for DESeq2 preprocessing
  ###################################################################################################################################
  
  #Filters out 0's and NA's, if a file is properly prepared, none of these should occur
  File_1<-File_1[complete.cases(File_1),]
  File_1<-File_1[!(File_1$Gene=="0.0"),]
  
  File_2<-File_2[complete.cases(File_2),]
  File_2<-File_2[!(File_2$Gene=="0.0"),]
  
  
  
  #Counts the number of collumns/patients in each file
  num_1 <- ncol(File_1)-1
  num_2 <- ncol(File_2)-1
  
  
  #Remove first column of Quartile that is being added
  #These are the counts that are will be merged to another
  new_file_1<- File_1[,-1]
  new_file_2<- File_2[,-1]
  
  
  #Create 'merged' Quartiles
  merged_files <- cbind(File_1,new_file_2)
  rownames(merged_files)=merged_files[,1]
  merged_files <- merged_files[,-1]
  
  
  #converts it to numeric
  merged_files <- data.frame(sapply(merged_files, as.numeric),check.names=F, row.names = rownames(merged_files))
  
  #Creates the matrices
  merged_files <- as.matrix(merged_files)
  
  
  #Assign Condition Q1 to all of the columns/samples/patients
  condition <- factor(c(rep(variable_condition_1, num_1),rep(variable_condition_2,num_2)))
  ####################################################################################
  #Create a coldata frame and instantiate the DESeqDataSet
  
  (col_data <- data.frame(row.names=colnames(merged_files),condition))
  dds <- DESeqDataSetFromMatrix(countData=merged_files, colData=col_data, design=~condition)
  ###################################################################################################################################
  
  dds = estimateSizeFactors(dds)
  
  #Run the DESeq pipeline, this takes a while
  dds <- DESeq(dds)
  
  ###################################################################################################################################
  #Change the format into something that can be used by R (dds --> res)
  ###################################################################################################################################
  res <- results(dds)
  
  #Could be used if they want to reduce?
  #res <- lfcShrink(dds, coef=2, type="apeglm")
  
  #Orders the results via adjusted p-value
  res <- res[order(res$padj), ]
  # Merge with normalized count data
  resdata <- merge(as.data.frame(res), as.data.frame(counts(dds, normalized=TRUE)), by="row.names", sort=FALSE)
  names(resdata)[1] <- "Gene"
  head(resdata)
  pre_processed_file_full<-resdata
  ## Write results
  write.csv(resdata, file=paste("diffexpr_results",variable_condition_1,"vs",variable_condition_2,".csv"))
  
  
  ## MA plot with with text
  ###################################################################################################################################
  #Sets up the function
  maplot_text <- function (res, thresh=0.05, labelsig=TRUE, textcx=1, ...) {
    tryCatch({
      with(res, plot(baseMean, log2FoldChange, pch=20, cex=.5, log="x", ...))
      with(subset(res, padj<thresh), points(baseMean, log2FoldChange, col="red", pch=20, cex=1.5))
      if (labelsig) {
        require(calibrate)
        with(subset(res, padj<thresh), textxy(baseMean, log2FoldChange, labs=Gene, cex=textcx, col=2))
      }
    },error=function(error_message){
    })
  }
  
  #Calls the function if the condition is met
  if (do_MA_plot==TRUE){
    png(paste("diffexpr_maplot_",variable_condition_1,"vs",variable_condition_2,"_Text.png"), 7500, 7000, pointsize=15)
    suppressWarnings(maplot_text(resdata, main="MA Plot"))
    invisible(dev.off())
  }
  
  
  ## MA plot with no text
  ###################################################################################################################################
  #Sets up the function
  maplot_no_text <- function (res, thresh=0.05, labelsig=TRUE, textcx=1, ...) {
    tryCatch({
      with(res, plot(baseMean, log2FoldChange, pch=20, cex=.5, log="x", ...))
      with(subset(res, padj<thresh), points(baseMean, log2FoldChange, col="red", pch=20, cex=1.5))
      if (labelsig) {
        require(calibrate)
        with(subset(res, padj<thresh))#, textxy(baseMean, log2FoldChange, labs=Gene, cex=textcx, col=2))
      }
    },error=function(error_message){
    })
  }
  
  #Calls the function is the condition is met
  if (do_MA_plot==TRUE){
    png(paste("diffexpr_maplot_",variable_condition_1,"vs",variable_condition_2,"_No_Text.png"), 2500, 2000, pointsize=15)
    suppressWarnings(maplot_no_text(resdata, main="MA Plot"))
    invisible(dev.off())
  }
  
  
  
  ## Volcano plot with "significant" genes in green with text
  ###################################################################################################################################
  #Sets up the function
  volcanoplot_text <- function (res, lfcthresh=1, sigthresh=0.05, main="Volcano Plot", legendpos="bottomright", labelsig=TRUE, textcx=1, ...) {
    tryCatch({
      with(res, plot(log2FoldChange, -log10(pvalue), pch=20, main=main, ...))
      with(subset(res, padj<sigthresh ), points(log2FoldChange, -log10(pvalue), pch=20, col="red", ...))
      with(subset(res, abs(log2FoldChange)>lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="orange", ...))
      with(subset(res, padj<sigthresh & abs(log2FoldChange)>lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="green", ...))
      if (labelsig) {
        require(calibrate)
        with(subset(res, padj<sigthresh & abs(log2FoldChange)>lfcthresh), textxy(log2FoldChange, -log10(pvalue), labs=Gene, cex=textcx, ...))
      }
      legend(legendpos, xjust=1, yjust=1, legend=c(paste("FDR<",sigthresh,sep=""), paste("|LogFC|>",lfcthresh,sep=""), "both"), pch=20, col=c("red","orange","green"))
    },error=function(error_message){
    })
  }
  
  #Calls the function
  if(do_Volcano_Plot==TRUE){
    png(paste("diffexpr_volcanoplot_",variable_condition_1,"vs",variable_condition_2,"_Text.png"), 5200, 5000, pointsize=20)
    suppressWarnings(volcanoplot_text(resdata, lfcthresh=1, sigthresh=0.05, textcx=.8, xlim=c(-5, 5)))
    invisible(dev.off())
  }
  
  
  ## Volcano plot with "significant" genes in green with no text active_reformed
  ###################################################################################################################################
  #Sets up the function
  volcanoplot_no_text <- function (res, lfcthresh=2, sigthresh=0.05, main="Volcano Plot", legendpos="bottomright", labelsig=TRUE, textcx=1, ...) {
    tryCatch({
      with(res, plot(log2FoldChange, -log10(pvalue), pch=20, main=main, ...))
      with(subset(res, padj<sigthresh ), points(log2FoldChange, -log10(pvalue), pch=20, col="red", ...))
      with(subset(res, abs(log2FoldChange)>lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="orange", ...))
      with(subset(res, padj<sigthresh & abs(log2FoldChange)>lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="green", ...))
      x <-subset(res, padj<sigthresh & abs(log2FoldChange)>lfcthresh)
      write.csv(x,file = paste(variable_condition_1,"vs",variable_condition_2,"_RESULTS_VOLCANO.csv"))
      return (x)
    },error=function(error_message){
    })
  }
  
  #Calls the function
  #this one is special, the function will be called regardless as it is used to produce the necessary list (X) which gives significant genes
  #However, depending on what the user wants, the function will only produce a list, or it will produce a list and create the corresponding volcano plot
  if (do_Volcano_Plot==TRUE){
    png(paste("diffexpr_volcanoplot_",variable_condition_1,"vs",variable_condition_2,"_No_Text.png"), 1200, 1000, pointsize=20)
    pre_processed_file_short<-suppressWarnings(volcanoplot_no_text(resdata, lfcthresh=1, sigthresh=0.05, textcx=.8, xlim=c(-5, 5)))
    invisible(dev.off())
  }else{
    pre_processed_file_short<-suppressWarnings(volcanoplot_no_text(resdata, lfcthresh=1, sigthresh=0.05, textcx=.8, xlim=c(-5, 5)))
  }
  
  
  ###################################################################################################################################
  #Creates a file that is used to generate a list of the top 60 genes, 30 most up-regulated, and 30 most under-regulated
  
  file_for_sig_genes <-  read.csv(file = paste(variable_condition_1,"vs",variable_condition_2,"_RESULTS_VOLCANO.csv"),check.names=FALSE)
  
  resUpReg= file_for_sig_genes[which(file_for_sig_genes$log2FoldChange<0),] #Get the upregulated genes
  resDownReg= file_for_sig_genes[which(file_for_sig_genes$log2FoldChange>0),]#Get the downregulated
  Upreg <- head(resUpReg[order(resUpReg$padj),],30) #order by P adjusted and print top 30*
  rownames(Upreg)=Upreg$Gene
  Downreg <- head(resDownReg[order(resDownReg$padj),],30)
  rownames(Downreg)=Downreg$Gene
  gene_list <- rownames(Upreg)
  gene_list <- append(gene_list,rownames(Downreg))
  write.table(gene_list,file=paste("gene_list_",variable_condition_1,"vs",variable_condition_2,"_Most_Significant.txt"))
  ###################################################################################################################################
  
  
  return (pre_processed_file_short)
}


#Call the functions
DESeq2_file_short <- DESeq2_pre_processing(File_1, File_2, variable_condition_1, variable_condition_2, do_MA_plot, do_Volcano_Plot)

DESeq2_file_short <- DESeq2_file_short[,1:7]
rownames(DESeq2_file_short) <- DESeq2_file_short[,1]
DESeq2_file_short <- DESeq2_file_short[,-1]
