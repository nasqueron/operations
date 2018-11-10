#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-11-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os_family'] == 'RedHat' %}

/etc/tuned/paas-docker:
  file.directory

/etc/tuned/paas-docker/tuned.conf:
  file.managed:
    - source: salt://roles/paas-docker/kernel/files/tuned.conf

apply_paas_docker_tuned_configuration:
  cmd.run:
    - name: tuned-adm profile paas-docker
    - onchanges:
        - file: /etc/tuned/paas-docker/tuned.conf

{% endif %}
