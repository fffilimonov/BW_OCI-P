#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage $0 FILE RESPFILE";
    exit -1;
fi;

. config;
FILE="$1";
RESP="$2";

#Try connection and connect.
timeout -s INT $TIMEOUT bash -c "exec 3<>/dev/tcp/$HOST/$PORT";
if [ $? -ne 0 ]; then
    echo "No connection";
    exit -1;
fi;
exec 3<>/dev/tcp/$HOST/$PORT;

#Set sessionID
SESSION=`date +%s`;
cat xml/head.xml.tmpl | sed "s/CHANGEmeSESSIONID/"$SESSION"/" > xml/head.xml;
cat xml/botom.xml.tmpl > xml/botom.xml;

#Send Auth
cat xml/auth.xml.tmpl | sed "s/CHANGEmeUSER/"$OCI_LOGINID"/" > xml/auth.xml;
cat xml/head.xml >&3;
cat xml/auth.xml >&3;
cat xml/botom.xml >&3;
timeout -s INT $TIMEOUT cat <&3 > response/auth.response.xml;

#Hash pass
NONCE=`cat response/auth.response.xml | ./lib/FixXml.awk | ./lib/GetNonce.awk`;
if [ "$NONCE" == "" ]; then
    echo "No auth response";
    exit -1;
fi;
HPASS=`echo -n $OCI_PASSWORD | sha1sum | gawk '{print $1}'`;
RESPONSE=`echo -n "$NONCE:$HPASS" | md5sum| gawk '{print $1}'`;

#Send login
cat xml/login.xml.tmpl | sed "s/CHANGEmePASS/"$RESPONSE"/;s/CHANGEmeUSER/"$OCI_LOGINID"/" > xml/login.xml;
cat xml/head.xml >&3;
cat xml/login.xml >&3;
cat xml/botom.xml >&3;
timeout -s INT $TIMEOUT cat <&3 > response/login.response.xml;
OK=`grep "LoginResponse14sp4" response/login.response.xml`;
if [ "$OK" == "" ]; then
    ERROR=`grep "ErrorResponse" response/login.response.xml`;
    if [ "$ERROR" == "" ]; then
        echo "Failed to login/ No response";
        exit -1;
    else
        echo "Failed to login/ Wrong username or password";
        exit -1;
    fi;
fi;

#Send custom req
cat xml/head.xml >&3;
cat $FILE >&3;
cat xml/botom.xml >&3;
timeout -s INT 1 cat <&3 > $RESP;

#Send logout
cat xml/logout.xml.tmpl | sed "s/CHANGEmeUSER/"$USER"/" > xml/logout.xml;
cat xml/head.xml >&3;
cat xml/logout.xml >&3;
cat xml/botom.xml >&3;
timeout -s INT $TIMEOUT cat <&3 > response/logout.response.xml;

#Close FD
exec 3>&-;
