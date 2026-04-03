#   -------------------------------------------------------------
#   Salt — Provision software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os'] == 'FreeBSD' %}

#   -------------------------------------------------------------
#   Declare repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/etc/pkg/repos:
  file.directory:
    - makedirs: True

/usr/local/etc/pkg/repos/nasqueron.conf:
  file.managed:
    - source: salt://roles/devserver/pkg/files/nasqueron.conf

#   -------------------------------------------------------------
#   Fingerprints
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/share/keys:
  file.directory:
    - makedirs: True

/usr/local/share/keys/pkg:
  file.recurse:
    - source: salt://roles/devserver/pkg/files/keys

{% endif %}
