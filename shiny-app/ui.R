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
library(tidytext)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(
    
    navbarPage(theme = shinytheme("flatly"),
        "The long-term effect of Communism on women right: Data from communist, 
        post-communist and never-communist countries",
               tabPanel(
                   "About",
                   p("Do post-communist countries have a higher number of women
                     in public jobs?"), 
                   p("My name is Lavinia Teodorescu, and I am originally from a
                     post-communist country: Romania."),
                   p("One of the main premises of Communism is gender equality 
                   - making jobs, education and services equal to everyone. 
                   But living in a post-communist country, I see very few women
                   in public jobs, and even fewer in leadership positions."),
                   p("In this project, I will analyze the differences between 
                   the number of women in public/ government-offered jobs in 
                   post-communist countries v. countries that have never been 
                   communist. What was the situation in 1980 around the globe, 
                   and what is the situation now? Has there been any change 
                   since these countries stopped being communist? My project 
                   will examine these questions, as well as propose some 
                   data-backed answers as to whether communism impacts gender
                    equality in the jobs market"),
                   p(a("Click Here for a link to my Repo", 
                       href = "https://github.com/teodoresculavinia/women_public_functions")), 
                   sidebarLayout(
                       sidebarPanel(
                           sliderInput(inputId = "Year_User", 
                                              label = "Year", 
                                              min = 1900, 
                                                max = 2020, 
                                              # multiple = TRUE, 
                                              value = 2000, 
                                              sep = "")), 
                       mainPanel(leafletOutput("comm_timeline")))
                  
                   ),
               # You would add your content within the parentheses above.
               tabPanel(
                   "Employment",
                   fluidPage(
                       fluidRow(
                           column(2,
                                  " ", 
                                  " ",
                                  " "
                           ),
                           column(8, 
                                  titlePanel("Percentage of Women who are employed"), 
                                  sidebarLayout(
                                      fluidRow(column(2,
                                             sidebarPanel(
                                                 checkboxGroupInput(inputId = "Continent_User", 
                                                             label = "Continent", 
                                                             choices = c("Africa" = "Africa", 
                                                                         "Asia" = "Asia", 
                                                                         "Europe" = "Europe", 
                                                                         "Oceania" = "Oceania", 
                                                                         "South America" = "South America", 
                                                                         "North America" = "North America"), 
                                                             # multiple = TRUE, 
                                                             selected = c("Africa", "Asia", "Europe", 
                                                                          "Oceania", "South America", 
                                                                          "North America")))),
                                             column(6,
                                      mainPanel(plotOutput("female_employment")))))),
                           column(2,
                                  " "
                           )
                       )
                   ),
                   
                #   tags$style(
                #       type = "text/css",
                #       ".shiny-output-error {display: none;}",
                #       ".shiny-output-error:before {display: none;}"
                #   ),
                   
                fluidPage(
                    fluidRow(
                        column(2,
                               " ", 
                               " ",
                               " "
                        ),
                        column(8,
                                p("This is a sample data plot that shows how widely the 
                             percentage of women in the workforce differs around the 
                            globe. For this specific plot, I just selected all the 
                            countries that start with the letter 'B'. In our senario, 
                            we can see Burundi, with over 80% of women beng in the 
                            workforce, as opposed to Bangladesh, where just over 20 %
                            are")), 
                        column(2, 
                               " "))),
                fluidPage(
                    fluidRow(
                        column(2,
                               " ", 
                               " ",
                               " "
                        ),
                        column(8,
                               leafletOutput("map_employment")), 
                        column(2, 
                               " "))),
                fluidPage(
                    fluidRow(
                        column(2,
                               " "
                        ),
                        column(8,
                               titlePanel("Model"),
                               mainPanel(imageOutput("tbl_regression")),
                               p("This graph shows the percentage of women who are employed 
                    in the workforce around the world. The darker colors show a
                    lower percentage of women."))), 
                        column(2, 
                               " "))), 
                  
                  tabPanel(
                    "Healthcare",
                    plotOutput("female_education"),
                    p("This dataset shows the difference in percentage of women
                      that continue education after high school. The countries 
                      are part of the OECD. The first (pink) line  shows the 
                      countries that have never been communist, while the second 
                      one shows countries that 
                      have been Communist in the past", 
                    p("No post-communist country has a percentage of women of 
                      over 35%. That is counter-intuitive to what I expected, 
                      as one of the principle of communism is gender equality
                      in the education"))), 

                tabPanel(
                  "Education",
                  plotOutput("parliament2Plot"),
                  p("This dataset, similarly to the one in the previous tab, shows 
                    the difference in Europe in percentage of women in public jobs
                    in Western (never Communist) vs. Eastern (post Communist) countries"))
                    

    ))
    
  