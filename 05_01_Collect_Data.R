# DO,Oxygen Collect

setwd("/Users/jinsungpark/Desktop/WaterML_code/Summary_Result")
getwd()

library(dplyr)
library(writexl)

VarName_lst <- read.csv("VariableName_lst.csv")

## 다운받기 원하는 변수 이름을 추가해서 해당하는 변수의 정보단 df_collect.xlsx파일에 저장하여 일괄다운 받음
## 아래에서 변수 개수만큼 수정해줘야하는 부분 있음!
keyWord <- c("Dissolved oxygen, water, unfiltered, milligrams per liter",
            "Dissolved oxygen, water, unfiltered, percent of saturation",
            "Oxygen",
            "Oxygen-18",
            "Oxygen-18, stable isotope ratio delta",
            "Oxygen, dissolved",
            "Oxygen, Dissolved")

df_collect <- read.csv("df_base.csv")
df_collect = subset(df_collect, select = -c(X))
FailToDownload_URL <- read.csv("FailToDownload_URL.csv")
totalUrl <- nrow(services)
collectCnt <- 0

for (url_num in 1:totalUrl)
{
    isThisUrlFail = FALSE
    
    for (failUrl in FailToDownload_URL$downUrlFail_num)
    {
        if (url_num == failUrl)
        {
            isThisUrlFail = TRUE
        }
    }   
    
    if (isThisUrlFail)
    {
        next
    }
    
    if(url_num < 10)
    {
        address <- paste0("Summary_UrlNum_0",url_num,".csv")
    } else
    {
        address <- paste0("Summary_UrlNum_",url_num,".csv")
    }
    
    df_summary <- read.csv(address)
    df_summary = subset(df_summary, select = -c(X))
    
    for (i in 1:nrow(df_summary))
    {
        print(sprintf("##### URL : %d/%d, Site : %d/%d, Collected Data : %d #####",totalUrl ,url_num, i, nrow(df_summary), collectCnt))
        var_name <- df_summary$VariableName[i]
        is.na(var_name)
        
        if (length(var_name) == 0)
        {
            next   
        }else if (is.na(var_name))
        {
            next     ## 아래 부분을 변수 개수만큼 keyword값을 수정해줘야함!
        } else if (var_name == keyWord[1] | var_name == keyWord[2] | var_name == keyWord[3] | var_name == keyWord[4] | var_name == keyWord[5] | var_name == keyWord[6] | var_name == keyWord[7])
        {
            df_collect$SiteName[collectCnt]          <- as.character(df_summary$SiteName[i])
            df_collect$url[collectCnt]               <- as.character(df_summary$url[i])
            df_collect$FullSiteCode[collectCnt]      <- as.character(df_summary$FullSiteCode[i])
            df_collect$FullVariableCode[collectCnt]  <- as.character(df_summary$FullVariableCode[i])
            df_collect$Organization[collectCnt]      <- as.character(df_summary$Organization[i])
            df_collect$Latitude[collectCnt]          <- df_summary$Latitude[i]
            df_collect$Longitude[collectCnt]         <- df_summary$Longitude[i]
            df_collect$Index[collectCnt]             <- df_summary$Index[i] 
            df_collect$VariableName[collectCnt]      <- as.character(df_summary$VariableName[i])
            df_collect$ValueType[collectCnt]         <- as.character(df_summary$ValueType[i])
            df_collect$DataType[collectCnt]          <- as.character(df_summary$DataType[i])
            df_collect$GeneralCategory[collectCnt]   <- as.character(df_summary$GeneralCategory[i])
            df_collect$SampleMedium[collectCnt]      <- as.character(df_summary$SampleMedium[i])
            df_collect$UnitName[collectCnt]          <- as.character(df_summary$UnitName[i])
            df_collect$UnitType[collectCnt]          <- as.character(df_summary$UnitType[i])
            df_collect$TimeUnitName[collectCnt]      <- as.character(df_summary$TimeUnitName[i])
            df_collect$TimeSupport[collectCnt]       <- df_summary$TimeSupport[i]
            df_collect$beginDateTimeUTC[collectCnt]  <- as.character(df_summary$beginDateTimeUTC[i])
            df_collect$endDateTimeUTC[collectCnt]    <- as.character(df_summary$endDateTimeUTC[i])
            df_collect$mean[collectCnt]              <- df_summary$mean[i]
            df_collect$s.dev[collectCnt]             <- df_summary$s.dev[i]
            df_collect$minimum[collectCnt]           <- df_summary$minimum[i]
            df_collect$maximum[collectCnt]           <- df_summary$maximum[i]
            df_collect$length[collectCnt]            <- df_summary$length[i]
            df_collect$Comment[collectCnt]           <- as.character(df_summary$Comment[i])
            
            collectCnt <- collectCnt + 1
            
            df <- data.frame(matrix(nrow = 1, ncol = ncol(df_collect)))
            names(df) <- names(df_collect)
            df_collect <- rbind(df_collect, df)
        }else
        {
            next
        }
    }
}

View(df_collect)
write_xlsx(df_collect, path = "df_collect.xlsx")
