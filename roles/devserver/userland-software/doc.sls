#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Documentation
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devserver_software_documentation:
  pkg.installed:
    - pkgs:
      - graphviz

/opt/plantuml.jar:
  file.managed:
    - source: https://github.com/plantuml/plantuml/releases/download/v1.2026.2/plantuml-1.2026.2.jar
    - source_hash: 3cdce52133c424dea22425b947ae9d47f2167b0866dfcf99e714d4ea1689975c
    - mode: 644

{{ dirs.bin }}/plantuml:
  file.managed:
    - contents: |
        #!/usr/bin/env sh
        java -jar /opt/plantuml.jar "$@"
    - mode: 755
    - require:
      - file: /opt/plantuml.jar

/opt/phpDocumentor.phar:
  file.managed:
    - source: https://github.com/phpDocumentor/phpDocumentor/releases/download/v3.9.1/phpDocumentor.phar
    - source_hash: ef5509af790c8e56d11fff8162f12c7c19473b9af6e79b0fb9a62aff26da2ea5
    - mode: 755

{{ dirs.bin }}/phpdoc:
  file.symlink:
    - target: /opt/phpDocumentor.phar
    - require:
      - file: /opt/phpDocumentor.phar

/opt/doctum.phar:
 file.managed:
    - source: https://github.com/code-lts/doctum/releases/download/v5.6.0/doctum.phar
    - source_hash: https://github.com/code-lts/doctum/releases/download/v5.6.0/doctum.phar.sha256
    - mode: 755

{{ dirs.bin }}/doctum:
  file.symlink:
    - target: /opt/doctum.phar
    - require:
      - file: /opt/doctum.phar
