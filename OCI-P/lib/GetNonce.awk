#!/usr/bin/gawk -f

{
    if ($0~"nonce") {
        split ($0,value,"[>|<]");
        printf ("%s\n",value[3]);
    }
}