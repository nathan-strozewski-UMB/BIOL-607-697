#' ------------------------------------
#' 
#' @title Homework: Iterations and Functions
#' @author Nathan Strozewski
#' @date 2022-10-05
#' 
#  ------------------------------------

#### Part 0: Intro

# Load libraries

library(tidyverse)

# Set ggplot theme

theme_set(theme_classic(base_size = 12))

#### Part 1: Basic function and iteration

##  Part 1a: Write a function that takes no arguments ...
## but tells you (using cat(), paste(), print(), etc.) “You’re doing a great job!”

function_1a <- function(x){
  ret_value <- paste(x)
  return(ret_value)
}
function_1a("You're doing a great job!")

## Part 1b: Have it tell you this 10 times ...
## Use replicate() for the first five and map_chr() for the second 5

function_1b_rep <- as.character(replicate(n = 5, function_1a("You're doing a great job!")))
function_1b_rep

function_1b_map <- map_chr(1:5, ~ function_1a("You're doing a great job!"))
function_1b_map

paste(function_1b_rep) %>% 
  paste(function_1b_map)

## Part 1c: Impress Yourself
## try purrr:::walk()

paste(function_1b_rep) %>% 
  paste(function_1b_map) %>% 
  walk(print)

## how does it differ from map()? 

# map() applies the function to each item in a collection ...
# while walk() applies a function that performs an action instead of producind data

## Do you need to modify the function to make it work?

# I did not. Perhaps that means I didn't do it correctly
# This is the resouce I used: https://dcl-prog.stanford.edu/purrr-extras.html#walk

#### Part 2: Visualizing the exponential distribution

## Part 2a: write a function that ...
## takes a rate, a minimum, and maximum as its inputs
## defaults for min and max be 0 and 4
## returns a data frame or tibble with three columns ...
### The first is the rate (the input)
### second is a sequence of 100 numbers between the min and max
### third is the probability density of the exponential distribution at that value given the rate

set.seed(1000)

part_2a <- function(a = 0,
                    b = 0,
                    c = 4) {
  seq_betw_min_max = runif(100, min = b, max = c)
  prob_dens_exp_dist = dexp(seq_betw_min_max, rate = a)
  return(data.frame("Rate" = a,
                     "Sequence_between_min_max" = seq_betw_min_max,
                     "Prob_dens_exp_dist" = prob_dens_exp_dist))
}
part_2a_df_rate3 <- part_2a(3, 0, 4)
part_2a_df_rate3

## Show that your function works by making a ggplot for rate = 3

library(ggplot2)

ggplot(part_2a_df_rate3) +
  xlim(c(0, 4)) +
  ylim(c(0, 4)) +
  geom_line(mapping = aes(x = part_2a_df_rate3$Sequence_between_min_max,
                          y = part_2a_df_rate3$Prob_dens_exp_dist)) +
  labs(title = "Probability density of an exponential distribution",
       subtitle = "At rate = 3",
       x = "Value",
       y = "Probability density")

ggplot(part_2a(3, 0, 4)) +
  geom_line(mapping = aes(x = part_2a$Sequence_between_min_max,
                          y = part_2a$Prob_dens_exp_dist))

## Part 2b: Use purrr::map_df() and a vector of rates: c(0.2, 0.5, 1, 2, 4) ...
## to create a data frame or tibble with the above function ...
## that for each rate, has values of x and the probability density of x

part_2b <- map_df(c(0.2, 0.5, 1, 2, 4),
      part_2a)
part_2b

## Part 2c: Plot the result in a way that shows the influence of rate ...
## on the shape of the curve. 
## What do higher or lower rates do to the shape of an exponential distribution?
## Does this make sense if rate = the number of events per interval on average ...
## and this is the distribution of time between events from a random process?

part_2c <- part_2b %>% 
  group_by(Rate) %>% 
  ggplot(data = part_2b,
         mapping = aes(x = ,
                       y = ))
  
  ggplot(data = part_2b,
                  mapping = aes(x = Sequence_between_min_max,
                                y = Prob_dens_exp_dist,
                                group = Rate,
                                color = Rate)) +
    labs(title = "Effect of Rate on Probability Density",
         subtitle = "HW04, Part 2c",
         x = "Value",
         y = "Probability Density") +
  geom_point() +
  geom_line()

# higher rates = sharper drop, lower rates = flatter drop

#### Part 3: Precision and Sampling the Exponential

## Part 3a: Write a function that, given a vector, will ... 
## return a data frame or tibble of that vector with a mean and median

part_3a <- function(x) {
  mean_formula_3a = mean(x)
  med_formula_3a = median(x)
  return(list(c(mean_formula_3a, med_formula_3a)))
}

## Test is with a vector to make sure it’s doing the right thing

part_3a(c(1, 2, 3, 4, 5))
part_3a(c(10, 100, 1000))

## Part 3b: Write a function that, given a sample size and a rate, ...
## takes a sample from an exponential distribution ...
## and then use the above function to return the mean and median as a data frame.
## Show us it works. 
## One way to do this is by setting a seed before drawing a random sample ...
## and then getting the mean and median, and then setting the SAME seed before running your function.

part_3b <- function(n = 0,
                    x = 0){
  set.seed(3000)
  values = runif(n, min = 0, max = 1)
  exp_dist = dexp(values, rate = x)
  sample_mean = mean(exp_dist)
  sample_med = median(exp_dist)
  set.seed(3000)
  return(data.frame("Rate" = x,
                    "Mean" = sample_mean,
                    "Median" = sample_med))
}
part_3b(n = 10, x = 3)
part_3b(1000, 0.5)

## Part 3c: Write a function that, given a sample size, rate, ...
## and number of simulations (which defaults to 1e3), ...
## returns a data frame with however many rows of means and medians given your number of simulations. 
## Show it works by plotting the distribution of means and medians ...
## for rate = 2 and sample size = 10. 

# set assumptions
sample_size = 10
rate = 2
simulations = 1e3
sample_df = data.frame(1:sample_size)

# one sim
part_3c_onesim <- function(sample_size,
                           rate,
                           simulations) {
  values = runif(sample_size, min = 0, max = 1)
  exp_dist = dexp(values, rate = rate)
  sample_mean = mean(exp_dist)
  sample_sd = sd(exp_dist)
  sample_med = median(exp_dist)
  data.frame("Sample_Size" = sample_size,
               "Rate" = rate,
               "Mean" = sample_mean,
               "Median" = sample_med)
}
part_3c_onesim(sample_size, rate, simulations)
# iterate
part_3c_iter <- function(sample_size,
                         rate,
                         sample_mean,
                         sample_med,
                         simulations) {
  map_df(1:simulations,
         ~part_3c_onesim(sample_size,
                         rate,
                         simulations))
}
part_3c_iter(sample_size = 10, rate = 2, simulations = 1e3)

part_3c_results <- sample_df %>% 
  summarize(part_3c_iter(simulations = simulations,
                         sample_size = sample_size,
                         rate = rate,
                         sample_mean = sample_mean,
                         sample_med = sample_med))
part_3c_results

## IMPRESS YOURSELF by doing this in only one ggplot using pivot_longer() ...
## to get the data into shape for plotting.






## Part 3d: Use the function tidyr::crossing() to make a tibble ...
## with all possible combinations of sample sizes c(3,5,7,9) ...
## and rate c(1, 1.5, 2, 4). 
## See the helpfile and learn one of your new favorite functions! 
## Take a look at the result!

sample_size = c(3, 5, 7, 9)
rate = c(1, 1.5, 2, 4)
part_3d <- crossing(
  "Sample_Size" = sample_size,
  "Rate" = rate)
part_3d

## Part 3e: With this data frame, use group_by() on sample size ...
## and rate and summarize on combination with the simulation function above ...
## to get simulated means and medians at all different parameter combinations. 
## Show us you have done so by plotting the distributions of your medians ...
## using facet_grid() to split up rate/sample size combinations.

part_3e <- part_3d %>% 
  group_by(Sample_Size, Rate) %>% 
  summarize(part_3c_iter(sample_size = Sample_Size,
                         rate = Rate,
                         simulations = 1e3))

part_3e_plot <- ggplot(data = part_3e,
                       aes(x = Mean,
                           y = Median)) +
  labs(title = "Simulated Means & Medians for All Parameter Combinations",
       subtitle = "Part 3e",
       x = "Mean",
       y = "Median") +
  stat_summary(aes(x = Mean,
                   y = Median), 
               geom = "line",
               size = 0.5,
               alpha = 0.5)
part_3e_plot

part_3e_plot +
facet_grid(Sample_Size ~ Rate)

## Part 3f: With this result, group by rate and sample size again ...
## and calculate the sd of each measure. 
## Then plot the resulting curves showing ...
## the influence of sample size on the precision of our estimate for mean and median. 
## What does this tell you? 
## Think about pivot_longer() to format for use with ggplot()

part_3f <- part_3e %>% 
  group_by(Sample_Size, Rate) %>%
  mutate(mean_sd = sd(Mean)) %>% 
  mutate(med_sd = sd(Median))
part_3f

part_3f_mean_plot <- ggplot(data = part_3f,
                            mapping = aes(x = Sample_Size,
                                          y = mean_sd,
                                          group = Rate,
                                          color = Rate)) +
  geom_point() +
  geom_line() +
  labs(title = "Influence of Sample Size on Precision of Mean Estimate",
       subtitle = "By Rate",
       x = "Sample Size",
       y = "Precision of Mean Estimate (sd)",
       legend = "Rate")
part_3f_mean_plot

part_3f_med_plot <- ggplot(data = part_3f,
                            mapping = aes(x = Sample_Size,
                                          y = med_sd,
                                          group = Rate,
                                          color = Rate)) +
  geom_point() +
  geom_line() +
  labs(title = "Influence of Sample Size on Precision of Median Estimate",
       subtitle = "By Rate",
       x = "Sample Size",
       y = "Precision of Median Estimate (sd)",
       legend = "Rate")
part_3f_med_plot

## Part 3g: What should your sample size be and why under different rates?

# Sample size should be as large as possible for both mean and median ...
# (in this case, 9) because variance (sd in mean and median) decreases ...
# as sample size increases

# Can also look at the spread of means
part_3g_mean <- ggplot(data = part_3f,
                       mapping = aes(x = Sample_Size,
                                     y = Mean,
                                     color = Rate)) +
  labs(title = "Variance of Mean by Sample Size",
       subtitle = "Across Rates",
       x = "Sample Size",
       y = "Mean",
       color = "Rate") +
  geom_point(alpha = 0.5) +
  geom_jitter() +
  facet_wrap(~Rate)
part_3g_mean

# Sample size of 10 had lowest spread in means across all rates

# And the spread of medians
part_3g_med <- ggplot(data = part_3f,
                     mapping = aes(x = Sample_Size,
                                   y = Median,
                                   color = Rate)) +
  labs(title = "Variance of Medians by Sample Size",
       subtitle = "Across Rates",
       x = "Sample Size",
       y = "Median",
       color = "Rate") +
  geom_point(alpha = 0.5) +
  geom_jitter() +
  facet_wrap(~Rate)
part_3g_med

# same as above



