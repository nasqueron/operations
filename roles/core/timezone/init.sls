#   -------------------------------------------------------------
#   Salt — Time zone
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-23
#   License:        Trivial work, not eligible to copyright
#
#   Dance, dance, to set timezone across OSes
#
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Just write the timezone somewhere style
#                                Well no, dpkg-reconfigure after
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os_family'] == 'Debian' %}
/etc/timezone:
  file.managed:
    - contents: Etc/UTC

update_timezone:
  cmd.run:
    - name: dpkg-reconfigure -f noninteractive tzdata
    - onchanges:
      - file: /etc/timezone
{% endif %}

#   -------------------------------------------------------------
#   Symbolic link style
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os_family'] == 'RedHat' %}
/etc/localtime:
  file.symlink:
    - target: /usr/share/zoneinfo/Etc/UTC
{% endif %}

#   -------------------------------------------------------------
#   Just let the OS set the files with a command style
#                     Okay, but WE need to know WHEN start this
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
/var/db/zoneinfo:
  file.managed:
    - contents: Etc/UTC

update_timezone:
  cmd.run:
    - name: tzsetup Etc/UTC
    - onchanges:
      - file: /var/db/zoneinfo
{% endif %}
