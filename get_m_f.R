props = char_meta_merged_df %>% 
  filter(gender %in% c('m', 'f')) |>
  group_by(script_id) |>
  mutate(total = sum(words)) |>
  ungroup() |>
  mutate(prop = words/total) |>
  group_by(script_id, gender) |>
  summarise(prop = sum(prop)) |>
  pivot_wider(names_from = gender, values_from = prop,values_fill = 0)

