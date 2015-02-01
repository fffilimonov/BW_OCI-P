#!/bin/bash

if [ $# -lt 5 ]; then
    echo "Usage $0 USERID PASS LAST FIRST EXT [PHONE]";
    exit 1;
fi;

. config;
. common;
command="xml/adduser1.xml.tmpl";

USERID=$1;
WPASS=$2;
LAST=$3;
FIRST=$4;
EXT=$5;
PHONE=$6;

if [ "$6" == "" ]; then
    command2="xml/adduser2.xml.tmpl";
else
    command2="xml/adduser2PSTN.xml.tmpl";
fi;

export USERID WPASS LAST FIRST EXT PHONE;

./lib/OCIclient.sh $command $command2;
./SetPacks.sh $USERID;
./SetPass.sh $USERID $WPASS;
