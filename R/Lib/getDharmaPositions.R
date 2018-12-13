
getDharmaPositions <- function() {
    
    ticker <- fread("M:\\Alexandre\\Tfc\\Upload\\Positions Dharma Eq.csv", 
                    sep= ",", stringsAsFactors = FALSE)
    ticker <- ticker[, Date:= as.Date(Date)]
    lastDt <- max(unique(ticker[, Date]))
    ticker <- ticker[Date==lastDt, 'Security ID']
    
    colnames(ticker) <- "Ticker"
    setkey(ticker, Ticker)
    
    # if month(lastDt < month(Sys.Date())) RUN Monthly update
    
    load ("Data/dharma.RData")
    
    position  <- na.omit(dharma[ticker])
    newTicker <- as.character(ticker[!Ticker %in% position$Ticker, Ticker])
    
    if (!is.null(newTicker)) {
        
        # alert if new positions
        library(tcltk)
        msgBox <- tkmessageBox(title= "Alert New Positions in Dharma", 
                               message= newTicker, icon = "info")
        
        # complete data
        data <- getSecurityDetails(newTicker)
        
        colnames(data)[1] <- "Ticker"
        
    }
    
    data <- rbind(data, position)
    
    return(data)
    
}
