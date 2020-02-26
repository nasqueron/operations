#   -------------------------------------------------------------
#   Salt — MediaWiki farm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   includes folder
#
#    :: MediaWiki and SaaS location blocks
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/nginx/includes:
  file.recurse:
    - source: salt://roles/saas-mediawiki/nginx/files/includes
    - dir_mode: 755
    - file_mode: 644
    - template: jinja
    - context:
        saas: {{ pillar['mediawiki_saas'] }}

#   -------------------------------------------------------------
#   vhosts folder
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/nginx/vhosts:
  file.recurse:
    - source: salt://roles/saas-mediawiki/nginx/files/vhosts
    - dir_mode: 755
    - file_mode: 644
