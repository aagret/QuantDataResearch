

sectorRecap <- as.list(
                    round(colMeans(database[GICS_Sector_Name == 
                                                unique(database[Ticker=="AD NA Equity", GICS_Sector_Name]), Filter(is.numeric, .SD)],
                                   na.rm=TRUE),
                          2)
                    )

secRecap    <- as.list(
                    round(last(database[Ticker=="AD NA Equity", Filter(is.numeric, .SD)]), 
                          2)
                    )
recap <- t(rbind(secRecap, sectorRecap))
    

colnames(recap) <- c("Security", "Sector")



      
