#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(shinythemes)
library(stringr)

# Define UI for application that draws a histogram
shinyUI(
    navbarPage(theme = shinytheme("flatly"),
        "Women in Public Functions (Post Communist v. non-Communist countries",
               tabPanel(
                   "About",
                   p("add my info here"), 
                   p(a("Link to my repo:", 
                       href = "https://github.com/teodoresculavinia/women_public_functions"))
                  
                   ),
               # You would add your content within the parentheses above.
               tabPanel(
                   "Data",
                   plotOutput("senatePlot"),
                   p("add my info here")
          
               )
    ))


