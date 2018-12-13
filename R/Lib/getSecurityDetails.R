
getSecurityDetails <- function(tic=tickers) {

    securityFields <- scan("Config/securityFields.txt", what= "character", sep= "\n")
    
    connection <- blpConnect() 
    data       <- bdp(tic, securityFields)
    blpDisconnect(connection)
    
    return(data)
    
}
