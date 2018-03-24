#   -------------------------------------------------------------
#   Salt — MediaWiki farm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages, packages_prefixes with context %}

#   -------------------------------------------------------------
#   Software required by MediaWiki or other tools
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mediawiki_software_dependencies:
  pkg.installed:
    - pkgs:
      - {{ packages.exiftool }}
      - exiv2
      - git
      - {{ packages.imagemagick }}
      - {{ packages['jpeg-turbo'] }}
      - {{ packages.lua }}
      - {{ packages_prefixes.php }}opcache
      - rlwrap

#   -------------------------------------------------------------
#   Administration tool
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.bin }}/mw:
  file.managed:
    - source: roles/saas-mediawiki/software/files/mw.sh.jinja
    - mode: 755
    - template: jinja
    - context:
        saas: {{ pillar['mediawiki_saas'] }}
