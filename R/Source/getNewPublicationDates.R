
getNewPublicationDates <- function(db= indicators, 
                                   tickers= securities$Ticker, 
                                   fromDate= oldestMissingDate) {
    
    res <- bdh(as.character(unique(tickers)), "Announcement_Dt", fromDate)
    res <- ldply(res, data.frame)
    res <- setDT(res[, -2], key= NULL)
    
    colnames(res)[1] <- "Ticker"

    res <- unique(res)
    setkey(res, Ticker, Announcement_Dt)
    
    # remove dates already in indicators database (if any)
    res <- res[!res[db[, .(Ticker, Announcement_Dt)], nomatch= 0]]
    
    # add Primary_Periodicity data
    res <- res[securities[, .(Ticker, Primary_Periodicity)]]
    
    # keep only non NA rows
    res <- res[complete.cases(res)]
    
    colnames(res)[1] <- "Ticker"
    
    setkey(res, Ticker, Announcement_Dt)
    
    return(res)
    
}

