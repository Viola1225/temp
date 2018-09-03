#clean function
clean<-function(df){
  # clean raw data
  # rename columns and define types, select columns
  # @return: cleaned dataframe with some columns kept
  
  columns<-c("ID",
             "TDU",
             "REP",
             "PRODUCT",
             "KWH500",
             "others",
             "KWH2000",
             "FEES",
             "PREPAID",
             "TOU",
             "FIXED",
             "RATE_TYPE",
             "RENEWABLE",
             "TERM_LENGTH",
             "CANCEL_FEE",
             "WEBSITE",
             "TERMS",
             "TERMS_URL",
             "PROMOTION",
             "PROMOTION_DESC",
             "FACTS_URL",
             "ENROLL_URL",
             "PREPAID_URL",
             "ENROLL_PHONE",
             "NEW_CUST",
             "MIN_USAGE_FEE",
             "LANGUAGE",
             "RATING")
  colnames(df)=columns
  
  
  
  df=df %>% #mutate
    select("ID",
           "TDU",
           "REP",
           "PRODUCT",
           "KWH500",
           "others",
           "KWH2000",
           "RATE_TYPE",
           "RENEWABLE",
           "TERM_LENGTH",
           "PREPAID",
           "TOU",
           "PROMOTION",
           "FACTS_URL") %>%
  mutate(KWH500=KWH500*100,
         others=others*100,
         KWH2000=KWH2000*100,
         PREPAID=as.character(PREPAID),
         TOU=as.logical(TOU),
         PROMOTION=as.logical(PROMOTION)) 
  df=na.omit(df)
  
  df$TDU[df$TDU=="AEP TEXAS CENTRAL DIVISION"]=c("电子电器")
  df$TDU[df$TDU=="AEP TEXAS NORTH DIVISION"]=c("服装鞋帽")
  df$TDU[df$TDU=="CENTERPOINT ENERGY HOUSTON ELECTRIC LLC"]=c("机具仪器")
  df$TDU[df$TDU=="NUECES ELECTRIC COOPERATIVE"]=c("快消品")
  df$TDU[df$TDU=="ONCOR ELECTRIC DELIVERY COMPANY"]=c("文化娱乐")
  df$TDU[df$TDU=="TEXAS-NEW MEXICO POWER COMPANY"]=c("其他")
  
  df$RATE_TYPE[df$RATE_TYPE=="Fixed"]=c("淡旺季")
  df$RATE_TYPE[df$RATE_TYPE=="Indexed"|df$RATE_TYPE=="Variable"]=c("普通")
  
  # df$PREPAID[df$PREPAID=="TRUE"]=c("新客户")
  # df$PREPAID[df$PREPAID=="FALSE"]=c("老客户")
  df$PREPAID=as.character(df$PREPAID)
  df$TOU=as.character(df$TOU)
  df$PROMOTION=as.character(df$PROMOTION)
  df$RATE_TYPE=as.character(df$RATE_TYPE)

  return(df)
}



get_df<-function(){
  url<-"http://www.powertochoose.org/en-us/Plan/ExportToCsv"
  #url<-"ftp://10.118.13.41:2121/power-to-choose-offers.csv"
  df<-read.csv(file = url,header = TRUE,stringsAsFactors = FALSE)
  df<-clean(df)
}

# get_df<-function(){
#   df<-read.csv(file = "D:\\user1\\01378037\\docum\\GitHub\\elecprice\\power-to-choose-offers.csv",header = TRUE,stringsAsFactors = FALSE)
#   df<-clean(df)
# }


