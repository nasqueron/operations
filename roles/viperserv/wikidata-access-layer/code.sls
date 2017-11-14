#   -------------------------------------------------------------
#   Salt — Deploy eggdrop park
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-06
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

daeghrefn_wikidata_access_layer:
    file.directory:
      - name: /srv/wikidata-access-layer
      - user: deploy
    git.latest:
      - name: https://devcentral.nasqueron.org/source/Daeghrefn-Wikidata.git
      - target: /srv/wikidata-access-layer
      - user: deploy
