
library("data.table")
library("xts")
library("Rblpapi")
library("plyr")

load("Data/histoPrices.RData")

expectedDates <- seq.Date(from=min(histoPrices$Date), to = max(histoPrices$Date)-1, by= 1)
#expectedDates <- expectedDates[!weekdays(expectedDates) %in% c("saturday","sunday","samedi","dimanche")]
load("Data/ExcludeHistoryDates.RData")

missing <- histoPrices[, structure(setdiff(expectedDates, Date), class= "Date"), by= Ticker]

colnames(missing)[2] <- "Date"
setkey(missing, Date)

missing[, Diff:= c(0, (diff(Date) > 1) * 1), by= Ticker]
missing[, Group:= cumsum(Diff) + 1, by= Ticker]
missing <- missing[!wday(Date) %in% c(1, 7)]


missing[, ":=" (Start= Date[1], End= Date[.N]), by= list(Ticker, Group)]
missing <- missing[, .(Ticker, Start, End)]

setkey(missing, NULL)
missing <- unique(missing)
setkey(missing)

missing <- missing[!excludeData]


if (nrow(missing) != 0) {
    
    bdhData <- missing[Start != End]
    bdpData <- missing[Start == End]
    
    fields <- scan("Config/dailyDataFields.txt", what = "character")
    
    # connect to Bloomberg
    connection  <- blpConnect() 
    
    newData <- data.frame()
     # excludeData <- data.frame(matrix(0, nrow=0, ncol=3))
     # colnames(excludeData) <- c( "Ticker", "Start", "End")
    
    for (i in 1:nrow(bdhData)) { 
        
        res <- try(
            bdh(as.character(bdhData$Ticker[i]), 
                fields, 
                bdhData$Start[i], 
                bdhData$End[i],
                options= c("CapChg"="Yes", 
                           "CshAdjAbnormal"="No",
                           "CshAdjNormal"="No"))
            )
        
        if (nrow(res) != 0 & class(res) != "try-error") {
            colnames(res)[1] <- "Date"
            res$Ticker <- bdhData$Ticker[i]
            newData <- rbind(newData,res)
            
        } else {
            
            excludeData <- rbind(excludeData, data.frame(Ticker= bdhData$Ticker [i],
                                                         Start = bdhData$Start[i],
                                                         End=    bdhData$End[i]))
        }
        colnames(newData)[1] <- "Date"
        
        }
    
}
    
    
    histoPrices <- rbind(histoPrices, newData)

    ### download isolated days
    
    for (i in unique(bdpData$Start)) { 
        
        db <- bdpData[Start == i]
        
        for (j in 1:unique(db$Ticker)) {
            
            res <- try(
                bdh(as.character(db$Ticker[j]), 
                    fields, 
                    as.Date(i), 
                    as.Date(i),
                    options= c("CapChg"="Yes", 
                               "CshAdjAbnormal"="No",
                               "CshAdjNormal"="No"))
            )
            
            if (nrow(res) != 0 & class(res) != "try-error") {
               
                colnames(res)[1] <- "Date"
                res$Ticker <- as.character(db$Ticker[j])
                newData <- rbind(newData,res)
                
            } else {
                
                excludeData <- rbind(excludeData, data.frame(Ticker= db$Ticker [j],
                                                             Start = db$Start[i],
                                                             End=    db$End[i]))
            }
        }}
    

    

    
    setkey(histoPrices, Ticker, Date)
    setDT(excludeData)
    setkey(excludeData)
    
    save(histoPrices, file="Data/histoPrices.RData")
    save(excludeData, file="Data/ExcludeHistoryDates.RData")
    
    # close Bloomberg Connection
    blpDisconnect(connection)
    

