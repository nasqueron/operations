#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

nginx_software:
  pkg.installed:
    - pkgs:
      - nginx

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

nginx_service:
  service.running:
    - name: nginx
    - enable: true
