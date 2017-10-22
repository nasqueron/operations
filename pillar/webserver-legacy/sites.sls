#   -------------------------------------------------------------
#   Salt — Sites to provision on the legacy web server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Domains we deploy
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_domains:
  #
  # Directly managed by Nasqueron
  #
  nasqueron:
    - nasqueron.org
  #
  # Nasqueron members
  #
  nasqueron_members:
    - dereckson.be
  #
  # Wolfplex
  #
  wolfplex:
    - wolfplex.be

#   -------------------------------------------------------------
#   Static sites
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_static_sites:
  nasqueron.org:
    - www
    - docker
    - ftp
    - trustspace
