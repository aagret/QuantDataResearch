
getNewFundData  <- function(db= database, per= "-0FQ", flds= fundDataFields) {
    
    
    opt <- c("CapChg"="Yes", 
             "CshAdjAbnormal"="No",
             "CshAdjNormal"="No")
    
    if (nrow(db) == 0) return()
    
    newIndicators <- ldply(unique(db$Announcement_Dt), 
                           function(x) {
                               
                               res <- bdp(db[Announcement_Dt == x, Ticker], 
                                          flds,
                                          #options= opt,
                                          overrides = c(Eqy_Fund_Relative_Period = per,
                                                        Eqy_Fund_Dt = as.character(format(x, "%Y%m%d")))
                               )
                               
                               res <- cbind(db[Announcement_Dt == x, Ticker], 
                                            x, 
                                            res)
                               
                               colnames(res)[1:2] <- c("Ticker", "Announcement_Dt")
                               
                               setDT(res, key= c("Announcement_Dt", "Ticker"))
                               
                               return(res)
                               
                           }
                    )
    
    return(newIndicators)
    
}

