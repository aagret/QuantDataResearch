library(Rblpapi)
library(data.table)
library(plyr)

a <- histoPrices

con <- blpConnect()

pxOpen <- bdh(as.character(unique(a$Ticker)), "Px_Open", 
             min(a$Date), max(a$Date),
             options= c("CapChg"="Yes", 
                        "CshAdjAbnormal"="No",
                        "CshAdjNormal"="No"))


nonAdjPx <- ldply(nonAdjPx, data.frame)

colnames(nonAdjPx) <- c("Ticker", "Date","Non_Adj_Last")

setDT(nonAdjPx, key=c("Ticker", "Date"))


b <-  merge(a,nonAdjPx)

b[, ":=" (Adj_Px_Open= Px_Open * Adj_Last / Px_Last,
           Adj_Px_High= Px_High * Adj_Last / Px_Last,
           Adj_Px_Low=  Px_Low  * Adj_Last / Px_Last)
           ]

