
## Proleptic Gregorian Calendar

#This line uses expand.grid() to creat a data fram with all values that can be formed with combinations of all the vectors or factors passed to the functions as an arguement.
#The ":" is formatted as from:to.
GC = expand.grid(31:1, 12:1, 1582:(-4713), KEEP.OUT.ATTRS=FALSE)

#This line names the above variables
names(GC)=c('GC.day', 'GC.month', 'GC.year')

#Create a variable for all dates thats TRUE. Why the "$" tho?
GC$GC.valid=TRUE

#Define months that have 30 days as such. April,June,Sept.,Nov
GC$GC.valid[(GC$GC.month %in% c(4,6,9,11)) & GC$GC.day==31]=FALSE

###Define Leap Day
# This line makes a base that Feb29-31 dont exist
GC$GC.valid[GC$GC.month==2 & (GC$GC.day %in% 29:31)]=FALSE

#This line will make a conditional on when Feb 29 CAN exist
#Rule for Gregorian Calender is: Every year divisible by 4 is a leap year
#Except for years that are divisible by 100
#I think it should be structured as: If the year is divisible by 4 AND NOT divisible by 100 IS a leap year
                #OR ||             # If the year is evenly divisiblE by 400 then it IS a leap year

GC$GC.valid[(GC$GC.year%%4)==0 &
            ((GC$GC.year%%100)!=0 |
            (GC$GC.year%%400)==0) &
            GC$GC.month==2 &
            GC$GC.day==29]=TRUE

#The above line satisfies the Gregorian Leap Year Criteria

#Below adds NA to the table of TRUE/FALSE
addmargins(table(GC$GC.valid, useNA='ifany'))

#These lines set the table length to be as long as there are valid days
(NG=length(GC$GC.valid))
#(M=sum(GC$GC.valid))
NYE1582=as.integer(as.Date('1582/12/31'))
str(seq(NYE1582, NYE1582-M+1, -1))

GC$period=NA
GC$period[GC$GC.valid]=seq(NYE1582, NYE1582-M+1, -1)
GC$weekday=((GC$period-4)%%7)+1 ##Monday is 1 and 7 is Sunday
table(GC$weekday)

subset(GC, GC.year==1582 & GC.month==10)
subset(GC, GC.year==-4712 & GC.month==1& GC.day==1)
GC[GC$valid, ][M, ]

#Hint: Year in -4713

#Answer: 11/24/4713BCE, The ISO date is 11/24/4714BCE bc no yr 0.
