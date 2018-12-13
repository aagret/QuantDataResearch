
changeInftoNA <- function(db= database) {
    
    lapply(names(db),
           function(.name) set(db, 
                               which(is.infinite(db[[.name]])), 
                               j= .name, 
                               value= NA_real_)
    )
    
}

