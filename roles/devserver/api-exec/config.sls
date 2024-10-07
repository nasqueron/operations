#   -------------------------------------------------------------
#   API :: api-exec
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set network = salt['node.resolve_network']() %}
{% set half_num_cpus = grains["num_cpus"] / 2 %}

/usr/local/etc/api-exec.conf:
  file.managed:
    - source: salt://roles/devserver/api-exec/files/api-exec.conf
    - template: jinja
    - context:
        internal_ip: {{ network["private_ipv4_address"] }}
        port: 2337

        processes: {{ half_num_cpus | int }}

        paths:
          app: /srv/api-exec/src
          venv: /srv/api-exec/venv

/var/log/api-exec.log:
  file.managed:
     - user: nobody
     - replace: False
