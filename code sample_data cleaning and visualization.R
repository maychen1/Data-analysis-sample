###
title: "Data cleaning and analysis"
author: "May(Zhaoyuan) Chen"
###
rm(list = ls())
library(tidyverse)
library(dplyr)
library(stringr)

## Work Directory 
general = "/Users/zhaoyuan/Documents/Application/Applying/Code sample/code-samples"
setwd(general)

## Read data
data_names <- c("SAEMP25N total.csv", "SAEMP25N by industry.csv")

for (i in 1:length(data_names)) {
  assign(paste0("data", i),                                   
         #Read and store data frames
         read.csv(paste0(general,"/", data_names[i]), 
                  # Skip first 5 rows of discriptions 
                  skip = 4, header = T))
}

## Clean data: 
# step1: remove footnotes for both data sets
data1 <- data1[-c(52:54),]
data2 <- data2[-c(562:566),]

# step2.1: Drop subtotal summaries in data2
data2 <- filter(data2, Description != "By industry")

# step2.2: Drop blanks/tabs in data2 `Description` column
data2$Description <- trimws(data2$Description , which = c("left"))

## Reorganize data: 
# step1: Apply pivot longer on both data frames to make year and total/subtotal 
# two columns
data1 <- data1 %>%
  pivot_longer(
    cols = starts_with("x"),
    names_to = "year",
    names_prefix = "x",
    values_to = "total",
    values_drop_na = TRUE
  )
data2 <- data2 %>%
  pivot_longer(
    cols = starts_with("x"),
    names_to = "year",
    names_prefix = "x",
    values_to = "subtotal",
    values_drop_na = TRUE
)

# Turn Year into numeric value
data1$year <- as.numeric(str_extract(data1$year, "[0-9]+"))
data2$year <- as.numeric(str_extract(data2$year, "[0-9]+"))

# step2: combine reorganized data into one long dataframe 
data <- left_join(data2, data1, by = c("GeoFips","GeoName", "year"))

## Calculate statistics: 
data$subtotal <- as.numeric(data$subtotal)
data          <- data %>% mutate(pct = subtotal/total)

## Export the cleaned data:
output <- "/Users/zhaoyuan/Documents/Application/Applying/Code sample/code-samples/data.csv"
write.csv(data, output, row.names = F)

## Data visualization 
h5_em_manufacture <- data %>%
  filter(year == "2000") %>%
  filter(Description == "Manufacturing") %>%
  arrange(desc(pct)) %>%
  head(5) %>%
  select("GeoName")

h5_em_manufacture_dt <- data %>%
  filter(GeoName %in% h5_em_manufacture$GeoName) %>%
  filter(Description == "Manufacturing")

# Plot changes in employment in states that ranked top 5 in 2000
ggplot(h5_em_manufacture_dt, aes(x = as.character(year), 
                                 y = pct,
                                 color = GeoName)) +  
  geom_point(size = 3, alpha = 0.5) +
  geom_text(aes(label = round(pct, 3)),
            vjust = "outward", hjust = "outward",
            show.legend = FALSE) +
  geom_line(aes(group = GeoName)) +
  labs(x = "Year", y = "% Employment in Manufacturing") + 
  theme_classic() 
