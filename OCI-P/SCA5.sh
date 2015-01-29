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

commandt="xml/sca5add.xml";
responset="response/sca5add.response.xml";

for ((i=1;i<6;i++)); do
    PORT=${USERID}$i;
    >${responset}${i};
    cat $commandt.tmpl |\
     sed "s/CHANGEmeID/$USERID/;\
     s/CHANGEmePORT/$PORT/;\
     s/CHANGEmeDMN/$DOMAIN/;\
     s/CHANGEmeDEVP/$DEVPROFNAME/;\
     s/CHANGEmeDEVL/$DEVPROFLEVEL/" > ${commandt}${i};
done;

./lib/OCIclient.sh $command $response ${commandt}1 ${responset}1 ${commandt}2 ${responset}2 ${commandt}3 ${responset}3 ${commandt}4 ${responset}4 ${commandt}5 ${responset}5;
./lib/FixXml.awk $response | checkecho;
./lib/FixXml.awk ${responset}1 | checkecho;
./lib/FixXml.awk ${responset}2 | checkecho;
./lib/FixXml.awk ${responset}3 | checkecho;
./lib/FixXml.awk ${responset}4 | checkecho;
./lib/FixXml.awk ${responset}5 | checkecho;

