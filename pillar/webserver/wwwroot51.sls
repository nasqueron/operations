#   -------------------------------------------------------------
#   Salt — Sites to provision on the devserver wwwroot51
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

wwwroot51_basedir: /var/51-wwwroot

wwwroot_identities:
  alken-orin:
    secret: nasqueron/deploy/deploy_keys/alken-orin
    path: /opt/salt/security/id_alken_orin_ed25519

  deploy-key-bitbucket-dereckson-www:
    secret: nasqueron/deploy/deploy_keys/by_repo/bitbucket/dereckson/www
    path: /opt/salt/security/id_bitbucket_dereckson_www

  deploy-key-bitbucket-espacewin-www:
    secret: nasqueron/deploy/deploy_keys/by_repo/bitbucket/ewosp/www
    path: /opt/salt/security/id_bitbucket_espacewin_www

  deploy-key-github-wolfplex-api-www:
    secret: nasqueron/deploy/deploy_keys/by_repo/github/wolfplex/api-www
    path: /opt/salt/security/id_github_wolfplex_api_www

wwwroot51_directories:
  api:
    user: dereckson
    group: dereckson
    repository: ssh://vcs@devcentral.nasqueron.org:5022/source/api.git
    identity: alken-orin

  dereckson-www:
    user: dereckson
    group: dereckson
    repository: git@bitbucket.org:dereckson/www.dereckson.be.git
    identity: deploy-key-bitbucket-dereckson-www

  espacewin-www:
    user: dereckson
    group: dereckson
    repository: git@bitbucket.org:ewosp/www.espace-win.org.git
    identity: deploy-key-bitbucket-espacewin-www

  mediawiki-dereckson:
    user: dereckson
    group: dereckson

  obsidian:
    user: dereckson
    group: dereckson

  rain:
    user: dereckson
    group: dereckson

  saas-mediawiki:
    user: dereckson
    group: mediawiki
    repository: ssh://vcs@devcentral.nasqueron.org:5022/source/saas-mediawiki.git
    identity: alken-orin

  tools:
    user: dereckson
    group: dereckson
    repository: ssh://vcs@devcentral.nasqueron.org:5022/source/tools.git
    identity: alken-orin

  wolfplex-api:
    user: dereckson
    group: dereckson
    repository: git@github.com:wolfplex/api-www.git
    identity: deploy-key-github-wolfplex-api-www

  www:
    user: dereckson
    group: dereckson
    repository: ssh://vcs@devcentral.nasqueron.org:5022/source/www.git
    identity: alken-orin
