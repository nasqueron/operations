#   -------------------------------------------------------------
#   Salt — PEFS
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains["os"] == "FreeBSD" %}

pefs-kmod:
  pkg.installed

pefs_kernel_modules_enable:
  module.wait:
    - name: kmod.load
    - mod: pefs
    - persist: True
    - watch:
        - pkg: pefs-kmod

/boot/loader.conf.d/pefs.conf:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/pefs.conf

{% endif %}
