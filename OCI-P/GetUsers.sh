#!/bin/bash

command="xml/getusers.xml";
response="response/getusers.response.xml";

trap 'exit -1' ERR;

>$response;
cat $command.tmpl > $command;
./lib/OCIclient.sh $command $response;
./lib/FixXml.awk $response | ./lib/GetUsers.awk;
