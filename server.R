#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ngram)
library(stringr)
# Set up Functions

# Function comprised of smaller functions that will clean text and use appropriate backoff method 
# depending on the amount of words user has entered.
makePrediction<- function(str) {
        text <- cleanInput(str)
        findLocations(text)
}

# Function that cleans user Input
cleanInput<- function(str) {
        
        # Get Length of user input string
        len <- sapply(strsplit(str, " "), length)
        
        # If user accidentally/sneakily added nothing, return error.
        if(len == 0) {
                print("Please enter some text.")
                
        }
        
        # If the user entered a phrase with more words than ngram size, cut off
        # beginning words, clean text and proceed
        else if(len > 3) {
                subtract <- len - 2
                str <- word(str, subtract, -1)
                str <- preprocess(str, case ="lower", remove.punct = TRUE)
                str <- paste("^", str,sep="")
        }
        
        # If the user entered a phrase with less words than ngram size, clean text 
        # and proceed
        else {
                str <- preprocess(str, case ="lower", remove.punct = TRUE)
                str <- paste("^", str,sep="") 
        }
        
        # Return cleaned user input which is ready for analysis
        return(str)
}

# Function that finds
findLocations <- function(str) {
        
        # Get length of user entered phrase'
        len <- sapply(strsplit(str, " "), length)
        
        # First check to see what ngram to use and then
        # loop until iteration with locations returned'
        if(len == 3){
                locations <- grep(str, quadrigram)
                empty <- length(locations) == 0
        }
        else if(len == 2){
                locations <- grep(str, trigram)
                empty <- length(locations) == 0
        }
        else if(len == 1){
                locations <- grep(str, bigram)
                empty <- length(locations) == 0
        }
        else{
                print("Text not long enough/no text detected")
        }
        
        #If matches are found, return locations and phrase
        #Later will call different function
        #else, remove word from beginning of phrase and recursively check again
        if (len == 0) {
                print("No matches were found.")
        }
        else if (empty == FALSE){
                #print(concatenate(str, len, locations))
                getPredictions(len, head(locations, 10))
        }
        else {
                str <- word(str, 2, -1)
                str <- cleanInput(str)
                findLocations(str)
        }
}

getPredictions <- function(len, locations)  {
        if(len == 3){
                j = 1
                for (i in locations) {
                        gram <- quadrigram[i]
                        gram <- tail(strsplit(gram,split=" ")[[1]],1)
                        print(concatenate("Prediction ", j, ": ", gram))
                        j = j + 1
                }
        }
        else if(len == 2){
                j = 1
                for (i in locations) {
                        gram <- trigram[i]
                        gram <- tail(strsplit(gram,split=" ")[[1]],1)
                        print(concatenate("Prediction ", j, ": ", gram))
                        j = j + 1
                }
        }
        else if(len == 1){
                j = 1
                for (i in locations) {
                        gram <- bigram[i]
                        gram <- tail(strsplit(gram,split=" ")[[1]],1)
                        print(concatenate("Prediction ", j, ": ", gram))
                        j = j + 1
                }
        }
        else {
                print("Cannot predict")
        }
}

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
        
        #Store reactive values
        usr_text <- reactive({input$usr_text})
        
        #Outputs
        output$value <- renderPrint({makePrediction(usr_text())})
        
})
