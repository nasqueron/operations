#   -------------------------------------------------------------
#   Salt — rsyslog
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Ensure xconsole pipeline isn't configured
#
#   See http://kb.monitorware.com/kbeventdb-detail-id-6925.html
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['node.has']('fixes:rsyslog_xconsole') %}
/etc/rsyslog.d/50-default.conf:
  file.managed:
    - source: salt://roles/core/rsyslog/files/default.conf
{% endif %}
