data scratch;
    i=1;
    do x = 1 to 5;
        y=2+i;
        i=i+1;
        output;
        end;
run;

proc print data=scratch;run;
        
        
