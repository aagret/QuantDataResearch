
getNewIndicators <- function(dts= newFundDates, flds= fundDataFields) {
    
    if (nrow(dts) == 0) return(NULL)
    
    quarterData <- dts[grep("Quarter", dts[, Primary_Periodicity])]
    semiData    <- dts[grep("Semi",    dts[, Primary_Periodicity])]
    annualData  <- dts[!quarterData][!semiData]
    
    Q  <- getNewFundData(quarterData, "-0FQ", flds)
    Q2 <- getNewFundData(quarterData, "-0FY", flds)
    
    for (x in seq_along(Q)) set(Q, 
                                i= which(is.na(Q[[x]])),
                                j= x,
                                value= Q2[[x]][is.na(Q[[x]])])
    
    S  <- getNewFundData(semiData, "-0FS", flds)
    S2 <- getNewFundData(semiData, "-0FY", flds)
    
    for (x in seq_along(S)) set(S, 
                                i= which(is.na(S[[x]])),
                                j= x,
                                value= S2[[x]][is.na(S[[x]])])
    
    Y  <- getNewFundData(annualData, "-0FY", flds)
    
    res <- rbind(Q, S, Y)
    
    setDT(res, key= c("Ticker", "Announcement_Dt"))
          
    return(res)
    
}

