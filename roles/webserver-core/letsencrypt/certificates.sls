#   -------------------------------------------------------------
#   Salt — Let's encrypt certificates
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-04-27
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Certificates
#   -------------------------------------------------------------

{% for domain in salt['pillar.get']("certificates_letsencrypt:" + grains['id'], []) %}
certificate_{{ domain }}:
  cmd.run:
    - name: certbot certonly -d {{ domain }}
    - creates: {{ dirs.etc }}/letsencrypt/live/{{ domain }}/fullchain.pem
{% endfor %}
