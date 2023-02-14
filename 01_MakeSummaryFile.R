# Download sites information except value data information

# URL요약 파일을 저장할 경로 설정
setwd("/Users/jinsungpark/Desktop/WaterML_Code/Summary_Result")
getwd()

# WaterML library 사용
library(WaterML)
library(readxl)
library(writexl)

# URL 데이터 불러오기 (2020.11.05 기준 96개 URL 존재)
services <- GetServices()
write.csv(services, "services_20201105.csv")
# View(services)

# 다운로드 실패한 항목들을 저장하고 카운팅하기 위함
downUrlFail_num <- c()
downUrlFail_name <- c()

downSiteFail_url_num <- c()
downSiteFail_url_name <- c()
downSiteFail_SiteCode <- c()
UrlErrorCnt <- 0
SiteErrorCnt <- 0

# 다운로드 시작 부분
for (url_num in 1:length(services$url))
{
    # URL을 통해 URL에 존재하는 Site목록을 다운로드 해보고 안되면 리스트에 URL이름과 번호 추가
    # 새로운 URL이 업데이트 되면 번호가 밀릴수도 있으므로 이름을 꼭 확인해아함!
    skip_url <- FALSE
    url <- services$url[url_num] 
    tryCatch(
        {
            Sites <- GetSites(url)  #################### errors possible #####################
        },
        error = function(e)
        {
            UrlErrorCnt <<- UrlErrorCnt + 1
            print("Url Download Error Occurs!!")
            downUrlFail_num <<- append(downUrlFail_num, url_num)
            downUrlFail_name <<- append(downUrlFail_name, url)
            skip_url <<- TRUE
        })
    if(skip_url) { next }

    
    # Site의 세부 사항을  다운로드 해보고 안되면 리스트에 URL 이름과 Site 번호와 이름 추가
    df_summary <- read_excel("/Users/jinsungpark/Desktop/WaterML_Code/Summary.xlsx") # 미리 만들어 놓은 엑셀 불러오기(column만 존재)
    checkPoint = 0
    for (Site_num in 1:length(Sites$FullSiteCode))
    {
        print(sprintf("url : %d, Sites : %d / %d",url_num , Site_num, length(Sites$FullSiteCode)))
        FullSiteCode <- Sites$FullSiteCode[Site_num]  
        
        skip_site <- FALSE
        tryCatch(
            {
                SitesInfo <- GetSiteInfo(url, FullSiteCode) #################### errors possible #####################
                
                # 필요한 만큼 데이터프레임의 행을 늘려서 저장하는 방식
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
                    df_summary$Index[i+checkPoint]             <- 0 # 나중에 다른 코드로 분류하여 입력해야함
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
                    df_summary$mean[i+checkPoint]              <- 0 # 나중에 다른코드로 다운로드하여 입력(시간소요가 너무 크기때문)
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
                downSiteFail_url_num <<- append(downSiteFail_url_num, url_num)
                downSiteFail_url_name <<- append(downSiteFail_url_name, as.character(url))
                downSiteFail_SiteCode <<- append(downSiteFail_SiteCode, as.character(FullSiteCode))
                
                # 인코딩 오류로 입력이 되지 않을 경우 번호와 SiteCode가 매치되지 않음을 방지하기 위함
                if(length(downSiteFail_url_name) != length(downSiteFail_SiteCode))
                {
                    downSiteFail_SiteCode <<- append(downSiteFail_SiteCode, NA)
                }
                
                skip_site <<- TRUE
                print("Site Download Error Occurs!!")
            })
        if(skip_site) { next }
    }
    
    fileNum <- as.character(url_num)
    if(url_num < 10)
    {
        address <- paste0("Summary_UrlNum_0",fileNum,".csv")
    }else
    {
        address <- paste0("Summary_UrlNum_",fileNum,".csv")
    }
    write.csv(df_summary, address)
}


FailData_URL <- data.frame(downUrlFail_num, downUrlFail_name)
FailData_Site <- data.frame(downSiteFail_url_num, downSiteFail_url_name, downSiteFail_SiteCode)
write.csv(FailData_URL, "FailToDownload_URL.csv")
write.csv(FailData_Site, "FailToDownload_Site.csv")
print(sprintf("End, Url Download Error : %d, Site Download Error : %d", UrlErrorCnt, SiteErrorCnt))



