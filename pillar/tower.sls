#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Description:    External pillar to configure pillar stanza
#                   by pillar, grain or option value
#   Reference:      https://github.com/jgraichen/salt-tower
#   -------------------------------------------------------------

base:
  - dns/{{ minion_id }}/*.sls
  - paas/alkane/{{ minion_id }}/*.sls
  - paas/docker/{{ minion_id }}/*.sls

  - saas/nextcloud/{{ minion_id }}/*.sls

  - webserver/{{ minion_id }}/*.sls

  # Servers with the devserver role have no cluster associated
  - dbserver/{{ minion_id }}.sls
