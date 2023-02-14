# Add value data information
# 01_MakeSummaryFile.R 에서 만든 Summary파일에 데이터 value 값을 추가 하는 코드(0을 초기화 해놓았었음)

setwd("/Users/jinsungpark/Desktop/WaterML_Code/Summary_Result")
getwd()

library(WaterML)

services <- read.csv("/Users/jinsungpark/Desktop/WaterML_Code/services_20201105.csv")
FailToDownload_Site <- read.csv("FailToDownload_Site.csv")
FailToDownload_URL <- read.csv("FailToDownload_URL.csv")

changeCnt <- 0

for (url_num in 52:nrow(services)) # 11, 33, 39, 40, 44,46, 51, 건너뜀(데이터양이 너무 많아서 다 받가애는 시간이 너무 오래걸림)
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
    }else
    {
        address <- paste0("Summary_UrlNum_",url_num,".csv")
    }

    df_summary <- read.csv(address)

    for (i in 1:nrow(df_summary))
    {
        url                 <- as.character(df_summary$url[i])
        FullSiteCode        <- as.character(df_summary$FullSiteCode[i])
        FullVariableCode    <- as.character(df_summary$FullVariableCode[i])

        tryCatch(
            {
                if (df_summary$mean[i] == 0)
                {
                    print(sprintf("################## Url : %d, Update %d/%d ##################", url_num, i, nrow(df_summary)))
                    Data <- GetValues(url, siteCode =  FullSiteCode, variableCode = FullVariableCode)
                    Data$DataValue[is.infinite(Data$DataValue)] <- NA
                    Data <- Data[ complete.cases(Data[, c("DataValue")]),]

                    df_summary$mean[i]      <- mean(Data$DataValue, na.rm = TRUE)
                    df_summary$s.dev[i]     <- sd(Data$DataValue, na.rm = TRUE)
                    df_summary$minimum[i]   <- min(Data$DataValue, na.rm = TRUE)
                    df_summary$maximum[i]   <- max(Data$DataValue, na.rm = TRUE)
                    df_summary$length[i]    <- length(Data$DataValue)
                    changeCnt <- changeCnt + 1
                }else
                {
                    print("already data exist")
                    next
                }
            },
            error = function(e)
            {
                print("################## Error Occurs!! ##################")
            })
        if ((i %% 50) == 0 )
        {
            write.csv(df_summary, address, row.names = FALSE)
        }
        
    }
    write.csv(df_summary, address, row.names = FALSE)
}

print(sprintf("End, Update : %d, DownloadFail : %d", changeCnt, nrow(failData)))



