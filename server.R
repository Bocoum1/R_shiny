
#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
library(ggiraph)
library(ggplot2)
library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {

  data_filtre <- reactive({
    indicateurs %>%
      filter(Ile %in% input$iles)
  })
  
  # ---- ValueBox habitants max ----
  output$box_habitants <- renderValueBox({
    val <- data_filtre() %>% 
      filter(annee == input$annee) %>%
      summarise(max_hab = max(habitants, na.rm = TRUE)) %>%
      pull(max_hab)
    
    valueBox(
      value = format(val, big.mark = " "),
      subtitle = paste("Habitants max en", input$annee),
      icon = icon("users"),
      color = "green"
    )
  })
  
  # ---- ValueBox prix moyen ----
  output$box_prix <- renderValueBox({
    val <- data_filtre() %>% 
      filter(annee == input$annee) %>%
      summarise(moy_prix = mean(prix_m2, na.rm = TRUE)) %>%
      pull(moy_prix)
    
    valueBox(
      value = paste0(round(val), " €"),
      subtitle = paste("Prix moyen au m² (", input$annee, ")", sep = ""),
      icon = icon("euro-sign"),
      color = "yellow"
    )
  })
  
  # ---- ValueBox taux moyen résidences secondaires ----
  output$box_resid <- renderValueBox({
    val <- data_filtre() %>% 
      filter(annee == input$annee) %>%
      summarise(moy_taux = mean(taux_resid, na.rm = TRUE)) %>%
      pull(moy_taux)
    
    valueBox(
      value = paste0(round(val*100,1), " %"),
      subtitle = paste("Résid. secondaires moyennes"),
      icon = icon("home"),
      color = "red"
    )
  })
  
  
  
  
  # ---- Graphique d’évolution ----
  output$plot_evolution <- renderGirafe({
    p <- ggplot(data_filtre(),
                aes(x = annee, y = .data[[input$indicateur]],
                    color = Ile,
                    tooltip = paste(Ile, annee, round(.data[[input$indicateur]], 1)))) +
      geom_col_interactive() +
      labs(title = paste("Évolution de", input$indicateur)) +
      theme_minimal()
    
    girafe(ggobj = p)
  })
  
  
  # ---- Comparaison annuelle ----
  output$plot_comparaison <- renderPlotly({
    p <- data_filtre() %>%
      filter(annee == input$annee) %>%
      ggplot(aes(x = reorder(Ile, .data[[input$indicateur]]),
                 y = .data[[input$indicateur]],
                 fill = Ile,
                 text = paste(Ile, ":", round(.data[[input$indicateur]], 1)))) +
      geom_col() +
      labs(
        title = paste("Comparaison des îles en", input$annee),
        x = "Île", y = input$indicateur
      ) +
      theme_minimal()
    
    ggplotly(p, tooltip = "text")
  })
  
  
  # ---- Tableau ----
  output$tableau <- renderDT({
    data_filtre()
  })
}
