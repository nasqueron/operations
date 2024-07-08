#   -------------------------------------------------------------
#   Salt — Provision Redis
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Redis service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}

/etc/rc.conf.d/redis:
  file.managed:
    - source: salt://roles/redis/server/files/redis.rc

redis_running:
  service.running:
    - name: redis

{% endif %}
