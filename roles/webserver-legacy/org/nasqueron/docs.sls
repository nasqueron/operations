#   -------------------------------------------------------------
#   Salt — Provision docs.nasqueron.org website
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages with context %}

#   -------------------------------------------------------------
#   Base directroy
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/nasqueron.org/docs:
  file.directory:
    - user: deploy
    - group: web
    - dir_mode: 755

#   -------------------------------------------------------------
#   Deploy a rSW docs dir HTML build to docs.n.o/salt-wrapper
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/nasqueron.org/docs/salt-wrapper:
  file.directory:
    - user: deploy
    - group: web
    - dir_mode: 755

salt_wrapper_doc_build:
  cmd.script:
    - source: salt://roles/webserver-legacy/org/nasqueron/files/build-docs-salt-wrapper.sh
    - args: /var/wwwroot/nasqueron.org/docs/salt-wrapper
    - cwd: /tmp
    - runas: deploy
    - require:
      - file: /var/wwwroot/nasqueron.org/docs/salt-wrapper
      - pkg: sphinx

#   -------------------------------------------------------------
#   Software to build the docs
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

sphinx:
  pkg.installed:
    - name: {{ packages.sphinx }}
