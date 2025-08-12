For instance, let's highlight asylum seekers from Syria within the plot. We'll add the data for Syria as a new `geom_line()`, and we'll specify a larger size and a different color.

```{r}  

# first all the data (we made this earlier but just to highlight)  

all = population %>%    
  filter(coa_iso == 'DEU') %>%    group_by(year, coo) %>%    summarise(n = sum(asylum_seekers)) %>%    filter(year %in% c(2000:2020))   
# now a new dataset but with an extra filter  
syria = population %>%    filter(coa_iso == 'DEU' & coo_iso == 'SYR') %>%    group_by(year, coo) %>%    summarise(n = sum(asylum_seekers)) %>%    filter(year %in% c(2000:2020))  # create the plot  ggplot() +      geom_line(data = all, aes(x = year, y = n, group = coo), alpha = .5) + #reduce the transparency of the other lines   geom_line(data =syria, aes(x = year, y = n), size = 1.5, color = 'forestgreen') + # add a new line and specify size/color   labs(title = "Asylum seekers to Germany\nby country of origin",         subtitle = "2000-2020 inclusive",         caption = "Data from https://www.unhcr.org/refugee-statistics/",        x = NULL,        y = "Number seeking asylum") +    theme(axis.title = element_text(size = 16))}

```

### Exercises:

-   Add a second line with a different color, this time for asylum seekers with a country of origin Afghanistan.

## Adding text and annotations

Another really useful technique for creating a narrative in your data visualisation is to add annotations. This is usually to draw attention to particular aspects of the data, or to explain or give context. The idea is to guide your reader towards the story in your data.

There are quite a few ways of adding text. The simplest way is to add an annotation with a layer called `annotate()`. This allows us to add text but also shapes or lines.

To create a text annotation, we need to specify a few things within `annotate()`:

-   The type of annotation, in this case `text`.

-   The x and y position the annotation should be placed. This is done manually and usually requires a bit of experimentation.

-   The actual label to be displayed

-   Optionally, we can specify color, size, face, family and so forth...

Let's add a label to show our readers that the highlighted line is Syria

`{r}  ggplot() +      geom_line(data = all, aes(x = year, y = n, group = coo), alpha = .5) +   geom_line(data =syria, aes(x = year, y = n), size = 1.5, color = 'forestgreen') +    annotate('text', x = 2014, y = 75000, label = 'Syria', color = 'forestgreen', size = 5) + # add the annotation   labs(title = "Asylum seekers to Germany\nby country of origin",         subtitle = "2000-2020 inclusive",         caption = "Data from https://www.unhcr.org/refugee-statistics/",        x = NULL,        y = "Number seeking asylum") +    theme(axis.title = element_text(size = 16))}`

### Exercises

-   Add a similar label for Afghanistan. Find a suitable place on the chart where it will be readable

### Adding lines as annotations

Another useful technique for adding contextual information, particularly with line charts, is to add vertical lines highlighting particular points in time.

This is done using another element, called `geom_vline()`. In this case, we specify where the line should be placed using `xintercept`. Optionally, we can set the `size`, the `linetype` (e.g. to `dashed`), and the transparency using `alpha`.

Let's add a line to the chart to highlight an important milestone in the Syrian civil war: the beginning of revolts in March 2011. Note that because the data is not in date format but simply numbers, we have to add the line at 2011.25 to make it approximately March 2011.

`{r} ggplot() +      geom_line(data = all, aes(x = year, y = n, group = coo), alpha = .5) +   geom_line(data =syria, aes(x = year, y = n), size = 1.5, color = 'forestgreen') +    annotate(geom = 'text', x = 2014, y = 75000, label = 'Syria', color = 'forestgreen', size = 5) +    geom_vline(xintercept = 2011.25, linetype = 'dashed') + # add the line, specifying the linetype.    labs(title = "Asylum seekers to Germany\nby country of origin",         subtitle = "2000-2020 inclusive",         caption = "Data from https://www.unhcr.org/refugee-statistics/",        x = NULL,        y = "Number seeking asylum") +    theme(axis.title = element_text(size = 16))}`

Exercises:

-   Add a similar line for September 2015, when the German government announced that asylum seekers would be welcomed in Germany.

### Text annotations and lines

On their own, these lines are not enough. We can also add labels to the line. For this, we return to the `annotate()` element.

First, let's draw a label in an empty area of the chart, using `annotate()`.

`{r} ggplot() +      geom_line(data = all, aes(x = year, y = n, group = coo), alpha = .5) +   geom_line(data =syria, aes(x = year, y = n), size = 1.5, color = 'forestgreen') +    annotate(geom = 'text', x = 2014, y = 75000, label = 'Syria', color = 'forestgreen', size = 5) +    geom_vline(xintercept = 2011.25, linetype = 'dashed') +    annotate(geom = 'text', x = 2007, y = 110000, label = "Beginning of Syrian Revolt") +    labs(title = "Asylum seekers to Germany\nby country of origin",         subtitle = "2000-2020 inclusive",         caption = "Data from https://www.unhcr.org/refugee-statistics/",        x = NULL,        y = "Number seeking asylum") +    theme(axis.title = element_text(size = 16))}`

Next we can draw a curved line to connect the text label to the vertical line.

Again, we use `annotate()`. This time, the geom type is set to `curve`. When we make a curve, we need to specify the x beginning and end using `x` and `xend`, and the y beginning and end, using `y` and `yend`.

`{r}  ggplot() +      geom_line(data = all, aes(x = year, y = n, group = coo), alpha = .5) +   geom_line(data =syria, aes(x = year, y = n), size = 1.5, color = 'forestgreen') +    annotate(geom = 'text', x = 2014, y = 75000, label = 'Syria', color = 'forestgreen', size = 5) +    geom_vline(xintercept = 2011.25, linetype = 'dashed') +    annotate(geom = 'text', x = 2007, y = 110000, label = "Beginning of Syrian Revolt") +    annotate(geom = 'curve', x = 2007, y = 100000, xend = 2011, yend = 65000,     arrow = arrow(length = unit(0.3, 'cm'), type = 'closed')) +    labs(title = "Asylum seekers to Germany\nby country of origin",         subtitle = "2000-2020 inclusive",         caption = "Data from https://www.unhcr.org/refugee-statistics/",        x = NULL,        y = "Number seeking asylum") +    theme(axis.title = element_text(size = 16))}`

Optionally, we can add an arrow to the end of the line. The syntax starts to get a bit complicated, so copy and paste is your friend!
  
  First, specify to draw an arrow by placing `arrow =`within the `annotate()`. Next, we use the following code to tell it what arrow to draw:
  
  `arrow = arrow(length = unit(.3, 'cm'), type = 'closed')`

Within `arrow()`, we specify the length of the arrow, within `unit()` where we also specify what time of unit (e.g. cm, mm, in). Lastly, we can specify either a 'closed' or 'open' arrow type.

`{r}  ggplot() +      geom_line(data = all, aes(x = year, y = n, group = coo), alpha = .5) +   geom_line(data =syria, aes(x = year, y = n), size = 1.5, color = 'forestgreen') +    annotate(geom = 'text', x = 2014, y = 75000, label = 'Syria', color = 'forestgreen', size = 5) +    geom_vline(xintercept = 2011.25, linetype = 'dashed') +    annotate(geom = 'text', x = 2007, y = 110000, label = "Beginning of Syrian Revolt") +    annotate(geom = 'curve', x = 2007, y = 100000, xend = 2011, yend = 65000, # add the      arrow = arrow(length = unit(0.3, 'cm'), type = 'closed')) +    labs(title = "Asylum seekers to Germany\nby country of origin",         subtitle = "2000-2020 inclusive",         caption = "Data from https://www.unhcr.org/refugee-statistics/",        x = NULL,        y = "Number seeking asylum") +    theme(axis.title = element_text(size = 16))}`

### Highlighting

Add highlight colours using additional dataframes.

### Exercises

For both of these, use copy and paste where possible - start by copying in the identical code, and then make changes to the values as necessary.

-   Add a text label for the second highlighted milestone. Find a suitable place on the chart (it can also be to the right)

-   Create a connecting line from the label to the vertical line. Optionally, add an arrow.
