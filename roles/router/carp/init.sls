#   -------------------------------------------------------------
#   Salt — Router — CARP
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages_prefixes with context %}

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

carp_switch_pip:
  pkg.installed:
    - name: {{ packages_prefixes.python3 }}pip

carp_switch_dependencies:
  cmd.run:
    - name: python3 -m pip install ovh secretsmith
    - creates: {{ salt['python.get_site_packages_directory']() }}/secretsmith
