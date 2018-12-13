

#### plot graph functions ####

plotRadar <- function(tic= Ticker) {
    
    colSelect <- scan("ConfigFiles/criteriaFields.txt", what= "character") 
    
    gics <- unique(database[Ticker == tic, GICS_Sector_Name])
    name <- unique(database[Ticker == tic, Short_Name])
    
    res <- strats$lastScoring[Ticker== tic, colSelect, with=FALSE]
    res <- rbind(res, strats$lastSectorScoring[gics, colSelect, with=FALSE])
    res <- rbind(res, strats$lastMedianDharmaScoring[, colSelect, with=FALSE])
    
    res <- rbind(rep(list(1), length(colSelect)), rep(list(0), length(colSelect)), res)
    res[is.na(res)] <- 0
    
    res <- res[, c(1, 6, 5, 4, 3, 2), with= FALSE]
    
    rownames(res) <- c( 1, 2, name, gics, "dharma")
    colnames(res) <- c("Gearing", "Payout", "Sales Growth", "Valuation", "Dividend Growth", "Dividend")
    
    radarchart( res  , 
                centerzero = TRUE, pty=16,
                pcol= 4:2 , pfcol= , plwd=2 , plty=1:3,
                axistype=1 , seg=5, axislabcol="grey", calcex= 0.8,
                cglcol="grey", cglty=1, cglwd=0.8
    )
    
    legend(x= -2 , y= -0.8, legend = c(name, gics, "Dharma Strategy"), bty = "n", pch=20 , 
           col=4:2 , text.col = "grey", 
           x.intersp = 1, y.intersp = 0.8,
           text.width = 1, cex=0.7, pt.cex=0.5)
    
}

getLogRet <- function(dat= rating) {

    dat <- dat[db]

    setkey(dat, Date)
    dat <- merge(dat, sp500, all.x=TRUE)
    dat <- merge(dat, stoxx, all.x=TRUE)

    dat <- dat[complete.cases(dat)]

    dat[ , ':=' (SecRet= c(diff(log(Adj_Px_Last)), 0),
                 SpRet=  c(diff(log(Sp500)), 0),
                 StoRet= c(diff(log(Stoxx)), 0)),
         by= .(Ticker)]

    return(dat)

}

getRetPlot <- function(dt= "2012-03-31", field= "Rating") {

    if (field != "Rating") {

        dat[, Rang:= cut(get(field), seq(0, 1, by= 0.125), drop= FALSE)]
        field <- "Rang"
    }

    res <- dat[Date > dt, .(mean(SecRet),
                            mean(SpRet),
                            mean(StoRet)),
               by= c(field, "Date")]

    res[is.na(res)] <- 0

    setkey(res, Date)
    res <- res[, ':=' (csV1=exp(cumsum(V1)),
                       csV2=exp(cumsum(V2)),
                       csV3=exp(cumsum(V3))),
               by= c(field)]



    #colnames(res) <- c("get(field)", "Sec", "Sp500","Stoxx")

    res[, Abs:= csV1 - ((csV2 + csV3) / 2)]


    g01 <- ggplot(res, aes(x= Date, y= Abs, group= get(field), colour= get(field))) +
        geom_line() +
        geom_label(data= res[Date==last(Date)], aes(x=Date, y= Abs, label= get(field)))

    g02 <- ggplot(data= res) +
        geom_line(aes(x=Date, y= csV1, group= get(field), colour= get(field))) +
        geom_label(data= res[Date==last(Date)], aes(x=Date, y= csV1, label= get(field))) +
        geom_line(data= res[, mean(csV2), by= Date], aes(x=Date, y=V1), size= 1, colour="red") +
        geom_line(data= res[, mean(csV3), by= Date], aes(x=Date, y=V1), size= 1, colour="green")

    g <- list(g01,g02)

    return(g)

}

getIndex <- function() {

    getSymbols(c("^GSPC", "^STOXX"), from="2012-01-01", src="yahoo")
    db <- database[, .(Date, Ticker, Px_Last)]
    setkey(db, Ticker, Date)

    sp500 <- as.data.table(GSPC)[, .(index, GSPC.Close)]
    stoxx <- as.data.table(STOXX)[, .(index, STOXX.Close)]

    colnames(sp500) <- c("Date", "Sp500")
    colnames(stoxx) <- c("Date", "Stoxx")

    setkey(sp500, Date)
    setkey(stoxx, Date)

    return(list("sp500"= sp500, "stoxx"= stoxx))

}