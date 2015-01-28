#!/bin/bash

. config;
command="xml/getusersgroup.xml";
response="response/getusersgroup.response.xml";

trap 'exit -1' ERR;

>$response;
cat $command.tmpl |\
 sed "s/CHANGEmeENT/$ENT/;\
 s/CHANGEmeGR/$GROUP/;" > $command;
./lib/OCIclient.sh $command $response;
./lib/FixXml.awk $response | ./lib/GetUsersGroup.awk;
