#!/usr/bin/env bats

SCRIPT="../roles/core/certificates/files/edit-acme-dns-accounts.py"

#   -------------------------------------------------------------
#   Arguments parsing
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

@test "exit with error code if no arg provided" {
    run $SCRIPT
    [ "$status" -ne 0 ]
}

@test "exit with error code if command doesn't exist" {
    run $SCRIPT somenonexistingcommand
    [ "$status" -ne 0 ]
}

@test "exit with error code if no enough arg" {
    run $SCRIPT import
    [ "$status" -ne 0 ]
}

#   -------------------------------------------------------------
#   Import
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

@test "can't import a file into itself" {
    export ACME_ACCOUNTS=/dev/null
    run $SCRIPT import /dev/null
    [ "$output" = "You're trying to import /dev/null to itself" ]
    [ "$status" -eq 2 ]
}

@test "can merge correctly two credentials files" {
    ACME_ACCOUNTS=$(mktemp)
    export ACME_ACCOUNTS
    cp data/acmedns.json "$ACME_ACCOUNTS"

    run $SCRIPT import data/acmedns-toimport.json
    [ "$status" -eq 0 ]

    isValid=0
    run jsondiff "$ACME_ACCOUNTS" data/acmedns-merged.json
    rm "$ACME_ACCOUNTS"
    [ "$status" -eq 0 ]
    [ "$output" = "{}" ] || isValid=1

    if [ $isValid -ne 0 ]; then
        echo "Non matching part according jsondiff:"
        echo "$output"
    fi

    return $isValid
}
