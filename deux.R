library(tidyr)   
library(dplyr)
library(readr)
library(ggplot2)
library(readxl)      
library(shiny)       
library(DT)  
library(plotly)
library(shinydashboard)
library(ggiraph)
library(ggplot2)

# Charger les donnéees
data_raw <- read_excel("data/Data_Ponant.xlsx")

# ---- Nettoyage Belle-Île ----
# On garde seulement le total Belle-Île (pas les communes internes)
data_clean <- data_raw %>%
  filter(!(Ile == "Belle-Ile" & `Nom commune` != "Belle-Ile"))

# ---- Transformation en format tidy ----
# Habitants
habitants <- data_clean %>%
  select(Ile, starts_with("Nb d'habitants")) %>%
  pivot_longer(
    cols = starts_with("Nb d'habitants"),
    names_to = "annee",
    values_to = "habitants"
  ) %>%
  mutate(annee = parse_number(annee))

# Résidences secondaires
resid <- data_clean %>%
  select(Ile, starts_with("Taux de résidendes secondaires")) %>%
  pivot_longer(
    cols = starts_with("Taux de résidendes secondaires"),
    names_to = "annee",
    values_to = "taux_resid"
  ) %>%
  mutate(annee = parse_number(annee))

names(resid)

# mettre la colonne 2023 en numeric
data_clean <- data_clean %>%
  mutate(`Prix médian du bâti au m2 (2023)` = as.numeric(`Prix médian du bâti au m2 (2023)`))

str(data_clean)

# Prix m2
prix <- data_clean %>%
  select(Ile, starts_with("Prix médian du bâti au m2 (")) %>%
  pivot_longer(
    cols = starts_with("Prix médian du bâti au m2 ("),
    names_to = "annee",
    values_to = "prix_m2"
  ) %>%
  mutate(
    annee = gsub("m2", "", annee),
    annee = parse_number(annee)
  )


glimpse(prix) 

unique(habitants$annee)
unique(resid$annee)
unique(prix$annee)

# Fusionner les trois indicateurs
indicateurs <- habitants %>%
  left_join(resid, by = c("Ile", "annee")) %>%
  left_join(prix, by = c("Ile", "annee"))


indicateurs <- indicateurs %>%
  filter(!(Ile %in% c("Le Palais", "Bangor", "Locmaria", "Sauzon")))

liste_iles <- unique(indicateurs$Ile)
liste_annees <- sort(unique(indicateurs$annee))

liste_annees
