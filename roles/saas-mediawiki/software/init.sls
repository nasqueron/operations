#   -------------------------------------------------------------
#   Salt — MediaWiki farm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages with context %}

#   -------------------------------------------------------------
#   Software required by MediaWiki
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mediawiki_software_dependencies:
  pkg.installed:
    - pkgs:
      - {{ packages.exiftool }}
      - exiv2
      - git
      - {{ packages.imagemagick }}
      - {{ packages['jpeg-turbo'] }}
