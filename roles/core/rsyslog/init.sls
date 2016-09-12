#   -------------------------------------------------------------
#   Salt — rsyslog
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2016-09-11
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Ensure xconsole pipeline isn't configured
#
#   See http://kb.monitorware.com/kbeventdb-detail-id-6925.html
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['file.directory_exists' ]('/etc/rsyslog.d') %}
/etc/rsyslog.d/50-default.conf:
  file.managed:
    - name : /etc/rsyslog.d/50-default.conf
    - source: salt://roles/core/rsyslog/files/default.conf
{% endif %}
