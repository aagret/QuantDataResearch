
getChanges <- function (ndays= 1L, strats= strats, univer= artha) {
    
    lastDt  <- max(strats$rating$Date)
    changes <- strats$rating[(Rating - shift(Rating)) != 0, 
                             .SD[c(.N - 1, .N)], 
                             by= Ticker] # all histo changess
    
    changes <- univer[, .(Ticker, Short_Name, GICS_Sector_Name)][changes]
    setkey(changes, Ticker, Date)
    
    changes <- strats$grade[changes]
    changes <- strats$scoring[, .(Date, Ticker, Scoring, Ranking, RankingGics)][changes]
    
    # remove non-univers Tickers
    changes <- changes[!is.na(Short_Name)]
    
    changes[, ':=' (OldRating=      Rating     [.N - 1],
                    OldGrade=       Grade      [.N - 1],
                    OldRanking=     Ranking    [.N - 1],
                    oldRankingGics= RankingGics[.N - 1],
                    Since=          Date       [.N - 1], 
                    NewRating=      Rating     [.N],
                    NewGrade=       Grade      [.N],
                    NewRanking=     Ranking    [.N],
                    newRankingGics= RankingGics[.N],
                    On=             Date       [.N]), 
            by= Ticker]
    
    
    changes <- changes[On > lastDt - ndays, 
                       .SD[.N], 
                       by= Ticker]
    
    changes <- changes[, .(On, Ticker, Short_Name, GICS_Sector_Name, 
                           OldRating, OldGrade, OldRanking, oldRankingGics,
                           Since, NewRating, NewGrade, NewRanking, newRankingGics)]
    
    setkey(changes, On, Ticker)
    
    return(changes)
    
}

