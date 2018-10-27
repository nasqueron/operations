#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-08
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

/var/wwwroot-502:
  file.recurse:
    - source: salt://wwwroot/502
    - exclude_pat: E@.git
    - include_empty: True
    - dir_mode: 755
    - file_mode: 644

{% if has_selinux %}
wwwroot_502_selinux_context:
  selinux.fcontext_policy_present:
    - name: /var/wwwroot-502(/.*)?
    - sel_type: httpd_sys_rw_content_t

wwwroot_502_selinux_context_applied:
  selinux.fcontext_policy_applied:
    - name: /var/wwwroot-502
    - recursive: True
{% endif %}
