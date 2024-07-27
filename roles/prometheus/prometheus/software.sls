#   -------------------------------------------------------------
#   Salt — Provision Prometheus
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

prometheus_software:
  pkg.installed:
    - pkgs:
      - prometheus
