#   -------------------------------------------------------------
#   Salt — Webserver core units for all webservers roles
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% from "roles/webserver-core/map.jinja" import options, certbot_dir with context %}

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

#   -------------------------------------------------------------
#   Accounts - web group
#
#   A group shared between nginx, back-end and content directories
#   to allow ACL giving access to the nginx process.
#
#   This group will so be used by:
#     - nginx process (configured in nginx.conf)
#     - back-end UNIX sockets like php-fpm sockets can be 660
#     - more private folders can use 007 as umask
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

webserver_core_group:
  group.present:
    - name: web
    - gid: 9003
    - system: True

#   -------------------------------------------------------------
#   Base configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/nginx/nginx.conf:
  file.managed:
    - source: salt://roles/webserver-core/nginx/files/nginx.conf
    - template: jinja
    - context:
        nginx_dir: {{ dirs.etc }}/nginx
        nginx_options: {{ options }}

#   -------------------------------------------------------------
#   includes folder
#
#    :: general configuration
#    :: application-specific code
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

webserver_core_nginx_includes:
  file.recurse:
    - name: {{ dirs.etc }}/nginx/includes
    - source: salt://roles/webserver-core/nginx/files/includes
    - dir_mode: 755
    - file_mode: 644
    - template: jinja
    - context:
        nginx_dir: {{ dirs.etc }}/nginx
        nginx_options: {{ options }}
        certbot_dir: {{ certbot_dir }}

#   -------------------------------------------------------------
#   Parameters for Diffie-Hellman
#
#   Some ciphers still require DH exchange. They contain "DHE" in
#   the name, e.g. DHE-RSA-AES128-GCM-SHA256 DHE-RSA-AES256-GCM-SHA384
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

webserver_core_nginx_dh:
  cmd.run:
    - name: openssl dhparam -out {{ dirs.etc }}/nginx/dhparams.pem 4096
    - creates: {{ dirs.etc }}/nginx/dhparams.pem

#   -------------------------------------------------------------
#   OCSP - Online Certificate Status Protocol
#
#   To allow nginx to verify TLS certificate presented by CA
#   when it makes requests to the CRL, a bundle of CA certificates
#   should be available.
#
#   To generate the bundle file on this repository, use `make`.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/share/certs/ocsp-ca-certs.pem:
  file.managed:
    - source: salt://roles/webserver-core/nginx/files/ocsp-ca-certs.pem
    - makedirs: True
    - mode: 644

#   -------------------------------------------------------------
#   Logs
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/log/www:
  file.directory:
     - user: {{ options["www_user"] }}
     - group: web
     - dir_mode: 711

{% if has_selinux %}
selinux_context_nginx_logs:
  selinux.fcontext_policy_present:
    - name: /var/log/www
    - sel_type: httpd_log_t

selinux_context_nginx_logs_applied:
  selinux.fcontext_policy_applied:
    - name: /var/log/www
{% endif %}

#   -------------------------------------------------------------
#   vhost folder
#
#   To be filled by the specific web role or unit
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/nginx/vhosts:
  file.directory
