#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-01-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os'] == 'FreeBSD' %}

{% for port, args in pillar.get("ports", {}).items() %}

#   -------------------------------------------------------------
#   Provision port options
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/db/ports/{{ args['category'] }}_{{ args['name'] }}/options:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/port_options
    - template: jinja
    - mode: 644
    - context:
        args: {{ args }}

#   -------------------------------------------------------------
#   Build and install package
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

port_{{ port }}:
  cmd.run:
    - name: make build package deinstall reinstall
    - cwd: /usr/ports/{{ args['category'] }}/{{ args['name'] }}
    - creates: {{ args['creates'] }}
{% endfor %}

{% endif %}
