library(tidyverse)
library(highcharter)
library(webshot)
library(htmlwidgets)

dataset <- 
  read.csv('D:/R scripts/script051120_Happiness_report_2019/World Happiness Report 2019/World Happiness Report 2019/world-happiness-report-2019.csv')

#Reshape dataframe
df <- as.data.frame(dataset)
df <- df[, -c(3:5)]
colnames(df)[1] <- 'Country'
glimpse(df)
df$Country <- as.character(as.factor(df$Country))

#Replace value in specific cells
df[df == 'United States'] <- 'United States of America'

#map
map_data <- get_data_from_map(download_map_data("custom/world"))
p <- hcmap(map = 'custom/world', download_map_data = getOption("highcharter.download_map_data"), data = df,
      value = 'Ladder', joinBy = c('name', 'Country')) %>%
  hc_tooltip(useHTML = TRUE, headerFormat = '<b>World ranking position of<br>', 
             pointFormat = '{point.name}: N°{point.value}') %>%
  hc_title(text = 'World happiness report (2019)', 
           style = list(fontWeight = 'bold', fontSize = '20px'),
           align = 'left') %>%
  hc_credits(enabled = TRUE, text = 'Map by Antonela Tamagnini
             <br> Source: WHO, Minsitry of Health Department') %>%
  hc_mapNavigation(enabled = TRUE) %>%
  hc_colorAxis(stops = color_stops(8, c("#0000CD","#8ba9fe","#fee08b","#434348")))
p
saveWidget(widget = p, file = "plot.html")
webshot(url = 'plot.html', file = 'plot.png')
