#### Enter the Data
y1 <- c(9, 9.5, 9.75, 10, 13, 9.5)
y2 <- c(13.25, 11.5, 12, 13.5, 11.5)

mean(y1)

mean(y2)

sqrt(var(y1))

sqrt(var(y2))


#### Assuming variance is equal between the two groups

test1 <- t.test(y1, y2, alternative="two.sided", var.equal=TRUE)

### Hard code the t-test
n1 <- length(y1)
n2 <- length(y2)
sp <- sqrt(((n1-1)*var(y1) + (n2-1)*var(y2))/(n1+n2-2))

TS = (mean(y1) - mean(y2))/(sp*sqrt(1/n1 + 1/n2))
df= n1 + n2 -2
pval = 2*pt(-abs(TS), df=df)

#### Assuming unequal variance between the two groups

test2 <- t.test(y1, y2, alternative="two.sided", var.equal=FALSE)

### Hard code this t-test
TS = (mean(y1) - mean(y2))/sqrt(var(y1)/n1 + var(y2)/n2)
df = (var(y1)/n1 + var(y2)/n2)^2/((var(y1)^2)/(n1^2*(n1-1)) + var(y2)^2/(n2^2*(n2-1)))
pval = 2*pt(-abs(TS), df=df)


###########################################################
############## Paired t-test ##############################
###########################################################

before <- c(1.71, 1.25, 2.13, 1.29, 1.58, 4, 1.42, 1.08, 1.83, 0.67, 1.13, 2.71, 1.96)
after <- c(0.13, 0.88, 1.38, 0.13, 0.25, 2.63, 1.38, 0.5, 1.25, 0.75, 0, 2.38, 1.13)
diff <- before - after

paired.t <- t.test(diff, alternative="two.sided")

unpaired.t.equal.var <- t.test(before, after, alternative="two.sided", var.equal=TRUE)
unpaired.t.unequal.var <- t.test(before, after, alternative="two.sided", var.equal=FALSE)


##############################################################
########### Output the Data to .csv to read into SAS #########
##############################################################
var1 <- c(before, after)
var2 <- c(rep("BEFORE", times=13), rep("AFTER", times=13))

dat <- data.frame(var1, var2)
colnames(dat) <- c("Response", "Group")
write.csv(dat, "~/Desktop/paired_test_example.csv", row.names=FALSE, quote=FALSE)

dat2 <- data.frame(before, after)
write.csv(dat2, "~/Desktop/paired_test_example2.csv", row.names=FALSE, quote=FALSE)



