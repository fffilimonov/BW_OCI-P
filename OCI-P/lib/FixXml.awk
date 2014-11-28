#!/usr/bin/gawk -f

BEGIN {
    RS="><"
}

{
    printf $0">\n<"
}