#!/bin/bash

if [ $# -lt 5 ]; then
    echo "Usage $0 USERID PASS LAST FIRST EXT [PHONE]";
    exit 1;
fi;

. config;
command="xml/adduser1.xml";
response="response/adduser1.response.xml";

USERID=$1;
PASS=$2;
LAST=$3;
FIRST=$4;
EXT=$5;
PHONE=$6;

>$response;
cat $command.tmpl |\
 sed "s/CHANGEmeID/"$USERID"/;\
 s/CHANGEmePASS/"$PASS"/;\
 s/CHANGEmeLAST/"$LAST"/;\
 s/CHANGEmeFIRST/"$FIRST"/;\
 s/CHANGEmeCLAST/"$LAST"/;\
 s/CHANGEmeCFIRST/"$FIRST"/;\
 s/CHANGEmeENT/"$ENT"/;\
 s/CHANGEmeGR/"$GROUP"/;\
 s/CHANGEmeDMN/"$DOMAIN"/" > $command;
./lib/OCIclient.sh $command $response;
./lib/FixXml.awk $response | grep "echo";

if [ "$6" == "" ]; then
    command="xml/adduser2.xml";
    response="response/adduser2.response.xml";
else
    command="xml/adduser2PSTN.xml";
    response="response/adduser2PSTN.response.xml";
fi;

>$response;
cat $command.tmpl |\
 sed "s/CHANGEmeID/"$USERID"/;\
 s/CHANGEmePORT/"$USERID"/;\
 s/CHANGEmePHONE/"$PHONE"/;\
 s/CHANGEmeDMN/"$DOMAIN"/;\
 s/CHANGEmeDEVP/"$DEVPROFNAME"/;\
 s/CHANGEmeDEVL/"$DEVPROFLEVEL"/;\
 s/CHANGEmeEXT/$EXT/" > $command;
./lib/OCIclient.sh $command $response;
./lib/FixXml.awk $response | grep "echo";

./SetPacks.sh $USERID;
./SetPass.sh $USERID $PASS;