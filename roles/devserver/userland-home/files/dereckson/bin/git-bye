#!/bin/sh

BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$BRANCH" = "master" ]; then
	echo "You're already on the master branch."
	exit 1
fi

# Updates master branch if there isn't any staged change and working tree is clean
git checkout master
git diff-index --quiet --cached HEAD -- && git diff-files --quiet && git pull

git branch -D "$BRANCH"
