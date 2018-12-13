
getStyle <- function(db= database, valFlds= valueFields, groFlds= growthFields) {
    
    fields= c(valFlds, groFlds)
    
    db <- db[, c("Date", "Ticker", "Adj_Px_Last", fields), with= FALSE]
    
    db[, Momentum:= roll_meanr(Adj_Px_Last, 50) / roll_meanr(Adj_Px_Last, 200),
       by= Ticker]
    
    db[, Value:=  rowMeans(.SD, na.rm=TRUE), .SDcols= valFlds]
    db[, Growth:= rowMeans(.SD, na.rm=TRUE), .SDcols= groFlds]
    
    db[, ":=" (Value=  frank(Value,  na.last= "keep") / sum(!is.na(Value)),
               Growth= frank(Growth, na.last= "keep") / sum(!is.na(Growth)))]
    
    db <- db[, c("Date","Ticker", "Growth", "Value", "Momentum"), with= FALSE]
    
    return(db)
    
}

