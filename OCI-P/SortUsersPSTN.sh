#!/bin/bash

./GetUsers.sh | gawk 'BEGIN{i=0}$0!~"USERID|TOTAL"{if (NF==5) {print $4;i++}}END{print "TOTAL:",i}' | sort;