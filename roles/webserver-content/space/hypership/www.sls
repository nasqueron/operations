#   -------------------------------------------------------------
#   Salt — Hypership
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Zed
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt['node.has_web_content'](".space/hypership") %}

/var/dataroot/zed:
  file.directory:
    - user: deploy

#   -------------------------------------------------------------
#   Content
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if not salt["file.directory_exists"]("/var/dataroot/zed/content/.git") %}
zed_content:
  file.directory:
    - name: /var/dataroot/zed/content
    - user: deploy
    - mode: 755

  git.latest:
    - name: https://github.com/hypership/content.git
    - target: /var/dataroot/zed/content
    - user: deploy
{% endif %}

{% if not salt["file.directory_exists"]("/var/dataroot/zed/content/users") %}
zed_content_private:
  file.directory:
    - name: /var/dataroot/zed/content/users
    - user: deploy
    - mode: 711

  git.latest:
    - name: git@github.com:hypership/content_users.git
    - target: /var/dataroot/zed/content/users
    - user: deploy
    - identity: {{ pillar["wwwroot_identities"]["deploy-key-github-hypership-content_users"]["path"] }}
    - update_head: False
{% endif %}

zed_content_rights:
  file.directory:
    - name: /var/dataroot/zed/content
    - user: web-space-hypership-www
    - recurse:
      - user
      - group

#   -------------------------------------------------------------
#   Cache
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/dataroot/zed/cache:
  file.directory:
    - user: web-space-hypership-www

{% for subdir in ['compiled', 'openid', 'sessions'] %}
/var/dataroot/zed/cache/{{ subdir }}:
  file.directory:
    - user: web-space-hypership-www
{% endfor %}

{% endif %}
