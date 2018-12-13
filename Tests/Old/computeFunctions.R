

### rating/metrics Functions

searchData <- function(select = database, date = NULL, Ticker = NULL) {
    # function to extract datas from database based on date, security, or both
    
    if (!is.null(date))		select <- select[select$date   == date, ]
    if (!is.null(ticker))	select <- select[select$ticker == ticker, ]
    
    return(select)
    
}

lastindex <- function(select = database) {
    # get last (most recent) economic data in database per security
    
    res <- NULL
    
    for (ii in unique(select$Ticker)) {
        
        tmp <- select[select$Ticker == ii, ]
        tmp <- tmp[!is.na(tmp$Latest_Announcement_Dt), ]
        tmp <- tmp[tmp$Latest_Announcement_Dt == max(tmp$Latest_Announcement_Dt), ]
        
        if (is.null(res)) res <- tmp else res <- rbind(res, tmp)  
        
    }
    
    return(res)
    
}

stats <- function(select=database) {
    #compute mean/med/quartile etc of of the database
    
    if (!grepl("Equity", Ticker)) Ticker <-paste(Ticker, " Equity", sep="")
    
    col <- c("Net_Debt_To_Ebitda", "Dividend_Yield", "Geo_Grow_Dvd_Per_Sh",
             "Pe_Ratio", "Geo_Grow_Net_Sales", "Dvd_Payout_Ratio")
    
    select <- database[, c("date", "Ticker", col)]
    select <- na.locf(select)
    
    select[,col] <- apply(select[,col], 2, function(x) 
        as.numeric(as.character(x)))
    
    mean 		<- aggregate(select[,col], list(select$date), mean, na.rm= TRUE)
    median 		<- aggregate(select[,col], list(select$date), median, na.rm=TRUE)
    quartile25 	<- aggregate(select[,col], list(select$date), quantile, probs=  0.25, na.rm= TRUE)
    quartile75 	<- aggregate(select[,col], list(select$date), quantile, probs= 0.75, na.rm= TRUE)
    max 		<- aggregate(select[,col], list(select$date), max , na.rm= TRUE)
    min 		<- aggregate(select[,col], list(select$date), min, na.rm= TRUE)
    stdDev  	<- aggregate(select[,col], list(select$date), sd, na.rm= TRUE)
    
    colnames(mean)[1] <- colnames(median)[1] <- colnames(quartile25)[1] <- "date"
    colnames(quartile75)[1] <- colnames(max) [1] <- colnames(min)[1] <- "date"
    colnames(stdDev)[1] <- "date"
    
    return(list(mean=mean, median=median, quartile1=quartile25,
                quartile3=quartile75, max=max, min=min, stdDev=stdDev))
    
}

getDetails <- function(Ticker = Ticker) {
    # get security results and graph from database
    
    data <- na.locf(database[database$Ticker == Ticker, ])
    data <- rating(data)
    
    plot(as.Date(data$date, "%Y-%m-%d"), data$rating, type= "s")
    title(Ticker)
    
}

dvd <- function(Ticker){
    
    if (!grepl("Equity", Ticker)) Ticker <-paste(Ticker, " Equity", sep="")
    
    col <- c("date", "Short_Name", "Dvd_Payout_Ratio", "Geo_Grow_Dvd_Per_Sh", 
             "Eqy_Dvd_Yld_12M", "Dividend_Yield")
    
    select <- database[database$Ticker==Ticker, col]
    select <- na.locf(select)
    
    date <- as.Date(select[,1])
    
    par(mar= c(5,4,4,5) + .1)
    plot(date, select[,6], type= "l", col= "red", xaxt= "n", 
         xlab= "", ylab= "% Yield")
    axis.Date(1, at=seq(date[1], last(date), "month"), format= "%Y-%m-%d", 
              las= 2, cex.axis= 0.75)
    par(new=TRUE)
    plot(date, select[,3], type= "l", col= "blue", xaxt= "n", yaxt= "n", 
         xlab= "", ylab= "", main= select[1,2])
    axis(4)
    mtext("Payout", side= 4, line= 3)
    legend("bottomright", col= c("red", "blue"), lty= 1, 
           legend= c("Yield", "PayoutRatio"))
    
}

artha <- function(Ticker) {
    
    if (!grepl("Equity", Ticker)) Ticker <-paste(Ticker, " Equity", sep="")
    
    col 	<- c("date", "Short_Name", "Px_Last")
    db  	<- database[database$Ticker==Ticker, ]
    select 	<- db[, col]
    date 	<- select$date
    
    par(mar= c(5,4,4,5) + .1)
    plot(date, select$Px_Last, type= "l",col= "black", xaxt= "n", 
         xlab= "", ylab="")
    axis.Date(1, at= seq(date[1], last(date), "month"), format= "%Y-%m-%d", 
              las= 2, cex.axis= 0.75)
    
    par(new=TRUE)
    plot(date, score(Ticker), type= "l", col= "blue", xaxt= "n", 
         yaxt= "n", xlab= "", ylab= "", main= select[1,2])
    axis(4)
    mtext("Scoring", side= 4, line= 3)
    
    par(new= TRUE)
    plot(date, rating(Ticker), ylim= rev(range(rating(Ticker))), type= "o", 
         col= "green", xaxt= "n", yaxt= "n", xlab= "",
         ylab= "", main= select[1,2])
    axis(2, line= 2, col= "green")
    
    par(new= TRUE)
    plot(date, piotroski(Ticker), type= "o", col= "red", xaxt= "n",  yaxt= "n", 
         xlab= "", ylab= "", main= select[1,2])
    axis(4,line=1, col="red")
    legend("bottomleft", col= c("black", "blue", "green", "red"), lty=1, 
           legend= c("Price", "Scoring", "rating", "piotroski"))
    
}

