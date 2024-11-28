#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Service:        Jenkins
#   -------------------------------------------------------------

docker_networks:
  cd:
    subnet: 172.18.1.0/24
  ci:
    subnet: 172.18.2.0/24

docker_images:
  - jenkins/jenkins
  - nasqueron/jenkins-agent-node
  - nasqueron/jenkins-agent-php
  - nasqueron/jenkins-agent-php:7.4.23
  - nasqueron/jenkins-agent-rust
  - nasqueron/tommy

docker_containers:

  jenkins:
    jenkins_cd:
      realm: cd
      host: cd.nasqueron.org
      app_port: 38080
      jnlp_port: 50000

    jenkins_ci:
      realm: ci
      host: ci.nasqueron.org
      app_port: 42080
      jnlp_port: 55000

  jenkins_agent:

    #
    # Agents for CD
    #

    apsile: &php_for_cd
      image_flavour: php
      realm: cd

    elapsi: *php_for_cd

    rust_brown:
      image_flavour: rust
      realm: cd

    yarabokin:
      image_flavour: node
      realm: cd

    #
    # Agents for CI
    #

    zateki: &php_for_ci
      image_flavour: php
      realm: ci

    zenerre: *php_for_ci

  tommy:
    tommy_cd:
      # No host definition, as this dashboard is mounted on infra.nasqueron.org
      app_port: 24180
      jenkins_url: https://cd.nasqueron.org

    tommy_ci:
      app_port: 24080
      host: builds.nasqueron.org
      aliases:
        - build.nasqueron.org
      jenkins_url: https://ci.nasqueron.org
      jenkins_multi_branch: True
