# Define UI for application
shinyUI(
          fluidPage(
                    # CSS theme 
                    theme = "bootstrap.css",
                    # title
                    headerPanel("Data Science Specialization - Text-Prediction App"),
                    # sidebar 
                    sidebarPanel(
                              # text input
                              textInput("text_input", "Text Input:", 
                                        value = "to be, or not to be: that is the..."),
                              # submit
                              submitButton('Submit'),
                              # loading message
                              hr(), 
                              h4('Instructions:'),
                              p('1. Type in a word or phrase into the "text input" box'),
                              p('2. Click the "submit" button'),
                              p('3. The best next-word prediction will be displayed on the "prediction" tab'),
                              p('4. Select other tabs to view the full prediction "data table", "plot", and "wordcloud"')
                    ),
                    # main panel
                    mainPanel(
                              tabsetPanel(
                                        # prediction panel 
                                        tabPanel("Prediction",
                                                  # repeat text input 
                                                  h3('Processed Text Input:'), 
                                                  verbatimTextOutput("input_value"),
                                                  tags$head(tags$style("#input_value{color: darkblue;
                                                                                         font-weight: bold;
                                                                                         font-size: 16px}")),
                                                  # best prediction 
                                                  h3('Next Word Prediction:'),
                                                  verbatimTextOutput("prediction_best"),
                                                  tags$head(tags$style("#prediction_best{color: green;
                                                                                         font-weight: bold;
                                                                                         font-size: 16px}"))                                                 
                                        ),
                                        # data panel
                                        tabPanel("Data Table",
                                                 # data table
                                                 h3('Data Table: Word Predictions'),
                                                 em('Top 10 Word Predictions vs. Probability Score (0-1, 1 = best)'),
                                                 br(),
                                                 dataTableOutput('mytable')
                                        ),
                                        # plot
                                        tabPanel("Plot",
                                                 # data table
                                                 h3('Plot: Word Predictions'),
                                                 em('Top 10 Word Predictions vs. Probability Score (0-1, 1 = best)'),
                                                 br(), br(),
                                                 plotOutput('myplot',
                                                            height = "400px", width = "600px")
                                        ),
                                        # wordcloud panel
                                        tabPanel("Wordcloud",
                                                 # wordcloud
                                                 h3('Wordcloud: Top 100 Predictions'),
                                                 em('Wordcloud may take a few seconds to load...'),
                                                 br(), br(),
                                                 plotOutput(outputId = "wordcloud", 
                                                            height = "450px", width = "450px")
                                        ),
                                        # about panel
                                        tabPanel("About",
                                                  
                                                  h3('Text-Prediction App, Version 1.0'),
                                                  
                                                  h3('Application Summary'),
                                                  HTML("This application, made specifically for the capstone project of the Johns Hopkins University Data Science Specialization Certificate Program (Coursera), predicts the next word of the user’s text input. This model was developed using 500,000 randomly sampled lines from blogs, news stories, and twitter. A modified Katz Back-Off model was developed using n-word sequences (n-grams) ranging from 2 to 6 words. Frequent n-grams were identified and used to calculate probabilities. Numbers, punctuation, capitalization, and profanity were removed. In addition to the next word, this application displays a prediction data table, plot, and wordcloud."),
                                                 
                                                  h3('Accuracy'),
                                                  p('Accuracy was determined by comparing the predicted word(s) to the observed word in a test data set of 2,500 randomly sampled n-grams. This analysis was repeated 5 times to obtain standard deviation error. These results were significantly better (approximately 10-15%) than a baseline model (most frequent words, 1-grams (i.e. the, to, a)).'),
                                                  HTML("Single Word Prediction Accuracy: 14.8% +/- 0.8% <br>
                                                  Top-3 Words Prediction Accuracy: 24.7% +/- 0.8% <br>
                                                  Top-5 Words Prediction Accuracy: 29.7% +/- 0.7% <br>
                                                  Top-10 Words Prediction Accuracy: 37.6% +/- 0.4% <br>"),
                                                 
                                                  h3('Data'),
                                                  HTML("(1.) Data Source: HC Corpora, corpora.heliohost.org <br>
                                                  (2.) Training Set: US blogs, news, and twitter (500K lines of text) <br> 
                                                  (3.) Removed capital letters, numbers, punctuation, and symbols <br>
                                                  (4.) Profanity words filtered and labeled (PROFANITY_WORD) <br>
                                                  (5.) Tokenized text and created n-grams (n=1,2,3,4,5,6) <br>
                                                  (6.) Created n-gram frequency tables (limited to frequencies > 1) <br>
                                                  (7.) Converted to data.table objects for faster lookup <br>"),
                                                  
                                                  h3('Algorithm'),
                                                  HTML("(1.) Process text input from user (separate into n words) <br>
                                                  (2.) Search (n+1)-gram frequency table for matches <br> 
                                                  (3.) Calculate probabilities of each match (frequency/total) <br>
                                                  (4.) If no matches, search the next lower-order n-gram table <br>
                                                  (5.) If no match in 2-gram table, use most frequent 1-grams <br>
                                                  (6.) Return word with the highest probability score (0-1, 1=best) <br> "),
                          
                                                  h3('Technical'), 
                                                  p('This application was created using R 3.1.3, Rstuido 0.98.1103, and the following R packages: stylo 0.5.9, ggplot2 1.0.1, data.table 1.9.4, wordcloud 2.5, RColorBrewer 1.1-2, and shiny 0.11.1 using a Macbook Pro (2.2 GHz Intel Core 2 Duo 64-Bit Processor, 4 GB RAM) on Mac OS X 10.10.3 (XQuartz 2.7.7).'),
                                                
                                                  h3('References'),
                                                  p('Katz, S. M. (1987). Estimation of probabilities from sparse data for the language model component of a speech recogniser. IEEE Transactions on Acoustics, Speech, and Signal Processing, 35(3), 400–401.'), br(), br()
                                                  
                                        )
                              )
                    )
          )
)

