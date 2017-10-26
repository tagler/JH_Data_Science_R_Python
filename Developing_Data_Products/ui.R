library(shiny)

# ui.R
shinyUI(pageWithSidebar(
                    # Application Title
                    headerPanel("NFL/NCAA Football Quarterback Passer Rating (QBR) Calculator"),
                    # Input Sidebar Panel
                    sidebarPanel(
                              # NFL or NCAA selection button
                              radioButtons("type", "Football League:", c("NFL" = "NFL", "NCAA" = "NCAA"), inline = TRUE),    
                              # Input Variables 
                              numericInput('attempts', 'Passing Attempts', 100, min = 1, step = 1),
                              numericInput('completions', 'Passing Completions', 50, min = 0, step = 1),
                              numericInput('yards', 'Passing Yards', 500, min = 0),
                              numericInput('tds', 'Passing Touchdowns (TDs)', 5, min = 0, step = 1),
                              numericInput('ints', 'Interceptions (INTs)', 1, min = 0, step = 1),
                              # Submit Button
                              submitButton('Submit')),
                    # Output Main Panel
                    mainPanel(
                              # output tabs
                              tabsetPanel(
                                        # calculator tab
                                        tabPanel("Calculator",
                                                 h3("Entered Values:"),
                                                 textOutput("type_inputValue"),
                                                 textOutput("attempts_inputValue"),
                                                 textOutput("completions_inputValue"),
                                                 textOutput("yards_inputValue"),
                                                 textOutput("tds_inputValue"),
                                                 textOutput("ints_inputValue"),
                                                 h3('Results:'),
                                                 h4('Quarterback Passer Rating:'),
                                                 verbatimTextOutput("qbr_prediction") 
                                                 ),
                                        # documentaton tab
                                        tabPanel("Documentation",
                                                 h3("Quarterback Passer Rating (QPR) Calculator"),
                                                 helpText("This application calculates the quarterback passing rating (QBR) 
                                                  for the National Football League (NFL, Professional) and NCAA (National Collegiate Athletic 
                                                  Association, College) football leagues."),
                                                  helpText("Step 1: Select league"),
                                                  helpText("Step 2: Enter the passing attempts, completions, yards, touchdowns, and interceptions"), 
                                                  helpText("Step 3: Select 'Submit'"),
                                                 helpText("Quarterback passer rating is a sports statistic. It is the measure of the performance of quarterbacks in American football.
                                                  There are two formulas currently in use: one used by the National Football 
                                                  League (NFL) and the other used in NCAA college football. Passer rating is calculated using 
                                                  a player's passing attempts, completions, yards, touchdowns, and interceptions. Since 1973, 
                                                  passer rating has been the official formula used by the NFL to determine its passing leader. 
                                                  Passer rating in the NFL is on a scale from 0 to 158.3. Passing efficiency in NCAA college football 
                                                  is on a scale from -731.6 to 1261.6."),
                                                 HTML("<b>NCAA QBR Equation:</b> <br>
                                                  QBR = a + b + c - d <br>
                                                   a = (yards/attempts) * 8.4 <br>
                                                   b = (tds/attempts) * 330 <br>
                                                   c = (completions/attempts) * 100 <br>
                                                   d = (ints/attempts) * 200 <br> <br>"),
                                                 HTML("<b>NFL QBR Equation:</b> <br>
                                                  QBR = (a + b + c + d) * (100/6) <br>   
                                                   a = ((completions/attempts) - 0.3) * 5 <br>
                                                   b = ((yards/attempts) - 3) * 0.25 <br>
                                                   c = (tds/attempts) * 20 <br>
                                                   d = 2.375 - (ints/attempts) * 25 <br>
                                                   * Note: In NFL QBR equation, a/b/c/d have a min value of 0 and max value of 2.375")
                                                 )
                                        )
                              )
          )
)

