/* Ryan Gallagher
   04224 Exam 2 Problem 13 */

%colormac;

/* Progression from blue -> indigo -> violet -> maroon -> red */

data color;
    put "%CNS(BLUE)"; * =H00080FF;
    put "%CNS(BLUE PURPLE)"; * =H01E80FF;
    put "%CNS(PURPLE)"; * =H03C80FF;
    put "%CNS(PURPLE RED)"; * =H05A80FF;
    put "%CNS(RED)"; * =H07880FF;
run;



%macro colors(col1=,col2=,col3=,col4=,col5=);

data dat;
    do x=1 to 5;
        y=1;
        output;
        end;
run;
    
ods graphics on / reset imagename="&fnroot" imagefmt=png;
    
title "Pallette of colors from pure blue to pure red with inbetween";
proc sgplot data=dat noautolegend noborder;
    styleattrs datacontrastcolors=(&col1 &col2 &col3 &col4 &col5) /*backcolor=H0008000*/;
    scatter x=x y=y / group=x markerattrs=(symbol=SquareFilled size=98);
    label x="Color";
    yaxis display=(NOLABEL);
run;

%mend colors;
       
%colors(col1=H00080FF,col2=H01E80FF,col3=H03C80FF,col4=H05A80FF,col5=H07880FF);

*%helpclr(ALL);
