#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage $0 command";
    exit -1;
fi;

. config;

#Functions

sgen ()
{
    cat /dev/urandom| tr -dc 'a-zA-Z0-9' | fold -w9| head -n1;
}

send ()
{
    cat xml/head.xml.tmpl | sed "s/CHANGEmeSESSIONID/$SESSION/" >&3;
    cat $1 | sed "s/CHANGEmeRESP/$RESPONSE/;\
     s/CHANGEmeUSER/$OCI_LOGINID/;\
     s/CHANGEmeID/$USERID/;\
     s/CHANGEmeNUMBER/$NUMBER/;\
     s/CHANGEme1PORT/$PORT1/;\
     s/CHANGEme2PORT/$PORT2/;\
     s/CHANGEme3PORT/$PORT3/;\
     s/CHANGEme4PORT/$PORT4/;\
     s/CHANGEme5PORT/$PORT5/;\
     s/CHANGEmeDMN/$DOMAIN/;\
     s/CHANGEmeDEVP/$DEVPROFNAME/;\
     s/CHANGEmeDEVL/$DEVPROFLEVEL/;\
     s/CHANGEmePASS/$PASS/;\
     s/CHANGEmeSP/$SERVICEPACK/;\
     s/CHANGEmeWPASS/$WPASS/;\
     s/CHANGEmeLAST/$LAST/;\
     s/CHANGEmeFIRST/$FIRST/;\
     s/CHANGEmeCLAST/$LAST/;\
     s/CHANGEmeCFIRST/$FIRST/;\
     s/CHANGEmeENT/$ENT/;\
     s/CHANGEmeGR/$GROUP/;\
     s/CHANGEmePORT/$USERID/;\
     s/CHANGEmePHONE/$PHONE/;\
     s/CHANGEmeEXT/$EXT/;\
     " >&3;
    cat xml/botom.xml.tmpl >&3;
    if [ "$2" != "1" ]; then
        timeout -s INT $TIMEOUT head -2 <&3;
    fi;
}

sendlogout ()
{
    send xml/logout.xml.tmpl 1;
    exec 3>&-;
    exit $1;
}

fixxml ()
{
    gawk 'BEGIN {RS="><"} {printf $0">\n<"}';
}

getnonce ()
{
    gawk '{if ($0~"nonce") {split ($0,value,"[>|<]");printf ("%s\n",value[3]);}}';
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
SESSION=$(sgen;);
#Send Auth
#send xml/auth.xml.tmpl
NONCE=$(send xml/auth.xml.tmpl  | fixxml | getnonce);
#Hash pass
if [ "$NONCE" == "" ]; then
    echo "No auth response";
    sendlogout 1;
fi;
HPASS=`echo -n $OCI_PASSWORD | sha1sum | gawk '{print $1}'`;
RESPONSE=`echo -n "$NONCE:$HPASS" | md5sum| gawk '{print $1}'`;
#Send login
LRESP=$(send xml/login.xml.tmpl);
OK=`echo $LRESP | grep "LoginResponse14sp4"`;
if [ "$OK" == "" ]; then
    ERROR=`echo $LRESP | grep "ErrorResponse"`;
    if [ "$ERROR" == "" ]; then
        echo "Failed to login/ No response";
        sendlogout 1;
    else
        echo "Failed to login/ Wrong username or password";
        sendlogout 1;
    fi;
fi;

#Send custom req
while true; do
    if [ $# -ne 0 ]; then
        nCOMMAND="$1";
        shift;
        send $nCOMMAND | fixxml | awk 'BEGIN {i=0} {if ($0~"ErrorResponse") {i++}print $0}END{if (NR==0) {i++};exit i}';
        if [ $? -ne 0 ]; then
            sendlogout 1;
        fi;
    else
        break;
    fi;
done;

#Send logout
sendlogout;
