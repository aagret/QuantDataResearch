
ticker <- "AD NA Equity"


#### load Init and requested functions ####
source("prod-V-0.9/InitFundData.R")

# get oldest date in database
startDate <- min(database$Date)

# get daily Fields
fields <- scan("ConfigFiles/dailyDataFields.txt", what= "character")

# connect to Bloomberg
connection  <- blpConnect() 

# download from bloomberg
ndd <- bdh(ticker, fields, startDate,
           options= c("CapChg"="Yes", 
                      "CshAdjAbnormal"="No",
                      "CshAdjNormal"="No"))

ndd$Ticker <- ticker
colnames(ndd)[1] <- "Date"
setDT(ndd, key=c("Ticker", "Date"))

# close Bloomberg Connection
blpDisconnect(connection)

histoPrices <- rbind(histoPrices, ndd)
setkey(histoPrices, NULL)

histoPrices <- unique(histoPrices)
setkey(histoPrices, Ticker, Date)

# save histoPrices.RData
save(histoPrices, file= "histoPrices.RData")

