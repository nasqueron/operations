#   -------------------------------------------------------------
#   Salt — Database server — MySQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Credit:         Jaime Crespo (@Jynus)
#   Created:        2017-11-09
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Coloration grc configuration file for MySQL client
#
#   “ This is more than pure aesthetics- DBAs are looking at this output
#     for long hours, a bit of color (disabled by default) will make
#     their life easier.
#
#     Enable with:
#     mysql --pager='grcat /etc/mysql/grcat.config | less -RSFXin'
#
#   ” -- Jaime Crespo
#
#   Note it's deployed instead in share dir to be able to `grc mysql`.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.share }}/conf.mysql:
  file.managed:
    - source: salt://roles/dbserver-mysql/grc/files/grcat.config

{{ dirs.etc }}/grc.conf:
  file.append:
    - text: |
        # MySQL mysql command
        (^|[/\w\.]+/)mysql\s?
        conf.mysql
