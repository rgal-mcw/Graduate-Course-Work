#Ryan Gallagher
#Bayesian HW 2
#Exercise 3.2

VetBP = read.csv("/Users/ryangallagher/Desktop/MedicalCollegeofWisconsin/Bayesian/VetBP.csv")

dat3.2 = VetBP$SBP_00
n=length(dat3.2)
var3.2 = 242.2
tau3.2 = 1/sqrt(var3.2)
y_bar3.2 = 134.5

#(a)
prior3.2 = rnorm(10000, 130, 100)
primean3.2 = 130
prisd3.2 = 100
privar3.2 = prisd3.2^2
pritau3.2 = 1/sqrt(privar3.2)
plot(density(prior3.2), col=2, lwd=3, ylim=c(0,0.015), main="Pri vs. Post - exc 3.2a", xlab="mu")

post3.2mean = ((n*tau3.2*y_bar3.2) + (pritau3.2*primean3.2)) / (n*tau3.2 + pritau3.2)
post3.2tau = 1/(pritau3.2 + n*tau3.2)
post3.2sd = 1/(post3.2tau)
post3.2 = rnorm(10000, post3.2mean, post3.2sd)
lines(density(post3.2),col=3, lwd=3)
legend(250, .010, legend=c("Prior","Posterior"), col=c("Red","Green"),lty=1, lwd=3, cex=0.5)

mean(post3.2)#=134.3432
median(post3.2)#=134.0742
quantile(post3.2, c(0.025, 0.975)) # 95% cred int = [84.0419, 185.37791]

#(b) 
b3.2 = rnorm(1, post3.2mean, post3.2sd)
pred_dist3.2 = rnorm(10000, b3.2, post3.2sd)
plot(density(pred_dist3.2))
mean(pred_dist3.2)
median(pred_dist3.2)
quantile(pred_dist3.2,c(0.025,0.975))
