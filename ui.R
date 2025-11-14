
library(DT)  
library(shiny)
library(bslib)


ui <- dashboardPage(
  dashboardHeader(title = "Projet Ponant"),
  # --- Sidebar, navigation  ---
  dashboardSidebar(
    sidebarMenu(
      menuItem("Évolution", tabName = "evolution", icon = icon("chart-line")),
      menuItem("Comparaison", tabName = "comparaison", icon = icon("chart-bar")),
      menuItem("Données", tabName = "donnees", icon = icon("table"))
    )
  ),
  
  # --- Contenu principal ---
  dashboardBody(
    fluidRow(
      valueBoxOutput("box_habitants"),
      valueBoxOutput("box_prix"),
      valueBoxOutput("box_resid")
    ),
    tabItems(
      
      # Onglet Évolution
      tabItem(tabName = "evolution",
              girafeOutput("plot_evolution"),
              hr(),
              box(width = 12, title = "Filtres Évolution", solidHeader = TRUE, status = "primary",
                  selectInput("indicateur", "Indicateur :", 
                              choices = c("habitants", "taux_resid", "prix_m2")),
                  checkboxGroupInput("iles", "Îles :", choices = liste_iles, selected = liste_iles)
              )
      ),
      
      # Onglet Comparaison
      tabItem(tabName = "comparaison",
              plotlyOutput("plot_comparaison"),
              hr(),
              box(width = 12, title = "Filtre Comparaison", solidHeader = TRUE, status = "info",
                  selectInput("annee", "Année :", 
                              choices = liste_annees, selected = max(liste_annees))
              )
      ),
      
      # Onglet Données
      tabItem(tabName = "donnees",
              DTOutput("tableau"),
              hr(),
              box(width = 12, title = "Filtres Données", solidHeader = TRUE, status = "warning",
                  selectInput("indicateur_table", "Indicateur :", 
                              choices = c("habitants", "taux_resid", "prix_m2")),
                  checkboxGroupInput("iles_table", "Îles :", choices = liste_iles, selected = liste_iles),
                  selectInput("annee_table", "Année :", choices = liste_annees, selected = max(liste_annees))
              )
      )
    )
  )
)
