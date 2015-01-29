#!/bin/bash

. common;
command="xml/getusers.xml";
response="response/getusers.response.xml";

>$response;
cat $command.tmpl > $command;
./lib/OCIclient.sh $command $response;
./lib/FixXml.awk $response | ./lib/GetUsers.awk;
