#   -------------------------------------------------------------
#   Salt — Salt master configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-04-28
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Providers
#   -------------------------------------------------------------

saltmaster_cloud_providers:
  file.recurse:
    - name: {{ dirs.etc }}/salt/cloud.providers.d
    - source: salt://roles/saltmaster/cloud/files/providers
    - dir_mode: 755
    - file_mode: 644
