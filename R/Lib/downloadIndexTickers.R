

library(data.table)
library(Rblpapi)

# get previous workday date
previousOpenDt <- function(dt = Sys.Date()) {
    
    if (format(dt - 1, "%w") %in% c(0, 6)) Recall(dt - 1) else dt - 1
    
}

# get first day of the month date
firstDayMonth  <- function(dt = Sys.Date()) { 
    
    dt <- as.POSIXct(format(dt, "%Y-%m-01"))
    
    if (!format(dt, "%w") %in% c(0, 6)) Recall (dt + 1) else dt
    
}


### load or get tickers list ###

#setwd("~/QuantDataResearch/ConfigFiles/")

arthaUniverTickers    <- scan("Config/arthaUniverTickers.txt",    what= "character", sep= "\n")
dharmaTickers         <- scan("Config/dharmaTickers.txt",         what= "character", sep= "\n")
arthaSelectionTickers <- scan("Config/arthaSelectionTickers.txt", what= "character", sep= "\n")

# connect to Bloomberg
connection  <- blpConnect() 

# download current spx tickers from Bloomberg
spxIndexTickers <- bds("SPX Index", "Indx_Members")

# format exchange codes and save ticker list
spxIndexTickers <- sub(" UN", " US", spxIndexTickers[,1])
spxIndexTickers <- sub(" UW", " US", spxIndexTickers)

spxIndexTickers <- paste(spxIndexTickers, "Equity", sep = " ")

write(spxIndexTickers, file="Config/spxTickers.txt", sep= "\n")

# download current be500 tickers from Bloomberg
be500IndexTickers <- bds("BE500 Index", "Indx_Members")
be500IndexTickers <- as.character(paste(be500IndexTickers[, 1], "Equity", sep = " "))

write(be500IndexTickers, "Config/be500Tickers.txt", sep= "\n")


### get security details from Bloomberg
securityFields <- scan("Config/securityFields.txt", what= "character", sep= "\n")

artha       <- bdp(arthaUniverTickers, securityFields)
dharma      <- bdp(dharmaTickers, securityFields)
selection   <- bdp(arthaSelectionTickers, securityFields)
spx         <- bdp(spxIndexTickers, securityFields)
be500       <- bdp(be500IndexTickers, securityFields) 

# close Bloomberg Connection
blpDisconnect(connection)

# format and save  resulting data
colnames(dharma)[1] <- colnames(selection)[1] <- colnames(artha)[1] <- "Ticker"
colnames(spx)[1]    <- colnames(be500)[1]     <- "Ticker"

setDT(artha,     key="Ticker")
setDT(dharma,    key="Ticker")
setDT(selection, key="Ticker")
setDT(spx,       key="Ticker")
setDT(be500,     key="Ticker")

artha    [, Ticker:=factor(Ticker)]
dharma   [, Ticker:=factor(Ticker)]
selection[, Ticker:=factor(Ticker)]
artha    [, Ticker:=factor(Ticker)]
artha    [, Ticker:=factor(Ticker)]

save(dharma,    file = "Data/dharma.RData")
save(selection, file = "Data/selection.RData")
save(artha,     file = "Data/artha.RData")
save(spx,       file = "Data/spx.RData")
save(be500,     file = "Data/Be500.RData")

