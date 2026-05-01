/usr/local/etc/syslog.d/gre-tunnels.conf:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/syslog_gre.conf
    - user: root
    - group: wheel
    - mode: 644

/etc/newsyslog.conf.d/gre-tunnels.conf:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/newsyslog_gre.conf
    - user: root
    - group: wheel
    - mode: 644

reload_syslogd_for_gre_logs:
  cmd.run:
    - name: service syslogd reload
    - onchanges:
      - file: /usr/local/etc/syslog.d/gre-tunnels.conf
