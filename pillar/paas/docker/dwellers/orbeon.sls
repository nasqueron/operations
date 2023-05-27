#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Service:        Orbeon
#   -------------------------------------------------------------

docker_networks:
  orbeon:
    subnet: 172.18.5.0/24

docker_images:
  - nasqueron/orbeon
  - tianon/exim4

docker_containers:
  exim:
    orbeon_smtp:
      mailname: forms.nasqueron.org
      network: orbeon

  orbeon:
    nasqueron_forms:
      host: forms.nasqueron.org
      app_port: 16080
      network: orbeon
      db:
        service: db-A
        database: forms
        credential: dbserver/cluster-A/users/orbeon
      secret_key: nasqueron/orbeon/oxf.crypto.password
      tomcat:
        users:
          dereckson: nasqueron/orbeon/users/dereckson
      smtp: orbeon_smtp

      # Published forms are categorized by apps.
      # List of forapps so nginx can proxy /<app>/
      apps:
        - nasqueron-join
        - nasqueron-requests
