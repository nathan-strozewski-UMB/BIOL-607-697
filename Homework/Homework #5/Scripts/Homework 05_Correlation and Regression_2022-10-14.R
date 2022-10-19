#' ---------------------------------------------------------------
#' @title Homework #5: Correlation and Regression
#' @author Nathan Strozewski
#' @date  2022-10-14
#  ---------------------------------------------------------------

#### Part 1: Correlation - W&S Chapter 16

### How does learning a second language change brain structure?

## Part 1.0: Load data and review

brainlang <- read.csv("https://whitlockschluter.zoology.ubc.ca/wp-content/data/chapter16/chap16q15LanguageGreyMatter.csv")
str(brainlang)
summary(brainlang)
# vars are proficiency (treatment) and grey matter (outcome)

## Part 1a: Display association between the two vars in scatter plot

library(ggplot2)
library(ggpubr)
brainlang_basicviz <- ggplot(data = brainlang,
                             mapping = aes(x = proficiency,
                                           y = greymatter)) +
  geom_point()
brainlang_basicviz

# Adding a more advanced plot that includes R2 value and pearson correlation

brainlang_advancedviz <- ggscatter(brainlang,
                                   x = "proficiency",
                                   y = "greymatter",
                                   add = "reg.line",
                                   conf.int = TRUE,
                                   cor.coef = TRUE,
                                   cor.method = "pearson") +
  labs(title = "Does learning a second language change brain structure?",
       subtitle = "Comparing second language proficiency on grey matter volume",
       x = "Second language proficiency rating",
       y = "Grey matter volume")
brainlang_advancedviz

## Part 1b: Calculate the correlation between second language proficiency ...
## and gray-matter density

cor(brainlang$greymatter,
    brainlang$proficiency)

## Part 1c: SKIP

## Part 1d: What are the assumptions when testing the null hypothesis of zero correlation?

library(performance)

brainlang_lm <- lm(greymatter ~ proficiency,
               data = brainlang)

check_model(brainlang_lm)

# Posterior Predictive Check - simulated data compared to the observed data
# Linearity - observation depends on the treatment/condition
# Homogeneity of variance - variances of two or more samples are considered equal
# Independence of errors / Influential Observations - there is no relationship between the errors and the observations
# Normality (of residuals) - treatment follows a normal (Gaussian) distribution


## Part 1e: Does the scatter plot support these assumptions? Explain

# Predictions check
check_predictions(brainlang_lm,
                  iterations = 100)
# Predicted lines do not closely fit the observed data

# Linearity check

library(modelr)

brainlang <- brainlang |>
  add_predictions(brainlang_lm) |>
  add_residuals(brainlang_lm)

ggplot(brainlang,
       mapping = aes(x = pred, y = resid)) +
  geom_point() +
  stat_smooth()
# The reference line is not flat / horizontal - data appears non-linear

# Alternative plotting method:
# check_model(brainlang_lm, check = "ncv") %>% 
  # plot()

# Homogeneity:

check_heteroscedasticity(brainlang_lm) |>
  plot()
# again, data appears non-linear

# Normality:

check_normality(brainlang_lm) %>% 
  plot()
# Distribution is close-ish but not that close to the normal curve

# Alternative plotting method:
# check_normality(brainlang_lm) %>% 
# plot(type = "qq")

# Outliers:

plot(brainlang_lm, which = 4)
# distance is larger than previous examples we have covered

check_outliers(brainlang_lm) %>% 
  plot()
# All points are within the contour lines though

## Part 1f: Do the results demonstrate that second language proficiency ...
## affects gray matter density in the brain? Why or why not?

# The general trend is that as second language profic. increases, grey matter volume increases

model_performance(brainlang_lm)
# R2 value = 0.67. Somewhat strong correlation suggesting that language proficiency does increase grey matter

#### Part 2:

### Part 2: Load data and review

grass <- read.csv("https://whitlockschluter.zoology.ubc.ca/wp-content/data/chapter17/chap17q19GrasslandNutrientsPlantSpecies.csv")

str(grass)
summary(grass)

### Part 2a: Scatter plot the data

library(ggplot2)

grass_basicviz <- ggplot(data = grass,
                             mapping = aes(x = nutrients,
                                           y = species)) +
  geom_point()
grass_basicviz

### Part 2b: What is the rate of change in # plant species supported by nutrient type added?

# Create model
grass_lm <- lm(species ~ nutrients,
                   data = grass)

# Check it's fit
check_model(grass_lm)

# Check the estimate (rate of change) of the fitted line

tidy(grass_lm) # estimate = -3.34

### Part 2c: Add the least-squared regression line to the scatter plot

library(ggpmisc)

grass_fit_plot <- ggplot(data = grass_lm,
                         mapping = aes(x = nutrients,
      y = species)) +
  stat_poly_line() +
  stat_poly_eq(aes(label = paste(after_stat(eq.label),
                                 after_stat(rr.label), sep = "*\", \"*"))) +
  geom_point() +
  stat_smooth(method = "lm",
              formula = y ~ x)
grass_fit_plot

## R2 = 0.54

### Part 2d: Test the null hypothesis on no treatment effect on the number of plant species
# treatment = nutrients = x
# outcome = species = y

r(x) = 34.1 - 3.34x
f(0) = 34.1

#### Part 3:

### Part 3: Load data and review

beetle <- read.csv("https://whitlockschluter.zoology.ubc.ca/wp-content/data/chapter17/chap17q25BeetleWingsAndHorns.csv")

str(beetle)
summary(beetle)

beetle_basicviz <- ggplot(data = beetle,
                         mapping = aes(x = hornSize,
                                       y = wingMass)) +
  geom_point()
beetle_basicviz

### Part 3a: calculate the residuals

beetle_lm <- lm(wingMass ~ hornSize,
                 data = beetle)
beetle_lm
summary(beetle_lm)

### Part 3b: Produce a residual plot

beetle <- beetle %>% 
  add_predictions(beetle_lm) %>% 
  add_residuals(beetle_lm)

beetle_residual_plot <- ggplot(data = beetle,
                               mapping = aes(x = pred,
                                             y = resid)) +
  geom_point() +
  stat_smooth()
beetle_residual_plot

### Part 3c: evaluate main assumptions of linear regression (using provided plot & resid plot)

check_model(beetle_lm)

# linearity and homogeneity of variance look weird, PPC maybe looks weird

# looking at homogeneity of variance closer
check_heteroskedasticity(beetle_lm) %>% 
  plot()
# looking at linearity closer
check_model(beetle_lm, check = "ncv") %>% 
  plot()
# this could be non-linearity

### Part 3d: What steps should be taken?

# Transformation for non-linearity by log transformation

### Part 3e: Do any other diagnostics seem weird?

check_normality(beetle_lm) %>% 
  plot()
# distribution does not really fit the normal curve too closely

plot(beetle_lm, which = 4)
check_outliers(beetle_lm) %>% 
  plot(type = "bar")
check_outliers(beetle_lm) %>% 
  plot()
# there are a few data points (1, 6, 19) that are on the cusp of breaking the contour lines

#### Part 4:

### Part 4: load data and review

teeth <- read.csv("https://whitlockschluter.zoology.ubc.ca/wp-content/data/chapter17/chap17q30NuclearTeeth.csv")

str(teeth)
summary(teeth)

teeth_basicviz <- ggplot(data = teeth,
                          mapping = aes(x = deltaC14,
                                        y = dateOfBirth)) +
  geom_point()
teeth_basicviz

### Part 4a: what is the slope of the regression line?

teeth_lm <- lm(dateOfBirth ~ deltaC14,
               data = teeth)

teeth_fit_plot <- ggplot(data = teeth_lm,
                         mapping = aes(x = deltaC14,
                                       y = dateOfBirth)) +
  stat_poly_line() +
  stat_poly_eq(aes(label = paste(after_stat(eq.label),
                                 after_stat(rr.label), sep = "*\", \"*"))) +
  geom_point() +
  stat_smooth(method = "lm",
              formula = y ~ x)
teeth_fit_plot
# slope is -0.0533

### Part 4b: Which pair of lines shows the confidence bands? What do they tell us?

## The inner pair of dotted lines show confidence bands
## These indicate the range that the population parameter is likely to fall within

### Part 4c: Which pair of lines shows the prediction interval? What do they tell us?
 
## The outer pair of dotted lines show the prediction interval
## These indicate the range that likely contains a new value for a dependent variable given a new observation

### Part 4d: Use augment() and geom_ribbon() to reproduce the above plot with data, fit, fit interval, and prediction interval

teeth_model_log <- lm(log(dateOfBirth) ~ deltaC14,
                      data = teeth)

x_frame <- teeth %>% 
  data_grid(deltaC14 = seq_range(deltaC14, n = 100))

teeth_log_curve <- data_grid(teeth,
                             deltaC14 = seq_range(deltaC14, n = 100)) %>% 
  augment(x = teeth_model_log,
          data = .x,
          interval = "confidence") %>% 
  mutate(across(c(.fitted:.upper),
                .fns = exp))
teeth_log_curve

teeth_pred <- augment(x = teeth_lm,
                      newdata = x_frame,
                      interval = "prediction")
teeth_pred

teeth_conf_pred_plot <- teeth_basicviz + 
  geom_line(data = teeth_log_curve,
            mapping = aes(y = .fitted)) +
  geom_ribbon(data = teeth_log_curve,
              mapping = aes(y = .fitted,
                            ymin = .lower,
                            ymax  =.upper),
              alpha = 0.2) +
  geom_line(data = teeth_pred,
            mapping = aes(y = .fitted)) +
  geom_ribbon(data = teeth_pred,
              mapping = aes(y = .fitted,
                            ymin = .lower,
                            ymax  =.upper),
              alpha = 0.2)
teeth_conf_pred_plot

#### Part 5: Impress Yourself

### Part 5a: Fit the deets and bite model from last lab

mosquito <- read.csv("/Users/nathanstrozewski/Documents/Everything/Education/M.S. Biology UMB/Courses/003_F2022/Biological Data Analysis/Homework/Homework #5/Data/17q24DEETMosquiteBites.csv")

mosquito_model <- lm(bites ~ dose,
                     data = mosquito)

## Look at vcov()

vcov(mosquito_model)

## Look at mnormt()

library(mnormt)
rmnorm(4, mean = coef(mosquito_model), varcov = vcov(mosquito_model))

### Part 5b: Fit simulations

## Using geom_abline(), make a plot that has the following layers:
## 1) the data, 2) the lm fit with a CI, and 3) simulated lines
## You might have to muck around to make it look as good as possible

mosquito_plot <- ggplot(data = mosquito,
                        mapping = aes(x = dose,
                                      y = bites)) +
  geom_point()
mosquito_plot

mosquito_model_log <- lm(log(bites) ~ dose, data = mosquito)
mosquito_log_curve <- data_grid(mosquito,
                                dose = seq_range(dose, n = 100)) %>% 
  augment(x = mosquito_model_log,
          data = .x,
          interval = "confidence") %>% 
  mutate(across(c(.fitted:.upper),
                .fns = exp))
mosquito_log_curve

mosquito_sims <- data.frame(rmnorm(100, mean = coef(mosquito_model), varcov = vcov(mosquito_model)))
mosquito_sims

mosquito_plot_5b <- mosquito_plot + 
  geom_line(data = mosquito_log_curve,
            mapping = aes(y = .fitted)) +
  geom_ribbon(data = mosquito_log_curve,
              mapping = aes(y = .fitted,
                            ymin = .lower,
                            ymax  =.upper),
              alpha = 0.5) +
  geom_abline(slope = mosquito_sims$dose,
              intercept = mosquito_sims$X.Intercept)
mosquito_plot_5b

### Part 5c: Add prediction intervals for simulated lines

summary(mosquito_model_log)

mosquito_predictions <- data.frame(predict(mosquito_model_log, newdata = mosquito_sims, interval = "predict"))
mosquito_predictions 

# combine mosquito_predictions into same df as plotting data
# or create new df with lwr and upr added to plotting data as unique columns

library(dplyr)
mosquito_predictions_withbounds <- cbind(mosquito_sims, mosquito_predictions)
mosquito_predictions_withbounds

mosquito_predictions_final <- data.frame(mosquito_predictions_withbounds) %>% 
  mutate(X.Intercept_lwr = X.Intercept. - lwr) %>% 
  mutate(X.Intercept_upr = X.Intercept. + upr)
mosquito_predictions_final

mosquito_plot_5c <- mosquito_plot + 
  geom_line(data = mosquito_log_curve,
            mapping = aes(y = .fitted)) +
  geom_ribbon(data = mosquito_log_curve,
              mapping = aes(y = .fitted,
                            ymin = .lower,
                            ymax  =.upper),
              alpha = 0.5) +
  geom_abline(slope = mosquito_sims$dose,
              intercept = mosquito_sims$X.Intercept) +
  geom_ribbon(data = mosquito_predictions_final,
              mapping = aes(y = X.Intercept.,
                            ymin = X.Intercept_lwr,
                            ymax = X.Intercept_upr))
mosquito_plot_5c


mosquito_plot_5c <- mosquito_plot_5b + 
  geom_ribbon(data = mosquito_predictions_final,
              mapping = aes(y = X.Intercept.,
                            ymin = X.Intercept_lwr,
                            ymax = X.Intercept_upr))
mosquito_plot_5c

# can't figure out how to get the ribbon around the geom_abline values


#### Part 6: Meta Questions

### Meta 1: How well do you feel you understand the assumption testing behind a linear model? 
### If there are elements that confuse you, what are they? Why?

## I feel somewhat confident about assumption testing now
## When we first covered it in lecture, I didn't understand what the assumptions were or how they fit into statistical analysis
## After additional reading and practice, I get why we look at them and how they help
## I am still a little confused on 

### Meta 2: What concepts of linear regression are the clearest for you? 
### Which are the most opaque?

## Outliers makes the most sense - very straightforward
## The positive predictor check is really cool and makes sense
## I don't fully get homogeneity of variance, but I am getting there

### Meta 3: Even if you did not do the IYKYK part of this assignment ...
### do you see how simulation can be used with a fit model? 
### Do you feel it would be useful? 
### Do you have gaps in your understanding about why simulation could work here?

## I attempted IYb and could not get the ribbon of predicted bounds around my geom_abline
## But going through IYa and some of IYb was helpful to understand HOW we can use simulation with a fit model
## This would absolutely be useful - I really want to figure out how to finish this so that I can see
## No conceptual gaps yet - just technical (code) gaps

### Meta 4: How much time did this take you, roughly? 

# This took me approximately two hours

### Meta 5: Please give yourself a weak/sufficient/strong assessment on this assignment

## I would rate myself between sufficient and strong - maybe closer to strong
## I feel that I understand the concepts covered (mostly)
## I was able to complete all of the problems, except IYb which I got close-ish on
## I am definitely getting better at applying my knowledge and problem solving within R