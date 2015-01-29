#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage $0 USERID PASS";
    exit 1;
fi;

. common;
command="xml/setpass.xml";
response="response/setpass.response.xml";

USERID=$1;
PASS=$2;

>$response;
cat $command.tmpl | sed "s/CHANGEmeID/$USERID/;s/CHANGEmePASS/$PASS/" > $command;
./lib/OCIclient.sh $command $response;
./lib/FixXml.awk $response | checkecho;
