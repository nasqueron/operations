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
    - source: salt://roles/webserver-legacy/php-sites/files/php-fpm.conf
    - template: jinja
    - context:
        instance: {{ instance }}

{{ dirs.etc }}/php-fpm.d/{{ instance }}-pools:
  file.directory

{% endfor %}

#   -------------------------------------------------------------
#   Configuration : pools
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for fqdn, site in pillar['web_php_sites'].items() %}

php-fpm_pool_{{ site['user'] }}:
  file.managed:
    - name: {{ dirs.etc }}/php-fpm.d/{{ site['php-fpm'] }}-pools/{{ site['user'] }}.conf
    - source: salt://roles/webserver-legacy/php-sites/files/php-fpm-pool.conf
    - template: jinja
    - context:
        fqdn: {{ fqdn }}
        domain: {{ site['domain'] }}
        subdomain: {{ site['subdomain'] }}
        user: {{ site['user' ]}}
        display_errors: {{ site['display_errors']|default('off') }}
        slow_delay: {{ site['slow_delay']|default('5s') }}
        env : {{ site['env']|default({}) }}

/var/log/www/{{ site['domain' ]}}/{{ site['subdomain' ]}}-php.log:
  file.managed:
    - replace: False
    - user: {{ site['user'] }}
    - group: web
    - chmod: 600

{% endfor %}

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}

{% set instances = " ".join(pillar['php_fpm_instances'].keys()) %}

# roles/webserver-legacy/php-sites/files/rc/php-fpm

/usr/local/etc/rc.d/php-fpm:
  file.managed:
    - source: salt://roles/webserver-legacy/php-sites/files/rc/php-fpm
    - mode: 755

/etc/rc.conf.d/php_fpm:
  file.directory

/etc/rc.conf.d/php_fpm/instances:
  file.managed:
    - source: salt://roles/webserver-legacy/php-sites/files/rc/instances
    - template: jinja
    - context:
        instances: {{ instances }}

{% for instance, config in pillar['php_fpm_instances'].items() %}
/etc/rc.conf.d/php_fpm/{{ instance }}:
  file.managed:
    - source: salt://roles/webserver-legacy/php-sites/files/rc/per_instance
    - template: jinja
    - context:
        instance: {{ instance }}
        command: {{ config['command'] | default('') }}
{% endfor %}

{% endif %}
