#   -------------------------------------------------------------
#   Salt — Set machine hostname
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-06-15
#   Description:    Set hostname
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Store hostname into a configuration file
#   -------------------------------------------------------------

hostname:
  file.managed:
    - name: /etc/hostname
    - contents: {{ pillar.get('hostnames')[grains['id']] }}

#   -------------------------------------------------------------
#   When the hostname is changed, what to run afterwards?
#   -------------------------------------------------------------

after_hostname_change:
  cmd.run:
    - name: hostname `cat /etc/hostname`
    - onchanges:
      - file: /etc/hostname

{% if grains['os_family'] == 'Debian' %}
after_hostname_change_debian:
  cmd.run:
    - name: invoke-rc.d hostname.sh start
    - onchanges:
      - file: /etc/hostname
{% endif %}
