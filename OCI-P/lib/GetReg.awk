#!/usr/bin/gawk -f

BEGIN {
    total=0;
    printf ("%-20s%-20s%-12s%-30s%-20s\n","ENT","GROUP","USERID","PORT","USER-AGENT");
}

{
    if ($0 ~ "<row>") {
        total++;
        for (i=1;i<=15;i++) {
            getline line;
            if (i==1||i==2||i==15) {
                split (line,value,"[>|<]");
                printf ("%-20s",value[3]);
            }
            if (i==3) {
                split (line,value,"[>|<]");
                printf ("%-12s",value[3]);
            }
            if (i==4) {
                split (line,value,"[>|<]");
                printf ("%-30s",value[3]);
            }
        }
        printf ("\n");
    }
}

END {
    print ("TOTAL:",total);
}
