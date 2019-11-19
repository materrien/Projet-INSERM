# We need libraries to read and parse URL
library(RCurl)
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

# Read in file with Gene Symbols
infile <- "C:/Users/marie/Downloads/GBM_RESULTS_VOLCANO"
data <- read.csv(paste(infile,".csv", sep = ""), header = TRUE, sep=",")

newdata <- data[, c("Gene", "log2FoldChange", "pvalue", "padj")]
names(newdata) <- c("Id", "logFC", "P.Value", "adj.P.Val")

# For each gene, look up the hsa identifiers
hsa = c()
for (g in 1:length(newdata[[1]])) {
  query = paste("http://rest.kegg.jp/find/hsa/",newdata$Id[g],sep="")
  result = getURL(query)
  hsa = c(hsa, strsplit(result,"\t")[[1]][1])
  }

# Squash them together
newdata <- cbind(newdata, hsa)
names(newdata) <- c("Id", "logFC", "P.Value", "adj.P.Val", "entrez")

# Filter out genes missing hsa ID
newdata <- newdata[grep("hsa:", hsa), ]
missing <- newdata[-grep("hsa:", hsa), ]

# Write to file
write.table(newdata, file = paste(infile,"_convert.txt", sep = ""), row.names=FALSE, col.names=TRUE,sep=",")
write.table(missing, file = paste(infile,"_missing.txt", sep = ""), row.names=FALSE, col.names=TRUE,sep=",")