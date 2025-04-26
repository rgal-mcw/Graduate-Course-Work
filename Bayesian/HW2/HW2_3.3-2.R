#Ryan Gallagher
#Bayesian HW 2
#Exercise 3.3

#3.3
VetBP = read.csv("/Users/ryangallagher/Desktop/MedicalCollegeofWisconsin/Bayesian/VetBP.csv")
#We're concerned with SBP_00

dat3.3 = VetBP$SBP_00
df3.3=data.frame(dat3.3)
n=length(dat3.3)
pop_mean = 134.5
sumexp = 403 * 242.2
meanSBP_00 = mean(dat3.3)

#data is iid normally distributed
#Assume (prior tau) ~ Ga(4,1000) and that sum(y_i-mu)^2 = 403*242.2

(a)
pri_gammaA = 4
pri_gammaB=1000
pri3.3 = rgamma(10000, pri_gammaA, pri_gammaB)

#post from the book:
plot(density(pri3.3), col=2, lwd=3, ylim=c(0,1500), main="Prior vs. Posterior exercise 3.3a")

#Derived on paper (find in notability)
post_gammaA = 206
post_gammaB = 49803.3
post3.3 = rgamma(10000, post_gammaA, post_gammaB)
lines(density(post3.3),col=3,lwd=3)
legend(0.01, 1000, legend=c("Prior","Posterior"), col=c("Red","Green"),lty=1, lwd=3, cex=0.8)

mean(post3.3) #0.00413 - also is equal to post_gammaA/post_gammaB
quantile(post3.3, c(0.025, 0.975)) #95% credible interval is [0.003589, 0.004715]
#Mode = (alpha-1/beta)
mode = (post_gammaA - 1) / post_gammaB #=0.004116

#(b)
sigmapri3.3 = 1/sqrt(pri3.3)
sigmapost3.3 = 1/sqrt(post3.3)
plot(density(sigmapri3.3), col=2, lwd=3, main="Pri vs Posti for sigma - ex3.3B", ylim=c(0,0.8))
lines(density(sigmapost3.3))

#(c)
pred_tau = rgamma(1, post_gammaA, post_gammaB)
pred_dist = rnorm(10000, pop_mean, 1/sqrt(pred_tau))
plot(density(pred_dist))
mean(pred_dist) #wikipedia says that mean=mu
median(pred_dist)
quantile(pred_dist,c(0.025, 0.975))

