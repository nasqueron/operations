#   -------------------------------------------------------------
#   Salt — Provision PHP websites — php-fpm pools
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Configuration : instances
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for instance, config in pillar['php_fpm_instances'].items() %}

php-fpm_config_{{ instance }}:
  file.managed:
    - name: {{ dirs.etc }}/php-fpm.d/{{ instance }}.conf
    - source: salt://roles/webserver-alkane/php/files/php-fpm.conf
    - template: jinja
    - context:
        instance: {{ instance }}

{{ dirs.etc }}/php-fpm.d/{{ instance }}-pools:
  file.directory

{% endfor %}

#   -------------------------------------------------------------
#   Configuration : pools
#
#   Sockets are created in /var/run/web/<site user>/php-fpm.sock
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/run/web:
  file.directory:
     - group: web
     - dir_mode: 711

{% for fqdn, site in pillar['web_php_sites'].items() %}

php-fpm_pool_{{ site['user'] }}:
  file.managed:
    - name: {{ dirs.etc }}/php-fpm.d/{{ site['php-fpm'] }}-pools/{{ site['user'] }}.conf
    - source: salt://roles/webserver-alkane/php/files/php-fpm-pool.conf
    - template: jinja
    - context:
        fqdn: {{ fqdn }}
        domain: {{ site['domain'] }}
        subdomain: {{ site['subdomain'] }}
        user: {{ site['user' ] }}
        display_errors: {{ site['display_errors'] | default('off') }}
        slow_delay: {{ site['slow_delay'] | default('5s') }}
        php_flags: {{ site['php_flags'] | default({}) }}
        php_values: {{ site['php_values'] | default({}) }}
        env : {{ site['env'] | default({}) }}
        capabilities: {{ site['capabilities'] | default([]) }}

/var/log/www/{{ site['domain' ] }}/{{ site['subdomain' ] }}-php.log:
  file.managed:
    - replace: False
    - user: {{ site['user'] }}
    - group: web
    - chmod: 600

{% endfor %}

#   -------------------------------------------------------------
#   Sessions directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/tmp/php:
  file.directory:
    - mode: 1770
    - group: web

/var/tmp/php/sessions:
  file.directory:
    - mode: 1770
    - group: web

{% for fqdn, site in pillar['web_php_sites'].items() %}
/var/tmp/php/sessions/{{ fqdn }}:
  file.directory:
    - mode: 700
    - user: {{ site['user'] }}
{% endfor %}
