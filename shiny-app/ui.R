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
                                              value = 2000)), 
                       mainPanel(leafletOutput("comm_timeline")))
                  
                   ),
               # You would add your content within the parentheses above.
               tabPanel(
                   "Employment",
                   titlePanel("Percentage of Women in Senate in Countries 
                              begining with 'B'"),
                #   tags$style(
                #       type = "text/css",
                #       ".shiny-output-error {display: none;}",
                #       ".shiny-output-error:before {display: none;}"
                #   ),
                   sidebarLayout(
                       sidebarPanel(
                           checkboxGroupInput(inputId = "Continent_User", 
                                       label = "Continent", 
                                       choices = c("Africa" = "Africa", 
                                                   "Asia" = "Asia", 
                                                   "Europe" = "Europe"), 
                                       # multiple = TRUE, 
                                       selected = c("Africa", "Asia", "Europe"))), 
                       mainPanel(plotOutput("female_employment"))),
                   leafletOutput("map_employment"),
                   plotOutput("senatePlot"),
                   p("This is a sample data plot that shows how widely the 
                     percentage of women in the workforce differs around the 
                     globe. For this specific plot, I just selected all the 
                     countries that start with the letter 'B'. In our senario, 
                     we can see Burundi, with over 80% of women beng in the 
                     workforce, as opposed to Bangladesh, where just over 20 %
                     are"),
                  p("My dataset doesn't contain all the informations necessary 
                    so in the future I will select only women who work in public
                    jobs, and divide the graphs by post-communist and never
                    communist. I am still gathering and cleaning that data.")), 
                  
                  tabPanel(
                    "Healthcare",
                    plotOutput("Healthcare access"),
                    p("This dataset shows the difference in percentage of women
                      in Parliament in different countries that are part of the 
                      OECD. The first graph shows the countries that have never
                      been communist, while the second one shows countries that 
                      have been Communist in the past", 
                    p("No post-communist country has a percentage of women of 
                      over 35%. That is counter-intuitive to what I expected, 
                      as one of the principle of communism is gender equality
                      in the workforce"))), 

                tabPanel(
                  "Education",
                  plotOutput("parliament2Plot"),
                  p("This dataset, similarly to the one in the previous tab, shows 
                    the difference in Europe in percentage of women in public jobs
                    in Western (never Communist) vs. Eastern (post Communist) countries")) 
                    

    ))
    
  