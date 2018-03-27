#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-27
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

#   -------------------------------------------------------------
#   Home directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/phpbb/mysql:
  file.directory:
    - user: 999
    - group: 999
    - makedirs: True

{% if has_selinux %}
selinux_context_phpbb_mysql_data:
  selinux.fcontext_policy_present:
    - name: /srv/phpbb/mysql
    - sel_type: svirt_sandbox_file_t

selinux_context_phpbb_mysql_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/phpbb/mysql
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

phpbb_db:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/mysql
    - binds: /srv/phpbb/mysql:/var/lib/mysql
    - environment:
        MYSQL_ROOT_PASSWORD: {{ salt['random.get_str'](31) }}
