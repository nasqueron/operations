#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Wrapper binaries
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for command in ['certbot', 'jenkins', 'phpbb', 'mysql', 'openfire', 'geoipupdate'] %}
{{ dirs.bin }}/{{ command }}:
  file.managed:
    - source: salt://roles/paas-docker/wrappers/files/{{ command }}.sh
    - mode: 755
{% endfor %}

{% for command in ['airflow', 'sentry'] %}
{{ dirs.bin }}/{{ command }}:
  file.managed:
    - source: salt://roles/paas-docker/wrappers/files/run-by-realm.sh.jinja
    - mode: 755
    - template: jinja
    - context:
        service: {{ command }}
{% endfor %}

{% for command in ['pad-delete'] %}
{{ dirs.bin }}/{{ command }}:
  file.managed:
    - source: salt://roles/paas-docker/wrappers/files/{{ command }}.py
    - mode: 755
{% endfor %}

#   -------------------------------------------------------------
#   Required directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

/srv/geoip:
  file.directory

{% if has_selinux %}
selinux_context_geoip_data:
  selinux.fcontext_policy_present:
    - name: /srv/geoip
    - sel_type: container_file_t

selinux_context_geoip_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/geoip
{% endif %}
