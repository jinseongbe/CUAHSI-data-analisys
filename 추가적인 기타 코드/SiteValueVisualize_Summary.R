library(WaterML)
library(readxl)
library(writexl)
library(gcookbook)
library(plyr)
library(reshape2)

setwd("/Users/jinsungpark/Desktop/R/Water_Lab/OxygenData_siteInfo_Summary")
getwd()

file_dir <- c("/Users/jinsungpark/Desktop/R/Water_Lab/OxygenData_siteInfo_Summary")
file_lst <- list.files(file_dir)
length(file_lst)

Term        <- c()
Variable    <- c()

for (i in 1:length(file_lst))
{
    file_name <- file_lst[i]
    
    if (nchar(file_name) == 28)
    {
        file_num <- strtoi(substr(file_name,6,8))
    } else if (nchar(file_name) == 29)
    {
        file_num <- strtoi(substr(file_name,6,9))
    } else if (nchar(file_name) == 30)
    {
        file_num <- strtoi(substr(file_name,6,10))
    } else
    {
        print("########## Error ###########")
    }
    
    SiteInfo    <- read.csv(file_name)
    SiteInfo    <- SiteInfo[-which(duplicated(as.character(SiteInfo$VariableName))),]
    SiteInfo

    for (k in 1:nrow(SiteInfo))
    {
        if (SiteInfo$DataExistRate_lst[k] <= 80 | is.na(SiteInfo$DataExistRate_lst[k]) != 0)
        {
            next
        }
        
        if (SiteInfo$beginDateTimeUTC[k] != SiteInfo$endDateTimeUTC[k])
        {
            beginDay_    <- SiteInfo$beginDateTimeUTC[k]
            endDay_      <- SiteInfo$endDateTimeUTC[k]
            
        }else if (SiteInfo$beginDateTime[k] != SiteInfo$endDateTime[k])
        {
            beginDay_    <- SiteInfo$beginDateTime[k]
            endDay_      <- SiteInfo$endDateTime[k]
        }else
        {
            print("Error : beginTime = endTime")
            error
        }
        
        Variable    <- append(Variable, as.character(SiteInfo$VariableName[k]))
        Term        <- append(Term, as.double(as.POSIXct(endDay_) - as.POSIXct(beginDay_)))
        
    }
    
    if (length(Variable) == 0)
    {
        next
    }
    
    df <- data.frame(Variable, Term)
}
View(df)

tempVar_lst <- c()
tempDay_lst <- c()

Variable            <- c()
Number_of_Variable  <- c()
Minimum_Term        <- c()
Maximum_Term        <- c()
Average_Term        <- c()


for (j in 1:length(levels(df$Variable)))
{
    for (l in 1:nrow(df))
    {
        print(sprintf("##### Variable : %d/%d, VarNum %d/%d", j, length(levels(df$Variable)), l, nrow(df)))
        if (df$Variable[l] == levels(df$Variable)[j])
        {
            tempVar_lst <- append(tempVar_lst, as.character(df$Variable[l]))
            tempDay_lst <- append(tempDay_lst, df$Term[l])
        }
    }

    if (j == 23 | j == 24 | j == 34 | j == 38 | j == 41 |  j == 46)
    {
        next
    }else
    {
        Variable            <- append(Variable, as.character(levels(df$Variable)[j]))
        Number_of_Variable  <- append(Number_of_Variable, length(tempVar_lst))
        Minimum_Term        <- append(Minimum_Term, min(tempDay_lst))
        Maximum_Term        <- append(Maximum_Term, max(tempDay_lst))
        Average_Term        <- append(Average_Term, mean(tempDay_lst))

        tempVar_lst <- c()
        tempDay_lst <- c()
    }
}

summaryGraph2 <- data.frame(Variable, Number_of_Variable, Minimum_Term, Maximum_Term, Average_Term)
View(summaryGraph2)

# write_xlsx(summaryGraph2, "SummaryGraph.xlsx")




