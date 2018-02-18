#   -------------------------------------------------------------
#   Salt — Bastion - Yubikeys
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-02-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% for username, user in salt['forest.get_users']().iteritems() %}

{% if 'yubico_keys' in user %}
/home/{{ username }}/.yubico:
  file.directory:
    - user: {{ username }}
    - mode: 700

/home/{{ username }}/.yubico/authorized_yubikeys:
  file.managed:
    - user: {{ username }}
    - mode: 600
    - contents: {{ username + ':' + ':'.join(user['yubico_keys']) }}
{% endif %}

{% endfor %}
