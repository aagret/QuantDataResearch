
#### remove outliers ####
removeOutliers <- function(db= database) {
    # function to replace outliers with NA
    
    col <- c("Net_Debt_To_Ebitda", "Eqy_Dvd_Yld_Ind", "Geo_Grow_Dvd_Per_Sh",
             "Pe_Ratio", "Geo_Grow_Net_Sales", "Dvd_Payout_Ratio")
    
    
    db <- database[, c("Ticker", col), with=FALSE]
    
    H <- db[, lapply(.SD, IQR, na.rm=TRUE), by= Ticker]
    H  <- 1.5 * H
    
    q1 <- db[, lapply(.SD, quantile, probs=0.25, na.rm= TRUE), by= Ticker]
    q1 <- as.data.frame(q1)
    
    q2 <- db[, lapply(.SD, quantile, probs=0.75, na.rm= TRUE), by= Ticker]
    q2 <- as.data.frame(q2)
    
    db <- as.data.frame(db)
    
    sum(is.na(db))
    
    for (tic in unique(db$Ticker)) {
        
        for (coln in 2:ncol(db)) {
            
            db[db$Ticker==tic, coln][db[db$Ticker== tic, coln] < q1[q1$Ticker==tic, coln] - H[H$Ticker== tic, coln]] <- NA
            db[db$Ticker==tic, coln][db[db$Ticker== tic, coln] > q2[q2$Ticker==tic, coln] + H[H$Ticker== tic, coln]] <- NA
        }
        
    }
    
    sum(is.na(db))
    
} # OK but slow and hawfull

removeOutliers2 <- function(db= database, global= TRUE) {
    # function to replace outliers with NA
    
    col <- c("Net_Debt_To_Ebitda", "Eqy_Dvd_Yld_Ind", "Geo_Grow_Dvd_Per_Sh",
             "Pe_Ratio", "Geo_Grow_Net_Sales", "Dvd_Payout_Ratio")
    
    
    db <- database[, c("Ticker", col), with=FALSE]
    
    # remove inf values and replace with NA
    invisible(lapply(names(db), function(x) set(db, 
                                                which(is.infinite(db[[x]])),
                                                j= x, value= NA)))
    
    
    if (global == TRUE) { 
        
        H <- db[, lapply(.SD, IQR, na.rm=TRUE), .SDcols= col]
        for (x in 1:ncol(H)) H[[x]] <- H[[x]] * 1.5
        
        q1 <- db[, lapply(.SD, quantile, probs=0.25, na.rm= TRUE), .SDcols= col]
        q2 <- db[, lapply(.SD, quantile, probs=0.75, na.rm= TRUE), .SDcols= col]
        
    } else {
        
        H <- db[, lapply(.SD, IQR, na.rm=TRUE), by= Ticker]
        for (x in 2:ncol(H)) H[[x]] <- H[[x]] * 1.5
        
        q1 <- db[, lapply(.SD, quantile, probs=0.25, na.rm= TRUE), by= Ticker]
        q2 <- db[, lapply(.SD, quantile, probs=0.75, na.rm= TRUE), by= Ticker]
        
    }
    
    setkey(q1)
    setkey(q2)
    
    print(sum(is.na(db)))
    
    for (tic in unique(db$Ticker)) {
        
        for (i in seq_along(db)) {
            
            set(db, i= which(db[tic][[i]] < (q1[tic][[i]] - H[tic][[i]])), j= i, value= NA) 
            set(db, i= which(db[tic][[i]] > (q2[tic][[i]] + H[tic][[i]])), j= i, value= NA)
        }
        
    }
    
    print(sum(is.na(db)))
    
    return(db)
    
} # much better


system.time(removeOutliers(database))
system.time(removeOutliers2(database))


f_all   <-  removeOutliers2(database, global= TRUE)
f_Tic   <- removeOutliers2(database, global= FALSE)
f_ticAll<- removeOutliers2(f_Tic, global= TRUE)

lapply(db, summary)
lapply(f_all, summary)
lapply(f_Tic, summary)
lapply(f_ticAll, summary)
