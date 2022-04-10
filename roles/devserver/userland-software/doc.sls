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
    - source: https://github.com/plantuml/plantuml/releases/download/v1.2022.3/plantuml-1.2022.3.jar
    - source_hash: cb92c5ca56321911f174ac49c7e6dbfda57cf0b27bca684fda69ecb979803465
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
    - source: https://github.com/phpDocumentor/phpDocumentor/releases/download/v3.3.1/phpDocumentor.phar
    - source_hash: 4a93d278fd4581f17760903134d85fcde3d40d93f739c8c648f3ed02c9c3e7bb
    - mode: 755

{{ dirs.bin }}/phpdoc:
  file.symlink:
    - target: /opt/phpDocumentor.phar
    - require:
      - file: /opt/phpDocumentor.phar

/opt/doctum.phar:
 file.managed:
    - source: https://github.com/code-lts/doctum/releases/download/v5.5.1/doctum.phar
    - source_hash: https://github.com/code-lts/doctum/releases/download/v5.5.1/doctum.phar.sha256
    - mode: 755

{{ dirs.bin }}/doctum:
  file.symlink:
    - target: /opt/doctum.phar
    - require:
      - file: /opt/doctum.phar
