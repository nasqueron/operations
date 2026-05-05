#   -------------------------------------------------------------
#   Salt — Network — GRE tunnels log
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set roles = grains.get("roles", []) %}

{% if "router" in roles or "devserver" in roles %}

/usr/local/etc/syslog.d/gre-tunnels.conf:
  file.managed:
    - source: salt://roles/core/network/files/syslog_gre.conf
    - user: root
    - group: wheel
    - mode: 644

/etc/newsyslog.conf.d/gre-tunnels.conf:
  file.managed:
    - source: salt://roles/core/network/files/newsyslog_gre.conf
    - user: root
    - group: wheel
    - mode: 644

/etc/syslog.conf add gre next to carp:
  file.replace:
    - name: /etc/syslog.conf
    - pattern: '^!-carp-ovh\n\*\.notice;authpriv\.none;kern\.debug;lpr\.info;mail\.crit;news\.err\s+/var/log/messages\n!\*$'
    - repl: '!-carp-ovh,gre-tunnels\n*.notice;authpriv.none;kern.debug;lpr.info;mail.crit;news.err    /var/log/messages\n!*'
    - flags:
      - MULTILINE
    - count: 1
    - backup: False
    - onlyif: grep -Fqx '!-carp-ovh' /etc/syslog.conf
    - unless: grep -Fqx '!-carp-ovh,gre-tunnels' /etc/syslog.conf

/etc/syslog.conf exclude gre:
  file.replace:
    - name: /etc/syslog.conf
    - pattern: '^\*\.notice;authpriv\.none;kern\.debug;lpr\.info;mail\.crit;news\.err\s+/var/log/messages$'
    - repl: '!-gre-tunnels\n*.notice;authpriv.none;kern.debug;lpr.info;mail.crit;news.err    /var/log/messages\n!*'
    - flags:
      - MULTILINE
    - count: 1
    - backup: False
    - onlyif: test "$(grep -Fxc '!-carp-ovh' /etc/syslog.conf)" = "0"
    - unless: grep -Eq '^!-(carp-ovh,gre-tunnels|gre-tunnels,carp-ovh|gre-tunnels)$' /etc/syslog.conf

{% endif %}
