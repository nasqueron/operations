#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Service:        Nasqueron Reports
#   -------------------------------------------------------------

docker_images:
  - nasqueron/reports

nasqueron_reports:
    reports_dir: /var/wwwroot-content/docker-002.nasqueron.org/reports

    jobs:
      - report: devcentral-tokens-language-models
        schedule: daily
