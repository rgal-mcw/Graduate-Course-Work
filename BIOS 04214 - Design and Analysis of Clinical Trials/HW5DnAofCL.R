group = c(rep(1,21),rep(2,21))
count = c(1,1,2,2,3,4,4,5,5,8,8,8,8,11,11,12,12,15,17,22,23,6,6,6,6,7,9,10,10,11,13,16,17,19,20,22,23,25,32,32,34,35)
cens = c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,1,0,0,1,1,1,0,0,1,1,1,1,1)

dat = data.frame(group,count,cens)

write.csv(dat,"/Users/ryangallagher/Desktop/HW5_3.csv")

#####

q= qchisq(.95,df=2)

pchisq(q,df=2,ncp=.599)

#From guessing and checking for pchisq = .9, we find that
lambda = 0.559

