#   -------------------------------------------------------------
#   Salt — Nasqueron Reports
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/opt/rhyne-wyse:
  file.directory:
    - user: builder
    - group: deployment

#   -------------------------------------------------------------
#   Virtual Environment
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

rhyne_wyse_venv:
  cmd.script:
    - name: salt://roles/reports/rhyne-wyse/files/build.sh
    - runas: builder
    - creates: /opt/rhyne-wyse/venv/bin/activate
