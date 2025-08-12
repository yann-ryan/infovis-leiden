library(data.table)
titanic_new_df = fread('..//../Downloads/phpMYEkMl.arff', na.strings = '?')
colnames(titanic_new_df) = c( 'pclass','survived', 'name', 'sex', 'age', 'sibsp', 'parch', 'ticket', 'fare', 'cabin', 'embarked', 'boat', 'body', 'home.dest')
titanic_new_df = titanic_new_df %>% arrange(name)

titanic_df = read_csv('titanic_df.csv')

titanic_pclass = titanic_df %>% arrange(name) %>% pull(pclass)

titanic_new_df = titanic_new_df %>% mutate(pclass = titanic_pclass)

titanic_new_df %>% 
  select(-body, -home.dest, -boat) %>% 
  write_csv('titanic_df_full.csv')


character_df = read_csv('https://raw.githubusercontent.com/melaniewalsh/Intro-Cultural-Analytics/master/book/data/Pudding/character_list5.csv')
metadata_df = read_csv('https://raw.githubusercontent.com/melaniewalsh/Intro-Cultural-Analytics/master/book/data/Pudding/meta_data7.csv')

female_lines = character_df |> 
  filter(gender == 'f') |>
  group_by(script_id) |>
  count(wt = words, name = 'female_lines')

male_lines = character_df |> 
  filter(gender == 'm') |>
  group_by(script_id) |>
  count(wt = words, name = 'male_lines')

female_lines |> full_join(male_lines, by = 'script_id') |>
  filter(female_lines > male_lines) |> left_join(metadata_df, by = 'script_id') |> 
  arrange(-gross)

imdb_genre = fread('/Users/Yann/Downloads/title.basics.tsv')

imdb_genre = imdb_genre |> filter(tconst %in% metadata_df$imdb_id)

imdb_genre = imdb_genre |> 
  separate(genres, into = c('genre_1', 'genre_2', 'genre_3'), sep = ',')

a = female_lines |> 
  left_join(metadata_df, by = 'script_id') |> 
  left_join(imdb_genre, by = c('imdb_id' = 'tconst')) %>% ungroup() %>% 
  count(genre_1, wt = female_lines) %>% 
  arrange(desc(n))

b = male_lines |> 
  left_join(metadata_df, by = 'script_id') |> 
  left_join(imdb_genre, by = c('imdb_id' = 'tconst')) %>% ungroup() %>% 
  count(genre_1, wt = male_lines) %>% 
  arrange(desc(n))

a %>% left_join(b, by = 'genre_1')
