

gp <- function(Ticker){
    # function to plot ohlc prices
    
    if (!grepl("Equity", Ticker)) Ticker <-paste(Ticker, " Equity", sep="")
    
    col <- c("date", "Px_Open", "Px_High", "Px_Low", "Px_Last"
    )
    select <- database[database$Ticker==Ticker, col]
    colnames(select)[5] <- "Px_Close"
    select <- xts(select[,-1], order.by = select[,1])
    chartSeries(select, type= "matchsticks", name= Ticker)
    
}

graph <- function (type= "Ticker", tic= "IBM US Equity", what= "Dvd_Payout_Ratio"){
    
    db <- database[get(type) == tic, c("Date", what), with= FALSE]
    
    ggplot(db, aes(x=Date, y=get(what))) +
        xlab("Date") +
        ylab(what) +
        geom_smooth() + 
        scale_x_date(date_labels ="%m/%y", date_breaks="2 months")
    
}

graph("Ticker", "AAPL US Equity", "Asset_Turnover")

graph2 <- function(Ticker=Ticker, index="Px_Last") {
    # graph result
    
    if (!grepl("Equity", Ticker)) Ticker <-paste(Ticker, " Equity", sep="")
    
    select  <- na.locf(database[database$Ticker==Ticker,])
    date    <- as.Date(select$date)
    
    plot(date, select[,index], type= "l", main= Ticker, xaxt= "n", 
         xlab= "", ylab= index)
    axis.Date(1, at= seq(date[1], last(date), "month"), 
              format= "%Y-%m-%d", las= 2, cex.axis= 0.75)
    
}