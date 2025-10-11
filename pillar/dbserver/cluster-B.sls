#   -------------------------------------------------------------
#   YAML aliases to use in MariaDB server configuration
#
#   Those pillar entries are not directly used in Salt states;
#   they define aliases to be used below in this YAML pillar.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dbserver_mysql_aliases:
  hosts:
    - &viperserv 172.27.27.33
    - &windriver 172.27.27.35
    - &web-001 172.27.27.10

dbserver_mysql_privileges_templates:
  interwiki: &interwiki
    scope: table
    privileges: SELECT, INSERT, DELETE
    tables:
      - interwiki

#   -------------------------------------------------------------
#   Configuration for MariaDB server to provision
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dbserver_mysql:

  server:
    salt:
      # Account used by Salt to configure the server
      credentials: dbserver/cluster-B/users/salt

  users:
    # Password paths are relative to ops/secrets

    nasqueron:
      password: dbserver/cluster-B/users/nasqueron
      host: *viperserv
      privileges:
        - database: Nasqueron
          scope: database

        - database: datacubes
          scope: database

        - database: datasource_lyrics
          scope: table
          privileges: SELECT, INSERT
          tables:
            # Tabled managed as datacube by Dæghrefn
            - lyrics_sneakers

    saas-mediawiki:
      password: dbserver/cluster-B/users/saas-mediawiki
      host: "%"
      privileges:
        - database: wikis
          scope: database
        - database: utopia
          scope: database
        - database: arsmagica
          scope: database
        - database: wolfplex_wiki
          scope: database
        - database: inidal_wiki
          scope: database
        - database: nasqueron_wiki
          scope: database

    saas-mw-deploy:
      password: dbserver/cluster-B/users/saas-mw-deploy
      host: *web-001
      privileges:
        - database: nasqueron_wiki
          <<: *interwiki

        - database: wolfplex_wiki
          <<: *interwiki

    ###
    ### Nasqueron members
    ###

    dereckson_www:
      password: dbserver/cluster-B/users/dereckson_www
      host: *web-001
      privileges: &dereckson_www
        - database: Dereckson
          scope: database

    dereckson_www51:
      password: dbserver/cluster-B/users/dereckson_www51
      host: *windriver
      privileges: *dereckson_www

    dereckson_blog:
      password: dbserver/cluster-B/users/dereckson_blog
      host: *web-001
      privileges:
        - database: Dereckson_Blog
          scope: database

    ###
    ### Wolfplex
    ###

    wolfplex_zine:
      password: dbserver/cluster-B/users/wolfplex_zine
      host: *windriver
      privileges:
        - database: wolfplex_zine
          scope: database

    ###
    ### Zed / HyperShip
    ###

    zed:
      password: dbserver/cluster-B/users/zed
      host: *web-001
      privileges:
        - database: zed_prod
          scope: database

    ###
    ### Maintenance accounts
    ###

    dereckson:
      password: dbserver/cluster-B/users/dereckson
      host: *windriver
      privileges:
        - database: Nasqueron
          scope: database
        - database: datacubes
          scope: database
        - database: datasource_%
          scope: database
        - database: wolfplex_%
          scope: database

  # Notes for databases encoding and collation:
  #
  #   This is a MariaDB cluster. At version 10.6, MariaDB is still using utf8mb3
  #   by default, but we generally prefer utf8mb4 as encoding.
  #
  #   For collation, MySQL 8 uses utf8mb4_0900_ai_ci / utf8mb4_0900_as_cs
  #   It's an accent (in)sensitive case (in)sensitive based on Unicode 9.0.
  #   For MariaDB 10.10+, we can use uca1400_as_ci; that's Unicode 14.0.
  #
  #   We note it with the full name utf8mb4_uca1400_as_ci, something not needed
  #   for manual requests, but allowing mysql_database.present to check equality.
  #
  #   TRANSITION NOTE. On MariaDB 10.6, utf8mb4_unicode_520_ci is the "newest".
  #   From 2023-04-15, we start to use uca1400_as_ci as the default collation.

  databases:
    # Database used by IRC eggdrops
    Nasqueron: &unicode
      encoding: utf8mb4
      collation: utf8mb4_uca1400_as_ci
    datacubes: *unicode
    datasource_lyrics: *unicode

    # Databases used by MediaWiki SaaS
    wikis: &mediawiki
      encoding: utf8mb4
      collation: utf8mb4_bin
    arsmagica: *mediawiki
    inidal_wiki: *mediawiki
    nasqueron_wiki: *mediawiki

    # Databases used by MediaWiki SaaS - still to split from other content
    utopia: *mediawiki
    wolfplex_wiki: *mediawiki

    # Nasqueron members
    Dereckson: *unicode
    Dereckson_Blog: *unicode

    # Wolfplex
    wolfplexdb: *mediawiki
    wolfplex_zine: *unicode

    # Zed / Hypership
    zed_prod: *unicode
