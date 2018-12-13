
reorderColumns <- function(db= database) {
    
    if (any(grep("Date", colnames(db)))) {
        
        first <- c("Ticker","Date","Announcement_Dt")
        
    } else {
        
        first <- c("Ticker","Announcement_Dt")
    }
    
    second <- sort(colnames(db[, -first, with= FALSE]))
    
    setcolorder(db, c(first, second))
    
}

