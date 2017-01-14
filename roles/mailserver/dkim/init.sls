#   -------------------------------------------------------------
#   Salt — OpenDKIM configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-01-14
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   OpenDKIM configuration files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

opendkim_config_files:
  file.recurse:
    {% if grains['os'] == 'FreeBSD' %}
    - name: /usr/local/etc/opendkim
    {% else %}
    - name: /etc/opendkim
    {% endif %}
    - source: salt://roles/mailserver/dkim/files/etc
    - include_empty: True
    - clean: False
    - dir_mode: 711
    - file_mode: 644

opendkim_keys_directory:
  file.directory:
    {% if grains['os'] == 'FreeBSD' %}
    - name: /usr/local/etc/opendkim/keys
    {% else %}
    - name: /etc/opendkim/keys
    {% endif %}
    - dir_mode: 711
    - user: opendkim
    - group: opendkim

#   -------------------------------------------------------------
#   OpenDKIM binaries
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

opendkim_software:
  pkg:
    - installed
    - pkgs:
      - opendkim
      {% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' %}
      - opendkim-tools
      {% endif %}

opendkim_extra_utilities:
  file.recurse:
    - name: /usr/local/bin
    - source: salt://roles/mailserver/dkim/files/bin
    - dir_mode: 755
    - file_mode: 755
