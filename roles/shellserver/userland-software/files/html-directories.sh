#!/bin/sh
#
# Generates HTML directories listing, similar to nginx autoindex output
#
# Usage: html-directories [directory]

DIR=$1
[ -z "$DIR" ] && DIR="."
TITLE="Index of $DIR"

echo "<html>"
echo "<head><title>$TITLE</title></head>"
echo '<body bgcolor="white">'
echo "<h1>$TITLE</h1><hr>"
echo '<pre><a href="../">../</a>'
find $DIR -type d -depth 1 -exec echo "<a href=\"{}\">$(basename "{}")/</a>" \;
echo "</pre><hr></body>"
echo "</html>"
