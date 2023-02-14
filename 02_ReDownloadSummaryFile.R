# 01_MakeSummaryFile 에서 다운로드 실패한 항목을 다시 받는 코드

setwd("/Users/jinsungpark/Desktop/WaterML_Code/Summary_Result")
getwd()

library(WaterML)
library(readxl)
library(writexl)

FailToDownload_Site <-read.csv("FailToDownload_Site.csv", header = TRUE)
FailToDownload_URL <-read.csv("FailToDownload_URL.csv", header = FALSE)
View(FailToDownload_Site)
View(FailToDownload_URL)

services <- GetServices()

downUrlFail_lst <- c()
downSiteFail_url <- c()
downSiteFail_lst <- c()
UrlErrorCnt <- 0
SiteErrorCnt <- 0
changeCnt <- 0


for (num in 1:nrow(FailDataRe))
{
    skip_url <- FALSE
    
    url_num <- FailDataRe$downSiteFail_url[num]
    url <- services$url[url_num] 
    tryCatch(
        {
            Sites <- GetSites(url)  #################### errors 생길수있는 부분 #####################
        },
        error = function(e) 
        {
            UrlErrorCnt <<- UrlErrorCnt + 1
            print("################ Url Download Error Occurs!! ################")
            downUrlFail_lst <<- append(downUrlFail_lst, url_num)
            skip_url <<- TRUE
        })
    if(skip_url) { next }
    
    
    if(url_num < 10)
    {
        address <- paste0("Summary_UrlNum_0",url_num,".csv")
    }else
    {
        address <- paste0("Summary_UrlNum_",url_num,".csv")
    }
    print(sprintf("#################### %s file Update start ####################", address))
    print(sprintf("%d/%d", num, nrow(FailDataRe)))
    df_summary <- read.csv(address)
    checkPoint = nrow(df_summary)
    
    Site_num <- FailDataRe$downSiteFail_lst[num]
    FullSiteCode <- Sites$FullSiteCode[Site_num]  
    
    skip_site <- FALSE
    tryCatch(
        {
            SitesInfo <- GetSiteInfo(url, FullSiteCode) #################### errors 생길수있는 부분 #####################
            
            df <- data.frame(matrix(nrow = length(SitesInfo$FullVariableCode), ncol = ncol(df_summary)))
            names(df) <- names(df_summary)
            df_summary <- rbind(df_summary, df)
            
            for (i in 1:length(SitesInfo$FullVariableCode))
            {
                df_summary$SiteName[i+checkPoint]          <- SitesInfo$SiteName[i]
                df_summary$url[i+checkPoint]               <- url
                df_summary$FullSiteCode[i+checkPoint]      <- SitesInfo$FullSiteCode[i]
                df_summary$FullVariableCode[i+checkPoint]  <- SitesInfo$FullVariableCode[i]
                df_summary$Organization[i+checkPoint]      <- services$organization[url_num]
                df_summary$Latitude[i+checkPoint]          <- SitesInfo$Latitude[i]
                df_summary$Longitude[i+checkPoint]         <- SitesInfo$Longitude[i]
                df_summary$Index[i+checkPoint]             <- 0
                df_summary$VariableName[i+checkPoint]      <- SitesInfo$VariableName[i]
                df_summary$ValueType[i+checkPoint]         <- SitesInfo$ValueType[i]
                df_summary$DataType[i+checkPoint]          <- SitesInfo$DataType[i]
                df_summary$GeneralCategory[i+checkPoint]   <- SitesInfo$GeneralCategory[i]
                df_summary$SampleMedium[i+checkPoint]      <- SitesInfo$SampleMedium[i]
                df_summary$UnitName[i+checkPoint]          <- SitesInfo$UnitName[i]
                df_summary$UnitType[i+checkPoint]          <- SitesInfo$UnitType[i]
                df_summary$TimeUnitName[i+checkPoint]      <- SitesInfo$TimeUnitName[i]
                df_summary$TimeSupport[i+checkPoint]       <- SitesInfo$TimeSupport[i]
                df_summary$beginDateTimeUTC[i+checkPoint]  <- as.character(SitesInfo$beginDateTimeUTC[i])
                df_summary$endDateTimeUTC[i+checkPoint]    <- as.character(SitesInfo$endDateTimeUTC[i])
                df_summary$mean[i+checkPoint]              <- 0
                df_summary$s.dev[i+checkPoint]             <- 0
                df_summary$minimum[i+checkPoint]           <- 0
                df_summary$maximum[i+checkPoint]           <- 0
                df_summary$length[i+checkPoint]            <- 0
                df_summary$Comment[i+checkPoint]           <- SitesInfo$Comments[i]
            }
            
            checkPoint = checkPoint + length(SitesInfo$FullVariableCode)
        },
        error = function(e) 
        {
            SiteErrorCnt <<- SiteErrorCnt + 1
            downSiteFail_url <<- append(downSiteFail_url, url_num)
            downSiteFail_lst <<- append(downSiteFail_lst, Site_num)
            skip_site <<- TRUE
            print("################ Site Download Error Occurs!! ################")
        })
    if(skip_site) { next }
    
    write.csv(df_summary, address, row.names = FALSE)
    changeCnt <- changeCnt + 1
}

print(sprintf("End, Updated Sites Num : %d, Url Download Error : %d, Site Download Error : %d", changeCnt, UrlErrorCnt, SiteErrorCnt))

# 한번 시도할때 마다 faildata이름을 바꿔서 저장해주는것이 안전함, 다운로드 중에 오류날수도 있기 때문에
FailData02 <- data.frame(downSiteFail_url, downSiteFail_lst)
View(FailData02)
# write.csv(FailData02, "FailToDownload02.csv")
