#   -------------------------------------------------------------
#   Salt — Hypership
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Zed
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt['node.has_web_content'](".space/hypership") %}

/srv/zed:
  file.directory

#   -------------------------------------------------------------
#   Content
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

zed_content:
  git.latest:
    - name: https://github.com/hypership/content.git
    - target: /srv/zed/content

{% endif %}
