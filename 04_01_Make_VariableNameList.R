
# Add value data index

setwd("/Users/jinsungpark/Desktop/WaterML_Code/Summary_Result")
getwd()

library(stringr)
library(WaterML)
library(dplyr)

## 맨 처음에 파일을 변수들을 전부 모아 파일을 생성하는 과정, 초기에 1회만 실행하면 됨! ##
# services <- read.csv("/Users/jinsungpark/Desktop/WaterML_Code/services_20201105.csv")
# FailToDownload_URL <- read.csv("FailToDownload_URL.csv")
# TotalVar_lst <- c()
# 
# for (url_num in 1:nrow(services))
# {
#     isThisUrlFail = FALSE
#     
#     for (failUrl in FailToDownload_URL$downUrlFail_num)
#     {
#         if (url_num == failUrl)
#         {
#             isThisUrlFail = TRUE
#         }
#     }   
#     
#     if (isThisUrlFail)
#     {
#         next
#     }
#     
#     if(url_num < 10)
#     {
#         address <- paste0("Summary_UrlNum_0",url_num,".csv")
#     }else
#     {
#         address <- paste0("Summary_UrlNum_",url_num,".csv")
#     }
#     
#     df_summary <- read.csv(address)
#     VarName <- distinct(df_summary, VariableName)
#     
#     for (i in 1:nrow(VarName))
#     {
#         TotalVar_lst <- append(TotalVar_lst, as.character(VarName[i,1]))    
#     }
#     print(sprintf("########## URL : %d Done ##########", url_num))
# }
# 
# Var_lst <- sort(unique(TotalVar_lst))
# IndexNum <- c(NA)
# df = data.frame(Var_lst, IndexNum)
# View(df)




## 이학과 화학 분류를 직접 해주는 과정, 키워드로 중복 처리를 해서 조금더 빠르게 분류 가능
## 드래그한뒤 control + enter로 부분 실행해줘야함!
df <- read.csv("/Users/jinsungpark/Desktop/WaterML_Code/Variable_lst.csv")
View(df)


# 이학
VarName_Key <- "Weather"

for (i in 1:nrow(filter(df, str_detect(Var_lst, VarName_Key))))
{
    print(filter(df, str_detect(Var_lst, VarName_Key))[i, 1])
    
    for (j in 1:nrow(df))
    {
        if (df$Var_lst[j] == filter(df, str_detect(Var_lst, VarName_Key))[i, 1])
        {
            df$IndexNum[j] <- "physical"
        }
    }
    
    print(sprintf("KeyWord : %s, Update %d/%d, Remain %d/%d", VarName_Key, i, nrow(filter(df, str_detect(Var_lst, VarName_Key))), sum(is.na(df$IndexNum)), nrow(df)))
}



# 화학
VarName_Key <- "Carbofuran"

for (i in 1:nrow(filter(df, str_detect(Var_lst, VarName_Key))))
{
    print(filter(df, str_detect(Var_lst, VarName_Key))[i, 1])
    
    for (j in 1:nrow(df))
    {
        if (df$Var_lst[j] == filter(df, str_detect(Var_lst, VarName_Key))[i, 1])
        {
            df$IndexNum[j] <- "chemical"
        }
    }
    
    print(sprintf("KeyWord : %s, Update %d/%d, Remain %d/%d", VarName_Key, i, nrow(filter(df, str_detect(Var_lst, VarName_Key))), sum(is.na(df$IndexNum)), nrow(df)))
}

# write.csv(df, "/Users/jinsungpark/Desktop/WaterML_Code/Variable_lst.csv", row.names=FALSE)


