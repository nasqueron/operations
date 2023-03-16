#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Service:        Sentry
#   -------------------------------------------------------------

docker_images:
  - getsentry/relay:nightly

docker_containers:
  relay:
    sentry_relay:
      app_port: 26300
      flavour: dev
