if(!require(RMySQL)){
  install.packages("RMySQL")
  library(RMySQL)
}

DB <- dbConnect(RMySQL::MySQL(), user="root", host="localhost",
                password="UpsilonLambda94", dbname="non_canonic")

test <- "Mitochondria"
gn <- "HK2"

result_table <- dbGetQuery(DB, paste0("SELECT * FROM Canonic join NCanonic using(Gene_Symbol) WHERE Gene_Symbol = '" , gn  ,"';"))

ref_table <- dbGetQuery(DB, paste0("SELECT * FROM `references` WHERE Gene_Symbol = '" , gn  ,"';"))



getwd()
#write.csv(result_table,file="test_write_result.csv")
