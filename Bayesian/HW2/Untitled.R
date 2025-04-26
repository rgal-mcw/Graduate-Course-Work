#Ryan Gallagher
#Bayesian HW 2
#Exercise 3.4

# Prior is NoGa(130, 1/3, 4, 1000) on (mu, tau)
mu_0 = 130
k = 1/3
c=4
d=1000

#(a)
#From the notes, we know that tau~Ga(4,1000)
#                   and mu|tau ~ N(130, tau*1/3)

tau3.4 = rgamma(1, c, d)

#From my derivation, we have (mu|tau, y) ~ N(134.4963, 3/(1213*tau))
#So,
sigma3.4 = 1/sqrt(tau3.4)
margPostmu = rnorm(10000, 134.4963, sigma3.4)
plot(density(margPostmu), main="Marginal Posterior for mu", xlab='Mu', col=2, lwd=3)

#(b)
LL = (132.5 - 134.4963) / sqrt(3 / (1213*tau3.4)) #Standardize
pnorm(LL) #Get probability
UL = (135.5 - 134.4963) / sqrt(3 / (1213*tau3.4)) #Standardize
pnorm(UL)# Get probability 
pnorm(UL) - pnorm(LL) #Prob of upper - prob of lower


