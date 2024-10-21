#   -------------------------------------------------------------
#   Salt — OpenDKIM configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-01-14
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   OpenDKIM main configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/opendkim/opendkim.conf:
  file.managed:
    - source: salt://roles/mailserver/dkim/files/opendkim.conf
    - template: jinja
    - context:
        dirs: {{ dirs }}
        socket: /var/run/milteropendkim/opendkim.sock

#   -------------------------------------------------------------
#   OpenDKIM configuration tables
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
#   Clean up
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set opendkim_package_leftovers = [
    "/usr/local/etc/mail/opendkim.conf",
    "/usr/local/etc/mail/opendkim.conf.sample",
    "/usr/local/etc/mail",
]
%}

{% for path in opendkim_package_leftovers %}
{{ path }}:
  file.absent
{% endfor %}
