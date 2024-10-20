#   -------------------------------------------------------------
#   Salt — Core — pf
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set network = salt["node.resolve_network"]() %}

#   -------------------------------------------------------------
#   Main configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/etc/pf.conf:
  file.managed:
    - source: salt://roles/core/pf/files/pf.conf
    - template: jinja
    - context:
        public_ipv4_interface: {{ network["public_ipv4_interface"] }}

#   -------------------------------------------------------------
#   Tables
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/etc/pf:
  file.directory

/etc/pf/badhosts:
  cmd.run:
    - name: touch /etc/pf/badhosts
    - creates: /etc/pf/badhosts
