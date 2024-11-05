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

/etc/rc.conf.d/milter-opendkim:
  file.managed:
    - source: salt://roles/mailserver/dkim/files/rc/milteropendkim.conf
    - template: jinja
    - context:
        user: opendkim
        group: mail
        config: {{ dirs.etc }}/opendkim/opendkim.conf

{% endif %}
