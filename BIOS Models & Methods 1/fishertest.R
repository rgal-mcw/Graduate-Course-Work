p = 0.5
Z = 1.96
E = 0.03

(Z^2*(p*(1-p)))/E^2

####

tab = matrix(c(750,250,2250,11750), byrow=TRUE, ncol=2)
fisher.test(tab)

