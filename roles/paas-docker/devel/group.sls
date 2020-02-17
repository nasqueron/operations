#   -------------------------------------------------------------
#   Salt — Docker development tools
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-02-17
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

docker_group:
  group.present:
    - name: docker
    - gid: 9000
    - members: {{ pillar['shellgroups']['ops']['members'] }}
