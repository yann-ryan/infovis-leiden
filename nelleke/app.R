#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#






# Libraries
library(tmap)
library(tidyverse)
library(rnaturalearth)
library(sf)
library(shiny)



# Read data
cwur_data <- read_csv("universities_data_infovis/cwurData.csv")
shanghai_data <- read.csv("universities_data_infovis/shanghai-world-university-ranking.csv", sep = ";") # aanpassen
times_data <- read_csv("universities_data_infovis/timesData.csv")
worldmap_data <- ne_countries(scale = 'medium', returnclass = 'sf') 



# Prepare CWUR data

cwur_data <- cwur_data |>
  
  # Change country names to match worldmap data 
  mutate(country = if_else(country == "USA", "United States of America", country)) |>
  mutate(country = if_else(country == "Czech Republic", "Czechia", country)) |>
  mutate(country = if_else(country == "Slovak Republic", "Slovakia", country)) |>
  
  # We use data from 2014
  filter(year == 2014) |>
  count(country) |> 
  distinct(country, .keep_all = TRUE) |>
  mutate(country_share = n/sum(n)*100)

# Join cwur data with worldmap data 
cwur_data_plot <- left_join(worldmap_data, cwur_data, by = c('name'='country')) |>
  select(name, n, country_share) |>
  rename('n_cwur' = 'n', 'country_share_cwur'= 'country_share') |>
  st_as_sf() 

# To check which country names do not match, use: 
# subset(cwur_data, !(country %in% cwur_data_plot$name))



# Prepare Times data

times_data <- times_data |>
  
  # Change country names to match worldmap data
  mutate(country = if_else(country == "Republic of Ireland", "Ireland", country)) |>
  mutate(country = if_else(country == "Russian Federation", "Russia", country)) |>
  mutate(country = if_else(country == "Czech Republic", "Czechia", country)) |>
  
  # We use data from 2014
  filter(year == 2014) |>
  count(country) |>
  distinct(country, .keep_all = TRUE)|>
  mutate(country_share = n/sum(n)*100)

# Join Times data with worldmap data 
times_data_plot <- left_join(worldmap_data, times_data, by = c('name'='country')) |>
  select(name, n, country_share) |>
  rename('n_times' = 'n', 'country_share_times'= 'country_share') |>
  st_as_sf() 

# To check which country names do not match, use: 
#subset(times_data, !(country %in% times_data_plot$name))



# Prepare Shanghai data

shanghai_data <- shanghai_data |>
  
  # Change country names to match worldmap data
  mutate(Country = if_else(Country == "Czech Republic", "Czechia", Country)) |>
  mutate(Country = if_else(Country == "Hong Kong, China", "China", Country)) |>
  mutate(Country = if_else(Country == "Iran, Islamic Rep. of", "Iran", Country)) |>
  mutate(Country = if_else(Country == "Korea, Republic of", "South Korea", Country)) |>
  mutate(Country = if_else(Country == "Russian Federation", "Russia", Country)) |>
  mutate(Country = if_else(Country == "Taiwan, China", "Taiwan", Country)) |>
  mutate(Country = if_else(Country == "United States", "United States of America", Country)) |>
  
  count(Country) |>
  distinct(Country, .keep_all = TRUE) |>
  mutate(country_share = n/sum(n)*100)

# Join Shanghai data with worldmap data 
shanghai_data_plot <- left_join(worldmap_data, shanghai_data, by = c('name'='Country')) |>
  select(name, n, country_share) |>
  rename('n_shanghai' = 'n', 'country_share_shanghai'= 'country_share') |>
  st_as_sf() 

# To check which country names do not match, use: 
#subset(times_data, !(country %in% times_data_plot$name))



# Add population share per country
population_share <- worldmap_data |>
  mutate(pop_share = pop_est/sum(pop_est)*100) |>
  select(name, pop_share)



# Combine datasets 

combined_data <- full_join(cwur_data_plot, times_data_plot  |> st_drop_geometry()) 

combined_data <- full_join(combined_data, shanghai_data_plot |> st_drop_geometry())

combined_data <- full_join(combined_data, population_share |> st_drop_geometry())



# Shiny Application 
ui <- fluidPage(
  fluidRow(
    column(6,
           p("Countries' Representation in Global University Rankings",
             style = "font-size: 30px; font-weight: bold;"),
           p("Comparing the percentage of universities from each country in the CWUR, Times, and Shanghai rankings (2014)",
             style = "font-size: 15px; font-weight: bold;"),
           p("Click on a country to see details.", 
             style = "color: darkgrey"),
           p("Sources: Center for World University Rankings, Times Higher Education, Shanghai Academic Ranking of World Universities.", 
             style = "color: darkgrey")),
    column(6, tmapOutput("map_cwur"))),
  fluidRow(
    column(6, tmapOutput("map_times")),
    column(6, tmapOutput("map_shanghai"))))

server <- function(input, output, session) {
  sf_use_s2(FALSE)
  tmap_mode("view")
  
  # CWUR Ranking Map
  output$map_cwur <- renderTmap({
    tm_shape(combined_data) +
      tm_polygons(
        col = "country_share_cwur",
        id = 'name',
        popup.vars = c(
          "% of CWUR's ranked uni's from this country:" = "country_share_cwur",
          "% of world population:" = "pop_share"),
        title = "% of CWUR Ranking list",
        showNA = FALSE,
        palette = "-viridis",
        style = "cont",
        breaks = c(0,5,10,15,20,25)) +
      tm_view(set.view = c(-15, 50, 0.8))})
  
  # Times Ranking Map
  output$map_times <- renderTmap({
    tm_shape(combined_data) +
      tm_polygons(
        col = "country_share_times",
        id = 'name',
        popup.vars = c(
          "% of Times' ranked uni's from this country:" = "country_share_times",
          "% of world population:" = "pop_share"),
        title = "% of Times Ranking list",
        showNA = FALSE,
        palette = "-viridis",
        style = "cont",
        breaks = c(0,5,10,15,20,25)) +
      tm_view(set.view = c(-15, 50, 0.8))})
  
  # Shanghai Ranking Map
  output$map_shanghai <- renderTmap({
    tm_shape(combined_data) +
      tm_polygons(
        col = "country_share_shanghai",
        id = 'name',
        popup.vars = c(
          "% of Shanghai's ranked uni's from this country:" = "country_share_shanghai",
          "% of world population:" = "pop_share"),
        title = "% of Shanghai Ranking list",
        showNA = FALSE,
        palette = "-viridis",
        style = "cont",
        breaks = c(0,5,10,15,20,25)) +
      tm_view(set.view = c(-15, 50, 0.8))})}
shinyApp(ui, server)

