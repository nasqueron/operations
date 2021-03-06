#   -------------------------------------------------------------
#   Salt — OpenDKIM configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-01-14
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   OpenDKIM configuration files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

opendkim_config_files:
  file.recurse:
    - name: {{ dirs.etc }}/opendkim
    - source: salt://roles/mailserver/dkim/files/etc
    - include_empty: True
    - clean: False
    - dir_mode: 711
    - file_mode: 644

opendkim_keys_directory:
  file.directory:
    - name: {{ dirs.etc }}/opendkim/keys
    - dir_mode: 711
    - user: opendkim
    - group: opendkim

#   -------------------------------------------------------------
#   OpenDKIM binaries
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

opendkim_software:
  pkg.installed:
    - pkgs:
      - opendkim
      {% if grains['os_family'] == 'Debian' %}
      - opendkim-tools
      {% endif %}

opendkim_extra_utilities:
  file.recurse:
    - name: /usr/local/bin
    - source: salt://roles/mailserver/dkim/files/bin
    - dir_mode: 755
    - file_mode: 755
