
setwd('C:/Users/USER/Desktop/Github/R Project')
getwd()

#檔案為txt
df<-read.table(file="cdnow_master.txt", header=FALSE)
df
str(df)

#備份資料:
df_backup<-df
#df<-df_backup


#挑出重要變數:
df<-df[,c(1,2,4)]
names(df)<-c("ID","Date","Amount")

str(df)
#發現目前日期是int類型
df$Date<-as.Date(as.character(df$Date), format="%Y%m%d")
str(df)

dim(df)
#69659筆交易資料

UserID<-df[!duplicated(df$ID),]
dim(UserID)
#23570個用戶

df

#(df,file="RFM_table.csv",row.names=F)
#檔案會寫入同一個路徑(最初開啟檔案的同一個資料夾)

# 使用Independent(獨立法)進行Bining(分箱)
#首先先做資料前處理:

startDate<-as.Date("19970101","%Y%m%d")
endDate<-as.Date("19980101","%Y%m%d")

# group by計算R,F,M值:

library(dplyr)
library(magrittr)

new_df <- 
    df %>% 
    filter(Date >= startDate & Date <= endDate) %>% 
    group_by(ID) %>% 
    summarise(
        MaxTransDate = max(Date),
        Amount = sum(Amount),
        Recency = as.numeric(endDate - MaxTransDate),
        Frequency = n(),
        Monetary = Amount/Frequency
    ) %>% 
    ungroup() %>% 
    as.data.frame()

head(new_df,10)
tail(new_df,10)

write.csv(new_df,"RFM_Table.csv",row.names=F)

