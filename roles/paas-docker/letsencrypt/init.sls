#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

#   -------------------------------------------------------------
#   See also
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Wrapper script
#   - wrappers/init.Sls
#   - wrappers/files/certbot.sh
#
# Image
#   - /pillar/paas/docker.Sls
#
# Nginx configuration
#   - nginx/files/includes/letsencrypt

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/letsencrypt:
  file.directory

{% if has_selinux %}
selinux_context_letsencrypt_home:
  selinux.fcontext_policy_present:
    - name: /srv/letsencrypt
    - sel_type: container_file_t

selinux_context_letsencrypt_home_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/letsencrypt
{% endif %}
