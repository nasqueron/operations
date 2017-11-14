#   -------------------------------------------------------------
#   Salt — Deploy eggdrop park
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-06
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages_prefixes with context %}

pywikibot_dependencies:
  pkg.installed:
    - pkgs:
      - {{ packages_prefixes.python3 }}requests

pywikibot_software:
  file.directory:
    - name: /opt/pywikibot
    - user: deploy
  git.latest:
    - name:  https://gerrit.wikimedia.org/r/pywikibot/core.git
    - submodules: True
    - target: /opt/pywikibot
    - user: deploy
    - require:
      - pkg: pywikibot_dependencies
