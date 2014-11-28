#!/usr/bin/gawk -f

BEGIN {
    total=0;
    printf ("USERID\t\tUSER-AGENT\n");
}

{
    if ($0 ~ "<row>") {
        total++;
        for (i=1;i<=15;i++) {
            getline line;
            if (i==3||i==15) {
                split (line,value,"[>|<]");
                printf ("%s\t",value[3]);
            }
        }
        printf ("\n");
    }
}

END {
    print ("TOTAL:",total);
}
