
getPiotroski <- function(db= database[indicators], flds= piotroskiDataFields) {
    # piotroski rating calculation

    db <- db[!is.na(Primary_Periodicity)]
    db <- db[, c("Date", "Ticker", piotroskiDataFields), with= FALSE]
   
    db[Primary_Periodicity == "Annual",                 Freq:= 1L]
    db[Primary_Periodicity == "Semi-Annual and Annual", Freq:= 2L]
    db[Primary_Periodicity == "Quarterly and Annual",   Freq:= 4L]

    db$Piotroski <- 0L ## ?
    
    db[, ":=" (P.1= Net_Income > 0,
               P.2= Cf_Cash_From_Oper > 0,
               P.3= Cf_Cash_From_Oper > Net_Income)
       , by= Ticker]
    
    db[Freq == 1, ":=" (P.4= Return_On_Asset      / shift(Return_On_Asset,      4) >  1, 
                        P.5= Lt_Debt_To_Tot_Asset / shift(Lt_Debt_To_Tot_Asset, 4) <  1,
                        P.6= Cur_Ratio            / shift(Cur_Ratio,            4) >  1,
                        P.7= Bs_Sh_Out            / shift(Bs_Sh_Out,            4) <= 1,
                        P.8= Gross_Margin         / shift(Gross_Margin,         4) >  1,
                        P.9= Asset_Turnover       / shift(Asset_Turnover,       4) >  1),
       by= Ticker]
    
    db[Freq == 2, ":=" (P.4= Return_On_Asset      / shift(Return_On_Asset,      2) >  1, 
                        P.5= Lt_Debt_To_Tot_Asset / shift(Lt_Debt_To_Tot_Asset, 2) <  1,
                        P.6= Cur_Ratio            / shift(Cur_Ratio,            2) >  1,
                        P.7= Bs_Sh_Out            / shift(Bs_Sh_Out,            2) <= 1,
                        P.8= Gross_Margin         / shift(Gross_Margin,         2) >  1,
                        P.9= Asset_Turnover       / shift(Asset_Turnover,       2) >  1),
       by= Ticker]
    
    db[Freq == 4, ":=" (P.4= Return_On_Asset      / shift(Return_On_Asset,      1) >  1,
                        P.5= Lt_Debt_To_Tot_Asset / shift(Lt_Debt_To_Tot_Asset, 1) <  1,
                        P.6= Cur_Ratio            / shift(Cur_Ratio,            1) >  1,
                        P.7= Bs_Sh_Out            / shift(Bs_Sh_Out,            1) <= 1,
                        P.8= Gross_Margin         / shift(Gross_Margin,         1) >  1,
                        P.9= Asset_Turnover       / shift(Asset_Turnover,       1) >  1),
       by= Ticker]
    
    db[, Piotroski:= rowSums(.SD, na.rm=TRUE), 
       .SDcols=  c("P.1", "P.2", "P.3" ,"P.4", "P.5", "P.6", "P.7", "P.8", "P.9")]
    
    piotroski <- db[, .(Date, Ticker, Piotroski)]   
    
    return(piotroski)
    
}

