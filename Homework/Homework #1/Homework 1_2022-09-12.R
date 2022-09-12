#### Start ####

#' @title Homework 1: Intro to R!
#' @date 2022-09-12
#' @author Nathan Strozewski
#  Biol 607 / 697

#### Part I ####

# Load quakes with data(quakes)

data(quakes)
quakes

# Show what’s there with str() and summary(). What do you see?

str(quakes) 
summary(quakes) 

# Notes:
    #' str() - variables are lat, long, depth, mag, stations
    #  summary() - min, max, median, quartiles for each variable

#### Part II ####

# Show the entirety of the column long

quakes[,"long"]

#### Part III ####

# Hey, another useful function - unique()! 
    #' Apply it to a vector, and you can see what are all of the unique values
    #' It’s great for really digging into a problematic vector.

unique(quakes)
unique(quakes[,"long"])
unique(quakes[,"mag"])

# Notes:
#' unique() returns the entered vector with duplicate data points removed
    #' unique() can be applied to an entire dataset or specific rows/cols
    #  I applied to cols here to test

#### Part IV ####

#' What unique stations are there?
#  Use length() with unique() to determine how many stations there are

length(unique(quakes[,"stations"]))

# Notes:
#' I tested ?length in the console to understand the new function
    #' I then established (unique(quakes[,"stations"]))
    #' I then applied length(x) where x = (unique(quakes[,"stations"]))
    #' Result: There are 102 unique stations in the quakes dataset

#### Part V ####

# Using range(), what is the range of depths where quakes occur?

range(quakes[,"depth"])

# Notes:
#' I tested ?range in the console to understand the new function
    #' I then applied range(x) to dataset[row,col] ...
    #' where dataset is quakes, row is all (,) and col is "depth"
    #  Result: 40 - 680

#### Part VI ####

#' Impress Yourself. 
#' Where was the earthquake of largest magnitude found? 
    #' You’ll need to use some comparisons and the max() function for this ...
    #  in your indices instead of a number!

quakes[which.max(quakes[,"mag"]),]

#' Notes:
#' I first tested max on "mag" variable to know what value I was looking for 
    #' max(quakes[,"mag"]) returned = 6.4
#' I then looked into ?which.max to understand its usage
    #' Then I applied which.max to locate the index of the max "mag" value
    #' which.max(quakes[,"mag"]) returned 152
#' I then pulled index 152 from the quakes dataset 
    #' to see the lat, long, depth, and station values at the max
    #' quakes[152,] returned the lat, long, depth, and station values at mag 6.4
    #' I cross-checked the mag (6.4) with that from max(quakes[,"mag"]) and it matched
#' Lastly, I wanted to condense all these lines of code into one line
    #' I indexed quakes, with the row being the which.max line of code
    #' and the column being all (,)
    #' I cross-checked the return with that from quakes[152,] and it matched

#### Part VII - Meta Questions ####

#'  Meta 1.a.: How did it feel to connect concepts to a novel set of problems.
    #'  This was incredibly helpful and hopefully how the course will continue
    #'  Apply the concepts and skills helped me to better understand them
    #'  I made many mistakes along the way that I learned from
         #'  Not only specifically to the command I was working with
         #'  But with basic and general R function and operation

#'  Meta 1.b.: If you have experience with R, was this a cakewalk or challenging?
    #'   I have dabbled with R for "fun" and have used MATLAB fairly extensively
    #'   The biggest learning curve is switching over languages in my head
    #'   I am not multi-lingual, but I imagine it is a similar mental switch
    #'   For example, I keep typing % to comment instead of #
    #'   Little mistakes like that add a lot of time and detract from focus
    #'   I feel comfortable following the logic of R coding
    #'   But do always need to check whether what I type is logical
    #'   The biggest challenge is not knowing what options 
          #'   (i.e., functions) exist to solve the problem i am working on
          #'   But I guess that's what Google and stack overflow are for!
    #'  It's great that R detects error in code and suggests alternatives

#'  Meta 1.c.: How did it feel to shake off the cobwebs?
    #'  Great! I am really enjoying this class
    #'  It is great to take a class solely dedicated to developing a skill
    #'  Rather than building a knowledge base
    #'  I am very excited to continue
    #'  The litany of resources + degree of organization that Dr. Byrnes has
        #'  established is very helpful + reassures that I'll be able to
        #'  find a solution to any issues/questions I have

#' Meta 2.: How much time did this take you, roughly?
    #' Approx. 1 hour
    #' I really took my time to read into each function that I used
    #' Spend more time now to understand = spend less time on misunderstandings later!

#' Meta 3.: Please give yourself a weak/sufficient/strong assessment
   #' I performed strongly on this assignment
      #' Good recall of the material we covered in class/lab
      #' Took time to read into each function
      #' Tested multiple ways to apply them
      #' Once I finished the question, I tried to consolidate the code
          #' into as few lines, functions, etc. as possible
          #' to improve my understanding, logic, and efficiency

#### END #####