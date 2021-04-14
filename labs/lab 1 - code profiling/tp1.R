# Tutorial 1 — Profiling

library(tibble)
library(dplyr)
library(ggplot2)

# Shifting perspective from quality metrics to technical metrics (speed of execution, memory use)

# 0. First questions

# 0.1 What is your theoretical capacity? (CPU, memory, storage) Do you have several cores? Do you have a graphic card?

# 1. Regression

ns <- floor(exp(7:16)/20)
ps <- 1:20
# change the max until it starts to take time on your computer
# you should stop when your either the memory limit is reached
# (cannot allocate vector of size blah blah)
# or when the computing time exceeds 10 seconds
n <- max(ns)
p <- max(ps)

# S <- diag(length(ps))
# S[1,2] <- S[2,1] <- 0.9
# S[1,3] <- S[3,1] <- S[2,3] <- S[3,2] <- 0.8
# X <- cbind(2, MASS::mvrnorm(n, 1:length(ps), Sigma = S))
X <- cbind(2, replicate(p, runif(n, 0, p)))
colnames(X) <- c("Intercept", paste0("X", ps))
Y <- rowSums(X)

as_tibble(lm_scaling) %>% select(n, p, time) %>% unnest(time) %>% mutate(time=as.numeric(time)) %>% ggplot(aes(x=n, y=p)) + geom_contour(aes(z=time)) + geom_point(position = "jitter") + scale_x_log10()

as_tibble(lm_scaling) %>% transmute(n, p, time=as.numeric(median)) %>% ggplot(aes(x=n, y=p))+
  geom_point(shape="+", size = 3) + scale_x_log10() +
  geom_contour(aes(z=time), breaks = 10^rep(-4:3, each=9), size= 1) +
  geom_contour(aes(z=time), breaks = 2:9 * 10^rep(-4:3, each=8), size= 0.5)
  

%>% unnest(time) %>% mutate(time=as.numeric(time)) %>% ggplot(aes(x=n, y=p)) + geom_contour(aes(z=time)) + geom_point(position = "jitter") + scale_x_log10()

# 1.1 Naïve

beta <- solve( t(X) %*% X ) %*% ( t(X) %*% Y )

beta

# 1.2 Standard

results <- lm(Y ~ X)
results <- lm.fit(X, Y)

results$coefficients

# How to measure computation time?

library(microbenchmark)
# library(bench)

# By default system.time()

compare <- microbenchmark(
  # "standard" = lm(Y ~ X),
  "standard" = lm.fit(X, Y),
  "naïve"    = solve( t(X) %*% X ) %*% ( t(X) %*% Y )
  # times = 30 # defaults to 100
)

summary(compare)
ggplot2::autoplot(compare)

# How to measure memory size?


compare_crossprod <- bench::mark(
  "naïve" = t(X) %*% X,
  "crossprod()" = crossprod(X)
)

plot(compare_crossprod)

# bench::mark


compare <- bench::mark(
  min_time = 5,
  check = FALSE,
  "lm" = lm(Y~X),
  "lm.fit" = lm.fit(X,Y),
  ".lm.fit" = .lm.fit(X,Y),
  "naïve"    = solve( t(X) %*% X ) %*% ( t(X) %*% Y ),
  "naïve+crossprod"    = solve( crossprod(X) ) %*% ( t(X) %*% Y ),
  "QR decomposition" = {QR <- qr.default(X) ; backsolve(QR$qr, qr.qty(QR, Y)) }
)

# summary(compare)
plot(compare) # gc = garbage collection

# TO DO: compute standard deviation and so forth

# https://stackoverflow.com/questions/40250691/multiple-regression-analysis-in-r-using-qr-decomposition

# Graph of time vs. size of the problem

compare <- list()

for(i in seq_along(ns)){
  
  n <- ns[i]
  x <- X[1:n,]
  y <- Y[1:n]
  
  compare[[i]] <- bench::mark(
    check = FALSE,
    "standard" = lm.fit(x, y),
    "naïve"    = solve( t(x) %*% x ) %*% ( t(x) %*% y )
  ) %>% bind_cols(n=n)
  
}

compare <- bind_rows(compare)

ggplot(compare) + geom_line(aes(x=n, y=median, col=names(expression)))

# Graph of memory use vs. size of the problem

ggplot(compare) + geom_line(aes(x=n, y=mem_alloc, col=names(expression)))

# Running jobs in the background with R Studio

# Algorithmic analysis of the problem

# Shifting perspective: think under time constraint

# -> what is the benefit of 1 addtionnal second ?

# Shifting perspective: think under memory constraint

# -> what is the benefit of 1 addtionnal Mo ?

# No point of getting beyond the decimal precision

.Machine$double.eps
.Machine$double.neg.eps


# Sampling

# Algorithmic tricks

# Low level tricks

# compare lm, lm.fit and .lm.fit

# Using GPU

# library(devtools)
# install_github("nullsatz/gputools") # not maintained
# CUDA support is dropped in Mac OS Big Sur

# Local parallelisation

# > foreach to repeat one step several time (embarassingly parallel problems)
# > more subtle approaches for linear regression

# Online algorithm

# Questions 

# In RStudio, where can you read the size of the data.frame ?
# Use .... to get it programmatically.
# How can you time a specific code?


X1 <- runif(100, 0, 1)
X1 <- runif(100, 0, 1)

X <- runif(100, 0, 1)
# 3. 

# Compilation

# TO DO:
# [ ] Incorporate https://bookdown.org/egarpor/PM-UC3M/lm-iii-bigdata.html
# [ ] https://adv-r.hadley.nz/perf-measure.html
# [ ] https://www.bioconductor.org/packages/release/data/experiment/vignettes/RegParallel/inst/doc/RegParallel.html
# [ ] https://ethen8181.github.io/machine-learning/linear_regression/linear_regession.html
# [ ] https://thatdatatho.com/gradient-descent-line-search-linear-regression/
# [ ] https://qr.ae/pG7v33
# [ ] https://stats.stackexchange.com/questions/160179/do-we-need-gradient-descent-to-find-the-coefficients-of-a-linear-regression-mode
# [ ] https://stackoverflow.com/questions/55806808/why-are-gradient-descent-results-so-far-off-lm-results
# [ ] http://eric.univ-lyon2.fr/~ricco/tanagra/fichiers/fr_Tanagra_Gradient_Descent_R.pdf
# [ ] https://wlandau.github.io/gpu/lectures/intro/intro.pdf
# [ ] https://uwaterloo.ca/math-faculty-computing-facility/sites/ca.math-faculty-computing-facility/files/uploads/files/gpu-review.pdf
# [ ] https://nceas.github.io/oss-lessons/parallel-computing-in-r/parallel-computing-in-r.html
# [ ] https://stats.stackexchange.com/questions/263429/how-to-run-linear-regression-in-a-parallel-distributed-way-for-big-data-setting
# [ ] https://freakonometrics.hypotheses.org/53269
# [ ] https://freakonometrics.hypotheses.org/53283
# [ ] https://github.com/angelobacchini/logReg
# [ ] https://medium.com/@themantalope/glms-cpus-and-gpus-an-introduction-to-machine-learning-through-logistic-regression-python-and-3f226196b1db
# [ ] https://github.com/angelobacchini/logReg
# [ ] https://www.quora.com/How-can-I-run-linear-regression-in-parallel
# [ ] http://sd.blackball.lv/library/Mastering_Parallel_Programming_with_R_(2016).pdf
# [ ] https://stats.stackexchange.com/questions/253632/why-is-newtons-method-not-widely-used-in-machine-learning#:~:text=Gradient%20descent%20maximizes%20a%20function,is%20used%20in%20logistic%20regression).
# [ ] https://www.deeplearningbook.org/ (discussion about optimization)