# libraries 
library(shiny)
library(data.table)
library(stylo)
library(wordcloud)
library(RColorBrewer)
library(ggplot2)
library(grid)
library(scales)

# load prediction function: text_predict() and text_return()
source("model.R")

# shiny server function 
shinyServer(
          function(input, output, session) {        
                    # process input
                    output$input_value <- renderText({ text_return(input$text_input) })
                    # prediction 
                    output$prediction_best <- renderText({ text_predict(input$text_input)[1]$WORD })
                    # data table
                    output$mytable <- renderDataTable({ RANK <- c(1,2,3,4,5,6,7,8,9,10)
                                                        datatable <- head( text_predict(input$text_input), 10)
                                                        table <- cbind(RANK, datatable)
                                                        table},  options = list( pageLength = 10,
                                                                                          paging = FALSE,
                                                                                          searching = FALSE) )
                    # plot
                    output$myplot <- renderPlot({
                              data <- text_predict(input$text_input)[1:10]
                              data$P2 <- round(data$P, 3)
                              plot <- ggplot(data, aes(x=reorder(WORD,P), y=P, fill=P) ) +
                                        geom_bar(stat='identity', alpha=0.9) +
                                        coord_flip() +
                                        labs(y = "\n P, Probability Score") +
                                        labs(x = "Word") +
                                        scale_fill_gradient2(high = '#08519c') +
                                        theme_minimal(base_size = 15) +
                                        guides(fill=FALSE) +
                                        theme(axis.ticks.x=element_blank()) +
                                        theme(axis.ticks.y=element_blank()) +
                                        theme(panel.grid.major.y = element_blank()) +
                                        theme(panel.grid.major = element_line(color = "black")) +
                                        geom_text(aes(label=P2), hjust=-0.1 ,vjust=0.4) +
                                        theme(plot.margin = unit(c(0.5,2,0.5,0.5), "cm")) 
                              gt <- ggplot_gtable(ggplot_build(plot))
                              gt$layout$clip[gt$layout$name == "panel"] <- "off"
                              grid.draw(gt)
                              })
                    
                    # wordcloud
                    output$wordcloud <- renderPlot({ wordcloud( text_predict(input$text_input)$WORD, 
                                                                text_predict(input$text_input)$P, 
                                                                max.words=100, 
                                                                random.order=FALSE,
                                                                scale=c(5,0.75),
                                                                colors=brewer.pal(5,"Dark2") ) 
                                                     })
               
          }
)
