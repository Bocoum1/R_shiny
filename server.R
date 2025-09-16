
library(shiny)
library(dplyr)      # pour %>%, filter, mutate, count
library(ggplot2)    # pour ggplot
library(lubridate)  # pour year()


# Define server logic required to draw a histogram
function(input, output, session) {

  output$plot_evolution <- renderPlot({
    data_allocine %>%
      filter(genre == input$choix_genre) %>%
      mutate(annee_sortie = year(date_sortie)) %>%
      count(annee_sortie) %>%
      ggplot() +
      geom_line(aes(x = annee_sortie, y = n),color = "blue") +
      labs(
        title = "Évolution du nombre de films par an",
        x = "Année de sortie",
        y = "Nombre de films"
      ) +
      theme_minimal()
  })
}
