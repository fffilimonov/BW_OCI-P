#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage $0 FILE RESPFILE";
    exit -1;
fi;

. config;

#Functions

sendlogout ()
{
    cat xml/logout.xml.tmpl | sed "s/CHANGEmeUSER/"$USER"/" > xml/logout.xml;
    cat xml/head.xml >&3;
    cat xml/logout.xml >&3;
    cat xml/botom.xml >&3;
    exec 3>&-;
}

send ()
{
    cat xml/head.xml >&3;
    cat $1 >&3;
    cat xml/botom.xml >&3;
    timeout -s INT $TIMEOUT head -2 <&3 > $2;
    ERR=`grep "ErrorResponse" $2`;
    if [ "$ERR" != "" ]; then
        echo "ErrorResponse";
        sendlogout;
        exit -1;
    fi;
}

#Try connection and connect.
timeout -s INT $TIMEOUT bash -c "exec 3<>/dev/tcp/$HOST/$PORT";
if [ $? -ne 0 ]; then
    echo "No connection";
    exec 3>&-;
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
timeout -s INT $TIMEOUT head -2 <&3 > response/auth.response.xml;

#Hash pass
NONCE=`cat response/auth.response.xml | ./lib/FixXml.awk | ./lib/GetNonce.awk`;
if [ "$NONCE" == "" ]; then
    echo "No auth response";
    exec 3>&-;
    exit -1;
fi;
HPASS=`echo -n $OCI_PASSWORD | sha1sum | gawk '{print $1}'`;
RESPONSE=`echo -n "$NONCE:$HPASS" | md5sum| gawk '{print $1}'`;

#Send login
cat xml/login.xml.tmpl | sed "s/CHANGEmePASS/"$RESPONSE"/;s/CHANGEmeUSER/"$OCI_LOGINID"/" > xml/login.xml;
cat xml/head.xml >&3;
cat xml/login.xml >&3;
cat xml/botom.xml >&3;
timeout -s INT $TIMEOUT head -2 <&3 > response/login.response.xml;
OK=`grep "LoginResponse14sp4" response/login.response.xml`;
if [ "$OK" == "" ]; then
    ERROR=`grep "ErrorResponse" response/login.response.xml`;
    if [ "$ERROR" == "" ]; then
        echo "Failed to login/ No response";
        exec 3>&-;
        exit -1;
    else
        echo "Failed to login/ Wrong username or password";
        exec 3>&-;
        exit -1;
    fi;
fi;

#Send custom req
while [ $# -ne 0 ]; do
    send $1 $2;
    shift 2;
done;

#Send logout
sendlogout;
