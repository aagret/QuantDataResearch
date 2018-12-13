
getRating <- function(db= database, flds= criteriaFields) {
   
    db     <- db[, c("Date", "Ticker", flds), with= FALSE] # na.locf ???
    rating <- db[, -1:-2, with= FALSE]
    
    criteria <- getCriteria()
    
    for(x in seq_along(rating)) {
        
        set(rating, which(rating[[x]] <  criteria[1][[x]]), j= x, value= 1L)
        set(rating, which(rating[[x]] >  criteria[2][[x]]), j= x, value= 1L)
        set(rating, which(rating[[x]] != 1),                j= x, value= 0)
        
    }
    
    res <- cbind(db[, .(Date, Ticker)], ncol(rating) + 1 - rowSums(rating, na.rm= TRUE))
    
    colnames(res)[3] <- "Rating"
    
    return(res)
    
}

