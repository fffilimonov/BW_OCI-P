#!/bin/bash

. common;
command="xml/getreg.xml";
response="response/getreg.response.xml";

>$response;
cat $command.tmpl > $command;
./lib/OCIclient.sh $command $response;
./lib/FixXml.awk $response | ./lib/GetReg.awk;
