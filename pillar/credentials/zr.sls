#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-12
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

zr_credentials:

  #
  # Credentials used by Nasqueron services
  #

  nasqueron:

    # login.nasqueron.org
    auth-grove:
      mysql: 67

    # status.nasqueron.org
    cachet:
      mysql: 47
      app_key: 126

    # pad.nasqueron.org
    etherpad:
      # This API key is used by Wolfplex API to access to the pad lists
      api: 125
