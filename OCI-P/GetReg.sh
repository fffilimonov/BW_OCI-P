#!/bin/bash

. common;
command="xml/getreg.xml.tmpl";
response="response/getreg.response.xml";

./lib/OCIclient.sh $command | ./lib/GetReg.awk;
