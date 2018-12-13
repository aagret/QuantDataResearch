temp    <- database[strats$rating][strats$scoring][, .SD[.N], by= Ticker][artha]

tempUS  <- temp[Crncy == "USD" & 
                    Rating %in% c(2,3,4) & 
                    Ranking >= 0.6 &
                    Tot_Common_Eqy >= 5, 
                .(Ticker, Short_Name, GICS_Sector_Name, Crncy)]

tempEUR <- temp[Crncy != "USD" & 
                    Rating %in% c(2,3,4) & 
                    Ranking >= 0.6 &
                    Tot_Common_Eqy >= 5, 
                .(Ticker, Short_Name, GICS_Sector_Name, Crncy)]

