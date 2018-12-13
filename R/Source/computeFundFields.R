
computeFundFields <- function(db= database) {
    
    db[Eqy_Dps == 0, Eqy_Dps:= NA_real_]
    db[Dvd_Payout_Ratio == 0, Dvd_Payout_Ratio:= NA_real_]
    db[Geo_Grow_Dvd_Per_Sh == 0,Geo_Grow_Dvd_Per_Sh:= NA_real_]
    
    db[, Net_Debt_To_Ebitda:= NA_real_]
    db[Trail_12m_Ebitda  > 0, Net_Debt_To_Ebitda:= Net_Debt / Trail_12m_Ebitda]
    
    
    db[, ":=" (Book_Val_Per_Sh=         Tot_Common_Eqy / Bs_Sh_Out,
               Cash_Dvd_Coverage=       Inc_Bef_Xo_Less_Min_Int_Pref_Dvd / Is_Tot_Cash_Com_Dvd,
               Cash_Flow_To_Net_Inc=    Cf_Cash_From_Oper / Net_Income,
               Cash_Gen_To_Cash_Req=    Cf_Cash_From_Oper / - Capital_Expend,
               Cfo_To_Sales=            Cf_Cash_From_Oper * 100 / Sales_Rev_Turn,
               Cur_Ratio=               Bs_Cur_Asset_Report / Bs_Cur_Liab,
               Ev_To_T12m_Ebitda=       Enterprise_Value / Trail_12m_Ebitda,
               Ebitda_Per_Sh=           Ebitda / Is_Avg_Num_Sh_For_Eps,
               Free_Cash_Flow_Per_Sh=   Cf_Free_Cash_Flow / Is_Avg_Num_Sh_For_Eps,
               Gross_Margin=            (Sales_Rev_Turn - Is_Cogs_To_Fe_And_Pp_And_G) * 100 / Sales_Rev_Turn,
               Interest_Coverage_Ratio= Ebit / Tot_Int_Exp,
               Oper_Margin=             Is_Oper_Inc * 100 / Sales_Rev_Turn,
               Pretax_Margin=           Pretax_Inc * 100 / Sales_Rev_Turn,
               Rd_Expend_To_Net_Sales=  Is_Rd_Expend * 100 / Sales_Rev_Turn,
               Revenue_Per_Sh=          Sales_Rev_Turn / Is_Avg_Num_Sh_For_Eps,
               Lt_Debt_To_Tot_Asset=    Bs_Lt_Borrow * 100 / Bs_Tot_Asset,
               Tot_Debt_To_Com_Eqy=     Short_And_Long_Term_Debt * 100 / Tot_Common_Eqy,
               Tot_Debt_To_Tot_Asset=   Short_And_Long_Term_Debt * 100 / Bs_Tot_Asset)]
    
    return(db)
    
}

