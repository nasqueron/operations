#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-29
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "roles/devserver/userland-software/map.jinja" import php with context %}

#   -------------------------------------------------------------
#   Fetch software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/opt/php-ast:
  file.directory:
    - user: builder

php_ast_repository:
  git.latest:
    - name: https://github.com/nikic/php-ast.git
    - target: /opt/php-ast
    - user: builder

#   -------------------------------------------------------------
#   Build software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

php_ast_build:
  cmd.script:
    - source: salt://roles/devserver/userland-software/files/install-php-extension.sh
    - cwd: /opt/php-ast
    - creates: /opt/php-ast/modules/ast.so

php_ast_install:
  cmd.run:
    - name: make install
    - cwd: /opt/php-ast
    - creates: {{ php.extension_dir }}/ast.so

#   -------------------------------------------------------------
#   PHP configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ php.cli_conf_dir }}/ext-40-ast.ini:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/ast.ini
