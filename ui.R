

library(shiny)

# Define UI for application that draws a histogram
fluidPage(

  # Titre de l’application
  titlePanel("Application Allociné"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("choix_genre", "Choix du genre :",
                  choices = unique(data_allocine$genre))
    ),
    
    mainPanel(
      plotOutput("plot_evolution")
    )
  )
)
