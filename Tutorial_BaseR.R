############################################################################################
##### Base R Stuff
##### Description: This section shows some of the Base R functionality; go ahead and 
#####              mess around with creating vectors, data frames, loops, and whatnot 
#####              here. Note that these work without any additional packages.
##### Note: For a more thorough tutorial, I highly recommend Data Camp.
#############################################################################################
# Creating character vectors
char_vec <- c("char1", "char2")

# Creating numeric vectors
num_vec  <- c(3,2,4)

# Creating a vector of a particular pattern
james_v <- "James"
bron_v  <- "Lebron"
king_v  <- rep(c(bron_v, james_v), times = 10)
print(king_v)

king2_v <- rep(c(bron_v, james_v), each = 10)
print(king2_v)

# Create a matrix from some vectors; matrices are created using a single vector, but we can specify rows, columns, and 
# how they are filled
num_vec1 <- c(1,1,4)
num_vec2 <- c(3,4,2)
num_vec  <- c(num_vec1, num_vec2)

matrixA  <- matrix(num_vec, nrow = 2, ncol = 3, byrow = TRUE)
print(matrixA)

matrixB  <- matrix(num_vec, nrow = 2, ncol = 3, byrow = FALSE)
print(matrixB)

# Create a more powerful data matrix called a data.frame that includes row and column names
df <- data.frame("var1" = num_vec1, "var2" = num_vec2, stringsAsFactors = FALSE)

# Using indexes to grab values, rows, or columns
num1 <- num_vec1[1]
row1 <- df[1,]
col1 <- df[,1]

rowvec1 <- df[[1]]
print(rowvec1)

rowvec1 <- df[["var1"]]
print(rowvec1)

rowvec1 <- as.numeric(df$var1)
test <- df$var2
print(rowvec1)

# Changing values using Base R (the tidyverse package or the data.table package are alternatives to this; I regularly use both
# tidyverse and base R methods for manipulating data)
num_vec1[1] <- 4
df[1,1] <- 3
df["var1",] <- c(3, 4)

# For loops
for (i in num_vec){
  print(i)
}

# While Loops
track <-1
while (track < 10){
  track <- track + 1
}
print(track)

# Conditionals
nicevec    <- "nice"
notnicevec <- "not nice"
if (num_vec[1] == 420){
  print(nicevec)
}else {
  print(notnicevec)
}
