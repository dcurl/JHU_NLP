#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(
        
        # App title ----
        titlePanel("JHU NLP Word Prediction Application"),
        
        # Sidebar layout with input and output definitions ----
        sidebarLayout(
                
                # Sidebar panel for inputs ----
                sidebarPanel(
                        h4("How to use this App:"),
                        h6("Step 1: Enter in some text into the textbox below."),
                        h6("Step 2: Please enter in AT LEAST one word."),
                        h6("Step 3: Hit 'Enter' to see predictions."),
                        h6("Note: This application may take a couple seconds to return predictions."),
                        
                        # Input: Textbox for Text ---
                        textInput("usr_text", label = h3("Text input"), value = "Once upon a")
                ),
                
                # Main panel for displaying outputs ----
                mainPanel(
                        
                        # Output: Text ----
                        verbatimTextOutput("value")
                    
                )
        )
)