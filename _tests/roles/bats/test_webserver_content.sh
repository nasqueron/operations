#!/usr/bin/env bats

SCRIPT="utils/generate-webcontent-index.py"
INDEX="roles/webserver-content/init.sls"

@test "Ensure webserver-content index is up-to-date" {
    cd ..
    run diff -u <($SCRIPT) <(cat $INDEX)
    [ "$status" -eq 0 ]
}
