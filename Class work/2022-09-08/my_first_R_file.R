#' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @title My First R File
#' my_first_R_file.R
#' BIOL 607
#' @date 2022-09-08
#' This script is my attempt at learning the basics of R
#' Let's party
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#### Formatting notes ####
# Snake case = using underscores between terms to create variables
# Camel case = using hyphens between terms to create variables (not ideal, can be conflated with minus)
# Adding one hastag will leave a comment
# Adding one hastags with an apostrophe will allow you to quick enter subsequent lines of commments
# Adding multiple, consecutive hastags (4) will create a quick-locate feature

#### Basic commands ####
#' Cmd+Cntrl+ENTER to run script
#' Alternatively, select "Run" above
# Type a question mark before a command to get information on it, including working examples
# Alternatively, google it or type help(function name)
# Use an arrow <- to make a variable (left) equal to a value (right)
# Alternatively, use an equal sign (=) but this can lead to confusion. The arrow shows direction which can be helpful

#### START OF CODE ####

#### Arithmetic tests ####
(2*3)+10
sqrt(9)
log(10)
log(x = 10, base = 1)
log(x = 10, base = exp(1))

#### Variable tests ####

# Work with calculated values
# Example: pi
pi

# Make foo = the sqrt of 2
foo <- sqrt(2) # OR foo = sqrt(2)
foo + 100

#### More than a number - RENAME ####

# Classes
class(foo)

# Booleans = logicals (true or false)
# NOTES: True = 1, False = 0
3 < 4
4 + 10 <3
TRUE + 5
FALSE + 5

# Integers #
class(1)
class(1L)

# What about NOTHING #
NA # is a missing value
NA + 5
class(NA)
NaN # is Not a Number
NaN + 5
4/0
0/0
-5/0
class(NaN)

# IS functions #
biz <- NA + 5
is.na(biz)
is.nan(biz)
is.finite(biz)


#### BIOL697 Lab 2022-09-09 #####

#### VECTORS ####
#

my_numbers <- c(5, 6, 7, 8)

# get me the third element of my numbers#

my_numbers[3]

# a sequence of numbers from 1 to 100 #
my_sequence <- 1:100
my_sequence[82]
my_sequence

# a sequence of numbers from 1 to 100, steb by .5
seq(from = 1, to = 100, by = 0.5)

# add a value to all components of a vector
my_numbers + 5

# vectors of random numbers are common
runif(100, min = 0, max = 1)

sum(c(3,4,5))
mean(c(3,4,5))


#### Digging into more complex objects ####
class(my_numbers)
class(c("hell", "goodbye"))
class(c(TRUE, FALSE))
class(c(3,4,"5"))

combo_vec <- c(my_numbers, my_sequence)

#### Our hero str ####
# (ok, and summary, too) #

str(combo_vec)
summary(combo_vec)

vec_with_na <- c(1:100, 3, 4, NA, 200:1000)
str(vec_with_na)
sum(vec_with_na)
summary(vec_with_na)

# here's how to ignore NAs
sum(vec_with_na, na.rm = TRUE)

#### Exercise ####
# Create a vector of any class.

vector_A <- 1:10

# str() and summarize() it.

str(vector_A)
summary(vector_A)

# Create two vectors of different classes

vector_B <- 1:25
vector_C <- c("A", "B", "C", "D", "E", "F", "G")

# Combine them

vector_BC <- c(vector_B, vector_C)

# What do these two useful functions tell you what happened?

str(vector_BC)
summary(vector_BC)


#### Matrix ####

# Creating a matrix

my_matrix <- matrix(1:50, nrow = 10, byrow = FALSE)
my_matrix

# Access a specific row, column, or data point

my_matrix[4,]
my_matrix[,4]
my_matrix[2,2]

# What is the index of a value (16) in the matrix?

which(my_matrix == 16, arr.ind = TRUE)


#### Get more info about this matrix ####

str(my_matrix) # Readout is class [row:row, column:column] value value value ...

summary(my_matrix)

# Get number of rows, columns, dimensions of a matrix

nrow(my_matrix)
ncol(my_matrix)
dim(my_matrix) # readout is [number of matrices] rows columns

rowMeans()


##### Exercise ####

# Create a 10x10 matrix of random uniform numbers between 5 and 50

matrix_A <- matrix(data = round(runif(100, min = 5, max = 50)), nrow = 10, ncol = 10)
matrix_A

# Get the row and column means

rowMeans(matrix_A)
colMeans(matrix_A)

# What is the output of str()?

str(matrix_A)

# What happens if you create a matrix by combining a numeric vector of
# length of 10 and a character vector of length 10?

matrix_B <- matrix(data = round(runif(10, min = 1, max = 10)), nrow = 1, ncol = 10)
matrix_B
matrix_C <- matrix(data = letters[1:10], nrow = 1, ncol = 10)
matrix_C

matrix_AB <- c(matrix_A, matrix_B)

# What is the output of str()?

str(matrix_AB)

# What is the difference in creating a matrix with 
# byrow = TRUE versus byrow = FALSE?

## byrow = TRUE organizes values by rows, byrow = FALSE does not

# Test this out by making a 5x5 matrix with the numbers 1:25


#### Numerics and characters #####

# Convert all values in my_vec into numerics

my_vec <- c(1, 2, "hello")
my_vec
as.numeric(my_vec) 

my_bad_vec <- c("3", "5", "6,")
as.numeric(my_bad_vec)
which(is.na(as.numeric(my_bad_vec)), arr.ind=TRUE)


#### LISTS #####

# Create a list

my_list <- list(First = 1:5,
                Second = letters[1:5])
my_list
class(my_list)
str(my_list)
summary(my_list)

# reference objects in a list (or subset)

my_list$First
my_list[1]

# weirdness ahoy!

class(my_list$First)
class(my_list[1])

my_list[[1]]
class(my_list[[1]])

my_list[["First"]] # double brackets help to inde

# nested lists

nested_list <- list(a = list(
  First = 1:10,
  Second = "hello"
))

nested_list
nested_list$a$Second # $ functions like double brackets, choose which works best
nested_list[["a"]][["Second"]]

# other list tools

names(my_list) #give you names of the subsets within a list
names(nested_list) # will only give you the top level of the list
my_list[c("First", "Second")]

my_names <- names(my_list)
my_list[my_names]


#### What if a list and a matrix had a baby ####


# A DATA FRAME #

#load some data on cars
#mtcars is a default dataset in R

data(mtcars) # data - loads specified data sets, or list the available data sets
head(mtcars) # head - returns first or last parts of dataset (alternatively, tails)
tail(mtcars)
str(mtcars) # shows objs, vars, data cols, classes
dim(mtcars) # shows dimensions of the matrix

# subsets

mtcars$cyl # indexes the cyl variable in the mtcars matrix
mtcars[,2] # indexes the second column in the mtcars matrix
mtcars[1:5,c("qsec", "vs")] # indexes the data from first five rows of the specified columns
mtcars[1:5,"qsec"] # indexes data from first five rows of specified columns


#### EXERCISE ####

# Load the morley dataset (experiments measuring speed of light)

data(morley)
morley

# what are the properties of the data? Explore!!!!

str(morley)
summary(morley)
dim(morley)

morley[,"Expt"]
morley[,"Run"]
morley[,"Speed"]

max(morley[,"Speed"]) # max speed value
min(morley[,"Speed"]) # min speed value















#### HOMEWORK #####

# Explore the dataset 'quakes' looking at earthquakes off of Fiji


# Run str() and summary()


# Show the entirety of the column 'long'


# Apply unique() to a vector and see what the unique values are

# What unique stations 




