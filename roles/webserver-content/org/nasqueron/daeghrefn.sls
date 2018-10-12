#   -------------------------------------------------------------
#   Salt — Provision daeghrefn.nasqueron.org website
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt['node.has_web_content'](".org/nasqueron/rain") %}

#   -------------------------------------------------------------
#   Base directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/nasqueron.org/daeghrefn:
  file.directory:
    - user: deploy
    - group: web
    - dir_mode: 755

#   -------------------------------------------------------------
#   Deploy rRAIN
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

www_daeghrefn_build:
  module.run:
    - name: jenkins.build_job
    - m_name: deploy-website-nasqueron-www1-daeghrefn

{% endif %}
