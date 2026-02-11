#   -------------------------------------------------------------
#   Salt — Anubis
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

#   -------------------------------------------------------------
#   User and group
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

anubis_group:
  group.present:
    - name: anubis
    - gid: 9019

anubis_user:
  user.present:
    - name: anubis
    - uid: 9019
    - shell: /sbin/nologin
    - groups:
        - anubis
    - system: True
    - require:
        - group: anubis_group

#   -------------------------------------------------------------
#   /run directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.run }}/anubis:
  file.directory:
    - user: anubis

{% if has_selinux %}
anubis_run_policy:
  selinux.fcontext_policy_present:
    - name: {{ dirs.run }}/anubis
    - sel_type: httpd_var_run_t

anubis_run_policy_applied:
  selinux.fcontext_policy_applied:
    - name: {{ dirs.run }}/anubis
{% endif %}
