## df_collect파일에 모아눈 변수들의 summary데이터를 토대로 일괄 다운벋는 코드

library(WaterML)
library(readxl)
library(writexl)
library(plyr)

setwd("/Users/jinsungpark/Desktop/R/Water_Lab/Summary_Result")
getwd()

df <- read_xlsx("df_collect.xlsx")
df <- arrange(df, desc(dataLength))
# View(df)
failCnt <- 0
SuccessCnt <- 0

# for ( i in 1:nrow(df))
for ( i in 1:nrow(df))
{
    skip <- FALSE
    
    print(sprintf("########## %d/%d, Downlod Succeeded : %d, Download Failed : %d", i, nrow(df), SuccessCnt, failCnt))
    url                 <- df$url[i]
    FullSiteCode        <- df$FullSiteCode[i]
    FullVariableCode    <- df$FullVariableCode[i]
    tryCatch(
        {
            Data <- GetValues(url, siteCode =  FullSiteCode, variableCode = FullVariableCode)
            
            if (length(Data) == 0 | nrow(Data) == 0)
            {
                errorCreate
            }
            
            address <- paste0("/Users/jinsungpark/Desktop/Oxygen/Data_",i,".csv")

            write.csv(Data, address)
            SuccessCnt <- SuccessCnt + 1
        },
        error = function(e)
        {
            failCnt <<- failCnt + 1
            skip <<- TRUE
            
        })
    
    if(skip)
    {
        next
    }
}

print(sprintf("######### Download fail : %, success : % #########",failCnt, SuccessCnt ))