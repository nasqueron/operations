#   -------------------------------------------------------------
#   Salt — Provision PHP websites — php-fpm service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}

{% set instances = " ".join(pillar['php_fpm_instances'].keys()) %}

/usr/local/etc/rc.d/php-fpm:
  file.managed:
    - source: salt://roles/webserver-alkane/php/files/rc/php-fpm
    - mode: 755

/usr/local/bin/restart-php-fpm:
  file.managed:
    - source: salt://roles/webserver-alkane/php/files/restart-php-fpm.sh
    - mode: 755

/etc/rc.conf.d/php_fpm:
  file.directory

/etc/rc.conf.d/php_fpm/instances:
  file.managed:
    - source: salt://roles/webserver-alkane/php/files/rc/instances
    - template: jinja
    - context:
        instances: {{ instances }}

{% for instance, config in pillar['php_fpm_instances'].items() %}
/etc/rc.conf.d/php_fpm/{{ instance }}:
  file.managed:
    - source: salt://roles/webserver-alkane/php/files/rc/per_instance
    - template: jinja
    - context:
        instance: {{ instance }}
        command: {{ config['command'] | default('') }}
{% endfor %}

{% endif %}
