#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-02-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/var/wwwroot-content/{{ grains['fqdn'] }}/index.html:
  file.managed:
    - contents: Welcome to {{ grains['fqdn'] }}.
    - replace: False
    - makedirs: True
    - mode: 644

/var/wwwroot-content/_fallback/index.html:
  file.managed:
    - source: salt://roles/paas-docker/wwwroot-content/files/domain-not-found.html
    - makedirs: True
    - mode: 644
