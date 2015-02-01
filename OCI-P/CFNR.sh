#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage $0 USERID PHONE";
    exit 1;
fi;

. config;
. common;
command="xml/cfnr.xml.tmpl";

USERID=$1;
NUMBER=$2;

export USERID NUMBER;
./lib/OCIclient.sh $command;
