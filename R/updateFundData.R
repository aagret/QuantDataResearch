
###########  ###########
########  Init  ########
########################


#### Init config  ####
source("R/InitFundData.R")


###########  ###########
########  Main  ########
########################


#### Download Script ####
# connect to Bloomberg
connection  <- blpConnect() 

# get new daily datas since last run
startDate       <- max(database$Date)
dailyDataFields <- scan("Config/dailyDataFields.txt", what= "character")
newDailyData    <- getNewDailyData(startDate, securities$Ticker, dailyDataFields)

# find oldest dates of newDailyData not yet in Indicators
oldestMissingDate <- indicators[Ticker %in% newDailyData$Ticker, 
                                .(Announcement_Dt, Ticker)][, max(Announcement_Dt), 
                                                            by=Ticker][, min(V1)]

# find all Fundamental publication dates since...
newFundDates <- getNewPublicationDates(indicators, securities$Ticker, oldestMissingDate)

# get new fundamental datas
if (nrow(newFundDates) != 0) {
    
    # get missing Indicators
    fundDataFields <- scan("Config/fundDataFields.txt", what= "character")
    newIndicators  <- getNewIndicators(newFundDates, fundDataFields)
    setkey(newIndicators, Ticker, Announcement_Dt)
    
    # Process Script #
    # complete and format newIndicators
    computeFundFields(newIndicators) # complete calculated fields
    changeInftoNA(newIndicators)     # change Inf to NA
    reorderColumns(newIndicators)    # reorder columns
    
    # add newIndicators to Indicators
    indicators <- rbind(indicators, newIndicators)
    setkey(indicators, NULL)
    
    # remove duplicates
    indicators <- unique(indicators)
    setkey(indicators, Ticker, Announcement_Dt)
    
    # save indicators.RData
    save(indicators, file = "Data/indicators.RData")
    
}


# get new CorpActions
getCorpAction(securities)

# close Bloomberg Connection
blpDisconnect(connection)


#### Process Script ####

# calc adjusted prices
newDailyData <- adjustHistoPrices(newDailyData, corpActions)

# add newDailyData to histoPrices
histoPrices <- rbind(histoPrices, newDailyData)

# remove duplicates
setkey(histoPrices, NULL)
histoPrices <- unique(histoPrices)
setkey(histoPrices, Ticker, Date)

# save histoPrices.RData
save(histoPrices, file= "Data/histoPrices.RData")

# rebuild database
database <- getDatabase()


############  #############
########  Process  ########
###########################


#### compute various indexes ####
rating    <- getRating   (database, criteriaFields)
grade     <- getGrade    (database, criteriaFields)
piotroski <- getPiotroski(database, criteriaFields)

# scorings vs univer (benchmark)
scoring       <- getScoring(database[securities], criteriaFields) 
lastScoring   <- scoring[, .SD[.N], by= Ticker]

sectorScoring <- scoring[, lapply(.SD, function(x) mean(x, na.rm= TRUE)),
                         by= .(Date, GICS_Sector_Name),
                         .SDcols= criteriaFields]

setkey(sectorScoring, GICS_Sector_Name, Date) #?

lastSectorScoring <- sectorScoring[, .SD[.N], by= GICS_Sector_Name]
dharmaScoring     <- getScoring(database[dharma][securities], criteriaFields)
dharmaScoring     <- dharmaScoring[GICS_Sector_Name !=0, ]
lastDharmaScoring <- dharmaScoring[, .SD[.N], by= Ticker]

# median of Dharma portfolio
lastMedianDharmaScoring <- lastDharmaScoring[, lapply(.SD, 
                                                      function(x) median(x, na.rm= TRUE)),
                                             by= Date,
                                             .SDcols= criteriaFields]

# regroup and save ratings
strats <- list("grade"=                   grade,
               "rating"=                  rating,
               "scoring"=                 scoring, 
               "piotroski"=               piotroski,
               "lastScoring"=             lastScoring,
               "sectorScoring"=           sectorScoring,
               "dharmaScoring"=           dharmaScoring,
               "lastSectorScoring"=       lastSectorScoring,
               "lastDharmaScoring"=       lastDharmaScoring,
               "lastMedianDharmaScoring"= lastMedianDharmaScoring)

save(strats, file="Data/strats.RData")
              

#### compute recent Rantig changes ####

changes <- getChanges(7, strats, artha)

# # publish document
# rmarkdown::render("Reports/Rmd/testKnitr.Rmd", 
#                   output_format= c("html_document", "pdf_document"), 
#                   output_file= c(
#                       paste0("Reports/Docs/RatingChanges_", format(Sys.time(), "%Y%m%d-%H%M"), ".html"),
#                       paste0("Reports/Docs/RatingChanges_", format(Sys.time(), "%Y%m%d-%H%M"), ".pdf")
#                       )
#                   )
# 


### TODO send by email



