#!/bin/sh
if [ $# -eq 0 ]
then
        echo "Usage: `basename $0` <filename>"
        exit 1
fi

FILE=$1

if [ ! -f $FILE ]
then
        echo "File not found: $FILE"
        exit 2
fi

arc paste --title $FILE < $FILE
