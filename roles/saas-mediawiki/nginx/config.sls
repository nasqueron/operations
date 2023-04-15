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

saas_mediawiki_nginx_includes:
  file.recurse:
    - name: {{ dirs.etc }}/nginx/includes
    - source: salt://roles/saas-mediawiki/nginx/files/includes
    - dir_mode: 755
    - file_mode: 644
    - template: jinja
    - context:
        saas: {{ pillar['mediawiki_saas'] }}

#   -------------------------------------------------------------
#   vhosts folder
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

saas_mediawiki_nginx_vhosts:
  file.recurse:
    - name: {{ dirs.etc }}/nginx/vhosts
    - source: salt://roles/saas-mediawiki/nginx/files/vhosts
    - dir_mode: 755
    - file_mode: 644
