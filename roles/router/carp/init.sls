#   -------------------------------------------------------------
#   Salt — Router — CARP
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/etc/rc.conf.d/netif/carp:
  file.managed:
    - source: salt://roles/router/carp/files/carp.rc
    - template: jinja
    - context:
        carp_entries: {{ salt['node.get_carp_entries']() }}
    - mode: '0644'

/boot/loader.conf.d/carp.conf:
  file.managed:
    - source: salt://roles/router/carp/files/carp.conf
    - mode: '0644'
