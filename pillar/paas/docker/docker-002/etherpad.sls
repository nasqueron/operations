#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

docker_images:
  - nasqueron/etherpad:production

docker_containers:
  etherpad:
    pad:
      app_port: 34080
      host: pad.nasqueron.org
      aliases:
        - pad.wolfplex.org
        - pad.wolfplex.be
      credential: nasqueron/etherpad/api
      mysql_link: acquisitariat

etherpad_settings:
  pad:
    title: Nasqueron pad
    defaultPadText: |
      Welcome to this Etherpad instance, shared between Wolfplex and Nasqueron projects.

      This pad text is synchronized as you type, so that everyone viewing this page sees the same text. This allows you to collaborate seamlessly on documents.

      Warning: the pad URL is public, it will be listed at https://www.wolfplex.org/pad/ and also available through a public API call to https://api.wolfplex.org/pads/
    favicon: "https://www.wolfplex.org/favicon.ico"

    mysql:
      host: mysql
      credential: nasqueron/etherpad/mysql
      database: etherpad

    users:
      dereckson:
        credential: nasqueron/etherpad/users/dereckson
        is_admin: True
