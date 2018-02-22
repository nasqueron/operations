#   -------------------------------------------------------------
#   Salt — Hotfixes to mitigate bugs and security issues
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-17
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   T1345
#
#   Drop rc configuration launching jails.
#   Keep jails directories' content.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['id'] in pillar['roles_disabled']['paas_jails'] %}

{% for jail_rc_config_file in ['jail', 'netif/jails', 'ezjail'] %}
/etc/rc.conf.d/{{ jail_rc_config_file }}:
  file.absent
{% endfor %}

{% endif %}
