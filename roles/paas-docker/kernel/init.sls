#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-11-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os_family'] == 'RedHat' %}
{% if salt['file.file_exists']("/etc/tuned") %}

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

{% else %}

# /sys/kernel allows to write settings and display the selected one in []
restrict_hugepages:
  cmd.run:
    - name: echo madvise > /sys/kernel/mm/transparent_hugepage/enabled
    - unless: grep -q "\[madvise\]" /sys/kernel/mm/transparent_hugepage/enabled

{% endif %}
{% endif %}
