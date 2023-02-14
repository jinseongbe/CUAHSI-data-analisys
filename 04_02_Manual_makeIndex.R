
# Add value data index

setwd("/Users/jinsungpark/Desktop/WaterML_Code/Summary_Result")
getwd()

library(stringr)
library(WaterML)
library(dplyr)

df <- read.csv("/Users/jinsungpark/Desktop/WaterML_Code/Variable_lst.csv")
View(df)

for (i in 1:nrow(df))
{
    if(!(is.na(df$IndexNum[i]))) { next }
    
    print(sprintf("%d/%d : %s, %s", i, nrow(df), df$Var_lst[i], df$IndexNum[i]))

    loop_condition = TRUE

    while(loop_condition)
    {
        index_type <-readline('chemical(c) or physical(p)? : ')

        if (index_type == "c" | index_type == "p")
        {
            loop_condition = FALSE
        }else
        {
            loop_condition = TRUE
        }
    }


    if (index_type == "c")
    {
        df$IndexNum[i] <- "chemical"
        print(sprintf("%s index added chemical, remain %d index", df$Var_lst[i], sum(is.na(df$IndexNum))))
    }

    if (index_type == "p")
    {
        df$IndexNum[i] <- "physical"
        print(sprintf("%s index added chemical, remain %d index", df$Var_lst[i], sum(is.na(df$IndexNum))))
    }
    
}

write.csv(df, "/Users/jinsungpark/Desktop/WaterML_Code/Variable_lst.csv", row.names=FALSE)








