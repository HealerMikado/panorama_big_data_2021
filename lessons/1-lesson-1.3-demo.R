library(profvis)

# Generate a vector of 10 million random numbers
x <- runif(1e8)

# Compute the sum of the square roots of the vector using a for loop
sum_sqrt <- 0
for (i in 1:length(x)) {
  sum_sqrt <- sum_sqrt + sqrt(x[i])
}


# version 1: direct

profvis({
  sum_sqrt <- 0
  for (i in 1:length(x)) {
    sum_sqrt <- sum_sqrt + sqrt(x[i])
  }
})

# version 2: decompose

profvis({
  sum_sqrt <- 0
  for (i in 1:length(x)) {
    xi <- x[i]
    xi_sqrt <- sqrt(xi)
    sum_sqrt <- sum_sqrt + xi_sqrt
  }
})

# version 3: compare

profvis({
  sum_sqrt <- 0
  for (i in 1:length(x)) {
    sum_sqrt <- sum_sqrt + sqrt(x[i])
  }
  
  sum_sqrt <- sum(sqrt(x))
})


#


profvis( lm(formula = price ~ cut + color + clarity + carat, data = ggplot2::diamonds) )

