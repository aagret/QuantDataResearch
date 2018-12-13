
connection  <- blpConnect() 


regionExposure <- data.table()
for (i in securities$Ticker) {
    regionExposure <- rbind.fill(regionExposure, {
        
                                 res <- try(bds(security = as.character(i),
                                               field= "Pg_Revenue",
                                               overrides =  c("Product_Geo_Override"= "P",
                                                              "Pg_Hierarchy_Level"= 1,
                                                              "Number_Of_Periods"= 1,
                                                              "Fund_Per"= "-0FS")))
                                 
                                 if (!inherits(res, "try-error") & !is.null((res))) cbind(i, res)
                                 })
                                 
                                 
}

regionExposure <- securities[, ldply(Ticker, 
                                     function(x) { 
                                         res <- try(bds(security = as.character(x),
                                                        field= "Pg_Revenue",
                                                        overrides =  c("Product_Geo_Override"= "G",
                                                                       "Pg_Hierarchy_Level"= 1,
                                                                       "Number_Of_Periods"= 1,
                                                                       "Fund_Per"= "-0FS")))
                                         
                                         if (!inherits(res, "try-error") & !is.null(res)) res <- cbind(x, res)
                                     }
                                    )
                                    
                             ]

