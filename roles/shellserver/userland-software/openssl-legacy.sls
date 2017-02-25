#   -------------------------------------------------------------
#   Salt — Deploy legacy OpenSSL 1.0
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2017-02-25
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Source code
#   -------------------------------------------------------------

openssl_src:
  file.directory:
    - name: /usr/local/src/openssl-legacy
    - user: builder
    - group: deployment
    - dir_mode: 755
  cmd.run:
    - name: curl ftp://openssl.org/source/openssl-1.0.2k.tar.gz | tar xz --strip-components=1
    - cwd: /usr/local/src/openssl-legacy
    - runas: builder
    - require:
        - file: openssl_src
    - unless: test -f /usr/local/src/openssl-legacy/Makefile

#   -------------------------------------------------------------
#   Build
#   -------------------------------------------------------------

openssl_build:
  cmd.run:
    - name: |
        ./config --prefix=/opt/openssl-legacy --openssldir=/etc/ssl-legacy shared zlib-dynamic
        make depend
        make
    - cwd: /usr/local/src/openssl-legacy
    - runas: builder
    - require:
        - file: openssl_src
    - unless: test -f /usr/local/src/openssl-legacy/libcrypto.so

#   -------------------------------------------------------------
#   Install
#   -------------------------------------------------------------

openssl_install:
  cmd.run:
    - name: make MANDIR=/opt/openssl-legacy/man MANSUFFIX=ssl install
    - cwd: /usr/local/src/openssl-legacy
    - require:
        - cmd: openssl_build
    - unless: test -f /opt/openssl-legacy/bin/openssl
