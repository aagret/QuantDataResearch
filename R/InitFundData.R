
########################
########  Init  ########
########################

#### load libraries ####
library(data.table)
library(Rblpapi)
library(xts)
library(plyr)
library(quantmod)
library(rmarkdown)
library(ggplot2)
library(grid)
library(gridExtra)
library(fmsb)
library(RcppRoll)

#### set working directory ####
workingDir <- normalizePath("./")
setwd(workingDir)

#### load requested functions ####
source("R/updateFundFunctions.R")


#### load dataset ####      
load ("Data/indicators.RData")
load ("Data/histoPrices.RData")
load ("Data/strats.RData")
load ("Data/spx.RData")
load ("Data/be500.RData")
load ("Data/artha.RData")
load ("Data/selection.RData")
load ("Data/dharma.RData")
load ("Data/corpActions.RData")

#### load criteria Fields ####
criteriaFields      <- scan("Config/criteriaFields.txt",      what= "character")
piotroskiDataFields <- scan("Config/piotroskiDataFields.txt", what= "character")
valueFields         <- scan("Config/valueStyleFields.txt",    what= "character")
growthFields        <- scan("Config/growthStyleFields.txt",   what= "character")

#### set variables ####
benchmark  <- rbind(spx, be500)
securities <- rbind(benchmark, artha, selection, dharma)

setDT(benchmark ,         key= "Ticker")
setDT(securities, key= "Ticker")

securities <- unique(securities)

save(benchmark,  file="Data/benchmark.RData")
save(securities, file="Data/securities.RData")

database <- getDatabase()

    
#### ! TODO create function to check and create securities dataset ####

