library(WaterML)
library(readxl)
library(writexl)

options(scipen=999)

setwd("/Users/jinsungpark/Desktop/R/Water_Lab/OxygenData_siteInfo_add")
getwd()

df <- read_xlsx("df_collect.xlsx")

file_dir <- c("/Users/jinsungpark/Desktop/R/Water_Lab/OxygenData_siteInfo_add")
file_lst <- list.files(file_dir)
NumberOfFile <- (length(file_lst) - 1)

for (i in 1:NumberOfFile)
{
    file_name <- file_lst[i]
    file_name
    
    if (nchar(file_name) == 12)
    {
        file_num <- strtoi(substr(file_name,6,8))
    } else if (nchar(file_name) == 13)
    {
        file_num <- strtoi(substr(file_name,6,9))
    } else if (nchar(file_name) == 14)
    {
        file_num <- strtoi(substr(file_name,6,10))
    } else
    {
        print("########## Error ###########")
    }
    
    # Data <- read.csv(file_name)
    
    URL <- df$url[file_num]
    FullSiteCode <- df$FullSiteCode[file_num]
    
    Info <- GetSiteInfo(URL, siteCode = FullSiteCode)
    
    DataExistRate_lst <- c()
    for (k in 1:nrow(Info))
    {
        ValueCnt            <- as.integer(Info$valueCount[k])
        timeSupport         <- as.integer(Info$TimeSupport[k])
        timeUnit            <- Info$TimeUnitAbbreviation[k]
        
        beginTime           <- Info$beginDateTime[k]
        endTime             <- Info$endDateTime[k]
        beginTimeUTC        <- Info$beginDateTimeUTC[k]
        endTimeUTC          <- Info$endDateTimeUTC[k]
        
        if (timeSupport == 0)
        {
            timeSupport <- 1
        }
        
        if (timeUnit == "min")
        { existDataTerm <- ValueCnt * timeSupport * (1 / 60) * (1 / 24)
        } else if (timeUnit == "s")
        { existDataTerm <- ValueCnt * timeSupport * (1 / 3600) * (1 / 24)
        } else if (timeUnit == "d")
        { existDataTerm <- ValueCnt * timeSupport
        } else if (timeUnit == "hr")
        { existDataTerm <- ValueCnt * timeSupport * (1 / 24)
        } else if (timeUnit == "week")
        { existDataTerm <- ValueCnt * timeSupport * 7
        } else if (timeUnit == "month")
        { existDataTerm <- ValueCnt * timeSupport * 30
        } else
        {
            print("Error : timeSupport is not exist")
            View(Info)
            error
        }
        
        if (endTime != beginTime)
        {
            term <- as.double(endTime - beginTime)
        }else if (endTimeUTC != beginTimeUTC)
        {
            term <- as.double(endTimeUTC - beginTimeUTC)
        }else
        {
            print("Error : beginTime = endTime")
            DataExistRate <- NA
            DataExistRate_lst <- append(DataExistRate_lst, DataExistRate)
            print(sprintf("########## Site : %d/%d, Variable : %d/%d is Same Time Error ##########", i, NumberOfFile, k, nrow(Info)))
            next
        }
        
        DataExistRate <- (existDataTerm / term) * 100
        DataExistRate_lst <- append(DataExistRate_lst, DataExistRate)
        # cbind(Info, DataExistRate_lst)
        print(sprintf("########## Site : %d/%d, Variable : %d/%d ##########", i, NumberOfFile, k, nrow(Info)))
    }
    
    Info_summary    <- Info[c("FullVariableCode", "VariableName", "DataType", "TimeUnitName", "TimeSupport", "valueCount", "beginDateTime", "endDateTime", "beginDateTimeUTC", "endDateTimeUTC")]
    Info_summary <- cbind(Info_summary, DataExistRate_lst)
    # Info_graph <- Info[c("VariableName", "DataType", "TimeUnitName", "beginDateTime", "endDateTime")]
    address_summary <- paste0("/Users/jinsungpark/Desktop/R/Water_Lab/OxygenData_siteInfo_Summary/Data_", file_num, "_SiteInfoSummary.csv")
    # write.csv(Info_detail, address_detail)
    write.csv(Info_summary, address_summary)
}

print("#################### Done! ####################")









# DataExistRate_lst <- c()
# for (k in 1:nrow(Info))
# {
#     ValueCnt            <- as.integer(Info$valueCount[k])
#     timeSupport         <- as.integer(Info$TimeSupport[k])
#     timeUnit            <- Info$TimeUnitAbbreviation[k]
#     
#     beginTime           <- Info$beginDateTime[k]
#     endTime             <- Info$endDateTime[k]
#     beginTimeUTC        <- Info$beginDateTimeUTC[k]
#     endTimeUTC          <- Info$endDateTimeUTC[k]
#     
#     if (timeSupport == 0)
#     {
#         timeSupport <- 1
#     }
#     
#     if (timeUnit == "min")
#     {
#         existDataTerm <- ValueCnt * timeSupport * (1 / 60) * (1 / 24)
#         
#     }else if (timeUnit == "s")
#     {
#         existDataTerm <- ValueCnt * timeSupport * (1 / 3600) * (1 / 24)
#     }else
#     {
#         print("Error : timeSupport is not exist")
#     }
#     
#     if (endTime != beginTime)
#     {
#         term <- as.double(endTime - beginTime)
#     }else if (endTimeUTC != beginTimeUTC)
#     {
#         term <- as.double(endTimeUTC - beginTimeUTC)
#     }else
#     {
#         print("Error : beginTime = endTime")
#     }
#     
#     DataExistRate <- (existDataTerm / term) * 100
#     print(DataExistRate)
#     DataExistRate_lst <- append(DataExistRate_lst, DataExistRate)
#     # cbind(Info, DataExistRate_lst)
# }
# 
# View(DataExistRate_lst)













