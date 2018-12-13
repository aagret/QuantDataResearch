
computeDailyFields <- function(db= database) {
    
    db[, Eqy_Dvd_Yld_Ind:= NA_real_]
    db[Dvd_Freq == "Quarter",  Eqy_Dvd_Yld_Ind:= (Eqy_Dps * 400  / Px_Last)]
    db[Dvd_Freq == "Annual",   Eqy_Dvd_Yld_Ind:= (Eqy_Dps * 100  / Px_Last)]
    db[Dvd_Freq == "Semi-Anl", Eqy_Dvd_Yld_Ind:= (Eqy_Dps * 200  / Px_Last)]
    db[Dvd_Freq == "Monthly",  Eqy_Dvd_Yld_Ind:= (Eqy_Dps * 1200 / Px_Last)]
    
    db[ Country %in% c("US", "CA"), Pe_Ratio:= Px_Last / T12m_Dil_Eps_Cont_Ops]
    db[!Country %in% c("US", "CA"), Pe_Ratio:= Px_Last / Trail_12m_Eps_Bef_Xo_Item]
    
    db[Crncy == "GBp", ":=" (Pe_Ratio=        Pe_Ratio / 100,
                             Eqy_Dvd_Yld_Ind= Eqy_Dvd_Yld_Ind * 100)]
    
    db[, ":=" (Eqy_Dvd_Yld_12m=              Dvd_Sh_12m * 100 / Px_Last,
               Cur_Mkt_Cap=                  Eqy_Sh_Out * Px_Last,
               Best_Pe_Cur_Yr=               Px_Last / Best_Eeps_Cur_Yr,
               Best_Pe_Nxt_Yr=               Px_Last / Best_Eeps_Nxt_Yr,
               Px_To_Book_Ratio=             Px_Last / Book_Val_Per_Sh,         
               Px_To_Sales_Ratio=            Px_Last / Trail_12m_Sales_Per_Sh,
               Px_To_Cash_Flow=              Px_Last / Trail_12m_Cash_Flow_Per_Sh,
               Px_To_Ebitda=                 Px_Last * Is_Avg_Num_Sh_For_Eps / Trail_12m_Ebitda,
               Free_Cash_Flow_Yield=         Trail_12m_Free_Cash_Flow_Per_Sh / Px_Last,
               Current_Px_To_Free_Cash_Flow= Px_Last / Trail_12m_Free_Cash_Flow_Per_Sh,
               Best_Epeg_Ratio=              (Px_Last * Best_Est_Long_Term_Growth) / Best_Eeps_Cur_Yr)]
    
    db[, ":=" (Book_To_Px_Ratio=             1 / Px_To_Book_Ratio,
               Ebitda_To_Price=              1 / Px_To_Ebitda,
               Sales_To_Price_Ratio=         1 / Px_To_Sales_Ratio,
               Earn_Yld=                     1 / Eqy_Dvd_Yld_Ind)]
    
}

