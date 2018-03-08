#!/bin/sh
if [ $# -eq 0 ]
then
	echo "Usage: $(basename "$0") <name of the branch to create>"
	exit 1
fi

BRANCH=$1

REPO=$(git rev-parse --show-toplevel)
REPO_RETCODE=$?

if [ $REPO_RETCODE -ne 0 ]
then
    exit $REPO_RETCODE
fi;

REPO=$(basename "$REPO")

if [ "$REPO" = "puppet" ]
then
    MASTER=production
else
    MASTER=master
fi

git checkout $MASTER
git fetch --all
git pull
git pull origin $MASTER
git checkout -b "$BRANCH"
