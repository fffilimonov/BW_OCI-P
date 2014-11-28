#!/bin/bash

./GetUsers.sh | gawk '$0!~"USERID|TOTAL"{print $1};$0~"TOTAL"{print $0}' | sort;