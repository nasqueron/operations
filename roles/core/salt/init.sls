#   -------------------------------------------------------------
#   Salt — Salt configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-06-12
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

salt_roles:
  grains.list_present:
    - name: roles
    - value: {{ salt['pillar.get']("nodes:" + grains['id'] + ":roles", []) }}
