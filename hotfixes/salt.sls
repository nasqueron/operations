#   -------------------------------------------------------------
#   Salt — Hotfixes to mitigate bugs and security issues
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   T1991 :: egrep -> grep -E
#
#   GNU grep deprecated egrep separate utility.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['kernel'] == 'Linux' %}

{% if salt["pkg.version_cmp"](grains["saltversion"], "3007") >= 0 %}
T1991_egrep_patch:
  file.patch:
    - name: {{ grains.saltpath }}
    - source: salt://hotfixes/files/T1991-egrep.salt-3007.patch
    - strip: 1
{% else %}
T1991_egrep_patch:
  file.patch:
    - name: {{ grains.saltpath }}
    - source: salt://hotfixes/files/T1991-egrep.salt-3006.patch
    - strip: 1
{% endif %}

{% endif %}
