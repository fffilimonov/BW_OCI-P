#!/bin/bash

. common;
command="xml/getusers.xml.tmpl";
response="response/getusers.response.xml";

./lib/OCIclient.sh $command | ./lib/GetUsers.awk;
