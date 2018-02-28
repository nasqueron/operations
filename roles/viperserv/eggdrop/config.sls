#   -------------------------------------------------------------
#   Salt — Deploy eggdrop park
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-14
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Directory for configuration
#
#   Each bot gets a directory to store userlist, chanlist, motd,
#   and specific configuration file.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for botname, bot in pillar['viperserv_bots'].items() %}

/srv/viperserv/{{ botname }}:
  file.directory:
    - user: {{ bot['runas'] | default('viperserv') }}
    - group: nasqueron-irc
    - dir_mode: 770

{% endfor %}

#   -------------------------------------------------------------
#   Logs
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for botname, bot in pillar['viperserv_bots'].items() %}

/srv/viperserv/logs/{{ botname }}.log:
  file.managed:
    - user: {{ bot['runas'] | default('viperserv') }}
    - group: nasqueron-irc
    - mode: 660
{% endfor %}

#   -------------------------------------------------------------
#   Configuration files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/viperserv/core.conf:
  file.managed:
    - source: salt://roles/viperserv/eggdrop/files/eggdrop-core.conf
    - user: viperserv
    - group: nasqueron-irc

/srv/viperserv/.credentials:
  file.managed:
    - source: salt://roles/viperserv/eggdrop/files/dot.credentials
    - user: viperserv
    - group: nasqueron-irc
    - replace: False
    - mode: 660

{% for botname, bot in pillar['viperserv_bots'].items() %}

/srv/viperserv/{{ botname }}/eggdrop.conf:
  file.managed:
    - source: salt://roles/viperserv/eggdrop/files/eggdrop-bot.conf
    - user: {{ bot['runas'] | default('viperserv') }}
    - group: nasqueron-irc
    - mode: 755
    - template: jinja
    - context:
        botname: {{ botname }}
        realname: {{ bot['realname'] | default(botname) }}
        scripts: {{ bot['scripts'] }}
        modules: {{ bot['modules'] | default([]) }}

/srv/viperserv/{{ botname }}/motd:
  file.managed:
    - source: salt://roles/viperserv/eggdrop/files/motd/{{ botname }}
    - user: {{ bot['runas'] | default('viperserv') }}
    - group: nasqueron-irc

/srv/viperserv/{{ botname }}/banner:
  file.managed:
    - source: salt://roles/viperserv/eggdrop/files/banner
    - user: {{ bot['runas'] | default('viperserv') }}
    - group: nasqueron-irc
    - template: jinja
    - context:
        bot: {{ botname }}
        server: {{ grains['id'] }}

{% endfor %}
