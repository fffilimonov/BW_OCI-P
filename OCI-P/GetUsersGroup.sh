#!/bin/bash

. config;
. common;
command="xml/getusersgroup.xml.tmpl";

./lib/OCIclient.sh $command | ./lib/GetUsersGroup.awk;
