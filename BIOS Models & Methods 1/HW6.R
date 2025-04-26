# Clincal Trials HW6
# Ryan Gallagher - 11/20/2022

#------------------------------------------

#Problem 1a

dat = c(23,27,12,38)
mat_1a =  matrix(dat,2,2,)
rownames(mat_1a) = c("Excellent", "Not Excellent")
colnames(mat_1a) = c("A", "B")

fisher.test(mat_1a)

# Fisher's Exact Test returns an oddsnratio of 2.6975, which matches the
# odds ratio when calculated => (23/27) / (12/38) = 2.6975
#
# We also find that the 95% confidence interval is [1.0621, 6.9949], also from
# the fisher.test() function.

# Problem 1b

# H_0 = proportion of excellent outcomes are the same between procedure A and procedure B
# H_A = prop of excellent outcomes are different between procedure A and B

# Using Fishers Exact Test and the Chi-Squared Test:

fisher.test(mat_1a)
chisq.test(mat_1a)

# We find a p_value of 0.036 for this hypothesis. Thus we reject H_0 and conclude that there is a
# difference of proportion of outcomes between A and B at a significatnce of 5%.

#----------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------

# Problem 2

library(gsDesign)

# 80% power to detect an average cholesterol reduction of 5 units for the new drug compared to 0 units for placebo.
# Using a two-sided 5% significance level. SD of reduction is expected to be 10. A group sequential design with 3 equally spaced
# analyses is planned.
power=0.8
alpha=0.05
delta=5
strd_dev = 10
var = strd_dev^2
z_halpha = abs(qnorm(.025)) #=1.96
z_beta = qnorm(0.8) #=.84

# Problem 2 (A)
# We have H_0: delta=5, and our Z(t) ~ N(0,1). 2 groups (treatment and placebo). 3 equally spaced analysis are planned. 
# Using table 14.2 of Piantadosi

pocock = 2.289

# If the Z_score is ever greater than this value, we stop the trial. This is the Pocock stopping boundary for 3 analyses.
# The decision rule is that if any Z value during the trials exceeds pocock=2.289, then we reject H_0.

look = c(1,2,3)
Pocock_tab = c(2.289,2.289,2.289)
DecisionRule = data.frame(look,Pocock_tab)

# In order to find the maximum sample size, we must first find the inflation factor, R_p.
# We can find the inflation factor, R, from table 2.2 and 2.4 of Jennison and Turnbull:

R_p = 1.166 #R_p(3, 0.05, 0.8)
n_f = (2*(z_halpha + z_beta)^2*var) / delta^2
n_max = R_p * n_f #PER GROUP

# Thus, n_max = 73.2 per arm.
# Group size to enroll for each stage is m=73.2 / 3 = 24.4 ~=~ 24 per treatment
# Stop and reject H_0 at analysis j if |Z(t_j)| >= 2.289 for j=1,2,3.

# Then, the maximum information:
n1 = n_max
n2 = n1
MI_p = (var*(1/n1 + 1/n2))^(-1)

# We get MI = 0.366



## Problem 2(B)

## We have 3 equally spaced analyses planned.
## According to the gsDesign function

OBF1 = 3.47
OBF2 = 2.45
OBF3 = 2.00

## Then, we have the decision rule for all stages below:

OBF_tab = c(OBF1, OBF2, OBF3)
RuleOBF = data.frame(look, OBF_tab)


## Maximum sample size targeted

R_b = 1.024 #R_b(3, 0.05, 0.8)
n_maxOBF = R_b * n_f #This is per group

## n_maxOBF = 64.298 per group.
## Group size to enroll for each stage is m=64.298/3 = 21.099 ~=~ 21 per treatment
## Stop and reject H_0 at analysis j if |Z(t_j)| >= 1.985*(sqrt(3/j)) for j=1,2,3.

## With maximum information for 2 groups:

n1b = n_maxOBF
n2b = n1b
MI_b = (var*(1/n1b + 1/n2b))^(-1)

# Maximum Information for OBF is 0.3214


## Problem 2(C)

## Looking at both designs, I would prefer the O'Brien-Fleming design for a few reasons:
##
## Firstly, having a harder stopping boundary early would guard against early un-representative
## behavior in the data. Early outlier data could cause a stop in the Pocock design. This also
## piggy-backs into a more sensitive stopping boundary later, since more data should be more
## reflective of the true efficacy and should be more resistant to a narrower stopping boundary.
##
## Secondly, OBF offers a smaller expected sample size. This makes interim analysis easier in
## practice.

## Problem 2(D)

t_stat = c(1.37, 2.12, 2.17)
prob2d = data.frame(look, Pocock_tab, OBF_tab, t_stat)
plot(look, Pocock_tab, type='l')
lines(OBF_tab)
lines(t_stat)

## For these t-statistics, we would find that for design (A), the Pocock design, we would get
## no stoppage as a result of the t-statistics being smaller than the pocock limit = 2.289.
## The conclusion of this interim analysis would be to NOT stop the trial early. 

## For design (B), the OBF design, we would get stoppage at look 3 as a result of the third,
## and more sensitive, boundary being greater than the final of the t-statistics. The conclusion
## of the interim analysis for design (B) would be to stop the trial early. 


## Problem 3

# 2 treatment arms
# H_0: delta = pi_1 - pi_2 = 0.
pwr = .1
alpha = 0.025 #two-sided significance for alpha=.05
delta=.35-.20  #20% success in control to 35% success in treatment
looks = 4 #O'Brien-Fleming boundary
groups = 2 #control arm and treatment arm
varp3 = 1 #Since this is a binomial proportion

z_a = abs(qnorm(.025))
z_b = abs(qnorm(.9))

#From the Jennison & Turnbull Table

R_bp3 = 1.022

n_fp3 = (2*(z_a+z_b)*varp3)/delta^2

gsDesign(k=4, test.type=2,alpha=alpha,beta=pwr,sfu="OF",n.fix=n_fp3)

## This yields the following table
lookp3 = c(1,2,3,4)
OBF_dec = c(4.05,2.86,2.34,2.02)
OBF_prob3 = data.frame(lookp3, OBF_dec)


n_maxp3 = R_bp3 * n_fp3 # = 294.47 ~=~ 295 total and 74 per group

## Group size to enroll for each stage is m=295. 295/4 = 74 per treatment.
## Stop and reject H_0 at analysis j if |Z(t_j)| >= 2.02*(sqrt(4/j)) for j=1,2,3,4.

n1p3=n_maxp3/2
n2p3=n1
MI_p3 = (varp3*(1/n1+1/n2))^(-1)

#Gives a maximum information of 36.607
