#   -------------------------------------------------------------
#   Salt — Nasqueron Reports
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/etc/secrets/rhyne-wyse.yaml:
  file.managed:
    - source: salt://roles/reports/rhyne-wyse/files/secrets.conf
    - user: rhyne-wyse
    - mode: 400
    - makedirs: True
    - template: jinja
    - context:
        vault:
          approle: {{ salt["credentials.read_secret"]("nasqueron/rhyne-wyse/salt") }}
          addr: {{ pillar["nasqueron_services"]["vault_url"] }}

/var/db/rhyne-wyse:
  file.directory:
    - user: rhyne-wyse
    - group: nasquenautes
    - dir_mode: 775
    - file_mode: 664
    - recurse:
      - group
      - mode

#   -------------------------------------------------------------
#   Configuration files maintained in the "reports" repository
#
#   As pywikibot checks ownership of the configuration file,
#   we need to copy it instead of symlink it.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/run/rhyne-wyse/conf:
  file.symlink:
    - target: /opt/nasqueron-reports/tools/rhyne-wyse/conf

/var/run/rhyne-wyse/families:
  file.directory:
    - user: rhyne-wyse
    - group: nasquenautes
    - dir_mode: 775

/var/run/rhyne-wyse/families/agora_family.py:
  file.managed:
    - source: /opt/nasqueron-reports/tools/rhyne-wyse/families/agora_family.py
    - user: rhyne-wyse
    - group: nasquenautes
    - mode: 664

/var/run/rhyne-wyse/user-config.py:
  file.managed:
    - source: /opt/nasqueron-reports/tools/rhyne-wyse/user-config.py
    - user: rhyne-wyse
    - group: nasquenautes
    - mode: 644
