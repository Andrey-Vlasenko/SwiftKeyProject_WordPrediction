
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(stringr)
library(textshape)
library(NLP)
library(tm)

X5<-readRDS("X5.rds")
names(X5) <- c("Key","NextWord","Frequency")
X5 <- X5[,-3]

X4<-readRDS("X4.rds")
names(X4) <- c("Key","NextWord","Frequency")
X4 <- X4[,-3]

X3<-readRDS("X3.rds")
names(X3) <- c("Key","NextWord","Frequency")
X3 <- X3[,-3]

X2<-readRDS("X2.rds")
names(X2) <- c("Key","NextWord","Frequency")
X2 <- X2[,-3]

DropWords<-readRDS("DropWords.rds")

CleaningData <- function(x) {
  x <- gsub('#[a-zA-z0-9]+', ' ', x)  # remove hashtags
  x <- gsub('[a-zA-Z_.-]*@[a-zA-Z_.-]+.[a-zA-Z]{2,4}', ' ', x) # remove emails
  
  x <- tolower(x)
  x <- removeWords(x, DropWords) # remove swearwords
  
  x <- gsub('[0-9]+.[0-9]+', ' ', x) # remove decimal numbers so that the "." is not tne end of a sentence
  x <- gsub('[[:digit:]]+', ' ', x) # remove all digits
  
  x <- gsub('[])(;:#%$^*\\~{}[&+=@/"`\'|<>_,-]+', '', x) # remove special characters
  x <- gsub('http[^[:space:]]*', ' ', x) # remove URLs
  
  #  x <- gsub('\\b[A-z]\\b{1}', ' ', x) # remove single character words
  x <- gsub('\\s+', ' ', str_trim(x)) # remove multiple spaces and blank spaces at the beginning and end of all input
  
  x <- unlist(split_sentence(x)) # split to sentences
  
  x <- gsub('[.!?]+', ' ', x) # remove punctuation
  
  x <- gsub('\\W+', ' ',x)  # remove non characters
  #  x <- gsub("[^\x01-\x7F]+", '', x) # remove non-Endlish characters
  
  #  x <- gsub('\\b[A-z]\\b{1}', ' ', x) # remove single character words
  x <- gsub('\\s+', ' ', str_trim(x)) # remove multiple spaces and blank spaces at the beginning and end of all input
  
  x <- x[x!=""] # remove empty sentences
  #  x <- x[grepl(" ",x)] # remove sentences with only one meaning word
  return(x)
}

PreCleanKey <- function(x) {
  t <- CleaningData(x)
  x <- t[length(t)]
  rm(t)
  x <- gsub(' ', '_', x,fixed = TRUE)
  #  KeyM <- stringr::str_split(x,"_")[[1]]
  #  key0 = paste(KeyM[(m-3):m],sep = "_",collapse = "_")
  tolower(x)
}

Predict_Word <- function(key,nWords=5){
  t <- data.frame()
  #key="new york city is"
  Key0 <- PreCleanKey(key)
  if (length(Key0)>0){
    KeyM <- stringr::str_split(Key0,"_")[[1]]
    m <- length(KeyM)
    key2="";key3="";key4="";key5="";
    
    if (m>=4) {
      key5 = paste(KeyM[(m-3):m],sep = "_",collapse = "_")
    }
    if (m>=3) {
      key4 = paste(KeyM[(m-2):m],sep = "_",collapse = "_")
    }
    if (m>=2) {
      key3 = paste(KeyM[(m-1):m],sep = "_",collapse = "_")
    }
    if (m>=1) {
      key2 = KeyM[m]
    }
    #t <- X[(X$Key==key5)|(X$Key==key4)|(X$Key==key3)|(X$Key==key2),]
    t <- rbind(X5[X5$Key==key5,],X4[X4$Key==key4,],X3[X3$Key==key3,],X2[X2$Key==key2,])
    #    if (dim(t)[1]>0) { return(t$Next[1])
    #    } else { return("not found")}
    #  } else {     return("Only swearwords in request or empty request")   }
    list(t$NextWord[1],unique(t$Key),unique(t$NextWord))
  } else {list("Empty request","","")}
}

shinyServer(function(input, output) {

  Prediction <- reactive({Predict_Word(input$text)})
  output$CurrentKey <- renderPrint(PreCleanKey(input$text))
  output$enteredWords <- renderText({input$text}, quoted = FALSE)
  output$TotalKeys <- renderPrint((dim(X2)[1]+dim(X3)[1]+dim(X4)[1]+dim(X5)[1]))
  
  output$predictedWord <- renderText(paste(Prediction()[1][[1]]))
  output$predictedWordVars <- renderText(Prediction()[3][[1]])
  output$FindedKeys <- renderPrint(paste(Prediction()[2][[1]]))

})
