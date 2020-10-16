#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


x <- readRDS(file = "data/ILO_LFP.rds")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$senatePlot <- renderPlot({

    
        x %>%
            rename("female_labor" = `Labor force participation rate, female (% of female population ages 15+) (modeled ILO estimate)`) %>%
            group_by(Entity) %>%
            summarize(avg = mean(female_labor), .groups = "drop") %>%
            filter(str_detect(Entity, "^R")) %>%
            
            ggplot(mapping = aes(x = Entity, y = avg)) +
            geom_point()

    })

})
