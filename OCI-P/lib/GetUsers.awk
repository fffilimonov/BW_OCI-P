#!/usr/bin/gawk -f

BEGIN {
    total=0;
    printf ("%-18s%-18s%-18s%-18s%-16s\n","USERID","LAST NAME","FIRST NAME","PSTN","EXTENSION");
}

{
    if ($0 ~ "<row>") {
        total++;
        for (i=1;i<=13;i++) {
            getline line;
            if (i==1||i==4||i==5||i==7||i==13) {
                split (line,value,"[>|<]");
                printf ("%-16s  ",value[3]);
            }
        }
        printf ("\n");
    }
}
END {
    print ("TOTAL:",total);
}
