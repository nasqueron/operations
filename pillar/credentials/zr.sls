#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-12
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Zemke-Rhyne credentials
#
#   Map K<id> on DevCentral with hierarchical keys
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

    # notifications.nasqueron.org
    notifications:
      broker: 56
      mailgun: 82
      sentry: 141

    # photos.nasqueron.org
    pixelfed:
      mysql: 142
      app_key: 143
      mailgun: 145

    # sentry.nasqueron.org
    sentry:
      postgresql: 139
      app_key: 140

  #
  # Credentials used by Nasqueron members private services
  #

  dereckson:

    # River Sector
    phabricator:
      mysql: 133

  #
  # Credentials used by Espace Win services
  #

  espacewin:

    # bugzilla.espace-win.org
    bugzilla:
      mysql: 131

  #
  # Credentials used by Wolfplex services
  #

  wolfplex:

    # phabricator.wolfplex.be
    phabricator:
      mysql: 135
      mailgun: 138

  #
  # Credentials used by Zed services
  #

  zed:

    # code.zed.dereckson.be
    phabricator:
      mysql: 134
      sendgrid: 45

#   -------------------------------------------------------------
#   Zemke-Rhyne clients
#
#   This section should list all the Docker engines server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

zr_clients:
 - key: 2
   allowedConnectionFrom:
     - 172.27.26.49
     - dwellers.nasqueron.drake
     - dwellers.nasqueron.org
   restrictCommand:
   comment: Zemke-Rhyne

 - key: 152
   allowedConnectionFrom:
     - docker-001.nasqueron.org
   restrictCommand:
   comment: Zemke-Rhyne
