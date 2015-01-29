#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage $0 USERID PHONE";
    exit 1;
fi;

. config;
. common;
command="xml/cfnr.xml";
response="response/cfnr.response.xml";

USERID=$1;
NUMBER=$2;

>$response;
cat $command.tmpl |\
sed "s/CHANGEmeID/$USERID/;\
 s/CHANGEmeNUMBER/$NUMBER/" > $command;

./lib/OCIclient.sh $command $response;
./lib/FixXml.awk $response | checkecho;
