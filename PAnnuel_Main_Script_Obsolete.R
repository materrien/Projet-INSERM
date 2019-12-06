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

#Library for gene symbol conversion to hsa
library(tcltk)
library(RCurl)
library(tidyverse)

#Basically a library call for ROntoTools script
require(graph)
require(ROntoTools)


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
  
  
  return (pre_processed_file_full)
}



#Create the function for gene symbol conversion to HSA
Gene_Symbol_Conversion <- function(DESeq2_file)
{
  options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

  data <- DESeq2_file
  newdata <- data[, c("Gene", "log2FoldChange", "pvalue", "padj")]
  
  names(newdata) <- c("Id", "logFC", "P.Value", "adj.P.Val")
  
  # For each gene, look up the hsa identifiers
  hsa = c()
  for (g in 1:length(newdata[[1]])) {
    query = paste("http://rest.kegg.jp/find/hsa/",newdata$Id[g],sep="")
    result = getURL(query)
    if (result=="\n"){
      hsa = c(hsa,result)
    }
    my_list <- strsplit(result,"\n")
    #For loop checks each element of the list (each line of the website) and checks which line contains the desired gene symbol
    found_this_many = 0
    for (i in 1:length(my_list[[1]])){
      x <- str_replace(my_list[[1]][i],"\t"," ")
      check_comma_tab <- as.character(str_match (x,as.character(paste("\t",newdata$Id[g],",",sep=""))))
      check_comma_space <- as.character(str_match (x,as.character(paste(" ",newdata$Id[g],",",sep=""))))
      check_semicolon_tab <- as.character(str_match (x,as.character(paste("\t",newdata$Id[g],";",sep=""))))
      check_semicolon_space <- as.character(str_match (x,as.character(paste(" ",newdata$Id[g],";",sep=""))))
      if (is.na(check_comma_tab)==FALSE | is.na(check_comma_space)==FALSE | is.na(check_semicolon_tab)==FALSE | is.na(check_semicolon_space)==FALSE){
        if (found_this_many == 0){
          hsa = c(hsa, strsplit(x," ")[[1]][1]) 
        }
        found_this_many = found_this_many + 1
        if (found_this_many > 0){
          newdata<-rbind(newdata,newdata[g,])
          hsa = c(hsa, strsplit(x," ")[[1]][1])
        }
      }
    }
  }
  
  # Squash them together
  newdata <- cbind(newdata, hsa)
  names(newdata) <- c("Id", "logFC", "P.Value", "adj.P.Val", "entrez")
  
  
  # Filter out genes missing hsa ID
  missing <- newdata[-grep("hsa:", hsa), ]
  newdata <- newdata[grep("hsa:", hsa), ]
  
  
  
  #Drop the fifth table (Entrez ID) as it is empty in this dataframe
  missing<- missing[,-5]
  
  #Write to file
  directory <- getwd()
  dir.create(file.path(paste(directory, "/Resultats_Conversion", sep="")))
  setwd(file.path(paste(directory, "/Resultats_Conversion", sep="")))
  write.table(newdata, file = "convert.txt", row.names=FALSE, col.names=TRUE,sep=",")
  write.table(missing, file = "missing.txt", row.names=FALSE, col.names=TRUE,sep=",")
  
  
  return(newdata)
}


#Call the functions
DESeq2_file_full <- DESeq2_pre_processing(File_1, File_2, variable_condition_1, variable_condition_2, do_MA_plot, do_Volcano_Plot)


###################################################################################################################################
test_500 <- DESeq2_file_full
#Order by padj
test_500 <- test_500[order(test_500$padj),]
#Take top 500 rows (smallest padj)
test_500 <- test_500[1:500,]
#Remove unecessary columns
test_500<-test_500[,1:7]

###################################################################################################################################



#Testing with full
converted_file <- Gene_Symbol_Conversion(test_500)

###################################################################################################################################

#Creates the necessary rownames from the first column (gene IDs), it also makes them unique
rownames(converted_file) = make.names(converted_file[,1],unique = TRUE) 

#Remove the column that is now the dupliacte of rowname
converted_file <- converted_file[,-1]

#Sort by p-value and change name to 'top'
top_temp <- converted_file[order(converted_file$P.Value),]
#converted_file is now 'top'

###################################################################################################################################
#Start the function
###################################################################################################################################
ROntoTools_analysis <- function (use_fc,use_custom,weight_algo,file)
{
  
  kpg <- keggPathwayGraphs("hsa",verbose = TRUE)
  #kpg <- keggPathwayGraphs("hsa", updateCache = TRUE, verbose = TRUE)
  
  #These weights may need to be modified
  kpg <- setEdgeWeights(kpg, edgeTypeAttr = "subtype",edgeWeightByType = list(activation = 1, inhibition = -1,expression = 1, repression = -1),defaultWeight = 0)
  ###################################################################################################################################
  #Setting things up
  ###################################################################################################################################
  fc_temp <- top_temp$logFC[top_temp$adj.P.Val <= .01]
  names(fc_temp) <- top_temp$entrez[top_temp$adj.P.Val <= .01]
  
  pv_temp <- top_temp$P.Value[top_temp$adj.P.Val <= .01]
  names(pv_temp) <- top_temp$entrez[top_temp$adj.P.Val <= .01]
  
  pvAll_temp <- top_temp$P.Value
  names(pvAll_temp) <- top_temp$entrez
  
  fcAll_temp <- top_temp$logFC
  names(fcAll_temp) <- top_temp$entrez
  
  if (use_fc==TRUE){
    results_variable <-fc_temp
    print("fc TRUE")
  }else if(use_fc==FALSE){
    results_variable <-pv_temp
    print("fc FALSE")
  }else{
    print("Something went wrong in the time space continum")
  }

  #Stores the names of all the HSAs
  ref_temp <- as.character(top_temp$entrez)
  
  #About node weights
  #Node weights are used to encode for the significance of each gene, the term described as 'alpha' in (article: Proceedings of the International 
  #Conference on Machine Learning Applications (ICMLA),). There are two alternative formulas to incorporate gene significance.
  #these are alpha1MR and alphaMLG
  #To set the weight using these calculations, use the following function
  #Here we set the weights using the alphaMLG formula in accordance with the pv (selection of differentially expressed genes of significance 1% (via p-value))
  
  #This if will change the p values used depending on if the user wants to use a custom selection or not
  if (use_custom==TRUE & weight_algo=="1MR"){
    kpg <- setNodeWeights(kpg, weights = alpha1MR(pv_temp), defaultWeight = 1)
    print("custom true weight 1MR")
  }else if (use_custom==TRUE & weight_algo=="MLG"){
    kpg <- setNodeWeights(kpg, weights = alphaMLG(pv_temp), defaultWeight = 1)
    print("custom true weight MLG")
  }else if (use_custom==FALSE & weight_algo=="1MR"){
    kpg <- setNodeWeights(kpg, weights = alpha1MR(pvAll_temp), defaultWeight = 1)
    print("custom false weight 1MR")
  }else if (use_custom==FALSE & weight_algo=="MLG"){
    kpg <- setNodeWeights(kpg, weights = alphaMLG(pvAll_temp), defaultWeight = 1)
    print("custom false weight MLG")
  }else{
    print("Something went wrong in the time space continum")
  }

  
  #The pe function is called to perform the analysis, the accuracy is determined by nboot (bigger=more accurate)
  #nboot significes number of bootstrap iterations
  #This is basically the number of times a statistical test is performed with random sampling replacement, the more it is performed, the more accurate it gets
  #Note: verbose should be set to false in final product
  
  peRes_Temp <- pe(x = results_variable, graphs = kpg, ref = ref_temp, nboot = 200, verbose = TRUE)

  kpn <- keggPathwayNames("hsa")
  
  ###################################################################################################################################
  #Writing the tables
  ###################################################################################################################################
  write.table(Summary(peRes_Temp), file = "Summary_peRes_Temp.txt", row.names=TRUE, col.names=TRUE,sep=",")
  
  write.table(Summary(peRes_Temp, pathNames = kpn, totalAcc = FALSE, totalPert = FALSE, pAcc = FALSE, pORA = FALSE, comb.pv = NULL, order.by = "pPert"), file="better_summary_peRes_Temp.txt")
  
  print("after writes")
  ###################################################################################################################################
  #Creating the visual results
  ###################################################################################################################################
  
  list_of_paths <- as.data.frame(kpn)
  list_of_paths <- rownames(list_of_paths)
  
  dev.new()
  pdf("Plot_All_Results.pdf")
  #plot function de R pour tout les résultats, c'est très moche.
  plot(peRes_Temp)
  dev.off()

  print("after first plot")

  # dev.new()
  # pdf("Plot_pathway_level_statistics.pdf")
  # #This plot shows pathway level statistics
  # plot(peRes_Temp, c("pAcc", "pORA"), comb.pv.func = compute.normalInv, threshold = .01)
  # dev.off()

  maindir <- getwd()

  # dir.create(file.path(maindir, "Two_Way_Plots"))
  # setwd(file.path(maindir, "Two_Way_Plots"))
  
  
  #print(list_of_paths[1])
  #View(peRes_Temp)
  # print(typeof(peRes_Temp@pathways))
  #plot(peRes_Temp@pathways[["path:hsa05168"]], type = "two.way")
  for (i in 1:length(names(peRes_Temp@pathways))){
    if (is.null(peRes_Temp@pathways[[names(peRes_Temp@pathways[i])]])==FALSE){
      tryCatch({
        #print(paste("This one works",names(peRes_Temp@pathways[i])))
        print(names(peRes_Temp@pathways[i]))
        current_hsa <- names(peRes_Temp@pathways[i])
        hsa_temp <- strsplit(current_hsa,':')
        
        
        print(peRes_Temp@pathways[[current_hsa]]@Acc)
        
        check_for_hsa_zero=FALSE
        
        for (y in 1:length(peRes_Temp@pathways[[current_hsa]]@Acc)){
          if ((peRes_Temp@pathways[[current_hsa]]@Acc[[y]])!=0){
            check_for_hsa_zero=TRUE
          }
        }
        
        print(paste("over here",check_for_hsa_zero))
        #View(peRes_Temp)
        # dev.new()
        # pdf(paste("two_way_plot_",hsa_temp[[1]][2],".pdf"))
        # plot(peRes_Temp@pathways[[current_hsa]], type = "boot")
        # dev.off()
        print("should be after warnings")
        #This for loop ensures that all active devices are closed by the end of the initial loop, otherwise errors occur
        # for (z in dev.list()[1]:dev.list()[length(dev.list())]) {
        #   #dev.off()
        #   print("hi")
        # }
      },error=function(error){
        #Skip it
      })
    break
    }
  }
  print("at the very end")
}

#weight_algo must be 1MR or MLG
ROntoTools_analysis(FALSE,TRUE,"MLG",top_temp)


