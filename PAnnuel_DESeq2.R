if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("DESeq2")
BiocManager::install("apeglm")

library( "DESeq2" )
library(ggplot2)
library(DESeq2)
library(apeglm)



count_File_Q1 <- read.csv(file = "C:\\Users\\yohan\\Desktop\\Analyse_Bioinformatique\\TCGA_GBM\\True_COUNTS_NORMAL_AGE_SUBSET_10_50_Formatted_CSV_VERSION.csv",check.names=FALSE)
count_File_Q4 <-read.csv(file = "C:\\Users\\yohan\\Desktop\\Analyse_Bioinformatique\\TCGA_GBM\\True_COUNTS_NORMAL_AGE_SUBSET_69_89_Formatted_CSV_VERSION.csv",check.names=FALSE)


#Keeping as a precaution
count_File_Q1<-count_File_Q1[complete.cases(count_File_Q1),]
count_File_Q1<-count_File_Q1[!(count_File_Q1$Gene=="0.0"),]

count_File_Q4<-count_File_Q4[complete.cases(count_File_Q4),]
count_File_Q4<-count_File_Q4[!(count_File_Q4$Gene=="0.0"),]



#Directory Workplace!
setwd("C:\\Users\\yohan\\Desktop\\Analyse_Bioinformatique\\TCGA_GBM\\R_Work_Folder")


numQ1 <- ncol(count_File_Q1)-1

numQ4 <- ncol(count_File_Q4)-1


#Remove first column of Quartile that is being added
#These are the counts that are will be merged to another
new_count_Q1<- count_File_Q1[,-1]

new_count_Q4<- count_File_Q4[,-1]


#Create 'merged' Quartiles
merged_quartiles <- cbind(count_File_Q1,new_count_Q4)
rownames(merged_quartiles)=merged_quartiles[,1]
merged_quartiles <- merged_quartiles[,-1]


#converts it to numeric
merged_quartiles <- data.frame(sapply(merged_quartiles, as.numeric),check.names=F, row.names = rownames(merged_quartiles))


####################################################################################

#Creates the matrices
merged_quartiles <- as.matrix(merged_quartiles)


#Assign Condition Q1 to all of the columns/samples/patients
condition <- factor(c(rep("Young", numQ1),rep("Old",numQ4)))


####################################################################################
#Create a coldata frame and instantiate the DESeqDataSet

(col_data <- data.frame(row.names=colnames(merged_quartiles),condition))
dds <- DESeqDataSetFromMatrix(countData=merged_quartiles, colData=col_data, design=~condition)

#Set up for the heat map
###################################################################################################################################

dds = estimateSizeFactors(dds)

#Run the DESeq pipeline, this takes a while
dds <- DESeq(dds)

###################################################################################################################################

dir.create(file.path(maindir, "Normal_Results"))
setwd(file.path(maindir, "Normal_Results"))
res <- results(dds)

#Could be used if they want to reduce?
#res <- lfcShrink(dds, coef=2, type="apeglm")




res <- res[order(res$padj), ]
## Merge with normalized count data
resdata <- merge(as.data.frame(res), as.data.frame(counts(dds, normalized=TRUE)), by="row.names", sort=FALSE)
names(resdata)[1] <- "Gene"
head(resdata)
## Write results
write.csv(resdata, file="diffexpr_results_Insert_Name.csv")

## MA plot with with text
###################################################################################################################################
maplot <- function (res, thresh=0.05, labelsig=TRUE, textcx=1, ...) {
  with(res, plot(baseMean, log2FoldChange, pch=20, cex=.5, log="x", ...))
  with(subset(res, padj<thresh), points(baseMean, log2FoldChange, col="red", pch=20, cex=1.5))
  if (labelsig) {
    require(calibrate)
    with(subset(res, padj<thresh), textxy(baseMean, log2FoldChange, labs=Gene, cex=textcx, col=2))
  }
}
png("diffexpr_maplot_Insert_Name_text.png", 7500, 7000, pointsize=15)
maplot(resdata, main="MA Plot")
dev.off()

## MA plot with no text
###################################################################################################################################
maplot <- function (res, thresh=0.05, labelsig=TRUE, textcx=1, ...) {
  with(res, plot(baseMean, log2FoldChange, pch=20, cex=.5, log="x", ...))
  with(subset(res, padj<thresh), points(baseMean, log2FoldChange, col="red", pch=20, cex=1.5))
  if (labelsig) {
    require(calibrate)
    with(subset(res, padj<thresh))#, textxy(baseMean, log2FoldChange, labs=Gene, cex=textcx, col=2))
  }
}
png("diffexpr_maplot_GBM_Insert_Name_text.png", 2500, 2000, pointsize=15)
maplot(resdata, main="MA Plot")
dev.off()


## Volcano plot with "significant" genes in green with text
###################################################################################################################################
volcanoplot <- function (res, lfcthresh=2, sigthresh=0.05, main="Volcano Plot", legendpos="bottomright", labelsig=TRUE, textcx=1, ...) {
  with(res, plot(log2FoldChange, -log10(pvalue), pch=20, main=main, ...))
  with(subset(res, padj<sigthresh ), points(log2FoldChange, -log10(pvalue), pch=20, col="red", ...))
  with(subset(res, abs(log2FoldChange)>lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="orange", ...))
  with(subset(res, padj<sigthresh & abs(log2FoldChange)>lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="green", ...))
  if (labelsig) {
    require(calibrate)
    with(subset(res, padj<sigthresh & abs(log2FoldChange)>lfcthresh), textxy(log2FoldChange, -log10(pvalue), labs=Gene, cex=textcx, ...))
  }
  legend(legendpos, xjust=1, yjust=1, legend=c(paste("FDR<",sigthresh,sep=""), paste("|LogFC|>",lfcthresh,sep=""), "both"), pch=20, col=c("red","orange","green"))
}
png("diffexpr_volcanoplot_Insert_Name_Text.png", 5200, 5000, pointsize=20)
volcanoplot(resdata, lfcthresh=1, sigthresh=0.05, textcx=.8, xlim=c(-5, 5))
dev.off()

## Volcano plot with "significant" genes in green with no text active_reformed
###################################################################################################################################
volcanoplot <- function (res, lfcthresh=2, sigthresh=0.05, main="Volcano Plot", legendpos="bottomright", labelsig=TRUE, textcx=1, ...) {
  with(res, plot(log2FoldChange, -log10(pvalue), pch=20, main=main, ...))
  with(subset(res, padj<sigthresh ), points(log2FoldChange, -log10(pvalue), pch=20, col="red", ...))
  with(subset(res, abs(log2FoldChange)>lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="orange", ...))
  with(subset(res, padj<sigthresh & abs(log2FoldChange)>lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="green", ...))
  x <-subset(res, padj<sigthresh & abs(log2FoldChange)>lfcthresh)
  write.csv(x,file = "Insert_Name_RESULTS_VOLCANO.csv")
  if (labelsig) {
    require(calibrate)
    with(subset(res, padj<sigthresh & abs(log2FoldChange)>lfcthresh))#, textxy(log2FoldChange, -log10(pvalue), labs=Gene, cex=textcx, ...))
  }
  legend(legendpos, xjust=1, yjust=1, legend=c(paste("FDR<",sigthresh,sep=""), paste("|LogFC|>",lfcthresh,sep=""), "both"), pch=20, col=c("red","orange","green"))
}
png("diffexpr_volcanoplot_Insert_Name_No_Text.png", 1200, 1000, pointsize=20)
volcanoplot(resdata, lfcthresh=1, sigthresh=0.05, textcx=.8, xlim=c(-5, 5))
dev.off()

###################################################################################################################################
#FOR THE HEAT MAP

file_heat_map <-  read.csv(file = "Insert_Name_RESULTS_VOLCANO.csv",check.names=FALSE)

resUpReg= file_heat_map[which(file_heat_map$log2FoldChange<0),] #Get the upregulated genes
resDownReg= file_heat_map[which(file_heat_map$log2FoldChange>0),]#Get the downregulated
Upreg <- head(resUpReg[order(resUpReg$padj),],30) #order by P adjusted and print top 30*
rownames(Upreg)=Upreg$Gene
Downreg <- head(resDownReg[order(resDownReg$padj),],30)
rownames(Downreg)=Downreg$Gene
gene_list <- rownames(Upreg)
gene_list <- append(gene_list,rownames(Downreg))
View(gene_list)
write.table(gene_list,file="gene_list_Insert_Name_Most_Significant.txt")

###################################################################################################################################

