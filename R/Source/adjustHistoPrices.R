
#### adjust histo prices after corporate action

adjustHistoPrices <- function(db= histoPrices, action= corpActions) {
    
    
    db <- action[db, roll=-Inf]
    db[, cumFactor:= shift(cumFactor, type="lead"), by= Ticker]
    db[is.na(cumFactor), cumFactor:= 1]

    db[, ":=" (Adj_Px_Open= Px_Open  * cumFactor,
               Adj_Px_High= Px_High  * cumFactor,
               Adj_Px_Low=  Px_Low   * cumFactor,
               Adj_Px_Last= Px_Last  * cumFactor)]
    
    return(db[, c(1, 2, 7:14), with=FALSE])
    
}

