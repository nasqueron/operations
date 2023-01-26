#   -------------------------------------------------------------
#   Salt — Database server — PostgreSQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Pillar:         dbserver_postgresql (in pillar/dbserver)
#   License:        Trivial work, not eligible to copyright
#                   If eligible, licensed under BSD-2-Clause
#   -------------------------------------------------------------

{% set users = salt['pillar.get']("dbserver_postgresql:users", {}) %}
{% set databases = salt['pillar.get']("dbserver_postgresql:databases", {}) %}

#   -------------------------------------------------------------
#   Users
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for username, args in users.items() %}
dbserver_pgsql_user_{{ username }}:
  postgres_user.present:
    - name: {{ username }}
    - password: {{ salt["credentials.get_password"](args["password"]) }}
    - encrypted: scram-sha-256
{% endfor %}

#   -------------------------------------------------------------
#   Databases
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for db_name, args in databases.items() %}
dbserver_pgsql_db_{{ db_name }}:
  postgres_database.present:
    - name: {{ db_name }}
    {% if "encoding" in args %}
    - encoding: {{ args["encoding"] }}
    {% endif %}
    {% if "collation" in args %}
    - lc_collate: {{ args["collation"] }}
    {% endif %}
    {% if "ctype" in args %}
    - lc_ctype:  {{ args["ctype"] }}
    {% endif %}
    - owner: {{ args["owner"] }}
    - require:
      - dbserver_pgsql_user_{{ args["owner"] }}

{% for extension in args.get("extensions", []) %}
dbserver_pgsql_db_{{ db_name }}_ext_{{ extension }}:
  postgres_extension.present:
    - maintenance_db: {{ db_name }}
    - name: {{ extension }}
    - require:
      - dbserver_pgsql_db_{{ db_name }}
{% endfor %}

{% endfor %}

#   -------------------------------------------------------------
#   Privileges
#
#   Scopes supported:
#     - schema
#     - table
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for username, user_args in users.items() %}
{% for privilege in user_args.get("privileges", []) %}

{% set idx = loop.index %}

{% if privilege["scope"] == "schema" %}
{% for schema in privilege.get("schemas", ["public"]) %}
dbserver_pgsql_user_{{ username }}_privilege_{{ idx }}_{{ schema }}:
  postgres_privileges.present:
    - name: {{ username }}
    - object_type: schema
    - object_name: {{ schema }}
    - maintenance_db: {{ privilege["database"] }}
    - privileges: {{ privilege["privileges"] }}
    - require:
      - dbserver_pgsql_user_{{ username }}
      - dbserver_pgsql_db_{{ privilege["database"] }}
{% endfor %}
{% endif %}

{% if privilege["scope"] == "table" %}
{% for table in privilege["tables"] %}
dbserver_pgsql_user_{{ username }}_privilege_{{ idx }}_{{ table }}:
  postgres_privileges.present:
    - name: {{ username }}
    - object_type: table
    - object_name: {{ table }}
    - prepend: {{ privilege["schema"] }}
    - maintenance_db: {{ privilege["database"] }}
    - privileges: {{ privilege["privileges"] }}
    - require:
      - dbserver_pgsql_user_{{ username }}
      - dbserver_pgsql_db_{{ privilege["database"] }}
{% endfor %}
{% endif %}

{% endfor %}
{% endfor %}
