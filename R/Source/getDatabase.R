
getDatabase <- function (hp= histoPrices, ind= indicators, sec= securities) {

    hp <- sec[hp]
    setkey(hp, Ticker, Date)
    
    ind[, Date:= Announcement_Dt]
    setkey(ind, Ticker, Date)
    
    db <- ind[hp, roll= +Inf]
    
    computeFundFields(db)
    computeDailyFields(db)
    changeInftoNA(db)
    reorderColumns(db)
    
    #remove empty indicators data
    db <- db[!is.na(Announcement_Dt)]
    
    return(db)
}

