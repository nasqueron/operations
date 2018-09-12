#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-27
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/phpbb/data:
  file.directory:
    - user: 431
    - group: 433
    - makedirs: True

{% if has_selinux %}
selinux_context_phpbb_datastores:
  selinux.fcontext_policy_present:
    - name: /srv/phpbb/data
    - sel_type: container_file_t

selinux_context_phpbb_datastores_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/phpbb/data
{% endif %}

{% for store in pillar['phpbb_datastores'] %}
/srv/phpbb/data/{{ store }}:
  file.directory:
    - user: 431
    - group: 433

{% for subdir in ['cache', 'config', 'ext', 'files', 'images', 'store'] %}
/srv/phpbb/data/{{ store }}/{{ subdir }}:
  file.recurse:
    - source: salt://software/phpbb/phpBB/{{ subdir }}
    - user: 431
    - group: 433
{% endfor %}
{% endfor %}
