#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-02-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% if has_selinux %}
wwwroot_content_selinux_context:
  selinux.fcontext_policy_present:
    - name: /var/wwwroot-content(/.*)?
    - sel_type: httpd_sys_rw_content_t

wwwroot_content_selinux_context_applied:
  selinux.fcontext_policy_applied:
    - name: /var/wwwroot-content
    - recursive: True
{% endif %}
