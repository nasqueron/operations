#   -------------------------------------------------------------
#   Salt — OpenDKIM configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-01-14
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   OpenDKIM base software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

opendkim_software:
  pkg.installed:
    - pkgs:
      - opendkim
      {% if grains['os_family'] == 'Debian' %}
      - opendkim-tools
      {% endif %}

#   -------------------------------------------------------------
#   Keys management utilities
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set utilities = {
  "get-dkim-dns-entries": "get-dkim-dns-entries.sh",
  "get-dkim-dns-entry": "get-dkim-dns-entry.php",
  "get-dkim-key-table": "get-dkim-key-table.sh",
  "get-dkim-signing-table": "get-dkim-signing-table.sh",
}
%}

{% for target, source in utilities.items() %}
/usr/local/bin/{{ target }}:
  file.managed:
    - source: salt://roles/mailserver/dkim/files/bin/{{ source }}
    - mode: 755
{% endfor %}

/usr/local/bin/add-dkim-domain:
  file.managed:
    - source: salt://roles/mailserver/dkim/files/bin/add-dkim-domain.sh
    - mode: 755
    - template: jinja
    - context:
        dirs: {{ dirs }}
