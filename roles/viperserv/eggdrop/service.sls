#   -------------------------------------------------------------
#   Salt — Deploy eggdrop park
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-19
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set bots = ' '.join(pillar['viperserv_bots'].keys()) %}

#   -------------------------------------------------------------
#   Install service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
/usr/local/etc/rc.d/eggdrop:
  file.managed:
    - source: salt://roles/viperserv/eggdrop/files/rc/eggdrop
    - mode: 755
{% endif %}

#   -------------------------------------------------------------
#   Configure service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}

/etc/rc.conf.d/eggdrop:
  file.directory

/etc/rc.conf.d/eggdrop/instances:
  file.managed:
    - source: salt://roles/viperserv/eggdrop/files/rc/instances
    - template: jinja
    - context:
        bots: {{ bots }}

{% for botname, bot in pillar['viperserv_bots'].items() %}
/etc/rc.conf.d/eggdrop/{{ botname }}:
  file.managed:
    - source: salt://roles/viperserv/eggdrop/files/rc/per_instance
    - template: jinja
    - context:
        runas: {{ bot['runas'] | default('') }}
        botname: {{ botname }}
{% endfor %}

{% endif %}
