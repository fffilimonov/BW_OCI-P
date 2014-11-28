#!/usr/bin/gawk -f

BEGIN {
    total=0;
    printf ("PSTN available\n");
}

{
    if ($0 ~ "<row>") {
        total++;
        for (i=1;i<=2;i++) {
            getline line;
            if (i==1) {
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
