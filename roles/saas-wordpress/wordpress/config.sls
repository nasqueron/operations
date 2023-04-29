#   -------------------------------------------------------------
#   Salt — WordPress SaaS
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Experimental WordPress Saas installation
#
#   The only goal of this stanza is to see how to populate
#   credentials through Vault.
#
#   In a next step, wp-config.php will be set by an entry point
#   built on the top of nasqueron/saas-service, like we do for
#   Mediawiki.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set blog_args = pillar["wordpress_sites"]["dereckson"] %}
{% set secrets = salt["vault.read_secret"]("ops/secrets/" + blog_args["secrets"]) %}

/srv/wordpress/wp-config.php:
  file.managed:
    - source: salt://roles/saas-wordpress/wordpress/files/wp-config.php.jinja
    - mode: 400
    - show_changes: False
    - user: {{ blog_args["user"] }}
    - makedirs: True
    - template: jinja
    - context:
        defines:
          DB_HOST: {{ pillar["nasqueron_services"][blog_args["db"]["service"]] }}
          DB_USER: {{ salt["credentials.get_username"](blog_args["db"]["credentials"]) }}
          DB_PASSWORD: {{ salt["credentials.get_password"](blog_args["db"]["credentials"]) }}
          DB_NAME: {{ blog_args["db"]["name"] }}

          # Secrets
          {% for key, value in secrets.items() %}
          {{ key }}: {{ value | yaml_dquote }}
          {% endfor %}
