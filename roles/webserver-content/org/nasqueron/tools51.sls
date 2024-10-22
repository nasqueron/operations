#   -------------------------------------------------------------
#   Salt — Provision tools51.nasqueron.org website
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Read Git revision
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/run/web/tools51.nasqueron.org/.gitconfig:
  file.managed:
    - source: salt://roles/webserver-content/org/nasqueron/files/git-safe.conf
    - user: web-org-nasqueron-tools51
    - template: jinja
    - context:
        path: /var/51-wwwroot/tools

#   -------------------------------------------------------------
#   Dependencies
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

tools51_dependencies:
  pkg.installed:
    - pkgs:
      - jive
      - valspeak
