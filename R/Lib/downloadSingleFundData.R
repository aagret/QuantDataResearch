
### Input requested field(s)
############################

fundDataFields <- "WACC"


#### load Init and requested functions ####
source("InitFundData.R")


# find Dates and Tickers
newData <- indicators[, .(Ticker , Announcement_Dt)]
newData <- securities[, .(Ticker, Primary_Periodicity)][newData]
setkey(newData, Ticker, Announcement_Dt)

# connect to Bloomberg
connection  <- blpConnect() 

# get missing Indicators

newIndicators  <- getNewIndicators(newData, fundDataFields)
setkey(newIndicators, Ticker, Announcement_Dt)

# close Bloomberg Connection
blpDisconnect(connection)

# add newIndicator to exisitng Indicators
indicators <- newIndicators[indicators]

# change Inf to NA
changeInftoNA(indicators)

# reorder columns
reorderColumns(indicators)

# save indicators.RData
save(indicators, file = "indicators.RData")

