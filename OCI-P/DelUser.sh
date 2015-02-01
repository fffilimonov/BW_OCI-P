#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage $0 USERID";
    exit 1;
fi;

. common;
command="xml/deluser.xml.tmpl";

USERID=$1;

export USERID;
./lib/OCIclient.sh $command;
