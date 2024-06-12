#   -------------------------------------------------------------
#   Salt — Sites to provision
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

web_content_sls:
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
