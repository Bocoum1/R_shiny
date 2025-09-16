# Charger les packages
library(readr)
library(dplyr)
library(readxl)
library(ggplot2)
library(lubridate)

### Importation de fichiers ######
data_allocine <- read_csv2("data/data_allocine.csv")
correspondances <- read_excel("data/correspondances_allocine.xlsx") |>
  rename(nationalite = nationalité)

######## Aperçu variables numériques 

summary(data_allocine)
head(data_allocine)
glimpse(data_allocine)

# Nature de l'objet
class(data_allocine)

# Compter le nombre de films par nationalité
count(data_allocine, nationalite)

#####  select pour supprimer une variable (colonne)
select(data_allocine, -recompenses) # ⚠️ ne modifie pas en place si pas sauvegardé

#### filter permet de sélectionner des lignes via une condition  #####
# Ne garder que les longs métrages:
# filter(data_allocine, type_film == "long-metrage")

# Vérification :
count(data_allocine, type_film)

# Rename : renommer (titre en titre_film)
rename(data_allocine, titre_film = titre)

# La fonction arrange pour trier
arrange(data_allocine, id_film)

# Le pipe
data_allocine |>
  filter(nationalite == "italien") |>
  arrange(desc(duree)) |>
  head(3)

# Tous les films français ayant une note presse supérieure à 4
# Trier par ordre croissant et exporter
data_allocine |>
  filter(nationalite == 'français', note_presse > 4) |>
  arrange(note_presse) |>
  select(titre, note_presse) |>
  write_csv2("liste_bons_films_français.csv")

# Jointure
data_allocine |>
  left_join(correspondances, by = "nationalite")

# Combien de films de drame en Europe de l'ouest et en Europe de l'est
data_allocine <- data_allocine |>
  left_join(correspondances, by = "nationalite")

count(data_allocine, region)

# summarize : moyenne des notes
data_allocine |>
  summarize(
    moyenne_presse = mean(note_presse, na.rm = TRUE),
    moyenne_spectateurs = mean(note_spectateurs, na.rm = TRUE)
  )

# group_by + summarize : calcul par groupe
data_allocine |>
  left_join(correspondances, by = "nationalite") |>
  filter(region == "Europe de l'ouest") |>
  group_by(genre) |>
  summarize(
    n = n(),
    durée_moyenne = mean(duree, na.rm = TRUE)
  ) |>
  arrange(desc(n)) |>
  head(5)

# Mutate : créer une nouvelle colonne
data_allocine <- data_allocine |>
  mutate(
    note_globale = note_presse + note_spectateurs
  )

# Vérification
data_allocine |>
  summarize(note_globale = mean(note_globale, na.rm = TRUE))

# Mutate + if_else
data_allocine <- data_allocine |>
  mutate(
    tr_note = if_else(
      note_globale < 5, "Mauvais film",
      if_else(note_globale < 6, "Film moyen", "Bon film")
    )
  )

########## Facteurs et ordre des colonnes

# Graphique : nombre de films par région
data_allocine |>
  filter(!is.na(region)) |>
  count(region) |>
  ggplot() +
  geom_col(aes(x = n, y = region), fill = "royalblue") +
  labs(title = "Nombre de films par région", x = "Nombre de films", y = "") +
  theme_minimal()

glimpse(data_allocine)



# Graphique avec DATE : évolution du nombre de films par an
data_allocine |>
  mutate(annee_sortie = year(date_sortie)) |>
  count(annee_sortie) |>
  ggplot() +
  geom_line(aes(x = annee_sortie, y = n))
 unique(data_allocine$genre)
