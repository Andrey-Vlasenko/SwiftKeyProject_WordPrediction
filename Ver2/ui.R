
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(stringr)
library(textshape)
library(tm)
library(NLP)


shinyUI(fluidPage(
  titlePanel("SwiftKeyProject Word Prediction Ver 2.0"),
  h4("Data Science Coursera Capstone Project"),
  sidebarLayout(
    sidebarPanel(
      h2("Next Word Prediction App"),
      em("This app makes a prediction of the next word in the last input sentence. 
It based on the entered words using n-grams model (n=2..5).   
         It takes into account 4 - 1 last words (swearwords, numbers, URLs, emails and hashtags are ignored)."),
      textInput("text", label = h3("Enter your text here:"), value = ),
      submitButton("Submit"),
      h6("Note: The word prediction model only supports phrases/words in english"),
      h6("P.S.: Avg.Accuaracy in predicting the next word is about 0.37 and the P('the next word in the list of variants') is about 0.47. 
         Avg.Time of prediction is about 0.4 sec (for model)")
    ),
    mainPanel(
      h4("Phrase you entered:"),
      em(textOutput("enteredWords", h5, strong("bold"))), br(), 
      h4("Predicted next word:"),
      div(textOutput("predictedWord", h4, strong("bold")), style="color:blue"),
      h4("Next word variants:"),
      div(textOutput("predictedWordVars", h4, strong("bold")), style="color:green"), br(),
      h5("Total number of Keys:"),  
      textOutput("TotalKeys", h6, strong("bold")),
      h5("Current searching Key:"),
      textOutput("CurrentKey", h6, strong("bold")),
      h5("Finded variants of Keys:"),
      textOutput("FindedKeys", h6, strong("bold")), br(), 
      h4("Links:"),
      tags$a(href = "http://rpubs.com/Andrey_Vlasenko/WordPredictionTesting", 
             "1. Testing of this prediction model (results)"), br(), 
      tags$a(href = "http://rpubs.com/Andrey_Vlasenko/SwiftKey_WordPredictionVer2", 
             "2. Presentation"), br(), 
      tags$a(href = "https://github.com/Andrey-Vlasenko/SwiftKeyProject_WordPrediction/Ver2", 
             "3. GitHub directory") 
    )
  )
))
