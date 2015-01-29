#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage $0 USERID";
    exit 1;
fi;

. config;
. common;
command="xml/sca5.xml";
response="response/sca5.response.xml";

USERID=$1;

>$response;
cat $command.tmpl |\
 sed "s/CHANGEmeID/$USERID/" > $command;
./lib/OCIclient.sh $command $response;
./lib/FixXml.awk $response | checkecho;

command="xml/sca5add.xml";
response="response/sca5add.response.xml";

for ((i=1;i<6;i++)); do
    PORT=${USERID}$i;
    >$response;
    cat $command.tmpl |\
     sed "s/CHANGEmeID/$USERID/;\
     s/CHANGEmePORT/$PORT/;\
     s/CHANGEmeDMN/$DOMAIN/;\
     s/CHANGEmeDEVP/$DEVPROFNAME/;\
     s/CHANGEmeDEVL/$DEVPROFLEVEL/" > $command;

    ./lib/OCIclient.sh $command $response;
    ./lib/FixXml.awk $response | checkecho;
done;
