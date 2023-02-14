library(WaterML)
library(readxl)
library(writexl)
library(ggplot2)
library(gcookbook)
library(plyr)
library(reshape2)

setwd("/Users/jinsungpark/Desktop/R/Water_Lab/OxygenData_siteInfo_Summary")
getwd()

file_dir <- c("/Users/jinsungpark/Desktop/R/Water_Lab/OxygenData_siteInfo_Summary")
file_lst <- list.files(file_dir)
length(file_lst)


for (i in 1:length(file_lst))
{
    file_name <- file_lst[i]
    file_name
    
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
    
    
    Time        <- c()
    Variable    <- c()
    TimeUnit    <- c()
    VarID       <- c()
    
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
        TimeUnit    <- append(TimeUnit, as.character(SiteInfo$TimeUnitName[k]))
        Time        <- append(Time, as.POSIXct(beginDay_))
        VarID       <- append(VarID, k)
        
        Variable    <- append(Variable, as.character(SiteInfo$VariableName[k]))
        TimeUnit    <- append(TimeUnit, as.character(SiteInfo$TimeUnitName[k]))
        Time        <- append(Time, as.POSIXct(endDay_))
        VarID       <- append(VarID, k)
    }
    
    if (length(Variable) == 0)
    {
        next
    }
    
    df <- data.frame(Variable, TimeUnit, Time, VarID)
    
    ggplot(data = df) +
        geom_line(aes(Time, Variable, group=VarID, color=TimeUnit), size = 3, lineend='round', size = 3) +
        scale_x_datetime(limits=c(as.POSIXct('2000-01-01 00:00:00'), as.POSIXct('2020-12-31 00:00:00')))
    
    address <- paste0("Data_",file_num,"_graph.jpg")
    ggsave(address)
    
}




