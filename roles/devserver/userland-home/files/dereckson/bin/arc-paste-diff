#!/usr/bin/env bash

COLORDIFF=`which colordiff`

if [ $# -ne 2 ]
then
        echo "Usage: `basename $0` <paste 1> <paste 2>"
        exit 1
fi

if [ "$COLORDIFF" = "" ]; then
	diff -u <(arc paste $1) <(arc paste $2)
else
	diff -u <(arc paste $1) <(arc paste $2) | colordiff
fi

