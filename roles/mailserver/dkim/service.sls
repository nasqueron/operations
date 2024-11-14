#   -------------------------------------------------------------
#   Salt — OpenDKIM configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-01-14
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, services with context %}

#   -------------------------------------------------------------
#   OpenDKIM service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if services["manager"] == "rc" %}

/etc/rc.conf.d/opendkim:
  file.managed:
    - source: salt://roles/mailserver/dkim/files/rc/opendkim.conf

/usr/local/etc/rc.d/opendkim:
  file.managed:
    - source: salt://roles/mailserver/dkim/files/rc/opendkim
    - mode: 775

{% endif %}
