
#### get corporate actions list by tickers

getCorpAction <- function(db= securities) {
    
    over <- c("CORPORATE_ACTIONS_FILTER"= "NORMAL_CASH|ABNORMAL_CASH|CAPITAL_CHANGE")
    
    corpActions <- db[, bds(as.character(unique(Ticker)), 
                    field= "EQY_DVD_ADJUST_FACT",
                    overrides= over), 
                         by= Ticker]
    
    colnames(corpActions) <- c("Ticker", "Date", "Adj_Factor", "Adj_Flag", "Adj_Type")
    
    setkey(corpActions, Ticker, Date)
    
    corpActions[Adj_Type == 1, Adj_Factor:= 1 / Adj_Factor]
    corpActions[, cumFactor:= cumprod(rev(Adj_Factor)), by= Ticker]
    corpActions[, cumFactor:= rev(cumFactor), by= Ticker]
    
    # check if new corporATE action since last update
    #setkey(corpActions)
    #setkey(old)

    # newCorpActions <- corpActions[!old]
    # 
    # # if new corpActions calculate adjusted prices in database
    # if (length(newCorpActions$Ticker) != 0)  adjustHistoPrices(histoPrices, corpActions)
    
    #  save file
    #corpActions <- newCorpActions
    #setkey(corpActions, Ticker, Date)

    save(corpActions, file= "Data/corpActions.RData")
    
}

