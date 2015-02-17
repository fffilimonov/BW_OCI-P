#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage $0 USERID";
    exit 1;
fi;

. config;
. common;
command="xml/services.xml.tmpl";

USERID=$1;

export USERID;
./lib/OCIclient.sh $command;
