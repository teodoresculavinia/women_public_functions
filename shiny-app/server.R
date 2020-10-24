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

})
