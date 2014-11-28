#!/bin/bash

. config;
command="xml/getavailpstn.xml";
response="response/getavailpstn.response.xml";

>$response;
cat $command.tmpl | sed "s/CHANGEmeENT/"$ENT"/;s/CHANGEmeGR/"$GROUP"/" > $command;
./lib/OCIclient.sh $command $response;
./lib/FixXml.awk $response | ./lib/GetPSTN.awk;


