
getNewDailyData <- function(dt= startDate, 
                            tickers= securities$Ticker, 
                            flds= dailyDataFields) {
    
    endDt <- min(Sys.Date() - 1, dt + 50) # finetune step to avoid bloomberg saturation
    
#    res   <- bdh(as.character(tickers), flds, dt, endDt)

    res <- bdh(as.character(tickers), flds, dt, endDt,
               options= c("CshAdjNormal"="Yes",
                          "CshAdjAbnormal"="Yes",
                          "CapChg"="Yes") )
    
    res   <- ldply(res, data.frame)

    colnames(res)[1:2] <- c("Ticker", "Date")
    res   <- setDT(res, key=c("Ticker", "Date"))
    
    return(res)
    
}

