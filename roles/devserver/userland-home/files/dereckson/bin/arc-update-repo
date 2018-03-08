#!/bin/sh
ROOT_DIR=`git rev-parse --show-toplevel 2>/dev/null`
if [ "$?" -ne "0" ]; then
	ROOT_DIR=`hg root 2>/dev/null`
	if [ "$?" -ne "0" ]; then
		echo "Doesn't seem to be a Git or Mercurial repository."
		exit
	fi
fi

if [ ! -f $ROOT_DIR/.arcconfig ]; then
	echo 'Create a .arcconfig file with "repository.callsign" : "..." (without the leading r) option.'
	exit
fi

CALLSIGN=`cat $ROOT_DIR/.arcconfig | jq '."repository.callsign"'`
if [ "$CALLSIGN" = "null" ]; then
	echo 'Add to your .arcconfig file a "repository.callsign" : "..." (without the leading r) option.'
	exit
fi

echo "{ \"callsigns\": [$CALLSIGN] }" | arc call-conduit diffusion.looksoon > /dev/null
