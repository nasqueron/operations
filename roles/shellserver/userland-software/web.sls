#   -------------------------------------------------------------
#   Salt — Provision web software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2016-06-12
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages with context %}

#   -------------------------------------------------------------
#   nginx
#   -------------------------------------------------------------

nginx:
  pkg.installed: []
  service.running:
    - require:
      - pkg: nginx

#   -------------------------------------------------------------
#   SSL certificates
#   -------------------------------------------------------------

letsencrypt:
  pkg.installed:
    - name: {{ packages.certbot }}
