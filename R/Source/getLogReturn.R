
getLogReturn <- function(strat= strats$rating, db= database) {
    
    getSymbols(c("^GSPC", "^STOXX"), from= "2012-01-01", src= "yahoo")
    setkey(strat, Ticker, Date)
    
    sp500 <- as.data.table(GSPC) [, .(index, GSPC.Close)]
    stoxx <- as.data.table(STOXX)[, .(index, STOXX.Close)]

    colnames(sp500) <- c("Date", "Sp500")
    colnames(stoxx) <- c("Date", "Stoxx")
    
    setkey(sp500, Date)
    setkey(stoxx, Date)
    
    dat <- strat[db[, .(Date, Ticker, Adj_Px_Last)]]
    setkey(dat, Date)
    
    dat <- merge(dat, sp500, all.x=TRUE)
    dat <- merge(dat, stoxx, all.x=TRUE)
    dat <- dat[complete.cases(dat)]
    
    dat[ , ':=' (SecRet= c(diff(log(Adj_Px_Last)), 0),
                 SpRet=  c(diff(log(Sp500)), 0),
                 StoRet= c(diff(log(Stoxx)), 0)),
         by= Ticker]
    
    return(dat)
    
}

