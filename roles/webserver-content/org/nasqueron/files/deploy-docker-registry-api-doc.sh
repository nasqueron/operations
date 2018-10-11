#!/bin/sh

#   -------------------------------------------------------------
#   Nasqueron Docs
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/webserver-content/org/nasqueron/files/build-docs-salt-wrapper.sh
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

PROJECT=docker-registry-api
JENKINS_JOB=$PROJECT-doc
SOURCE=https://cd.nasqueron.org/job/$JENKINS_JOB
TARBALL_PATH=~deploy/workspace
DOC_PATH=/var/wwwroot/nasqueron.org/docs/$PROJECT
EXIT_CODE=0
DL=fetch
DL_ARGS="-o"

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <build number>" 1>&2;
    exit 1
fi
BUILD=$1

case $BUILD in
    ''|*[!0-9]*)
        echo "Build number argument must be an integer."
        exit 1
        ;;
    *) echo "Deploying documentation for build #$BUILD..." ;;
esac

# Fetch files

$DL $DL_ARGS $TARBALL_PATH/doc-$PROJECT-rust.tar.gz "$SOURCE/$BUILD/artifact/target/doc-rust.tar.gz"
$DL $DL_ARGS $TARBALL_PATH/doc-$PROJECT-openapi.tar.gz "$SOURCE/$BUILD/artifact/target/doc-openapi.tar.gz"

# Deploy

if [ -f $TARBALL_PATH/doc-$PROJECT-rust.tar.gz ]; then
	tar xzf $TARBALL_PATH/doc-$PROJECT-rust.tar.gz -C $DOC_PATH/rust/
	rm $TARBALL_PATH/doc-$PROJECT-rust.tar.gz
else
	>&2 echo "Artifact not found: crate documentation archive (doc-$PROJECT-rust.tar.gz)"
	EXIT_CODE=2
fi

if [ -f $TARBALL_PATH/doc-$PROJECT-openapi.tar.gz ]; then
	tar xzf $TARBALL_PATH/doc-$PROJECT-openapi.tar.gz -C $DOC_PATH/
	rm $TARBALL_PATH/doc-$PROJECT-openapi.tar.gz
else
	>&2 echo "Artifact not found: OpenAPI Spectacle documentation archive (doc-$PROJECT-openapi.tar.gz)"
	EXIT_CODE=$((EXIT_CODE+4))
fi

exit $EXIT_CODE
