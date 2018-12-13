
#############################
########  Functions  ########
#############################


#### download functions ####
source("R/Source/getNewFundData.R")
source("R/Source/getNewDailyData.R")
source("R/Source/getNewIndicators.R")
source("R/Source/getNewPublicationDates.R")
source("R/Source/getCorpAction.R")
source("R/Source/adjustHistoPrices.R")

#### build the database ####
source("R/Source/getDatabase.R")

# change inf to NA_real and change NA to Zero
source("R/Source/changeInftoNA.R")
source("R/Source/changeNAtoZero.R")

# reorder columns
source("R/Source/reorderColumns.R")

# complete calculated Fields and ratios
source("R/Source/computeFundFields.R")
source("R/Source/computeDailyFields.R")

#### process functions ####
source("R/Source/getGrade.R")
source("R/Source/getStyle.R")
source("R/Source/getRating.R")
source("R/Source/getScoring.R")
source("R/Source/getChanges.R")
source("R/Source/getCriteria.R")
source("R/Source/getSummaries.R")
source("R/Source/getPiotroski.R")

#### plot functions ####
source("R/Source/plotData.R")
source("R/Source/plotChangesTODO.R")
source("R/Source/plotRadar.R")


