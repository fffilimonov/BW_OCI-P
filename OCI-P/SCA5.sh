#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage $0 USERID";
    exit 1;
fi;

. config;
. common;
command="xml/sca5.xml.tmpl";

USERID=$1;

command1="xml/sca5add1.xml.tmpl";
command2="xml/sca5add2.xml.tmpl";
command3="xml/sca5add3.xml.tmpl";
command4="xml/sca5add4.xml.tmpl";
command5="xml/sca5add5.xml.tmpl";

PORT1=${USERID}1;
PORT2=${USERID}2;
PORT3=${USERID}3;
PORT4=${USERID}4;
PORT5=${USERID}5;

export USERID PORT1 PORT2 PORT3 PORT4 PORT5;
./lib/OCIclient.sh $command $command1 $command2 $command3 $command4 $command5;
