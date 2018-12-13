
getCriteria <- function(flds= criteriaFields) {  
    
    target <- c(
                c(1.1, ""  , "", 16.5, "", 66), 
                c("" , 2.75,  6, ""  ,  5, "")
                )
    
    res <- matrix(as.numeric(target), ncol = length(flds), byrow= TRUE)
    res <- as.data.table(res)
    
    rownames(res) <- c("<", ">")
    colnames(res) <- flds
    
    return(res)
    
} # OK DT pas top

