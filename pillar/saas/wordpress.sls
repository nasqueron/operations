#   -------------------------------------------------------------
#   Salt — WordPress SaaS
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

wordpress_saas:
  wordpress_directory: /srv/wordpress

wordpress_sites:
  dereckson:
    user: web-be-dereckson-www
    db:
      service: db-B
      credentials: dbserver/cluster-B/users/dereckson_blog
      name: dereckson_blog
    secrets: dereckson/wordpress/secrets
