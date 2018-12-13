

getStyle <- function(db= database, valFlds= valueFields, groFlds= growthFields) {
    
    fields= c(valFlds, groFlds)
    
    db <- db[, c("Date", "Ticker", "Adj_Px_Last", fields), with= FALSE]
    
    db[, Momentum:= roll_meanr(Adj_Px_Last, 50) / roll_meanr(Adj_Px_Last, 200), by= Ticker]
    
    val <- db[, lapply(.SD, function(x) rank(db[,x], na.last="keep") / 
                           sum(!is.na(db[,x]))),
              .SDcols= valFlds]
    
    gro <- db[, lapply(.SD, function(x) rank(db[,x], na.last="keep") / 
                           sum(!is.na(db[,x]))),
              .SDcols= groFlds]
    
    db[, ":=" (Value=  rowMeans(val, na.rm= TRUE),
               Growth= rowMeans(gro, na.rm= TRUE))]
    
    db <- db[, c("Date","Ticker", "Growth", "Value", "Momentum"), with= FALSE]
    
    return(db)
    
}

