#   -------------------------------------------------------------
#   Salt — Kernel state
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#
#   -------------------------------------------------------------

{% if grains['os'] == 'FreeBSD' %}

{% set use_zfs = salt['node.has']('zfs:pool') %}

/etc/sysctl.conf:
  file.managed:
    - source: salt://roles/core/sysctl/files/sysctl.conf
    - template: jinja
    - context:
        use_zfs: {{ use_zfs }}
        mem: {{ grains['mem_total'] }}
        is_router: {{ salt[ "node.has_role" ]("router") }}
{% endif %}
