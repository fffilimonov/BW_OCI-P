#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage $0 USERID";
    exit 1;
fi;

command="xml/deluser.xml";
response="response/deluser.response.xml";

trap 'exit -1' ERR;

USERID=$1;

>$response;
cat $command.tmpl | sed "s/CHANGEmeID/$USERID/" > $command;
./lib/OCIclient.sh $command $response;
./lib/FixXml.awk $response | grep "echo";

