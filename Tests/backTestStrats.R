

source("R/Source/plotRadarFunction.R")
source("R/Source/getLogReturnFunction.R")
source("R/Source/getReturnPlotFunction.R")


dat <- getLogRet(strats$rating)

g1   <- getRetPlot(dat, "2015-12-31", "Rating")
g1.1 <- getRetPlot(dat, "2012-01-31", "Rating")

###

dat <- getLogRet(strats$scoring)

g2   <- getRetPlot(dat, "2015-12-31", "Ranking")
g2.2 <- getRetPlot(dat, "2012-01-31", "Ranking")
 
g3   <- getRetPlot(dat, "2015-12-31", "RankingGics")
# 
# g00 <- arrangeGrob(g1[[1]], g2[[1]], ncol=2, widths= c(0.5, 0.5))
# g01 <- arrangeGrob(g1.1[[1]], g2.2[[1]], ncol=2, widths = c(0.5, 0.5))
# g   <- arrangeGrob(g00, g01, nrow=2, heights= c(0.5,0.5))
# 
# grid.arrange(g)
# 
# g00 <- arrangeGrob(g1[[2]], g2[[2]], ncol=2, widths= c(0.5, 0.5))
# g01 <- arrangeGrob(g1.1[[2]], g2.2[[2]], ncol=2, widths = c(0.5, 0.5))
# g   <- arrangeGrob(g00, g01, nrow=2, heights= c(0.5,0.5))
# 
# grid.arrange(g)
# 

