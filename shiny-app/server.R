#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


x <- readRDS(file = "data/ILO_LFP.rds")
post_comm_list <- readRDS(file = "data/post_comm_list.rds")
employment_sex_sector <- readRDS(file = "data/employment_sex_sector.rds")
graph_1 <- readRDS(file = "data/graph_1.rds")
average_employment <- readRDS(file = "data/average_employment.rds")
world_simple_employment <- readRDS(file = "data/world_simple_employment.rds")
world_simple_timeline <- readRDS(file = "data/world_simple_timeline.rds")
comm_year <- readRDS(file = "data/comm_year.rds")
wrld_simpl <- readRDS(file = "data/wrld_simpl.rds") 
gender_health_graph <- readRDS(file = "data/gender_health_graph.rds") 


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$senatePlot <- renderPlot({

    
      x %>%
        rename("female_labor" = `Labor force participation rate, female (% of female population ages 15+) (modeled ILO estimate)`) %>%
        
        # The initial column title is to long and I can't seem to be able to put
        # it on two lines because rename() stops working.
        
        group_by(Entity) %>%
        summarize(avg = mean(female_labor), .groups = "drop") %>%
        filter(str_detect(Entity, "^B")) %>%
        
        # This filters the Entity column to find all names that start with a
        # capital B. str_detect is part of the stringr package.
        
        ggplot(mapping = aes(x = reorder_within(Entity, within = avg, 
                                                by = avg), y = avg, 
                             fill = avg)) +
        geom_col() +
        scale_x_reordered() +
        theme_linedraw() +
        theme(panel.grid.major = element_line(color = "lightgrey"),
              panel.grid.minor = element_line(color = "lightgrey"),
              panel.background = element_rect(fill = "white"),
              panel.border = element_rect(color = "grey", fill = NA)) +
        theme(axis.text.x = element_text(angle=30)) +
        labs(title = "Women in the Workforce: By country (letter B)", 
             x = "Countries", 
             y = "Percentage of Women in the Workforce", 
             caption = "\n  \n Source: Inter-Parliamentary Union",
             fill = "Percentage") 
      
      # This is a combination of themes that I did in the past and really
      # enjoyed, so decided to copy it here as well. reorder_withing and
      # scale_x_reorder helped me reorger values n the x axis based on the
      # values on the y axis.

    })
    
    output$map_employment <- renderLeaflet({
      
      binpal <- colorBin("Reds", world_simple_employment$mean_percentage_total, 
                         9, 
                         pretty = FALSE)
      
      map_employment <- leaflet(world_simple_employment) %>%
        addPolygons(stroke = FALSE, smoothFactor = 1, fillOpacity = 1,
                    color = ~binpal(mean_percentage_total)) %>%
        addProviderTiles(providers$CartoDB.Positron)
      map_employment
      
    })
    
    output$parliamentPlot <- renderPlot({
      
      post_comm_list %>%
        rename("year" = 'year...1') %>%
        filter(year == 2018) %>%
        ggplot(aes(x = reorder_within(country, womenpar, womenpar), y = womenpar, color = post_comm)) +
        geom_point() +
        facet_wrap(~post_comm, drop = TRUE, scales = "free_x") +
        scale_x_reordered() +
        theme_linedraw() +
        theme(panel.grid.major = element_line(color = "lightgrey"),
              panel.grid.minor = element_line(color = "lightgrey"),
              panel.background = element_rect(fill = "white"),
              panel.border = element_rect(color = "grey", fill = NA)) +
        scale_color_discrete(name = "Communist Status", 
                             labels = c("Never Communist", "Post-Communist"))+
        labs(title = "Women in Parliament: Never Communist v. Post- Communist Countries", 
             x = "OECD Countries", 
             y = "Percentage of Women in Parliament", 
             caption = "\n  \n Source: CPDS") +
        theme(axis.text.x = element_text(angle = 30))

      
    })
    
    output$parliament2Plot <- renderPlot({
      
      
      post_comm_list %>%
        rename("year" = 'year...1') %>%
        filter(year == 2018) %>%
        ggplot(aes(x = post_comm, y = womenpar, color = post_comm)) +
        geom_boxplot() +
        scale_x_reordered() +
        theme_linedraw() +
        theme(panel.grid.major = element_line(color = "lightgrey"),
              panel.grid.minor = element_line(color = "lightgrey"),
              panel.background = element_rect(fill = "white"),
              panel.border = element_rect(color = "grey", fill = NA)) +
        scale_color_discrete(name = "Communist Status", 
                             labels = c("Never Communist", "Post-Communist"))+
        labs(title = "Women in Parliament: Never Communist v. Post- Communist Countries", 
             x = "OECD Countries", 
             y = "Percentage of Women in Parliament", 
             caption = "\n  \n Source: CPDS") +
        theme(axis.text.x = element_text(angle=30))})


output$female_employment <- renderPlot({
  
  graph_1 %>%
    filter(Continent_Name %in% input$Continent_User) %>%
    ggplot(aes(x = post_comm, y = female_percentage, color = post_comm)) +
    geom_point() +
    labs(title = "How many women have a job??", 
         x = "Status", 
         y = "Percentage", 
         caption = "\n  \n Source: Inter-Parliamentary Union", 
         fill = "Been Communist?") 
  
})

output$comm_timeline <- renderLeaflet ({
  
#    world_simple_timeline <- wrld_simpl
#    world_simple_timeline@data <- comm_year %>%
#      mutate(communist = ifelse(year_first <= input$Year_User & input$Year_User <= year_last, "yes", "no")) %>%
#      right_join(world_simple_timeline@data, by = "ISO3") %>%
#      mutate(communist = ifelse(is.na(communist), "no", communist))
    
    temp <- comm_year %>%
      distinct(ISO3, .keep_all = TRUE) %>%
      select(ISO3, year_first, year_last) %>%
      mutate(communist = ifelse(year_first <= input$Year_User & year_last >= input$Year_User, "yes", "no"))
    
    world_simple_timeline <- wrld_simpl
    world_simple_timeline@data <- wrld_simpl@data %>%
      left_join(temp, by = "ISO3") %>%
      mutate(communist = ifelse(is.na(communist), "no", communist))
    
    factpal <- colorFactor(c("red", "yellow"), world_simple_timeline$communist)
    map_timeline <- leaflet(world_simple_timeline) %>%
      addPolygons(stroke = FALSE, smoothFactor = 1, fillOpacity = 1,
                  color = ~factpal(communist)) %>%
      addProviderTiles(providers$CartoDB.Positron)
    map_timeline
})

output$female_education <- renderPlot({
  
  gender_health_graph %>%
    ggplot(aes(x = reorder(country, percentage), y = percentage, color = communist)) +
    geom_point() +
    facet_wrap(~health_decision_maker) +
    scale_x_reordered() +
    theme_linedraw() +
    theme(panel.grid.major = element_line(color = "lightgrey"),
          panel.grid.minor = element_line(color = "lightgrey"),
          panel.background = element_rect(fill = "white"),
          panel.border = element_rect(color = "grey", fill = NA)) +
    theme(axis.text.x = element_text(angle = 30)) +
    labs(title = "Who gets to decide a woman's healthcare?", 
         x = "Countries", 
         y = "Percentage of Women whose healtcare is decided", 
         caption = "\n  \n Source: Inter-Parliamentary Union", 
         fill = "Been Communist?") 
  
})

output$tbl_regression <- renderImage({
  
  list(src = 'data/model.png',
       contentType = 'image/png', 
       width = 300, 
       height = 400
  )
  
  
}, deleteFile = FALSE)

})
