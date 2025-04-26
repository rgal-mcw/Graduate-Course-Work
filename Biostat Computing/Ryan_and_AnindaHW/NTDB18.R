## NTDB HW (all code at the bottom) submitted by Ryan Gallagher and Aninda Roy



ntdb = read.csv("~/04224/R_stuff/NTDB18.csv", stringsAsFactors=FALSE)

## is ntdb sorted by traumactr?
all(ntdb$traumactr==sort(ntdb$traumactr))
ntdb = ntdb[order(ntdb$traumactr), ]

table(ntdb$white, ntdb$black, useNA='ifany')
table(ntdb$white, ntdb$other, useNA='ifany')
table(ntdb$hispanic, useNA='ifany')
table(ntdb$male, useNA='ifany')
summary(ntdb$sbp)
summary(ntdb$pulse)
summary(ntdb$rr)

table(ntdb$gcstot, useNA='ifany')
table(ntdb$tbi_icd9, useNA='ifany')
table(ntdb$year, useNA='ifany')
table(ntdb$dead, useNA='ifany')
table(ntdb$age, useNA='ifany')
addmargins(table(ntdb$male, useNA='ifany'))

fit=glm(dead~gcstot+male+age+black+other+year+factor(traumactr),
                     data=ntdb, family='binomial')
summary(fit)

## calculate total volume
table(ntdb$traumactr, useNA='ifany')

vol = cbind(1, ntdb$traumactr)
(totvol.=tapply(vol[ , 1], vol[ , 2], sum))
(totvol=cbind(traumactr=as.integer(dimnames(totvol.)[[1]]),
              totvol=totvol.))

ntdb.=merge(ntdb, totvol, by='traumactr')
table(ntdb.$totvol)

## calculate annual volume
(a=table(ntdb$traumactr, ntdb$year, useNA='ifany'))

apply(a>0, 1, sum)

## fit=glm(dead~gcstot+male+age+black+other+year+totvol+factor(traumactr),
##                      data=ntdb., family='binomial')
## summary(fit)

##Hospital ID is traumadtr
##year is year

#####HW4 part1.#######
#####This utilizes the sum function in the apply() function for the table of traumaCtr x Year. 
ctrXyr = table(ntdb$traumactr,ntdb$year,useNA='ifany')
YearlySums = apply(ctrXyr>0,1,sum)
traumactrTbl = table(ntdb$traumactr,useNA='ifany')
avgCtr = traumactrTbl / YearlySums
avgCtr
###################
###################
#### HW part2 #####

ntdb.2 = read.csv("~/04224/R_stuff/NTDB18.csv", stringsAsFactors=FALSE)[ ,c('INC_KEY','white', 'black', 'other', 'hispanic', 'male', 'sbp', 'pulse', 'rr')]
ntdb.check = read.csv("~/04224/R_stuff/NTDB18.csv", stringsAsFactors=FALSE)[ ,c('INC_KEY','white', 'black', 'other', 'hispanic', 'male', 'sbp', 'pulse', 'rr')]

nrow(ntdb.2) #should be =nrow(ntdb)=49778
set.seed(2)

### Q's : For a variable like hispanic where I've calc'ed that (without NA's) the reporting ratio is 1269:37121 (yes:no), should we still rely on a 0/1 (50% chance) random number generator? It seems like there certainly isnt a 50% chance these folks are hispanic / not.
### Q: For a variable like spb, how should we figure out the gauge on how small a reasonable minimum value is? Should we accept 0 here?


###ntdb.2[1, 2] = 0    ## CHANGES THE VALUE OF THE 1 ROW 2ND COLUMN TO 0
## 48 is the first row with white = NA
## I've tackled this problem assuming that white, black, and other are all mutually exclusive events. 

## white column
i=0
for (value.w in ntdb.2$white) {
    i=1+i
    if (is.na(value.w) == TRUE) {
        ntdb.2[i, 2] = sample(0:1, 1, replace=TRUE)
        }
    }

#black column
j=0
for (value.b in ntdb.2$black) {
    j=j+1
    if (is.na(value.b) == TRUE && ntdb.2[j, 2]==1) {
        ntdb.2[j, 3] = 0
        } else if (is.na(value.b) == TRUE && ntdb.2[j, 2]==0) {
            ntdb.2[j, 3] = sample(0:1, 1, replace=TRUE)
            }
    }

### 48, 66, 111, 179, 227, 338, 426, 466, 567, 610, should all be "other" after the next code -> which(ntdb.2$white==0 & ntdb.2$black==0)
### which(is.na(ntdb$white)==TRUE & is.na(ntdb$black)==TRUE & is.na(ntdb$other)==TRUE) (out of curiousity)
which(is.na(ntdb.2$white)==FALSE & is.na(ntdb.2$black)==FALSE & is.na(ntdb.2$other)==TRUE) ## should be 0 after this loop

#other column
k=0
for (value.o in ntdb.2$other) {
    k=k+1
    if (is.na(value.o) == TRUE & (ntdb.2[k, 2] == 1 | ntdb.2[k,3] == 1)) { 
        ntdb.2[k, 4] = 0
        } else if (is.na(value.o)==TRUE & ntdb.2[k, 2]==0 & ntdb.2[k, 3]==0) {
            ntdb.2[k, 4] = 1
            }

    }

## Check:
sum(is.na(ntdb.2$white))
sum(is.na(ntdb.2$black))
sum(is.na(ntdb.2$other))
which(is.na(ntdb.2$other)==TRUE)
which(ntdb.2$black==1 & ntdb.2$other==1)
which(is.na(ntdb.2$white)==TRUE | is.na(ntdb.2$black)==TRUE | is.na(ntdb.2$other)==TRUE)

## hispanic column
h=0
for (value.h in ntdb.2$hispanic) {
    h=h+1
    if (is.na(value.h) == TRUE) {
        ntdb.2[h, 5] = sample(0:1, 1, replace=TRUE)
        }
    }

## male column
m = 0
which(is.na(ntdb.2$male)==TRUE)
for (value.m in ntdb.2$male) {
    m=m+1
    if (is.na(value.m) == TRUE) {
        ntdb.2[m, 6] = sample(0:1, 1, replace=TRUE)
        }
    }

which(is.na(ntdb.2$male)==TRUE)

## sbp
max(ntdb.2$sbp, na.rm=TRUE) #=280
min(ntdb.2$sbp, na.rm=TRUE) #=0
s = 0
which(is.na(ntdb.2$sbp)==TRUE)
for (value.s in ntdb.2$sbp) {
    s=s+1
    if (is.na(value.s) == TRUE) {
        ntdb.2[s, 7] = sample(0:280, 1, replace = TRUE)
        }
    }
which(is.na(ntdb.2$sbp)==TRUE)

## pulse
max(ntdb.2$pulse, na.rm=TRUE) #= 274
min(ntdb.2$pulse, na.rm=TRUE) #= 0
p = 0
for (value.p in ntdb.2$pulse) {
    p=p+1
    if (is.na(value.p) == TRUE) {
        ntdb.2[p, 8] = sample(0:274, 1, replace=TRUE)
        }
    }

which(is.na(ntdb.2$pulse)==TRUE)

## rr
max(ntdb.2$rr, na.rm=TRUE) #=98
min(ntdb.2$rr, na.rm=TRUE) #=0
r = 0
for (value.r in ntdb.2$rr) {
    r=r+1
    if (is.na(value.r) == TRUE) {
        ntdb.2[r, 9] = sample(0:98, 1, replace=TRUE)
        }
    }

which(is.na(ntdb.2$rr)==TRUE)

#Check
sum(is.na(ntdb.2)==TRUE)

## Idea for hotdecking:
## while (sum(is.na(value.x)==TRUE) != 0)
## for (value.x in ntdb.2$thing)
## if (is.na(value.x) == TRUE) {
## ntdb.2[x, #] = ntdb.2[(x-4), #] }


##################################
####### HW part 3 ################
##################################

##ntdb is sorted in ascending order by INC_KEY
##Make a column, fill it, then replace it is my strategy
ntdb$strata = c(1:nrow(ntdb))
ntdb.g = data.frame(ntdb$INC_KEY,ntdb$gcstot,ntdb$dead,ntdb$strata)

#order it by gcstot
ntdb.go = ntdb.g[order(ntdb.g$ntdb.gcstot), ]

# M=5 permutation generator w/ replacement
k=0
while (k < nrow(ntdb.go)) {
    
repeat {
      n = sample(1:5, 1, replace=TRUE)
     n2 = sample(1:5, 1, replace=TRUE)
     n3 = sample(1:5, 1, replace=TRUE)
     n4 = sample(1:5, 1, replace=TRUE)
     n5 = sample(1:5, 1, replace=TRUE)

     if (n!=n2 & n!=n3 & n!=n4 & n!=n5 & n2!=n3 & n2!=n4 & n2!=n5 & n3!=n4 & n3!=n5 & n4!=n5) {
         ntdb.go[k, 4] = n
         ntdb.go[k+1, 4] = n2
         ntdb.go[k+2, 4] = n3
         ntdb.go[k+3, 4] = n4
         ntdb.go[k+4, 4] = n5
         k=k+5
         break
         }
     }
    }
#remove added last row bc I can't figure it out in the which statement
ntdb.go = ntdb.go[-c(49779), ]

#re order
ntdb.go = ntdb.go[order(ntdb.go$ntdb.INC_KEY), ]

#DONE!!!
