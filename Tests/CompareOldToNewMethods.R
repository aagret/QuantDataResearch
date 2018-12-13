
#### compare bloom histo to R histo rating ####

bloom <- read.csv("BloomHistoRating.csv", sep=";", header= FALSE, stringsAsFactors = FALSE)
colnames(bloom) <- lapply(bloom[1,], function(x) format(as.Date(x, format="%d.%m.%Y"), "%Y-%m-%d"))
bloom <- bloom[-1,]
colnames(bloom)[1] <- "Ticker"
setDT(bloom)


aa <- rating[Ticker %in% bloom$Ticker]
aa <- aa[Date %in% as.Date(colnames(bloom)[-1])]
aa <- unique(aa)
aa <- dcast(aa, Ticker ~ Date, value.var = "Rating")

setcolorder(aa, c("Ticker",sort(colnames(aa[, -"Ticker", with= FALSE]), decreasing = TRUE)))
setcolorder(bloom, c("Ticker",sort(colnames(bloom[, -"Ticker", with= FALSE]), decreasing = TRUE)))

bloom <- bloom[Ticker %in% aa$Ticker]

dt <- rbind(aa,bloom)

dt <- dt[, lapply(.SD, function(x) as.numeric(dt[,x][.N]) - as.numeric(dt[,x][.N-1])), 
         by= Ticker,
         .SDcols= names(dt)[-1]]

dt[is.na(dt)]<- 0
dt2 <- melt(dt, id.vars = )

