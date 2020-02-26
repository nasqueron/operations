#   -------------------------------------------------------------
#   Salt — Deploy legacy OpenSSL 1.0
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2017-02-25
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

{% set openssl_version = "1.0.2t" %}
{% set openssl_hash    = "14cb464efe7ac6b54799b34456bd69558a749a4931ecfd9cf9f71d7881cac7bc" %}
{% set openssl_tarball = "openssl-" + openssl_version + ".tar.gz" %}

#   -------------------------------------------------------------
#   Source code
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/src:
  file.directory:
    - dir_mode: 755

/usr/local/src/openssl-legacy:
  file.directory:
    - user: builder
    - group: deployment
    - dir_mode: 755

/usr/local/src/{{ openssl_tarball }}:
  file.managed:
    - source: https://www.openssl.org/source/{{ openssl_tarball }}
    - source_hash: {{ openssl_hash }}
    - user: builder

openssl_extract:
  cmd.run:
    - name: tar xfz ../{{ openssl_tarball }} --strip-components=1
    - cwd: /usr/local/src/openssl-legacy
    - runas: builder
    - require:
        - file: /usr/local/src/{{ openssl_tarball }}
    - creates: /usr/local/src/openssl-legacy/Makefile

#   -------------------------------------------------------------
#   Build
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

openssl_build:
  cmd.script:
    - source: salt://roles/shellserver/userland-software/files/build-openssl-legacy.sh.jinja
    - template: jinja
    - context:
        openssldir: {{ dirs.etc }}/ssl-legacy
        builder_username: builder
    - cwd: /usr/local/src/openssl-legacy
    - runas: builder
    - require:
        - cmd: openssl_extract
    - creates: /usr/local/src/openssl-legacy/libcrypto.so

#   -------------------------------------------------------------
#   Install
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

openssl_install:
  cmd.run:
    - name: make MANDIR=/opt/openssl-legacy/man MANSUFFIX=ssl install
    - cwd: /usr/local/src/openssl-legacy
    - require:
        - cmd: openssl_build
    - creates: /opt/openssl-legacy/bin/openssl
