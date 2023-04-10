#   -------------------------------------------------------------
#   Salt — Database server — MySQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Pillar:         dbserver_mysql (in pillar/dbserver)
#   License:        Trivial work, not eligible to copyright
#                   If eligible, licensed under BSD-2-Clause
#   -------------------------------------------------------------

{% set users = salt['pillar.get']("dbserver_mysql:users", {}) %}
{% set databases = salt['pillar.get']("dbserver_mysql:databases", {}) %}

#   -------------------------------------------------------------
#   Users
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for username, args in users.items() %}
dbserver_mysql_user_{{ username }}:
  mysql_user.present:
    - name: {{ username }}
    - host: {{ args["host"] }}
    - password: {{ salt["credentials.get_password"](args["password"]) }}
{% endfor %}

#   -------------------------------------------------------------
#   Databases
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for db_name, args in databases.items() %}
dbserver_mysql_db_{{ db_name }}:
  mysql_database.present:
    - name: {{ db_name }}
    {% if "encoding" in args %}
    - character_set: {{ args["encoding"] }}
    {% endif %}
    {% if "collation" in args %}
    - collate: {{ args["collation"] }}
    {% endif %}
{% endfor %}

#   -------------------------------------------------------------
#   Privileges
#
#   Scopes supported:
#     - database (alias for GRANT ALL PRIVILEGES on <db>.* TO ...)
#     - table    (GRANT ... on <db>.<table> TO ...)
#
#   The state module mysql_grants uses the value database for the ON clause:
#       `GRANT ... ON <database> TO ...`
#
#   The "database" field should so be read as "priv_level"
#   according https://mariadb.com/kb/en/grant/#syntax name.
#
#   Please note using "database" instead or "privilege_level"
#   isn't considered as a a best practice. We understand to use
#   directly mysql_grants simplifies the module configuration
#   and as such this may be necessary for compatibility, but
#   we encourage a more precise terminology.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for username, user_args in users.items() %}
{% for privilege in user_args.get("privileges", []) %}

{% set idx = loop.index %}

{% if privilege["scope"] == "database" %}
dbserver_mysql_user_{{ username }}_privilege_{{ idx }}_{{ privilege["database"] }}:
  mysql_grants.present:
    - grant: all privileges
    - database: {{ privilege["database"] }}.*
    - user: {{ username }}
    - host: {{ user_args["host"] }}
    - require:
      - dbserver_mysql_user_{{ username }}
      - dbserver_mysql_db_{{ privilege["database"] }}
{% endif %}

{% if privilege["scope"] == "table" %}
{% for table in privilege["tables"] %}
dbserver_mysql_user_{{ username }}_privilege_{{ idx }}_{{ table }}:
  mysql_grants.present:
    - grant: {{ privilege["privileges"] }}
    - database: {{ privilege["database"] }}.{{ table }}
    - user: {{ username }}
    - require:
      - dbserver_mysql_user_{{ username }}
      - dbserver_mysql_db_{{ privilege["database"] }}
{% endfor %}
{% endif %}

{% endfor %}
{% endfor %}
