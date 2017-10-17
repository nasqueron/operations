#   -------------------------------------------------------------
#   Salt — Hotfixes to mitigate bugs and security issues
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-17
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   T1261
#   We now provision /srv/data instead of /data for Docker
#   containers data. As such, we ensure a symlink exists
#   on servers still using /data.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if not salt['file.directory_exists']('/srv/data') and salt['file.directory_exists']('/data') %}
srv_data_symlink:
  file.symlink:
    - name: /srv/data
    - target: /data
{% endif %}
