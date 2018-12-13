---
title: "DharmaResearch "
output: 
    flexdashboard::flex_dashboard:
        #logo: logo_H.jpg
        orientation: rows
        #vertical_layout: scroll
        runtime: shiny
---


```r
#### init directories and knitr ####
library("knitr")
workingDir <- normalizePath("../../")
opts_knit$set(root.dir= workingDir)
setwd(workingDir)


#### Init ####
library(flexdashboard)
library(plotly)
library(fmsb)
library(data.table)
library(quantmod)
library(ggplot2)
library(RcppRoll)


#### load datas ####
load("Data/indicators.RData")
```

```
## Warning in readChar(con, 5L, useBytes = TRUE): cannot open compressed file
## 'Data/indicators.RData', probable reason 'No such file or directory'
```

```
## Error in readChar(con, 5L, useBytes = TRUE): cannot open the connection
```

```r
load("Data/histoPrices.RData")
```

```
## Warning in readChar(con, 5L, useBytes = TRUE): cannot open compressed file
## 'Data/histoPrices.RData', probable reason 'No such file or directory'
```

```
## Error in readChar(con, 5L, useBytes = TRUE): cannot open the connection
```

```r
load("Data/securities.RData")
```

```
## Warning in readChar(con, 5L, useBytes = TRUE): cannot open compressed file
## 'Data/securities.RData', probable reason 'No such file or directory'
```

```
## Error in readChar(con, 5L, useBytes = TRUE): cannot open the connection
```

```r
load("Data/strats.RData")
```

```
## Warning in readChar(con, 5L, useBytes = TRUE): cannot open compressed file
## 'Data/strats.RData', probable reason 'No such file or directory'
```

```
## Error in readChar(con, 5L, useBytes = TRUE): cannot open the connection
```

```r
#### source functions ####
source("R/Source/plotRadar.R")
```

```
## Warning in file(filename, "r", encoding = encoding): cannot open file 'R/
## Source/plotRadar.R': No such file or directory
```

```
## Error in file(filename, "r", encoding = encoding): cannot open the connection
```

```r
source("R/Source/getLogReturn.R")
```

```
## Warning in file(filename, "r", encoding = encoding): cannot open file 'R/
## Source/getLogReturn.R': No such file or directory
```

```
## Error in file(filename, "r", encoding = encoding): cannot open the connection
```

```r
source("R/Source/getReturnPlot.R")
```

```
## Warning in file(filename, "r", encoding = encoding): cannot open file 'R/
## Source/getReturnPlot.R': No such file or directory
```

```
## Error in file(filename, "r", encoding = encoding): cannot open the connection
```

```r
source("R/Source/getDatabase.R")
```

```
## Warning in file(filename, "r", encoding = encoding): cannot open file 'R/
## Source/getDatabase.R': No such file or directory
```

```
## Error in file(filename, "r", encoding = encoding): cannot open the connection
```

```r
source("R/Source/computeFundFields.R")
```

```
## Warning in file(filename, "r", encoding = encoding): cannot open file 'R/
## Source/computeFundFields.R': No such file or directory
```

```
## Error in file(filename, "r", encoding = encoding): cannot open the connection
```

```r
source("R/Source/computeDailyFields.R")
```

```
## Warning in file(filename, "r", encoding = encoding): cannot open file 'R/
## Source/computeDailyFields.R': No such file or directory
```

```
## Error in file(filename, "r", encoding = encoding): cannot open the connection
```

```r
source("R/Source/changeInftoNA.R")
```

```
## Warning in file(filename, "r", encoding = encoding): cannot open file 'R/
## Source/changeInftoNA.R': No such file or directory
```

```
## Error in file(filename, "r", encoding = encoding): cannot open the connection
```

```r
source("R/Source/reorderColumns.R")
```

```
## Warning in file(filename, "r", encoding = encoding): cannot open file 'R/
## Source/reorderColumns.R': No such file or directory
```

```
## Error in file(filename, "r", encoding = encoding): cannot open the connection
```

```r
source("R/Source/perfTable.R")
```

```
## Warning in file(filename, "r", encoding = encoding): cannot open file 'R/
## Source/perfTable.R': No such file or directory
```

```
## Error in file(filename, "r", encoding = encoding): cannot open the connection
```

```r
source("R/Source/getStyle.R")
```

```
## Warning in file(filename, "r", encoding = encoding): cannot open file 'R/
## Source/getStyle.R': No such file or directory
```

```
## Error in file(filename, "r", encoding = encoding): cannot open the connection
```

```r
#### get requested datas ####
database <- getDatabase(histoPrices, indicators, securities)

valueFields  <- scan("Config/valueStyleFields.txt",  what= "character") 
```

```
## Warning in file(file, "r"): cannot open file 'Config/valueStyleFields.txt':
## No such file or directory
```

```
## Error in file(file, "r"): cannot open the connection
```

```r
growthFields <- scan("Config/growthStyleFields.txt", what= "character")
```

```
## Warning in file(file, "r"): cannot open file 'Config/
## growthStyleFields.txt': No such file or directory
```

```
## Error in file(file, "r"): cannot open the connection
```


Single Security View
=======================================================================


Column {.sidebar data-width=350}
-----------------------------------------------------------------------


Choose security to be displayed


```r
#### set input boxes ####
selectInput("secName", 
            label = NULL,
            choices = (unique(database$Short_Name)),
            selected = "APPLE INC")
```

```
## Error in eval(expr, envir, enclos): could not find function "selectInput"
```

```r
radioButtons("button", 
             label= NULL,
             c("Ranking"= "Ranking",
               "Rating" = "Rating"),
             inline= TRUE)
```

```
## Error in eval(expr, envir, enclos): could not find function "radioButtons"
```

```r
checkboxInput("absolute", label = "absolute", value= FALSE)
```

```
## Error in eval(expr, envir, enclos): could not find function "checkboxInput"
```

```r
#### set reactive variables ####
tic   <- reactive(unique(database[Short_Name == input$secName, Ticker]))
```

```
## Error in eval(expr, envir, enclos): could not find function "reactive"
```

```r
radar <- reactive(plotRadar(tic(), database, strats))
```

```
## Error in eval(expr, envir, enclos): could not find function "reactive"
```

```r
table <- reactive(perfTable(tic(), strats, database, input))
```

```
## Error in eval(expr, envir, enclos): could not find function "reactive"
```

Price Return

```r
#### render histo perf table ####
renderTable({
    
    table()

    }, bordered = "xs")
```

```
## Error in eval(expr, envir, enclos): could not find function "renderTable"
```

```r
#### plot radar chart ####
renderPlot({
    
    radar()

    })
```

```
## Error in eval(expr, envir, enclos): could not find function "renderPlot"
```

Row {data-height=150}
-----------------------------------------------------------------------

### Univer Ranking

```r
#### render Gauges ####
renderGauge({
    
    gauge(round(strats$lastScoring[Ticker == tic(), Ranking] * 100, 2),
          min = 0, max = 100, symbol = '%',
          gaugeSectors(success= c(60, 100),
                       warning= c(40,  60),
                       danger=  c( 0,  40)))

    })
```

```
## function (...) 
## {
##     if (length(outputArgs) != 0 && !hasExecuted$get()) {
##         warning("Unused argument: outputArgs. The argument outputArgs is only ", 
##             "meant to be used when embedding snippets of Shiny code in an ", 
##             "R Markdown code chunk (using runtime: shiny). When running a ", 
##             "full Shiny app, please set the output arguments directly in ", 
##             "the corresponding output function of your UI code.")
##         hasExecuted$set(TRUE)
##     }
##     if (is.null(formals(origRenderFunc))) 
##         origRenderFunc()
##     else origRenderFunc(...)
## }
## <environment: 0x000000001d6d0308>
## attr(,"class")
## [1] "shiny.render.function" "function"             
## attr(,"outputFunc")
## function (outputId, width = "100%", height = "200px") 
## {
##     htmlwidgets::shinyWidgetOutput(outputId, "gauge", width, 
##         height, package = "flexdashboard")
## }
## <environment: namespace:flexdashboard>
## attr(,"outputArgs")
## list()
## attr(,"hasExecuted")
## <Mutable>
##   Public:
##     clone: function (deep = FALSE) 
##     get: function () 
##     set: function (value) 
##   Private:
##     value: FALSE
```

### GICS Sector Ranking

```r
# render Gauges
renderGauge({
    
    gauge(round(strats$lastScoring[Ticker == tic(), RankingGics] * 100, 2),
          min = 0, max = 100, symbol = '%',
          gaugeSectors(success= c(60, 100),
                       warning= c(40,  60),
                       danger=  c( 0,  40)))
    
    })
```

```
## function (...) 
## {
##     if (length(outputArgs) != 0 && !hasExecuted$get()) {
##         warning("Unused argument: outputArgs. The argument outputArgs is only ", 
##             "meant to be used when embedding snippets of Shiny code in an ", 
##             "R Markdown code chunk (using runtime: shiny). When running a ", 
##             "full Shiny app, please set the output arguments directly in ", 
##             "the corresponding output function of your UI code.")
##         hasExecuted$set(TRUE)
##     }
##     if (is.null(formals(origRenderFunc))) 
##         origRenderFunc()
##     else origRenderFunc(...)
## }
## <environment: 0x000000001d4c6188>
## attr(,"class")
## [1] "shiny.render.function" "function"             
## attr(,"outputFunc")
## function (outputId, width = "100%", height = "200px") 
## {
##     htmlwidgets::shinyWidgetOutput(outputId, "gauge", width, 
##         height, package = "flexdashboard")
## }
## <environment: namespace:flexdashboard>
## attr(,"outputArgs")
## list()
## attr(,"hasExecuted")
## <Mutable>
##   Public:
##     clone: function (deep = FALSE) 
##     get: function () 
##     set: function (value) 
##   Private:
##     value: FALSE
```


### Rating

```r
renderValueBox({    
    
    valueBox(value=   last(strats$rating[Ticker == tic(), Rating]), 
             icon=    "fa-star",
             color=   ifelse(last(strats$rating[Ticker == tic(), Rating]) %in% c(2, 3, 4),
                             "success", "warning"))
    
    })
```

```
## function (...) 
## {
##     if (length(outputArgs) != 0 && !hasExecuted$get()) {
##         warning("Unused argument: outputArgs. The argument outputArgs is only ", 
##             "meant to be used when embedding snippets of Shiny code in an ", 
##             "R Markdown code chunk (using runtime: shiny). When running a ", 
##             "full Shiny app, please set the output arguments directly in ", 
##             "the corresponding output function of your UI code.")
##         hasExecuted$set(TRUE)
##     }
##     if (is.null(formals(origRenderFunc))) 
##         origRenderFunc()
##     else origRenderFunc(...)
## }
## <environment: 0x00000000239aa038>
## attr(,"class")
## [1] "shiny.render.function" "function"             
## attr(,"outputFunc")
## function (outputId, width = "100%", height = "160px") 
## {
##     shiny::uiOutput(outputId, class = "shiny-html-output shiny-valuebox-output", 
##         width = width, height = height)
## }
## <environment: namespace:flexdashboard>
## attr(,"outputArgs")
## list()
## attr(,"hasExecuted")
## <Mutable>
##   Public:
##     clone: function (deep = FALSE) 
##     get: function () 
##     set: function (value) 
##   Private:
##     value: FALSE
```

### Grade

```r
renderValueBox({    
    
    valueBox(value=   last(strats$grade[Ticker == tic(), Grade]), 
             icon=    "fa-graduation-cap",
             color=   "primary")
    
    })
```

```
## function (...) 
## {
##     if (length(outputArgs) != 0 && !hasExecuted$get()) {
##         warning("Unused argument: outputArgs. The argument outputArgs is only ", 
##             "meant to be used when embedding snippets of Shiny code in an ", 
##             "R Markdown code chunk (using runtime: shiny). When running a ", 
##             "full Shiny app, please set the output arguments directly in ", 
##             "the corresponding output function of your UI code.")
##         hasExecuted$set(TRUE)
##     }
##     if (is.null(formals(origRenderFunc))) 
##         origRenderFunc()
##     else origRenderFunc(...)
## }
## <environment: 0x0000000029e010b8>
## attr(,"class")
## [1] "shiny.render.function" "function"             
## attr(,"outputFunc")
## function (outputId, width = "100%", height = "160px") 
## {
##     shiny::uiOutput(outputId, class = "shiny-html-output shiny-valuebox-output", 
##         width = width, height = height)
## }
## <environment: namespace:flexdashboard>
## attr(,"outputArgs")
## list()
## attr(,"hasExecuted")
## <Mutable>
##   Public:
##     clone: function (deep = FALSE) 
##     get: function () 
##     set: function (value) 
##   Private:
##     value: FALSE
```

### Value Style

```r
# render Gauges
renderGauge({
    
    gauge(round(last(getStyle(database[Ticker== tic(),], valueFields, growthFields)$Value) * 100, 2),
          min = 0, max = 100, symbol = '%',
          gaugeSectors(success= c(70, 100),
                       warning= c(30,  70),
                       danger=  c( 0,  30)))
    
    })
```

```
## function (...) 
## {
##     if (length(outputArgs) != 0 && !hasExecuted$get()) {
##         warning("Unused argument: outputArgs. The argument outputArgs is only ", 
##             "meant to be used when embedding snippets of Shiny code in an ", 
##             "R Markdown code chunk (using runtime: shiny). When running a ", 
##             "full Shiny app, please set the output arguments directly in ", 
##             "the corresponding output function of your UI code.")
##         hasExecuted$set(TRUE)
##     }
##     if (is.null(formals(origRenderFunc))) 
##         origRenderFunc()
##     else origRenderFunc(...)
## }
## <environment: 0x0000000023c7b420>
## attr(,"class")
## [1] "shiny.render.function" "function"             
## attr(,"outputFunc")
## function (outputId, width = "100%", height = "200px") 
## {
##     htmlwidgets::shinyWidgetOutput(outputId, "gauge", width, 
##         height, package = "flexdashboard")
## }
## <environment: namespace:flexdashboard>
## attr(,"outputArgs")
## list()
## attr(,"hasExecuted")
## <Mutable>
##   Public:
##     clone: function (deep = FALSE) 
##     get: function () 
##     set: function (value) 
##   Private:
##     value: FALSE
```

### Growth Style

```r
# render Gauges
renderGauge({
    
    gauge(round(last(getStyle(database[Ticker== tic(),], valueFields, growthFields)$Growth) * 100, 2),
          min = 0, max = 100, symbol = '%',
          gaugeSectors(success= c(70, 100),
                       warning= c(30,  70),
                       danger=  c( 0,  30)))
    
    })
```

```
## function (...) 
## {
##     if (length(outputArgs) != 0 && !hasExecuted$get()) {
##         warning("Unused argument: outputArgs. The argument outputArgs is only ", 
##             "meant to be used when embedding snippets of Shiny code in an ", 
##             "R Markdown code chunk (using runtime: shiny). When running a ", 
##             "full Shiny app, please set the output arguments directly in ", 
##             "the corresponding output function of your UI code.")
##         hasExecuted$set(TRUE)
##     }
##     if (is.null(formals(origRenderFunc))) 
##         origRenderFunc()
##     else origRenderFunc(...)
## }
## <environment: 0x000000000410e488>
## attr(,"class")
## [1] "shiny.render.function" "function"             
## attr(,"outputFunc")
## function (outputId, width = "100%", height = "200px") 
## {
##     htmlwidgets::shinyWidgetOutput(outputId, "gauge", width, 
##         height, package = "flexdashboard")
## }
## <environment: namespace:flexdashboard>
## attr(,"outputArgs")
## list()
## attr(,"hasExecuted")
## <Mutable>
##   Public:
##     clone: function (deep = FALSE) 
##     get: function () 
##     set: function (value) 
##   Private:
##     value: FALSE
```


Row {data-height=800}
-----------------------------------------------------------------------

### histo price


```r
#plot histo chart
renderPlotly({
    
    dat <- database[Short_Name == input$secName, .(Date, Px_Last)]
    
    dat[, ':=' (Rsi5=   RSI(Px_Last, n=5,  maType="EMA", wilder=TRUE),
                Rsi9=   RSI(Px_Last, n=9,  maType="EMA", wilder=TRUE),
                Rsi14=  RSI(Px_Last, n=14, maType="EMA", wilder=TRUE),
                Rsi20=  RSI(Px_Last, n=20, maType="EMA", wilder=TRUE))]
    
    p6 <-  # plot line & smooth Px_Last
        ggplot(dat, aes(Date, Px_Last)) +
        geom_line() +
        geom_smooth()
    
    p7.1 <-  # Plot RSI 5/9/14/20
        ggplot(data= dat, mapping=aes(x=Date, y=Rsi20)) +
        geom_line() + geom_smooth() +
        geom_hline(aes(yintercept= quantile(Rsi20, 0.9, na.rm= TRUE)), colour="orangered3", size=0.2) +
        geom_ribbon(aes(ymin= quantile(Rsi20, 0.9, na.rm= TRUE),
                        ymax= ifelse(Rsi20 > quantile(Rsi20, 0.9, na.rm= TRUE),
                                     Rsi20,
                                     quantile(Rsi20, 0.9, na.rm= TRUE))),
                    fill="orangered3") +
        geom_hline(aes(yintercept= quantile(Rsi20, 0.1, na.rm= TRUE)), colour="green3", size=0.2) +
        geom_ribbon(aes(ymin= ifelse(Rsi20 < quantile(Rsi20, 0.1, na.rm= TRUE),
                                     Rsi20,
                                     quantile(Rsi20, 0.1, na.rm= TRUE)),
                        ymax= quantile(Rsi20, 0.1, na.rm= TRUE)),
                    fill="green3") +
        labs(y="Rsi 20")
    
    p7.2 <-  # Plot RSI 5/9/14/20
        ggplot(data= dat, mapping=aes(x=Date, y=Rsi5)) +
        geom_line() + geom_smooth() +
        geom_hline(aes(yintercept= quantile(Rsi5, 0.9, na.rm= TRUE)), colour="orangered3", size=0.2) +
        geom_ribbon(aes(ymin= quantile(Rsi5, 0.9, na.rm= TRUE),
                        ymax= ifelse(Rsi5 > quantile(Rsi5, 0.9, na.rm= TRUE),
                                     Rsi5,
                                     quantile(Rsi5, 0.9, na.rm= TRUE))),
                    fill="orangered3") +
        geom_hline(aes(yintercept= quantile(Rsi5, 0.1, na.rm= TRUE)), colour="green3", size=0.2) +
        geom_ribbon(aes(ymin= ifelse(Rsi5 < quantile(Rsi5, 0.1, na.rm= TRUE),
                                     Rsi5,
                                     quantile(Rsi5, 0.1, na.rm= TRUE)),
                        ymax= quantile(Rsi5, 0.1, na.rm= TRUE)),
                    fill="green3") +
        labs(y="Rsi 5")
    
    subplot(p6, p7.1, p7.2, nrows=3, shareX= TRUE, heights= c(0.7, 0.15, 0.15))
    
    })
```

```
## function (...) 
## {
##     if (length(outputArgs) != 0 && !hasExecuted$get()) {
##         warning("Unused argument: outputArgs. The argument outputArgs is only ", 
##             "meant to be used when embedding snippets of Shiny code in an ", 
##             "R Markdown code chunk (using runtime: shiny). When running a ", 
##             "full Shiny app, please set the output arguments directly in ", 
##             "the corresponding output function of your UI code.")
##         hasExecuted$set(TRUE)
##     }
##     if (is.null(formals(origRenderFunc))) 
##         origRenderFunc()
##     else origRenderFunc(...)
## }
## <environment: 0x0000000005a82188>
## attr(,"class")
## [1] "shiny.render.function" "function"             
## attr(,"outputFunc")
## function (outputId, width = "100%", height = "400px") 
## {
##     htmlwidgets::shinyWidgetOutput(outputId, "plotly", width, 
##         height, package = "plotly")
## }
## <environment: namespace:plotly>
## attr(,"outputArgs")
## list()
## attr(,"hasExecuted")
## <Mutable>
##   Public:
##     clone: function (deep = FALSE) 
##     get: function () 
##     set: function (value) 
##   Private:
##     value: FALSE
```


Row {data-height=250}
-----------------------------------------------------------------------

### rating


```r
renderPlotly({
    
    res <- strats$rating[Ticker == tic()][
            strats$grade[Ticker == tic()]][
            strats$scoring[Ticker== tic(), 
                           .(Date, Ticker, Ranking, RankingGics)]]
    
    ggplot(res) + aes(x= Date) +
        geom_line(aes(y= Rating, color="rating")) +
        geom_line(aes(y= Grade,  color="grade")) +
        aes(ylab= "Rating", ymin= 1, ymax= max(Rating)) +
        scale_y_reverse(breaks= 1:7, name="Rating") +
        theme(legend.position= c(.8, 0.3))
    
    })
```

```
## function (...) 
## {
##     if (length(outputArgs) != 0 && !hasExecuted$get()) {
##         warning("Unused argument: outputArgs. The argument outputArgs is only ", 
##             "meant to be used when embedding snippets of Shiny code in an ", 
##             "R Markdown code chunk (using runtime: shiny). When running a ", 
##             "full Shiny app, please set the output arguments directly in ", 
##             "the corresponding output function of your UI code.")
##         hasExecuted$set(TRUE)
##     }
##     if (is.null(formals(origRenderFunc))) 
##         origRenderFunc()
##     else origRenderFunc(...)
## }
## <environment: 0x000000000d0e4c00>
## attr(,"class")
## [1] "shiny.render.function" "function"             
## attr(,"outputFunc")
## function (outputId, width = "100%", height = "400px") 
## {
##     htmlwidgets::shinyWidgetOutput(outputId, "plotly", width, 
##         height, package = "plotly")
## }
## <environment: namespace:plotly>
## attr(,"outputArgs")
## list()
## attr(,"hasExecuted")
## <Mutable>
##   Public:
##     clone: function (deep = FALSE) 
##     get: function () 
##     set: function (value) 
##   Private:
##     value: FALSE
```

### ranking


```r
renderPlotly({
    
    res <- strats$rating[Ticker == tic()][
            strats$grade[Ticker == tic()]][
            strats$scoring[Ticker== tic(), 
                           .(Date, Ticker, Ranking, RankingGics)]]
    
    ggplot(res, aes(x=Date)) +
        geom_line(aes(y=Ranking, colour="univer")) +
        geom_line(aes(y=RankingGics, colour="sector")) +
        aes(ylab= "Ranking",
            ymin= min(floor(min(RankingGics)   / 0.05) * 0.05,
                      floor(min(Ranking)       / 0.05) * 0.05),
            ymax= max(ceiling(max(RankingGics) / 0.05) * 0.05,
                      ceiling(max(Ranking)     / 0.05) * 0.05)) + 
        theme(legend.position= c(.8, 0.3))
    
    })
```

```
## function (...) 
## {
##     if (length(outputArgs) != 0 && !hasExecuted$get()) {
##         warning("Unused argument: outputArgs. The argument outputArgs is only ", 
##             "meant to be used when embedding snippets of Shiny code in an ", 
##             "R Markdown code chunk (using runtime: shiny). When running a ", 
##             "full Shiny app, please set the output arguments directly in ", 
##             "the corresponding output function of your UI code.")
##         hasExecuted$set(TRUE)
##     }
##     if (is.null(formals(origRenderFunc))) 
##         origRenderFunc()
##     else origRenderFunc(...)
## }
## <environment: 0x00000000150390c8>
## attr(,"class")
## [1] "shiny.render.function" "function"             
## attr(,"outputFunc")
## function (outputId, width = "100%", height = "400px") 
## {
##     htmlwidgets::shinyWidgetOutput(outputId, "plotly", width, 
##         height, package = "plotly")
## }
## <environment: namespace:plotly>
## attr(,"outputArgs")
## list()
## attr(,"hasExecuted")
## <Mutable>
##   Public:
##     clone: function (deep = FALSE) 
##     get: function () 
##     set: function (value) 
##   Private:
##     value: FALSE
```


other Page
=======================================================================

Column {data-width=650}
-----------------------------------------------------------------------

### Chart A


```r
renderPlot({
    
    getReturnPlot(dat = getLogReturn(strats$rating, database), dt = "2012-01-31", field = "Rating")
    
    })
```

```
## Error in eval(expr, envir, enclos): could not find function "renderPlot"
```

Column {data-width=350}
-----------------------------------------------------------------------

### Chart B


```r
renderPlot({
    
    getReturnPlot(getLogReturn(strats$scoring, database), "2012-01-31", "Ranking")
    
    })
```

```
## Error in eval(expr, envir, enclos): could not find function "renderPlot"
```

### Chart C


