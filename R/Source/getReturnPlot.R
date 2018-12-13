
getReturnPlot <- function(dat= rating, dt= "2012-03-31", field= "Rating") {

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
    
    res <- res[, ':=' (csV1= exp(cumsum(V1)),
                       csV2= exp(cumsum(V2)),
                       csV3= exp(cumsum(V3))),
               by= field]
    
    res[, Abs:= csV1 - ((csV2 + csV3) / 2)]
    
    
    g01 <- ggplot(res, aes(x= Date, y= Abs, group= get(field), colour= get(field))) + 
        geom_line() + 
        geom_label(data= res[Date == last(Date)], aes(x= Date, y= Abs, label= get(field)))
    
    g02 <- ggplot(data= res) + 
        geom_line(aes(x= Date, y= csV1, group= get(field), colour= get(field))) + 
        geom_label(data= res[Date == last(Date)], aes(x= Date, y= csV1, label= get(field))) +
        geom_line(data= res[, mean(csV2), by= Date], aes(x= Date, y= V1), size= 1, colour= "red") +
        geom_line(data= res[, mean(csV3), by= Date], aes(x= Date, y= V1), size= 1, colour="green")
    
    g <- list(g01,g02)
    
    return(g)
    
}

