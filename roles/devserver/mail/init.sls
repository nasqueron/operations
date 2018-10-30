#   -------------------------------------------------------------
#   Salt — Provision a development server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-10-30
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Enable incoming mail (T1317)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}

/etc/rc.conf.d/sendmail:
  file.managed:
    - source: salt://roles/devserver/mail/files/sendmail.rc

{% endif %}
