netherlands = ne_countries(scale = 'medium', returnclass = 'sf', country = c('Netherlands', 'Belgium', 'Luxembourg', 'France','Germany', "United Kingdom"))
rivers = ne_download(scale = 'large', type = 'rivers_lake_centerlines', category = 'physical', returnclass = 'sf')
cities = ne_download(scale = 'medium', type = 'populated_places', category = 'cultural', returnclass = 'sf')

netherlands = netherlands |> mutate(b = ifelse(name %in%  c('Netherlands', 'Belgium'), TRUE, FALSE))

p1 = ggplot() + 
  geom_sf(data = netherlands, color = 'black', linewidth = .5, aes(fill = b)) + 
  geom_sf(data = rivers, color = 'blue',linewidth = .4) + 
  geom_sf(data = cities, size = 3) + 
  coord_sf(xlim = c(-2, 11), ylim = c(48, 55)) + 
  theme_void() + 
  annotate('segment', x = 2.74914, y = 54, xend = 4.8, yend = 52.48, arrow = arrow(type = 'closed', length = unit(.25, 'cm')), color = 'red') + 
  annotate('segment', x = 2.74914, y = 54, xend = 4.150, yend = 52.15833, arrow = arrow(type = 'closed', length = unit(.25, 'cm')), color = 'red')  + 
  annotate('segment', x = 8, y = 52, xend = 5.5, yend = 52.15833, arrow = arrow(type = 'closed', length = unit(.25, 'cm')), color = 'red')  + 
  annotate('segment', x = 8, y = 52, xend = 5.2, yend = 50.8, arrow = arrow(type = 'closed', length = unit(.25, 'cm')), color = 'red')+ 
  annotate('segment', x = 2.4, y = 52, xend = 3.6, yend = 50.9, arrow = arrow(type = 'closed', length = unit(.25, 'cm')), color = 'red') + 
  annotate('label', x = 2.74914, y = 54.2, label = 'Points', size = 5) + 
  annotate('label', x = 8.2, y = 52.2, label = 'Polygons', size = 5) + 
  annotate('label', x = 2.5, y = 52.2, label = 'Line', size = 5) +
  theme(legend.position = 'none') + 
  scale_fill_manual(values = c('gray99', 'gray85'))

ggsave('features.png', plot = p1)

p2 = ggplot() + geom_sf(data = netherlands, color = 'black', linewidth = .5) + 
  geom_sf(data = rivers, color = 'blue',linewidth = .4) + 
  geom_sf(data = cities, size = 3) + 
  coord_sf(xlim = c(-2, 11), ylim = c(48, 55)) + 
  theme_void()

ggsave('vector.svg', plot  = p2)


worldmap |>
  group_by(admin) |>
  summarise(avg_pop = sum(pop_est, na.rm = TRUE))
