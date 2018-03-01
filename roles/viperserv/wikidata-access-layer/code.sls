#   -------------------------------------------------------------
#   Salt — Deploy eggdrop park
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-06
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

daeghrefn_wikidata_access_layer:
  file.directory:
    - name: /srv/wikidata-access-layer
    - user: deploy
  git.latest:
    - name: https://devcentral.nasqueron.org/source/Daeghrefn-Wikidata.git
    - target: /srv/wikidata-access-layer
    - user: deploy

{{ dirs.share }}/viperserv/bin:
  file.directory:
    - user: viperserv
    - group: nasqueron-irc

{% for script in ['create_given_name', 'create_surname'] %}
{{ dirs.share }}/viperserv/bin/{{ script }}:
  file.symlink:
    - target: /srv/wikidata-access-layer/{{ script }}
    - user: viperserv
    - group: nasqueron-irc
{% endfor %}
