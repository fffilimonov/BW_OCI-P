#!/bin/bash

command="xml/getreg.xml";
response="response/getreg.response.xml";

trap 'exit -1' ERR;

>$response;
cat $command.tmpl > $command;
./lib/OCIclient.sh $command $response;
./lib/FixXml.awk $response | ./lib/GetReg.awk;

