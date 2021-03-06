#!/bin/sh

#   -------------------------------------------------------------
#   PaaS Docker
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-11-11
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/paas-docker/wrappers/files/sentry.sh
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <realm> <command> [arguments]" 1>&2;
    exit 1
fi

REALM=$1
shift

if [ ! -d "/srv/sentry/$REALM" ]; then
    echo "Realm doesn't exist: $REALM" 1>&2;
    exit 2
fi

DOCKER_RUN_SCRIPT=/srv/sentry/$REALM/bin/sentry

if [ ! -f "$DOCKER_RUN_SCRIPT" ]; then
    echo "File doesn't exist: $DOCKER_RUN_SCRIPT" 1>&2;
    echo "You can generate it running 'deploy-container sentry' command on the Salt master. 1>&2;"
    exit 4
fi

$DOCKER_RUN_SCRIPT "$@"
