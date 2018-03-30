#   -------------------------------------------------------------
#   Salt — FreeBSD repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "roles/freebsd-repo/map.jinja" import repo with context %}

#   -------------------------------------------------------------
#   Create key directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ repo.signing_key_dir }}:
  file.directory:
    - makedirs: True
    - user: builder

#   -------------------------------------------------------------
#   Generate a public/private key pair
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

signing_key_generate_private:
  cmd.run:
    - name: openssl genrsa -out repo.key 4096
    - cwd: {{ repo.signing_key_dir }}
    - creates: {{ repo.signing_key_dir }}/repo.key
    - runas: builder

signing_key_generate_public:
  cmd.run:
    - name: openssl rsa -in repo.key -out repo.pub -pubout
    - cwd: {{ repo.signing_key_dir }}
    - creates: {{ repo.signing_key_dir }}/repo.pub
    - runas: builder

{{ repo.signing_key_dir }}/repo.key:
  file.managed:
    - replace: False
    - mode: 0400
    - user: builder
