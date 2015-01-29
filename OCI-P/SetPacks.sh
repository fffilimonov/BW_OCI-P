#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage $0 USERID";
    exit 1;
fi;

. config;
. common;
command="xml/setpackage.xml";
response="response/setpackage.response.xml";

USERID=$1;

echo $SERVICEPACKS | gawk -F ";" '{for(i=1;i<=NF;i++){print $i}}' | while read SP; do
    >$response;
    cat $command.tmpl | sed "s/CHANGEmeID/$USERID/;s/CHANGEmeSP/$SP/" > $command;
    ./lib/OCIclient.sh $command $response;
    ./lib/FixXml.awk $response | checkecho;
done;
