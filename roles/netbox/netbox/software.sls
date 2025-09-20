#   -------------------------------------------------------------
#   Netbox
#   -------------------------------------------------------------
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   NetBox
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/netbox:
  file.directory:
    - mode: 755
    - makedirs: True

install_netbox:
  archive.extracted:
    - name: /srv/netbox/netbox
    - source: https://github.com/netbox-community/netbox/archive/refs/tags/v3.7.1.tar.gz
    - source_hash: 97ea9106b6d29e2568c4e9c395013ca015ba7521029e8c907b6aa515dd62649a
    - enforce_toplevel: False
    - options: --strip-components=1

#   -------------------------------------------------------------
#   User account
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

netbox_group:
  group.present:
    - name: netbox
    - gid: 1001

netbox_user:
  user.present:
    - name: netbox
    - uid: 1001
    - gid: 1001

#   -------------------------------------------------------------
#   Python environment
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/netbox/venv:
  file.directory:
    - user: netbox
    - group: netbox
    - mode: 755

netbox_python_venv:
  cmd.run:
    - name: |
        python3 -m venv /srv/netbox/venv
        . /srv/netbox/venv/bin/activate
        pip install psycopg-c psycopg-pool psycopg
        pip install $(grep -v psycopg /srv/netbox/netbox/requirements.txt)
    - creates: /srv/netbox/venv/pyvenv.cfg
    - runas: netbox

#   -------------------------------------------------------------
#   Documentation
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/netbox/netbox/netbox/project-static/docs:
  file.directory:
    - user: netbox
    - group: netbox
    - mode: 755

netbox_build_documentation:
  cmd.run:
    - name: |
        . /srv/netbox/venv/bin/activate
        mkdocs build
    - creates: /srv/netbox/netbox/netbox/project-static/docs/assets
    - runas: netbox
    - cwd: /srv/netbox/netbox

#   -------------------------------------------------------------
#   Static assets
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/netbox/netbox/netbox/static:
  file.directory:
    - user: netbox
    - group: netbox
    - mode: 755

netbox_build_static:
  cmd.run:
    - name: |
        . /srv/netbox/venv/bin/activate
        python3 manage.py collectstatic
    - creates: /srv/netbox/netbox/netbox/static/netbox.js
    - runas: netbox
    - cwd: /srv/netbox/netbox/netbox
