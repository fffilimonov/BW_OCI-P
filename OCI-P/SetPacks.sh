#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage $0 USERID";
    exit 1;
fi;

. config;
. common;
command="xml/setpackage.xml.tmpl";

USERID=$1;

export USERID SERVICEPACK;
./lib/OCIclient.sh $command;
