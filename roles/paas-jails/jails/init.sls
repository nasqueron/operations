#   -------------------------------------------------------------
#   Salt — Jails
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Notes:          FreeBSD-only unit
#   Created:        2017-10-21
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Software to manage jails
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ezjail:
  pkg.installed

#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

jails_rc_jail:
  file.managed:
    - name: /etc/rc.conf.d/jail
    - source: salt://roles/paas-jails/jails/files/jail.rc
    - template: jinja
    - context:
        jails: {{ salt['jails.flatlist']() }}

jails_rc_netif:
  file.managed:
    - name: /etc/rc.conf.d/netif/jails
    - makedirs: True
    - source: salt://roles/paas-jails/jails/files/netif.rc

jails_rc_ezjail:
  file.managed:
    - name: /etc/rc.conf.d/ezjail
    - source: salt://roles/paas-jails/jails/files/ezjail.rc

#   -------------------------------------------------------------
#   Build master jail
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

generate_basejail:
  cmd.run:
    - name: ezjail-admin install -p
    - creates: /usr/jails/basejail

/usr/jails/newjail/etc/resolv.conf:
  file.managed:
    - source: salt://roles/paas-jails/jails/files/resolv.conf

#   -------------------------------------------------------------
#   Build applications/services jails
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for jail in salt['jails.list_jails']() %}
{% set ips = salt['jails.get_ezjail_ips_parameter'](jail) %}
generate_jail_{{ jail }}:
  cmd.run:
    - name: ezjail-admin create {{ jail }} {{ ips | yaml_encode }}
    - creates: /usr/jails/{{ jail }}
{% endfor %}
