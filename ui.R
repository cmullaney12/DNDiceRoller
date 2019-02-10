#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
if (!require("shiny")) install.packages("shiny")

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("DnD Dice Calculator"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       numericInput("num", "Number of Dice:", 1, min = 1, max = 20),
       selectInput("dmg", "Dice Type:", c(4, 6, 8, 10, 12, 20), 8, multiple = FALSE),
       numericInput("add", "Flat Bonus:", 0, min = 0), 
       numericInput("threshold", "Desired Total:", 4, min = 0),
       textOutput("prob"),
       textOutput("expected")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
