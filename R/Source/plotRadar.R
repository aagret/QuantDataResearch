
plotRadar <- function(tic= Ticker, db= database, strats= strats) {
    
    colSelect <- c("Net_Debt_To_Ebitda", "Eqy_Dvd_Yld_12m", "Geo_Grow_Dvd_Per_Sh",
                   "Pe_Ratio", "Geo_Grow_Net_Sales", "Dvd_Payout_Ratio")
    
    gics <- unique(db[Ticker == tic, GICS_Sector_Name])
    name <- unique(db[Ticker == tic, Short_Name])
    
    res  <- strats$lastScoring[Ticker == tic, colSelect, with= FALSE]
    res  <- rbind(res, strats$lastSectorScoring[gics, colSelect, with= FALSE])
    res  <- rbind(res, strats$lastMedianDharmaScoring[, colSelect, with= FALSE])
    res  <- rbind(rep(list(1), length(colSelect)), rep(list(0), length(colSelect)), res)

    res[is.na(res)] <- 0
    res <- res[, c(1, 6, 5, 4, 3, 2), with= FALSE]
    
    rownames(res) <- c(1, 2, name, gics, "dharma")
    colnames(res) <- c("Gearing", "Payout", "Sales Growth", 
                       "Valuation", "Dividend Growth", "Dividend")
    
    radarchart(res, 
               centerzero= TRUE, pty= 16,
               pcol= 4:2, pfcol=, plwd= 2, plty= 1:3,
               axistype= 1, seg= 5, axislabcol= "grey", calcex= 0.8,
               cglcol= "grey", cglty= 1, cglwd= 0.8
    )
    
    legend(x= -2 , y= -0.8, legend= c(name, gics, "Dharma Strategy"), bty= "n", 
           pch= 20, col= 4:2, text.col= "grey", 
           x.intersp= 1, y.intersp= 0.8,
           text.width= 1, cex= 0.7, pt.cex= 0.5)
    
}

