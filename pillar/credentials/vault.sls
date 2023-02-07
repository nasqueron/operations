#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Vault configuration
#
#     :: vault_policies_path: path on vault server where to store policies
#
#     :: vault_policies_source: path to fetch policies from
#                               if starting by salt://, from salt files server
#
#     :: vault_mount_paths: translates secrets paths in policies paths
#
#          Generally, Vault paths are the same for policies and data access.
#
#          For kv secrets engine, version 2, writing and reading versions
#          of a kv value are prefixed with the data/ path.
#
#          credentials.build_policies_by_node will use this dictionary
#          to be able to rewrite secrets paths in data paths.
#
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

vault_policies_path: /srv/policies/vault
vault_policies_source: salt://roles/vault/policies/files

vault_mount_paths:
  ops/secrets: ops/data/secrets
  ops/privacy: ops/data/privacy

#   -------------------------------------------------------------
#   Vault policies to deploy as-is, ie without templating.
#
#   Entries of vault_policies must match a .hcl file in
#   roles/vault/policies/files folder.
#
#   If you need a template, create a new pillar entry instead
#   and add the parsing logic either:
#     - directly to roles/vault/policies/
#
#     - through _modules/credentials.py for policies to apply
#       to Salt nodes, like e.g. vault_secrets_by_role
#
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

vault_policies:
  - salt-primary
  - viperserv

#   -------------------------------------------------------------
#   Vault policies for Salt
#
#   Declare the extra policies each nodes need.
#
#   In adition of those extra policies, the vault_secrets_by_role
#   will be parsed for the keys.
#
#   IMPORTANT: as grains['roles'] can be modified by the node,
#              roles are extracted directly from the pillar.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

vault_extra_policies_by_role:
  salt-primary:
    - salt-primary

#   -------------------------------------------------------------
#   Vault secrets by role
#
#   Paths of the keys the specified role needs access to.
#
#   Avoid * notation as this namespace is shared between Vault
#   and the applications. As such, only secrets the Salt nodes
#   needs in a state they need to deploy should be listed here.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

vault_secrets_by_role:

  opensearch:
    - ops/secrets/nasqueron.opensearch.infra-logs.internal_users.admin
    - ops/secrets/nasqueron.opensearch.infra-logs.internal_users.dashboards

  paas-docker-prod:

    #
    # Personal data or personally identifiable information (PII)
    # related to Nasqueron Operations SIG members.
    #

    - ops/privacy/ops-cidr

    #
    # Credentials used by Nasqueron services
    # Format: ops/secrets/nasqueron.<service>.<type>
    #

    - ops/secrets/nasqueron.acquisitariat.mysql

    - ops/secrets/nasqueron.auth-grove.mysql

    - ops/secrets/nasqueron.cachet.app_key
    - ops/secrets/nasqueron.cachet.mysql

    - ops/secrets/nasqueron.etherpad.api

    - ops/secrets/nasqueron.notifications.broker
    - ops/secrets/nasqueron.notifications.mailgun
    - ops/secrets/nasqueron.notifications.sentry

    - ops/secrets/nasqueron.pixelfed.app_key
    - ops/secrets/nasqueron.pixelfed.mailgun
    - ops/secrets/nasqueron.pixelfed.mysql

    - ops/secrets/nasqueron.sentry.app_key
    - ops/secrets/nasqueron.sentry.postgresql

    #
    # Credentials used by Nasqueron members private services
    # Format: <username>.<service>.<type>
    #

    - ops/secrets/dereckson.phabricator.mysql

    #
    # Credentials used by projects hosted by Nasqueron
    # Format: <project name>.<service>.<type>
    #

    - ops/secrets/espacewin.phpbb.mysql_root

    - ops/secrets/wolfplex.phabricator.mailgun
    - ops/secrets/wolfplex.phabricator.mysql

    - ops/secrets/zed.phabricator.mysql
    - ops/secrets/zed.phabricator.sendgrid

  paas-docker-dev:

    #
    # Credentials used by projects hosted by Nasqueron
    # Format: <project name>.<service>.<type>
    #

    - ops/secrets/espacewin.bugzilla.mysql
    - ops/secrets/espacewin.bugzilla.mysql_root

  viperserv:
    - ops/secrets/nasqueron.viperserv.vault

#   -------------------------------------------------------------
#   Vault secrets by dbserver cluster
#
#   Paths of the keys the specified role needs access to.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

vault_secrets_by_dbserver_cluster:

  # Main PostgreSQL cluster
  A:
    - ops/secrets/dbserver/cluster-A/users/*
