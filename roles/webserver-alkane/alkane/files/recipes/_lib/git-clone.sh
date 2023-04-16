#!/bin/sh

#   -------------------------------------------------------------
#   Nasqueron PaaS :: Alkane :: Recipe for deployment
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/webserver-alkane/alkane/files/recipes/_lib/git-clone.sh
#   Action:         init
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

set -e

GIT_DEFAULT_BRANCH=main

#   -------------------------------------------------------------
#   Parse context
#     - URL
#     - branch
#
#   Formats:
#     - JSON payload {"url": "...", "branch": "production
#     - String, will only parse it as URL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ "$(printf %.1s "$ALKANE_SITE_CONTEXT")" = "{" ]; then
    # Parses JSON object
    GIT_URL=$(echo "$ALKANE_SITE_CONTEXT" | jq .url)
    GIT_BRANCH=$(echo "$ALKANE_SITE_CONTEXT" | jq .branch)

    if [ "$GIT_BRANCH" = "null" ]; then
        GIT_BRANCH=$GIT_DEFAULT_BRANCH
    fi
else
    GIT_URL=$ALKANE_SITE_CONTEXT
    GIT_BRANCH=$GIT_DEFAULT_BRANCH
fi

#   -------------------------------------------------------------
#   Ensure directory doesn't exist
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ -d "$ALKANE_SITE_PATH/.git" ]; then
    echo "$ALKANE_SITE_PATH repository already exists." >&2
    exit 1
fi

#   -------------------------------------------------------------
#   Update Git repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

git clone "$GIT_URL" "$ALKANE_SITE_PATH"
cd "$ALKANE_SITE_PATH"
git switch "$GIT_BRANCH"