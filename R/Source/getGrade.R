
getGrade <- function(db= database, flds= criteriaFields) {

    stats <- getSummaries(db)
    db    <- db[, c("Date", "Ticker", flds), with= FALSE ] # na.locf ?
    grade <- lapply(names(db), 
                    function(x) (as.numeric(stats[3][[x]]) - as.numeric(db[[x]])) 
                                 / 
                                 as.numeric((stats[3][[x]] - stats[4][[x]])))
    
    grade <- as.data.table(grade)

    for (x in seq_along(grade)) set(grade, 
                                    which(stats[3][[x]] < stats[4][[x]]), 
                                    j= x, 
                                    value= (as.numeric(stats[3][[x]]) -
                                                as.numeric(db[[x]]))
                                            /
                                            as.numeric((stats[3][[x]] - 
                                                stats[4][[x]]))
    )
    
    for (x in seq_along(grade)) set(grade,
                                    which(stats[3][[x]] > stats[4][[x]]), 
                                    j= x, 
                                    value= (as.numeric(db[[x]]) -
                                                as.numeric(stats[3][[x]])) 
                                            /
                                            as.numeric((stats[3][[x]] - 
                                                stats[4][[x]]))
    )
    
    for (x in seq_along(grade)) set(grade,
                                    which(grade[[x]] > 0),
                                    j= x,
                                    value= 1)
    
    for (x in seq_along(grade)) set(grade,
                                    which(grade[[x]] < 0),
                                    j= x,
                                    value= 0)
    
    res <- cbind(db[, .(Date,Ticker)], ncol(grade) + 1 - rowSums(grade, na.rm=TRUE))
    
    colnames(res)[3] <- "Grade"
    
    return(res)
    
} # OK DT moche 4 boucles

