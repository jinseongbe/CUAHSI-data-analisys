
# Add value data index in summary file

setwd("/Users/jinsungpark/Desktop/WaterML_Code/Summary_Result")
getwd()

services <- read.csv("/Users/jinsungpark/Desktop/WaterML_Code/services_20201105.csv")
FailToDownload_Site <- read.csv("FailToDownload_Site.csv")
FailToDownload_URL <- read.csv("FailToDownload_URL.csv")
ValIndex_lst <- read.csv("/Users/jinsungpark/Desktop/WaterML_Code/Variable_lst.csv")
totalUrl <- nrow(services)

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
    }else
    {
        address <- paste0("Summary_UrlNum_",url_num,".csv")
    }
    
    df_summary <- read.csv(address)
    
    if (nrow(df_summary) != 0)
    {
        for (i in 1:nrow(df_summary))   
        {
            
            if (df_summary$VariableName[i] == "Temperature" | df_summary$VariableName[i] == "Snow depth" | df_summary$VariableName[i] == "Precipitation")
            {
                df_summary$Index[i] <- "physical"
                print(sprintf("##### URL : %d/%d, SiteNum : %d/%d, Variable : %s added %s Index", url_num, totalUrl, i, nrow(df_summary), df_summary$VariableName[i], "physical"))
                next
            }
            
            for (j in 1:nrow(ValIndex_lst))
            {
                ValName <- ValIndex_lst$Var_lst[j]
                
                if (df_summary$VariableName[i] == ValName)
                {
                    df_summary$Index[i] <- as.character(ValIndex_lst$IndexNum[j])
                    print(sprintf("##### URL : %d/%d, SiteNum : %d/%d, Variable : %s added %s Index", url_num, totalUrl, i, nrow(df_summary), ValName, ValIndex_lst$IndexNum[j]))
                }
            }
        }
    }
    write.csv(df_summary, address, row.names = FALSE)
}
