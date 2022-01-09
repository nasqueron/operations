#!/bin/sh

set -e

OPENSEARCH_HOSTNAME=$1
ROOT=/opt/opensearch

# Wait a little bit to let OpenSearch start
sleep 5

bash $ROOT/plugins/opensearch-security/tools/securityadmin.sh \
    -cacert $ROOT/config/root-ca.pem \
    -cert $ROOT/config/admin.pem \
    -key $ROOT/config/admin.key \
    -cd $ROOT/plugins/opensearch-security/securityconfig \
    -nhnv -icl \
    -h "$OPENSEARCH_HOSTNAME"

touch $ROOT/plugins/opensearch-security/securityconfig/.initialized
