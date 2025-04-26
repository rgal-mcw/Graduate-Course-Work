#HW 3 submitted by Ryan Gallagher and Aninda Roy

#Z ~ N(mean=10, sd=25),P[Z<c]=0.025: what is c
qnorm(0.025,10,25)
# =-38.9991

# Z~Beta(shape1=10, shape2=25), P[Z<c]=0.025, P[Z<d]=0.975
qbeta(0.025,10,25)
# c=0.1509837
qbeta(0.975,10,25)
# d=0.4436154

# Z ~ Gamma(shape=10,rate=25), P[Z<c]=0.025, P[Z<d]=0.975
qgamma(0.025,10,25)
# c=0.1918
qgamma(0.975,10,25)
# d= 0.68339

# F f: Z~F(df1=10,df2=25), P[Z<c]=0.025, P[Z<d]=0.975
qf(0.025,10,25)
# c = 0.298
qf(0.975,10,25)
# d=2.6134

#Poisson pois: Z~Poisson(lambda=25), P[Z<=15]=p
ppois(15,25)
# = 0.022293

#Normal norm:Z~N(mean=10,sd=25)
#Generate 10000 random Z and graphically compare the empirical CDF, ecdf(), with the true CDF.
#And calculate sigma^2

z = rnorm(10000,10,25) #this makes your variable Z
plot(ecdf(z)) #This plots the empirical cdf
plot(pnorm(z)) #This is the true CDF plot

N=10000
EstMC = rep(0,10000)
for(i in 1:N){
    Z = rnorm(N,10,25)
    EstMC[i] = mean(Z)
    }
var(EstMC)
