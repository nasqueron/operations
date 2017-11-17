#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Unbound
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

unbound:
  pkg.installed

unbound_DNSSEC_trust_anchor:
  cmd.run:
    - name: {{ dirs.sbin }}/unbound-anchor ; true
    - runas: unbound
    - creates: {{ dirs.etc }}/unbound/root.key
    - require:
        - pkg: unbound
