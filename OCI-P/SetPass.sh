#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage $0 USERID PASS";
    exit 1;
fi;

. common;
command="xml/setpass.xml.tmpl";

USERID=$1;
PASS=$2;

export USERID PASS;
./lib/OCIclient.sh $command;
