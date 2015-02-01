#!/bin/bash

. config;
. common;
command="xml/getavailpstn.xml.tmpl";

./lib/OCIclient.sh $command | ./lib/GetPSTN.awk;

