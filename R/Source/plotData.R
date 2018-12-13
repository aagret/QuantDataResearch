
plotData <- function(tic= Ticker, strats= strats) {
    
    db <- strats$rating[tic][strats$grade[tic]][strats$scoring[tic, 
                                                             .(Date, Ticker,
                                                               Ranking, 
                                                               RankingGics)]]
    
    p1 <-  # plot line Rating
        ggplot(db) + aes(Date, Rating) +
        geom_line(color= "black") + aes(ymin= 1, ymax= max(Rating)) +
        scale_y_reverse() + 
        labs(title= "Rating")
    
    p2 <-  # plot line Grade
        ggplot(db) + aes(Date, Grade) +
        geom_line(color= "black") + aes(ylab= "Grade", ymin= 1, ymax= max(Grade)) +
        scale_y_reverse() + 
        labs(title= "Grade")
    
    p2.5 <- #plot lines rating + grade
        ggplot(db) + aes(x= Date) +
        geom_line(aes(y= Rating, color= "rating")) + 
        geom_line(aes(y= Grade,  color= "grade")) +
        aes(ylab= "Rating", ymin= 1, ymax= max(Rating)) +
        scale_y_reverse(breaks= 1:7, name= "Rating") + 
        labs(title= "Rating")
    
    
    p3 <-  # plot line Ranking
        ggplot(db) + aes(Date, Ranking) +
        geom_line(color= "black") + aes(ylab= "Ranking", 
                                        ymin= floor(Ranking / 0.05) * 0.05, 
                                        ymax= ceiling(Ranking / 0.05) * 0.05) +
        labs(title= "Ranking")
    
    
    p4 <-  # plot line RankingGics
        ggplot(db) + aes(Date, RankingGics) +
        geom_line(color= "red") + aes(ylab= "RankingGics", 
                                      ymin= floor(RankingGics   / 0.05) * 0.05, 
                                      ymax= ceiling(RankingGics / 0.05) * 0.05) +
        labs(title= "RankingGics")
    
    
    p5 <-  # plot lines Ranking & RankingGics
        ggplot(db, aes(x= Date)) +
        geom_line(aes(y= Ranking,     colour= "univer")) +
        geom_line(aes(y= RankingGics, colour= "sector")) + 
        aes(ylab= "Ranking", 
            ymin= min(floor(min(RankingGics) / 0.05) * 0.05,
                      floor(min(Ranking)     / 0.05) * 0.05),
            ymax= max(ceiling(max(RankingGics) / 0.05) * 0.05,
                      ceiling(max(Ranking)     / 0.05) * 0.05)) +
        labs(title= "Ranking Vs Benchmark & Gics_Sector") +
        theme(legend.position= c(.8, 0.3))
    
    
    p6 <-  # plot line & smooth Adj_Px_Last
        ggplot(database[tic, .(Date, Adj_Px_Last)], aes(Date, Adj_Px_Last)) +
        geom_line() +
        geom_smooth() +
        labs(title= "Adj_Px_Last")
    
    ### calculate RSI's
    db <- database[tic, .(Date, Adj_Px_Last)]
    db[, ':=' (Rsi5=   RSI(Adj_Px_Last, n=5,  maType="EMA", wilder=TRUE),
               Rsi9=   RSI(Adj_Px_Last, n=9,  maType="EMA", wilder=TRUE),
               Rsi14=  RSI(Adj_Px_Last, n=14, maType="EMA", wilder=TRUE),
               Rsi20=  RSI(Adj_Px_Last, n=20, maType="EMA", wilder=TRUE))]
    
    p7.1 <-  # Plot RSI 5/9/14/20
        ggplot(db, aes(Date, Rsi14)) +
        geom_line() + 
        geom_smooth() +
        geom_hline(aes(yintercept= quantile(Rsi14, 0.9, na.rm= TRUE))) +
        geom_hline(aes(yintercept= quantile(Rsi14, 0.1, na.rm= TRUE))) +
        theme(axis.title.x= element_blank(),
              axis.text.x=  element_blank(),
              axis.ticks.x= element_blank())
    
    p7.2 <-  # Plot RSI 5/9/14/20
        ggplot(db, aes(Date, Rsi5)) +
        geom_line() +
        geom_smooth() +
        geom_hline(aes(yintercept= quantile(Rsi5, 0.9, na.rm= TRUE))) +
        geom_hline(aes(yintercept= quantile(Rsi5, 0.1, na.rm= TRUE))) +
        theme(axis.title.x= element_blank(),
              axis.text.x=  element_blank(),
              axis.ticks.x= element_blank())
    
    p7 <-  # plot Adj_Px_Last & Rsi14
        arrangeGrob(p6, p7.2, p7.1, nrow= 3, heights= c( 0.7, 0.15, 0.15))
    
    #grid.arrange(p7)    
    
    # plot in grid Rating, Grade, Ranking/RankingGics & Adj_Px_Last 
    p01 <- arrangeGrob(p1,  p5,  ncol=2, widths = c(0.35, 0.65))
    p02 <- arrangeGrob(p2,  p7,  ncol=2, widths = c(0.35, 0.65))
    p03 <- arrangeGrob(p01, p02, nrow=2, heights= c(0.5, 0.5), 
                       top = textGrob(
                           tic,
                           just = "top", vjust = 0.75, gp = gpar(fontface = "bold")))
    grid.arrange(p03)
    
}

