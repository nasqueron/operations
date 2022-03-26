#   -------------------------------------------------------------
#   Salt — Provision dotfiles and other personal content
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-08
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% set triplet = salt['rust.get_rustc_triplet']() %}

{% for username, user in salt['forest.get_users']().items() %}
{% set tasks = user.get('devserver_tasks', []) %}

{% if 'deploy_dotfiles' in tasks %}
dotfiles_to_devserver_{{ username }}:
  file.recurse:
    - name: /home/{{ username }}
    - source: salt://roles/devserver/userland-home/files/{{ username }}
    - include_empty: True
    - clean: False
    - user: {{ username }}
    - group: {{ username }}
{% endif %}

{% if 'deploy_nanotab' in tasks %}
/home/{{ username }}/bin/nanotab:
  file.managed:
    - source: salt://roles/devserver/userland-home/files/_tasks/nanotab.sh
    - user: {{ username }}
    - group: {{ username }}
    - mode: 755

/home/{{ username }}/.config/nano/nanorc-tab:
  nano.config_autogenerated:
    - nanorc_dir: {{ dirs.share }}/nano
    - extra_settings:
      - unset tabstospaces
{% endif %}

{% if 'install_rustup' in tasks %}
{% set rustup_path = '/home/' + username + '/.cargo/bin/rustup' %}

devserver_rustup_{{ username }}:
  cmd.run:
    - name: rustup-init -y
    - runas: {{ username }}
    - creates: {{ rustup_path }}

{% for toolchain in ['stable', 'nightly'] %}
devserver_rustup_{{ toolchain }}_{{ username }}:
  cmd.run:
    - name: {{ rustup_path }} install {{ toolchain }}
    - runas: {{ username }}
    - creates: /home/{{ username }}/.rustup/toolchains/{{ toolchain }}-{{ triplet }}
{% endfor %}
{% endif %}

{% if 'install_diesel' in tasks %}
devserver_diesel_{{ username }}:
  cmd.run:
    - name: /home/{{ username }}/.cargo/bin/cargo install diesel_cli --no-default-features --features postgres,sqlite
    - runas: {{ username }}
    - creates: /home/{{ username }}/.cargo/bin/diesel
{% endif %}

{% endfor %}
