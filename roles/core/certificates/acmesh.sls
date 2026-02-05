#   -------------------------------------------------------------
#   Salt - Deploy acme.sh
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

{% set certificates = pillar.get("certificates", []) %}
{% set certificates_options = pillar.get("certificates_options", {}) %}

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

acme.sh:
  pkg.installed

#   -------------------------------------------------------------
#   Certificates directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/certificates:
  file.directory:
    - user: acme
    - mode: 711

/var/certificates/general:
  file.directory:
    - user: acme
    - mode: 700

{% for domain in certificates %}
{% set options = certificates_options.get(domain, {}) %}

deploy_certificate_for_domain_{{ domain }}:
  cmd.run:
    - name: |
       acme.sh --install-cert -d {{ domain }} \
       {% if "reload" in options %}--reloadcmd "{{ options["reload"] }}"{% endif %} \
       --cert-file /var/certificates/{{ domain }}/cert.pem \
       --key-file /var/certificates/{{ domain }}/key.pem \
       --fullchain-file /var/certificates/{{ domain }}/fullchain.pem \
       --ca-file /var/certificates/{{ domain }}/chain.pem
    - runas: acme

/var/certificates/{{ domain }}:
  file.directory:
    - user: acme

    {% if "shared_group" in options %}
    - group: {{ options.shared_group }}
    - mode: 750
    {% else %}
    - mode: 700
    {% endif %}

/var/certificates/{{ domain }}/key.pem:
  file.managed:
    - create: False

    {% if "shared_group" in options %}
    - group: {{ options.shared_group }}
    - mode: 640
    {% else %}
    - mode: 600
    {% endif %}

{% endfor %}

#   -------------------------------------------------------------
#   Logs
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/etc/newsyslog.conf.d/acme.sh.conf:
  file.managed:
    - source: salt://roles/core/certificates/files/acmesh/syslog.conf

acmesh_newsyslog_run:
  cmd.run:
    - name: newsyslog -NC
    - creates: /var/log/acme.sh.log

#   -------------------------------------------------------------
#   Auto-renew helper scripts
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/etc/cron.d/acmesh:
  file.managed:
    - source: salt://roles/core/certificates/files/acmesh/acme.sh.cron
    - makedirs: True

{{ dirs.bin }}/acmesh-nginxCheck:
  file.managed:
    - source: salt://roles/core/certificates/files/acmesh/nginxCheck.sh
    - mode: 755
