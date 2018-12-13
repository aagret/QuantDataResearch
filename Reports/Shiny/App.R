library(shiny)
library(data.table)
library(ggplot2)

Ticker <- unique(database$Ticker)
GICS_Sector_Name <- unique(database$GICS_Sector_Name)

ui <- fluidPage(
    
    fluidRow(
        
        column(1, offset= 0, tags$img(src="www/img/Logo_H.jpg", 
                                      height=144, eidth=144)
               ),
        
        column(4, offset= 2,
               wellPanel(
                   radioButtons("type","Choose by Ticker or Sector",
                                c("Ticker" = "Ticker", "Sector" = "GICS_Sector_Name"),
                                inline = TRUE),
                   
                   selectInput("search", label = "", choices = "", width = "80%",
                               selectize = FALSE, size = "1")
                   
               )
        )
    ),
        
    fluidRow(
        
        column(2,
               wellPanel(
                   checkboxGroupInput("field", "Select Field to Graph",
                                      choices= c("Last Price"= "Adj_Px_Last", "Debt/Ebitda"= "Net_Debt_To_Ebitda",
                                                 "Dvd Yield"= "Eqy_Dvd_Yld_Ind", "5y Dvd Growth"= "Geo_Grow_Dvd_Per_Sh",
                                                 "P/E"= "Pe_Ratio", "5y Sales Growth"= "Geo_Grow_Net_Sales",
                                                 "Payout"= "Dvd_Payout_Ratio"),
                                      selected= "Adj_Px_Last",
                                      width= "100%")
               )
               
        ),
        
        column(10, offset= 0,
               
               plotOutput("plot", width = "50%")
               
               )
        ),
    
       
    
        textOutput("check")
    
)
                

server <- function(input, output, session) {
    
    selectField <- reactive({get(input$type)})
    
    #vary <- enventReactive(input$type, {input$search})
    
    db <- reactive({database[get(input$type) == input$search,]})
    
    #fields <- reactive({input$field})
    
    snap <- reactive({securities[get(input$type) == input$search,]})
    
    observe({updateSelectInput(session, "search", label = input$type,
                               choices = selectField())})
    

    
    output$plot <- renderPlot({
        ggplot(db(), aes(x= Date)) +
            geom_line(y= Adj_Px_Last,  colour="blue") +
            geom_line(y= Pe_Ratio, coulour="red") 
        })
    
    output$check   <- renderText({names(db())})

}


shinyApp(ui = ui, server = server)

