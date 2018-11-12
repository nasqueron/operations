#   -------------------------------------------------------------
#   Salt — Sentry instances
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-11-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Sentry realms
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

sentry_realms:
  nasqueron:
    links:
      postgresql: sentry_db
      redis: sentry_redis
      smtp: sentry_smtp
    credential: nasqueron.sentry.app_key
    email_from: no-reply@sentry.nasqueron.org
    host: sentry.nasqueron.org
