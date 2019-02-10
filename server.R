#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
if (!require("shiny")) install.packages("shiny")
if (!require("dice")) install.packages("dice")

library(shiny)
library(dice)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
  probs <- reactive({return(getSumProbs(input$num, as.integer(input$dmg), sumModifier = input$add))})
  output$min <- reactive({input$num + input$add})
  output$max <- reactive({input$num * as.integer(input$dmg) + input$add})
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    #x    <- rolldice(input$num, as.integer(input$dmg), input$add)
    #probs <- getSumProbs(input$num, as.integer(input$dmg), sumModifier = input$add)
   # bins <- seq(min(x), max(x), length.out = input$bins + 1)
    min <- input$num + input$add
    max <- input$num * as.integer(input$dmg) + input$add
    bars = min:max
    colors = c('red', 'green')[(bars >= input$threshold) + 1]
    # draw the histogram with the specified number of bins
    barplot(probs()$probabilities[,2], names.arg=probs()$probabilities[,1], col = colors, border = 'white', xlab='Total', 
            ylab='Probability', main=paste('Predicted Roll Total for ', input$num, 'd', input$dmg, '+', input$add, sep=''))
    legend("topright", legend=c("Success", "Failure"), fill=c("green", "red"))
    
  })
  output$prob <- renderText({paste('Probability of Success:', 
                                   round(sum(probs()$probabilities[probs()$probabilities[,1] >= input$threshold, 2]), digits=3))})
  output$expected <- renderText({paste('Avg Total:', probs()$average)})
  
})

## Function for simulating 4000 dice rolls, used for estimating probabilities
rolldice <- function(num=1, dmg=20, add=0) {
    roll <- sample(1:dmg, size=4000, replace = TRUE)
    i = 2
    while(i <= num){
        roll <- roll + sample(1:dmg, size=4000, replace = TRUE)
        
        i <- i + 1
    }
    return(roll + add)
}

## Creates histogram and returns % success
probroll <- function(num=1, dmg=20, add=0, threshold=10) {
    rolls <- rolldice(num, dmg, add)
    hist(rolls, main= paste(num, 'd', dmg, '+', add, ' Rolls', sep =""))
    abline(v=threshold, col='red')
    num_rolls <- length(rolls)
    num_success <- length(which(rolls >= threshold))
    return(num_success / num_rolls)
}
