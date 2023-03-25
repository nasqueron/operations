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

{% if 'options' in args %}

/var/db/ports/{{ args['category'] }}_{{ args['name'] }}/options:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/port_options
    - template: jinja
    - mode: 644
    - context:
        args: {{ args }}

{% endif %}

#   -------------------------------------------------------------
#   Build and install package
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if 'package_dependencies' in args %}

port_{{ port }}_dependencies:
  pkg.installed:
    - pkgs: {{ args["package_dependencies"] }}

{% endif %}

port_{{ port }}:
  cmd.run:
    - name: |
        make build package deinstall reinstall
        pkg lock {{ port }}
    - cwd: /usr/ports/{{ args['category'] }}/{{ args['name'] }}
    - creates: {{ args['creates'] }}
{% endfor %}

{% endif %}
