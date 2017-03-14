#!/bin/sh

#   -------------------------------------------------------------
#   Nasqueron mail services
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-01-14
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/mailserver/dkim/files/bin/get-dkim-signing-table.sh
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

for d in /etc/opendkim/keys/*
do
	DOMAIN=`basename $d`

	for f in $d/*.private
	do
		SELECTOR=`basename $f .private`
		echo "$DOMAIN $SELECTOR._domainkey.$DOMAIN"
	done
done
