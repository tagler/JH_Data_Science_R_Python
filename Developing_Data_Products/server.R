library(shiny)

# function calculates ncaa qbr with inputs attempts, completions, yards, tds, and ints
qbr_ncaa <- function(attempts, completions, yards, tds, ints) {
          a = (yards/attempts) * 8.4
          b = (tds/attempts) * 330
          c = (completions/attempts) * 100
          d = (ints/attempts) * 200
          (a + b + c - d)
}

# function calculates nfl qbr with inputs attempts, completions, yards, tds, and ints
qbr_nfl <- function(attempts, completions, yards, tds, ints) {
          a = max(0, min(((completions/attempts) - 0.3) * 5, 2.375))
          b = max(0, min(((yards/attempts) - 3) * 0.25, 2.375))
          c = max(0, min((tds/attempts) * 20, 2.375))
          d = max(0, min(2.375 - ((ints/attempts) * 25), 2.375))
          (a + b + c + d) * (100/6)
}

## shiny server server.R
shinyServer(
          # input and outputs from ui.R
          function(input, output) {
                    # output inputs for testing 
                    output$type_inputValue <- renderText({paste("Football League:", input$type)})   
                    output$attempts_inputValue <- renderText({paste("Passing Attempts:", input$attempts)})
                    output$completions_inputValue <- renderText({paste("Passing Completions:", input$completions)})
                    output$yards_inputValue <- renderText({paste("Passing Yards:", input$yards)})
                    output$tds_inputValue <- renderText({paste("Passing Touchdowns (TDs):", input$tds)})
                    output$ints_inputValue <- renderText({paste("Interceptions (INTs):", input$ints)})            
                   # reactive conditional to select nfl or ncaa based on radio button type 
                   qbr_rating <- reactive({ 
                             if (input$type == "NFL") {
                                        qbr_nfl(input$attempts, 
                                                input$completions, 
                                                input$yards, 
                                                input$tds, 
                                                input$ints) 
                              } else if (input$type == "NCAA") {
                                        qbr_ncaa(input$attempts, 
                                                 input$completions, 
                                                 input$yards, 
                                                 input$tds, 
                                                 input$ints)
                              }
                    })
                    # output results
                    output$qbr_prediction <- renderText({qbr_rating()}) 
          }
)
