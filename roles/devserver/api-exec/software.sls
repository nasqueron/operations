#   -------------------------------------------------------------
#   API :: api-exec
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Source code
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/api-exec/src/server.py:
  file.managed:
    - source: salt://roles/devserver/api-exec/files/server.py
    - makedirs: True
    - mode: 755

#   -------------------------------------------------------------
#   Python virtual environment
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/api-exec/venv:
  file.directory:
    - user: deploy

api_exec_virtualenv:
  cmd.run:
    - name: |
        python3 -m venv /srv/api-exec/venv && \
        . /srv/api-exec/venv/bin/activate && \
        pip install Flask PyYAML uwsgi
    - creates: /srv/api-exec/venv/bin/activate
    - runas: deploy
