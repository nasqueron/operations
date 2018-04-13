#   -------------------------------------------------------------
#   Salt — Sites to provision on the legacy web server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   States
#
#   Sites with states documenting how to build them
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_content_sls:
  #
  # Eglide
  #
  shellserver:
    # Directly managed by Eglide project
    - .org/eglide

  #
  # Nasqueron servers
  #
  mastodon:
    - .org/nasqueron/social

  webserver-legacy: &legacy_to_migrate_to_alkane
    # Nasqueron members
    - .be/dereckson

    # Projects hosted
    - .space/hypership

    # Directly managed by Nasqueron
    - .org/nasqueron/api
    - .org/nasqueron/autoconfig
    - .org/nasqueron/daeghrefn
    - .org/nasqueron/docs
    - .org/nasqueron/infra
    - .org/nasqueron/labs
    - .org/nasqueron/rain

    # Wolfplex Hackerspace
    - .org/wolfplex/api
    - .org/wolfplex/www

  webserver-alkane: *legacy_to_migrate_to_alkane

#   -------------------------------------------------------------
#   Sites deployed through Jenkins CD
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_content_jenkins_cd:
  webserver-legacy:
    - api
    - assets
    - autoconfig
    - docker
    - docs
    - launch
    - www

#   -------------------------------------------------------------
#   Tweaks
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_autochmod:
  - /var/wwwroot/dereckson.be/www
