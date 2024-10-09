#   -------------------------------------------------------------
#   Salt - Deploy certificates
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages with context %}

{% set has_nginx = salt['node']['has_nginx']() %}
{% set has_selinux = salt["grains.get"]("selinux:enabled", False) %}

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

letsencrypt_software:
  pkg.installed:
    - name: {{ packages.certbot }}

#   -------------------------------------------------------------
#   Working directory and configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/letsencrypt-auto:
  file.directory:
    - user: root
    - dir_mode: 711

{% if has_selinux %}
selinux_context_certbot_www:
  selinux.fcontext_policy_present:
    - name: /var/letsencrypt-auto
    - sel_type: httpd_sys_content_t

selinux_context_certbot_www_applied:
  selinux.fcontext_policy_applied:
    - name: /var/letsencrypt-auto
{% endif %}

{{ dirs.etc }}/letsencrypt/cli.ini:
  file.managed:
    - source: salt://roles/core/certificates/files/cli.ini
    - makedirs: True

#   -------------------------------------------------------------
#   Extra utilities
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.bin }}/check-letsencrypt-certificates:
  file.managed:
    - source: salt://roles/core/certificates/files/check-letsencrypt-certificates.py
    - mode: 755

{{ dirs.etc }}/letsencrypt/acme-dns-auth:
  file.managed:
    - source: salt://roles/core/certificates/files/acme-dns-auth.py
    - mode: 755
    - makedirs: True

{{ dirs.bin }}/edit-acme-dns-accounts:
  file.managed:
    - source: salt://roles/core/certificates/files/edit-acme-dns-accounts.py
    - mode: 755

{{ dirs.bin }}/delete-certbot-certificate:
  file.managed:
    - source: salt://roles/core/certificates/files/delete-certbot-certificate.sh
    - mode: 755

#   -------------------------------------------------------------
#   Check and renew certificates daily
#
#   FreeBSD ... periodic
#   Linux ..... systemd timer
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if has_nginx %}
{% set renewal_script = "letsencrypt-renewal.sh" %}
{% else %}
{% set renewal_script = "letsencrypt-renewal-without-nginx.sh" %}
{% endif %}

/usr/local/sbin/letsencrypt-renewal:
  file.managed:
    - source: salt://roles/core/certificates/files/{{ renewal_script }}
    - mode: 755

{% if grains["os_family"] == "FreeBSD" %}

/usr/local/etc/periodic/daily/730.letsencrypt:
  file.managed:
    - source: salt://roles/core/certificates/files/730.letsencrypt

{% endif %}
