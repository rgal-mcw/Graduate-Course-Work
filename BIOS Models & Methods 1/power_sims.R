########### Power simulations


#### Example 5.6 from book

u1 = 4
u2 = 1
sigma = 10
delta = 0.3
n1 = 138
n2 = n1
alpha = 0.05
### Solution is power = 0.8

### Using the formula from the book, we need to assume our RVs
### are normally distributed, according to the parameters above.

### Generate data under these assumptions. Run a t-test. And repeat 1000 times

### Random number generator from the normal distribution

### Initiate the vector that you will populate in the "for loop"
p <- NULL
for(i in 1:10000){	
x1 <- rnorm(mean=u1, sd=sigma, n=n1)
x2 <- rnorm(mean=u2, sd=sigma, n=n2)
test <- t.test(x1, x2, var.equal=TRUE)
p[i] = test$p.value
}
## An estimate of the power is the number of times p < 0.05 divided by 1000.
power = sum(p<0.05)/10000

#################################################################################
############# Now, we want to calculate power across a range of sample sizes ####

power <- NULL
### We loop through a number of different sample sizes
ctr <- 1
sample.size = c(5, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 400)
for(j in sample.size){
u1 = 4
u2 = 1
sigma1 = 5
sigma2 = 7
delta = 0.3
n1 = j
n2 = n1+10
alpha = 0.05
p <- NULL
for(i in 1:1000){	
x1 <- rnorm(mean=u1, sd=sigma1, n=n1)
x2 <- rnorm(mean=u2, sd=sigma2, n=n2)
test <- t.test(x1, x2, var.equal=FALSE)
p[i] = test$p.value
}
power[ctr] = sum(p<0.05)/1000
ctr <- ctr+1
}
plot(sample.size, power, type="l")

####### We can use simulations to investigate Type I errors

### What happens when we use the pooled t-test when we have heterogeneous variances
### between our two groups? 

### In the type I error context, we assume H0 is true. 
### P(Type I error) = P(reject H0 when H0 is true)
u1 = 1
u2 = u1
sigma1 = 5
sigma2 = 5
n1 = 100
n2 = n1
p <- NULL
for(i in 1:1000){	
x1 <- rnorm(mean=u1, sd=sigma1, n=n1)
x2 <- rnorm(mean=u2, sd=sigma2, n=n2)
test <- t.test(x1, x2, var.equal=TRUE)
p[i] = test$p.value
}
alpha = sum(p<0.001)/1000

### alpha should be very close to our "decision rule" (which is p < value), if our 
### test has the correct type I error probability. 

### this simulation tells us that for "large" sample sizes, the pooled vs Satterthwaite
### doesn't matter much. 

### Pooled t-test is robust against heterogeneous variances, when sample sizes are large.




###### Even look at the robustness of the central limit theorem


#### T-test for u = 0 (single sample t-test)
#### Data are normally distributed
u = 0
sigma = 1
n = 10
p <- NULL
for(i in 1:1000){	
x <- rnorm(mean=u, sd=sigma, n=n)
test <- t.test(x)
p[i] = test$p.value
}
alpha = sum(p<0.05)/1000


#### T-test for u = 0 (single sample t-test)
#### Data are not normally distributed
u = 0
sigma = 1
n = 8
p <- NULL
for(i in 1:1000){	
x <- rchisq(df=2, n=n) - 2
test <- t.test(x)
p[i] = test$p.value
}
alpha = sum(p<0.05)/1000







