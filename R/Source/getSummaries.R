
getSummaries <- function(db= database, flds= criteriaFields) {
    
    # replace Inf by NA
    changeInftoNA(db)
    
    res <- db[, lapply(.SD, summary), .SDcols= flds]
    
    rownames(res) <- c("Min.", "1st Qu.", "Median", "Mean", 
                       "3rd Qu.", "Max", "NA's")
    
    return(setDT(res))
    
} 

