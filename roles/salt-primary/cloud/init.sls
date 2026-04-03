#   -------------------------------------------------------------
#   Salt — Salt configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Providers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

salt_cloud_providers:
  file.recurse:
    - name: {{ dirs.etc }}/salt/cloud.providers.d
    - source: salt://roles/salt-primary/cloud/files/providers
    - dir_mode: 755
    - file_mode: 644
