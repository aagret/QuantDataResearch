
perfTable <- function(tic= Ticker, strats= strats, db= database, input= input) {
    
    if (input$button == "Rating") {
        
        strat <- strats$rating
        field <- "Rating"
        cut   <- 1:7
        
    } else {
    
        strat <- strats$scoring
        field <- "Ranking"
        
    }
    
    db <- getLogReturn(strat, db[Ticker == tic, ])
    
    if (field == "Ranking") {
        
        data1 <- db[,
                    .(round(sum(SecRet) * 100, 2),
                      round(sum(SpRet)  * 100, 2),
                      round(sum(StoRet) * 100, 2)),
                    by= cut(Ranking, seq(0, 1, by= 0.125))]
        
        bh1   <- db[,
                    .(round(last(exp(cumsum(SecRet))) * 100, 2)-100,
                      round(last(exp(cumsum(SpRet)))  * 100, 2)-100,
                      round(last(exp(cumsum(StoRet))) * 100, 2)-100)]
        
        data1 <- rbind(data1, cbind(cut="B&H", bh1))
        
        data2 <- db[Date >= Sys.Date() - 365,
                    .(round(sum(SecRet) * 100, 2),
                      round(sum(SpRet)  * 100, 2),
                      round(sum(StoRet) * 100, 2)),
                    by= cut(Ranking, seq(0, 1, by= 0.125))]
        
        bh2   <- db[Date >= Sys.Date() - 365,
                    .(round(last(exp(cumsum(SecRet))) * 100, 2)-100,
                      round(last(exp(cumsum(SpRet)))  * 100, 2)-100,
                      round(last(exp(cumsum(StoRet))) * 100, 2)-100)]
        
        data2 <- rbind(data2, cbind(cut="B&H", bh2))
        
        data3 <- db[Date >= Sys.Date() - 91,
                    .(round(sum(SecRet) * 100, 2),
                      round(sum(SpRet)  * 100, 2),
                      round(sum(StoRet) * 100, 2)),
                    by= cut(Ranking, seq(0, 1, by= 0.125))]
        
        bh3   <- db[Date >= Sys.Date() - 91,
                    .(round(last(exp(cumsum(SecRet))) * 100, 2)-100,
                      round(last(exp(cumsum(SpRet)))  * 100, 2)-100,
                      round(last(exp(cumsum(StoRet))) * 100, 2)-100)]
        
        data3 <- rbind(data3, cbind(cut="B&H", bh3))
        
        setkey(data1, cut)
        setkey(data2, cut)
        setkey(data3, cut)

        data <- merge(merge(data1, data2, all= TRUE), data3, all= TRUE)
        
        setorder(data, -cut)
        colnames(data) <- c("Ranking",
                            "Histo", "Histo", "Histo",
                            "1Yr", "1Y.SP500", "1Y.BE500",
                            "90Mths", "90d.SP500", "90d.BE500")
        
    } else {
        
        data1 <- db[, .(round(sum(SecRet) * 100, 2),
                        round(sum(SpRet)  * 100, 2),
                        round(sum(StoRet) * 100, 2)),
                    by= Rating]
        
        bh1   <- db[,
                    .(round(last(exp(cumsum(SecRet))) * 100, 2)-100,
                      round(last(exp(cumsum(SpRet)))  * 100, 2)-100,
                      round(last(exp(cumsum(StoRet))) * 100, 2)-100)]
        
        data1 <- rbind(data1, cbind(Rating="B&H", bh1))
        
  
        data2 <- db[Date >= Sys.Date() - 365,
                    .(round(sum(SecRet) * 100, 2),
                      round(sum(SpRet)  * 100, 2),
                      round(sum(StoRet) * 100, 2)),
                    by= Rating]
        
        bh2   <- db[Date >= Sys.Date() - 365,
                    .(round(last(exp(cumsum(SecRet))) * 100, 2)-100,
                      round(last(exp(cumsum(SpRet)))  * 100, 2)-100,
                      round(last(exp(cumsum(StoRet))) * 100, 2)-100)]
        
        data2 <- rbind(data2, cbind(Rating="B&H", bh2))
        
        data3 <- db[Date >= Sys.Date() - 91,
                    .(round(sum(SecRet) * 100, 2),
                      round(sum(SpRet)  * 100, 2),
                      round(sum(StoRet) * 100, 2)),
                    by= Rating]
        
        bh3   <- db[Date >= Sys.Date() - 91,
                    .(round(last(exp(cumsum(SecRet))) * 100, 2)-100,
                      round(last(exp(cumsum(SpRet)))  * 100, 2)-100,
                      round(last(exp(cumsum(StoRet))) * 100, 2)-100)]
        
        data3 <- rbind(data3, cbind(Rating="B&H", bh3))
        
        setkey(data1, Rating)
        setkey(data2, Rating)
        setkey(data3, Rating)
        
        data <-  merge(merge(data1, data2, all=TRUE), data3, all=TRUE)
        
        colnames(data) <- c("Rating",
                            "Histo", "Histo", "Histo",
                            "1Yr", "1Y.SP500", "1Y.BE500",
                            "3Mths", "90d.SP500", "90d.BE500")
        
        data[, Rating:= as.character(Rating)]
        
    }
    
    if (input$absolute == TRUE) {
        
        res <- cbind(data$Ranking,
                     data[, lapply(seq(2, ncol(data) - 1, by= 3),
                                   function(x) data[[x]] - data[[x + 1]])]) # currently only S&P
        
        colnames(res) <- c(input$button, "Histo", "1Yr", "3 Mths")
        
    } else{
        
        res <- data[, c(1,2,5,8), with= FALSE]
        colnames(res) <- c(input$button, "Histo", "1Yr", "3 Mths")
        
    }

    return(res)
}

