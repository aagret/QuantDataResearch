
plotChanges <- function (db= changes) {
    
    price <- database[Ticker %in% db$Ticker, .(Date, Ticker, Adj_Px_Last)]
    
    setkey(price, Ticker)
    setkey(db, Ticker)
    
    price <- db[price]
    
    price <- price[Date >= Since, c(colnames(db), "Date", "Adj_Px_Last"), with= FALSE]
    
    ggplot(price, aes(x= Date, y= Adj_Px_Last)) +
        geom_line() + 
        facet_wrap( ~Ticker, scales= "free", ncol= 4)
    
}

