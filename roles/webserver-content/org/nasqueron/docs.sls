#   -------------------------------------------------------------
#   Salt — Provision docs.nasqueron.org website
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt['node.has_web_content'](".org/nasqueron/docs") %}

{% from "map.jinja" import dirs, packages with context %}

#   -------------------------------------------------------------
#   Base directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/nasqueron.org/docs:
  file.directory:
    - user: deploy
    - group: web
    - dir_mode: 755

#   -------------------------------------------------------------
#   Software to build the docs
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

sphinx:
  pkg.installed:
    - name: {{ packages.sphinx }}

{{ dirs.bin }}/deploy-docker-registry-api-doc:
  file.managed:
    - source: salt://roles/webserver-content/org/nasqueron/files/deploy-docker-registry-api-doc.sh
    - user: deploy
    - mode: 755

#   -------------------------------------------------------------
#   Deploy rDWWW as docs.n.o homepage and assets
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

www_docs_build:
  module.run:
    - name: jenkins.build_job
    - m_name: deploy-website-nasqueron-www1-docs

#   -------------------------------------------------------------
#   Deploy a rSW docs dir HTML build to docs.n.o/salt-wrapper
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/nasqueron.org/docs/salt-wrapper:
  file.directory:
    - user: deploy
    - group: web
    - dir_mode: 755

salt_wrapper_doc_build:
  cmd.script:
    - source: salt://roles/webserver-content/org/nasqueron/files/build-docs-salt-wrapper.sh
    - args: /var/wwwroot/nasqueron.org/docs/salt-wrapper
    - cwd: /tmp
    - runas: deploy
    - require:
      - file: /var/wwwroot/nasqueron.org/docs/salt-wrapper
      - pkg: sphinx

#   -------------------------------------------------------------
#   Deploy a rLF docs dir HTML build to docs.n.o/limiting-factor
#
#   Job: https://cd.nasqueron.org/job/limiting-factor-doc/
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/nasqueron.org/docs/limiting-factor/rust:
  file.directory:
    - user: deploy
    - group: web
    - dir_mode: 755
    - makedirs: True

limiting_factor_doc_build:
  module.run:
    - name: jenkins.build_job
    - m_name: limiting-factor-doc

#   -------------------------------------------------------------
#   Deploy a rAPIREG docs dir HTML build to docs.n.o/docker-registry-api
#
#   Job: https://cd.nasqueron.org/job/docker-registry-api-doc/
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/nasqueron.org/docs/docker-registry-api/rust:
  file.directory:
    - user: deploy
    - group: web
    - dir_mode: 755
    - makedirs: True

docker_registry_api_doc_build:
  module.run:
    - name: jenkins.build_job
    - m_name: docker-registry-api

{% endif %}
