library(tcltk)
# We need libraries to read and parse URL
library(RCurl)
#test git
# install.packages("tidyverse")
library(tidyverse)
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

# Read in file with Gene Symbols
directory <- tk_choose.dir()
setwd(directory)
infile <- file.choose()
data <- read.csv(infile, header = TRUE, sep=",")

#Check this
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
dir.create(file.path(paste(directory, "/Resultats", sep="")))
setwd(file.path(paste(directory, "/Resultats", sep="")))
write.table(newdata, file = "convert.txt", row.names=FALSE, col.names=TRUE,sep=",")
write.table(missing, file = "missing.txt", row.names=FALSE, col.names=TRUE,sep=",")
