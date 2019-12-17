if(!require(RMySQL)){
  install.packages("RMySQL")
  library(RMySQL)
}




Volcano_res <- read.csv(file = "C:\\Users\\yohan\\Desktop\\Projet-INSERM\\R_Work_folder\\All genes from Volcano NPY.csv",check.names=FALSE)
Volcano_res<-Volcano_res[,-1]
rownames(Volcano_res)=Volcano_res[,1]
Volcano_res<-Volcano_res[,-1]
Volcano_res<-Volcano_res[,1:6]

#Got my sig_genes
#Extract rownames into a vector

#Function starts here


sig_gene_list<-rownames(Volcano_res)

DB <- dbConnect(RMySQL::MySQL(), user="root", host="localhost",
                password="UpsilonLambda94", dbname="non_canonic")

#Initialize dataframes
non_canonic_results <- data.frame(
                  Gene_Symbol=character(),
                  NC_Pathway=character(), 
                  NC_Loc=character(), 
                  num_ncan=integer(),
                  stringsAsFactors=FALSE)

canonic_results <- data.frame(
                  Gene_Symbol=character(),
                  Gene_Name = character(),
                  NC_Pathway=character(), 
                  NC_Loc=character(), 
                  num_ncan=integer(),
                  stringsAsFactors=FALSE) 

ref_results <- data.frame(
                  Gene_Symbol=character(),
                  ref = character(),
                  stringsAsFactors=FALSE) 


for (i in 1:length(sig_gene_list)){
  if (nrow(dbGetQuery(DB, paste0("SELECT * FROM Canonic WHERE Gene_Symbol = '" , sig_gene_list[i]  ,"';")))>0){
    non_canonic_results <- rbind(non_canonic_results,dbGetQuery(DB, paste0("SELECT Gene_Symbol, Gene_Name, NC_Pathway as Non_Canonic_Pathway, NC_Loc as Non_Canonic_Location FROM ncanonic join canonic using (Gene_Symbol) WHERE Gene_Symbol = '" , sig_gene_list[i]  ,"';")))
    canonic_results <- rbind(canonic_results,dbGetQuery(DB, paste0("SELECT Gene_Symbol, Gene_Name, C_Pathway as Canonical_Pathway, C_Loc as Canonical_Location FROM Canonic WHERE Gene_Symbol = '" , sig_gene_list[i]  ,"';")))
    ref_results <- rbind(ref_results,dbGetQuery(DB, paste0("SELECT Gene_Symbol, Gene_Name, ref as `References` FROM `references` join Canonic using (Gene_Symbol) WHERE Gene_Symbol = '" , sig_gene_list[i]  ,"';")))
  }
  
}

#Store each dataframe in a list for return

dbDisconnect(DB)

my_results_list <- list("ncan"=non_canonic_results,"can"=canonic_results,"refs"=ref_results)


write.table(my_results_list[["ncan"]],file = "test_non_canonic_results.txt",row.names = FALSE)

write.table(my_results_list[["can"]],file = "test_canonic_results.txt",row.names = FALSE)

write.table(my_results_list[["refs"]],file = "test_references.txt",row.names = FALSE)

getwd()
#write.csv(result_table,file="test_write_result.csv")
