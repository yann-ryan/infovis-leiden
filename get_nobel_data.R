library(jsonlite)

iso = world_map %>% 
  st_drop_geometry() |> 
  select(admin, iso_a3_eh) |>
  mutate(admin = case_when(admin == 'United States of America' ~ "USA",
                           admin == 'Netherlands' ~ "the Netherlands",
                           admin == 'Czechia' ~ 'Czech Republic', 
                                .default = admin)) |> 
  add_row(admin = "Faroe Islands (Denmark)", iso_a3_eh = "DNK")|> 
  add_row(admin = "Guadeloupe, France", iso_a3_eh = "FRA")|> 
  add_row(admin = "Scotland", iso_a3_eh = "GBR")  %>% 
  rename(iso_birth_country_now = iso_a3_eh)

a = fromJSON('https://api.nobelprize.org/2.1/laureates?offset=0&limit=10000') 

b = fromJSON('https://api.nobelprize.org/2.1/nobelPrizes?offset=0&limit=10000')


df = as.data.frame(a)
df2 = as.data.frame(b)

df2= df2 %>% mutate(prize_id = 1:nrow(.))|>
  unnest(nobelPrizes.laureates) 

df = df %>% left_join(df2, by = c('laureates.id' = 'id'))

nobel = df %>% 
  select(laureates.id,
         laureates.givenName, 
         laureates.familyName, 
         laureates.gender, 
         laureates.birth, 
         laureates.death, 
         laureates.foundedCountry, 
         prize_id,
         nobelPrizes.awardYear, 
         nobelPrizes.category,
         nobelPrizes.dateAwarded, 
         nobelPrizes.prizeAmount, 
         nobelPrizes.prizeAmountAdjusted, 
         nobelPrizes.topMotivation,motivation)

nobel = nobel |>
  unnest(c(nobelPrizes.category, motivation), names_sep = '_')
  


nobel_df = nobel %>% 
  unnest(c(laureates.givenName, laureates.familyName, laureates.birth),  names_sep = '_') %>%
  unnest(laureates.birth_place) %>% 
  unnest(c(city,country, continent, countryNow, cityNow),  names_sep = '_') %>% 
  unnest(laureates.death) %>% 
  unnest(place,  names_sep = '_') %>%
  unnest(c(place_city, place_country, place_continent, place_countryNow), names_sep = '_') %>%
  select(laureates_id =laureates.id,
         prize_id,
         award_year = nobelPrizes.awardYear,
         award_date = nobelPrizes.dateAwarded,
         category = nobelPrizes.category_en,
         given_name = laureates.givenName_en, 
         family_name = laureates.familyName_en,
         gender = laureates.gender,birth_city = city_en,
         birth_date = laureates.birth_date,
         birth_country = country_en,
         birth_country_now = countryNow_en,
         birth_longitude = cityNow_longitude,
         birth_latitude = cityNow_latitude,
         birth_continent = continent_en,
         death_date = date,
         death_city = place_city_en,
         death_country = place_country_en,
         death_country_now = place_countryNow_en,
         death_continent = place_continent_en,
         amount = nobelPrizes.prizeAmount,
         amount_adjusted = nobelPrizes.prizeAmountAdjusted,
         motivation = motivation_en
         ) %>% arrange(award_year, category)


laureate_df = nobel_df |>
  select(laureates_id, prize_id,
         given_name,
         family_name,
         gender,
         birth_date,
         birth_city,
         birth_longitude,
         birth_latitude,
         birth_country,
         birth_country_now,
         birth_continent,
         death_date,
         death_city,
         death_country,
         death_country_now,
         death_continent) %>% filter(!is.na(given_name)) %>% 
  left_join(iso, by = c('birth_country_now' = 'admin'))

prize_df = nobel_df |>
  select(prize_id,
         award_year,
         award_date,
         category,
         amount,
         amount_adjusted, motivation) |>
  distinct(prize_id, .keep_all = TRUE)

laureate_df %>% write_csv('laureates_df.csv')

prize_df %>% write_csv('prize_df.csv')
