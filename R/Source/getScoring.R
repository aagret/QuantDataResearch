
getScoring <- function(db= database[benchmark], flds= criteriaFields) {
    
    db <- db[, c("Date", "Ticker", "GICS_Sector_Name", flds), with= FALSE]
    
    setkey(db, Date, Ticker, GICS_Sector_Name)
    
    db[, c(flds):= lapply(.SD, 
                          function(x) frank(db[, x], na.last= "keep") / 
                                      sum(!is.na(db[, x]))),
       by= Date,
       .SDcols= flds]
    
    
    db[, ':=' (Net_Debt_To_Ebitda= 1 - Net_Debt_To_Ebitda,
               Pe_Ratio=           1 - Pe_Ratio,
               Dvd_Payout_Ratio=   1 - Dvd_Payout_Ratio)]
    
    
    # dilute result by changing NA to zero
    changeNAtoZero(db)
    
    db[, Scoring:= rowMeans(.SD, na.rm= TRUE), .SDcols= flds]
    db[, Ranking:= frank(Scoring, na.last= "keep") / sum(!is.na(Scoring)), 
       by= Date]
    db[, RankingGics:= frank(Scoring, na.last= "keep") / sum(!is.na(Scoring)), 
       by= .(Date, GICS_Sector_Name)]
    
    db <- db[!is.na(Date)]
    setkey(db, Ticker, Date)
    
    return(db)
    
}

