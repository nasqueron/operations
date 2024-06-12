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
  - paas/alkane/{{ minion_id }}/*.sls
  - paas/docker/{{ minion_id }}/*.sls

  - saas/nextcloud/{{ minion_id }}/*.sls

  - webserver/{{ minion_id }}/*.sls
