#   -------------------------------------------------------------
#   Salt — Reserved UNIX identifiers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Service accounts and groups
#
#   This repository is the source of truth for stable UIDs and GIDs
#   assigned to service accounts and service groups.
#
#   Sort identifiers by numeric value.
#
#   User accounts for actual humans are assigned in the user.sls file
#   in the 2000-2999 range. Old ops use 5000-5099.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

uids:
  odderon: 830
  builder: 831
  chaton: 832 # LEGACY
  viperserv: 833
  tc2: 834
  opensearch: 835
  opendkim: 836
  grafana: 904 # from FreeBSD ports
  netbox: 1001
  mediawiki: 3004
  mailbox: 6000
  web-admin: 8000
  zr: 8900 # LEGACY
  salt: 9001
  deploy: 9002
  rhyne-wyse: 9018
  anubis: 9019

  # PaaS Alkane :: Mail server
  web-org-nasqueron-mail: 12000
  web-org-nasqueron-mail-admin: 12001

gids:
  shell: 200
  chaton-dev: 827
  deployment-legacy: 828 # Previous deployment assignment
  nasqueron-irc: 829
  opensearch: 835
  opendkim: 836
  nasqueron-dev-docker: 842
  grafana: 904 # from FreeBSD ports
  netbox: 1001
  ops: 3001
  # 3002 is intentionally left unassigned
  deployment: 3003
  mediawiki: 3004
  nasquenautes: 3005
  mailbox: 6000
  salt: 9001
  deploy: 9002
  web: 9003
  rhyne-wyse: 9018
  anubis: 9019
