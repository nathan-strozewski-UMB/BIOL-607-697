#' ----------------------------
#' 
#' @title Tidy Data Homework
#' @author Nathan Strozewski
#' @date 2022-09-28
#' 
#' ----------------------------

### Load libraries

library(tidyr)
library(dplyr)

### Problem 1: Read data ###

## Without downloading

library(readr)
kelp <- read_csv('https://github.com/kelpecosystems/observational_data/blob/master/cleaned_data/keen_cover.csv?raw=true')

## By downloading

setwd("/Users/nathanstrozewski/Documents/Everything/Education/M.S. Biology UMB/Courses/003_F2022/Biological Data Analysis/Homework/tidyr")
kelp <- read.csv("keen_cover.csv")

### Problem 2: Review the data ###

str(kelp)
summary(kelp)

## Is it in the wide or long format?

# The data set is in the long format
# Each row is an observation and each col is a variable ...
# that data was collected for during the observation

### Problem 3: Play with the data ###

## How many sites has each PI done?

kelp_PIsites <-
  kelp %>% 
  group_by(PI) %>% 
  summarize(num_sites = n_distinct(SITE)) %>% 
  pivot_wider(names_from = PI,
              values_from = num_sites)
kelp_PIsites

## How many years of data does each site have? 
## Show it in descending order

kelp_yearsofdata <-
  kelp %>% 
  group_by(SITE) %>% 
  summarize(num_years = n_distinct(YEAR)) %>% 
  pivot_wider(names_from = SITE,
              values_from = num_years)
kelp_yearsofdata

kelp_yearsofdata_desc <- kelp_yearsofdata[order(kelp_yearsofdata, 
                                                decreasing = TRUE)]
kelp_yearsofdata_desc # there is probably a way to condesnse this

## Make a figure showing which site was sampled when 
## Use slice() (there are more elegant solutions)
## For data viz, you can use geoms you’ve used before, or new ones, like geom_tile()!

library(ggplot2)

## Bar chart per site

kelp$SAMPLE_DATE <- as.Date(with(kelp, paste(YEAR, MONTH, DAY, sep = "-")), "%Y-%m-%d")
kelp$SAMPLE_DATE

kelp_sampledates <- ggplot(data = kelp) +
  labs(title = "Which sites were sampled -",
       subtitle = "and when?",
       x = "Sampling Site",
       y = "Date (YYYY-MM-DD") +
  geom_tile(aes(x = SITE,
                y = SAMPLE_DATE))
kelp_sampledates

### Problem 4: Let's look at some kelp!

## Trim down to the cols YEAR, SITE, TRANSECT, PERCENT_COVER, ...
## FAMILY, and SPECIES

kelp %>% 
  select(YEAR, SITE, TRANSECT, PERCENT_COVER, FAMILY, SPECIES) 

## Trim the data down to only the family “Laminariaceae”
## After that, ditch the FAMILY column

kelp %>% 
  filter(FAMILY == "Laminariaceae") %>% 
  select(YEAR, SITE, TRANSECT, PERCENT_COVER, SPECIES)

## For each species is there only one measurement per species transect each year?
## Or do we need to worry?

# For some species transects, there are more than one measurements each year
str(kelp) # stir the data to find out why
kelp[,13] %>% # look at the size data to see if this explains why
print(n = 1000) # notes show that some measurements are juveniles

# I conclude that the measurements are likely from both adult and juveniles

## Sum the cover for each species on each transect ...
## so that we only have one measurement per species (adults + juveniles together)
  
kelp_transectmean <- kelp %>% 
  # filter(!is.na(PERCENT_COVER)) %>% 
  group_by(SPECIES, TRANSECT) %>% # add site
  summarize(mean_transect_cover = mean(PERCENT_COVER, na.rm = TRUE)) %>% 
  print()

# unclear if I am supposed to have one measurement per transect per species ...
# or one measurement per species overall
# the former is one measurement per transect per species
# the following is one measurement per species

kelp_overallcover <- kelp %>% 
  group_by(SPECIES, SITE) %>% 
  summarize(mean_transect_cover = mean(PERCENT_COVER, na.rm = TRUE)) %>% 
  print()
  
## Make a plot showing the timeseries of kelps at each site. 
## You’ll want stat_summary() here. 
## You might even need it twice because ...
## note - stat_summary() has a geom argument where you can do things like “line”. 
## What might that do? Check it out! 
## Facet this plot by species, so we can see the trajectory of each. 
## Feel free to gussy this plot up however you would like (or not). 
## Do you notice anything? Comment!

kelp_timeseries <- ggplot(data = kelp,
                          aes(x = SAMPLE_DATE,
                              y = PERCENT_COVER)) + # plot with values
  labs(title = "Kelp Cover Over Time",
       x = "Date (YYYY-MM-DD)",
       y = "Percent Cover") + # labels
  stat_summary(aes(x = SAMPLE_DATE,
               y = PERCENT_COVER), 
               geom = "line",
               width = 0.5,
               size = 0.5,
               alpha = 0.5) + # stats to summarize + dimensions
  scale_y_continuous(limits=c(0, 110)) # change y-axis limit
kelp_timeseries

kelp_timeseries +
  geom_jitter() + # adds jitter to allow plotting of overlapping data points
  facet_wrap(~ SPECIES) # splits plots into individ. plots per species


# I needed to add a jitter to plot the data ...
# presumably because some points overlap
# it is quite difficult to make out a trend


### Problem 5: Wide Relationships ###

## Use pivot_wider() to make species into columns ...
## with percent cover as your values
## Note - be careful to fill in NAs as 0s

kelp_overallcover_wide <- kelp_overallcover %>% 
  pivot_wider(names_from = SPECIES,
                values_from = mean_transect_cover,
                values_fill = 0)
kelp_overallcover_wide

## Plot the relationship between Saccharina latissima and Laminaria digitata
## Add a line to your ggplot stat_smooth(method = "lm")
## Remember that you will need backticks ` around variables with spaces in them
## What do you think?
## Feel free to use any other geoms or explore however you like here

ggplot(data = kelp_overallcover_wide,
         aes(x = SITE,
             y1 = get('Saccharina latissima'),
             y2 = get('Laminaria digitata'))) +
  geom_point(aes(x = SITE,
                 y = get('Saccharina latissima'),
                 color = "Saccharina latissima",
                 group = 1)) +
  geom_line(aes(x = SITE,
                y = get('Saccharina latissima'),
                color = "Saccharina latissima",
                group = 1)) +
  geom_point(aes(x = SITE,
                 y = get('Laminaria digitata'),
                 color = "Laminaria digitata",
                 group = 1)) +
  geom_line(aes(x = SITE,
                y = get('Laminaria digitata'),
                color = "Laminaria digitata",
                group =1)) +
  labs(title = "Mean Kelp Cover by Site",
       subtitle = "Saccharina latissima vs. Laminaria digitata",
       x = "Site",
       y = "Mean Percent Kelp Cover (%)",
       color = "Species")

## Pivot this correct long data back wide and then remake the figure from 4e
## Does it look different? Does it tell a different story?

# I am a little confused by the wording here
# The objects I am working with (the "correct" data) are in wide already
# Pivoting this long creates some issues
# Wouldn't it be easier to fill 0s for NAs in the original data and plot?

# Replace NAs with base R

kelp_noNAs <- kelp
kelp_noNAs[is.na(kelp_noNAs)] = 0
kelp_noNAs

# Plot as in 4e

kelp_timeseries_noNAs <- ggplot(data = kelp_noNAs,
                          aes(x = SAMPLE_DATE,
                              y = PERCENT_COVER)) + # plot with values
  labs(title = "Kelp Cover Over Time",
       x = "Date (YYYY-MM-DD)",
       y = "Percent Cover") + # labels
  stat_summary(aes(x = SAMPLE_DATE,
                   y = PERCENT_COVER), 
               geom = "line",
               width = 0.5,
               size = 0.5,
               alpha = 0.5) + # stats to summarize + dimensions
  scale_y_continuous(limits=c(0, 110)) # change y-axis limit
kelp_timeseries_noNAs

kelp_timeseries_noNAs +
  geom_jitter() + # adds jitter to allow plotting of overlapping data points
  facet_wrap(~ SPECIES) # splits plots into individ. plots per species

