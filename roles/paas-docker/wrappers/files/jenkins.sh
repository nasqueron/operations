#!/bin/sh
#
# Usage: jenkins <container name> <command> [args]

CONTAINER_IP=$(sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1")
shift

ssh -l "$USER" -p 50022 "$CONTAINER_IP" $*
