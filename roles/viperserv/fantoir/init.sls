#   -------------------------------------------------------------
#   Salt — Deploy eggdrop park
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-14
#   License:        Trivial work, not eligible to copyright
#   Data license:   FANTOIR is licensed under Licence Ouverte
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Data directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/viperserv/data:
  file.directory:
    - user: viperserv
    - group: nasqueron-irc
    - dir_mode: 770

/srv/viperserv/data/dist:
  file.directory:
    - user: viperserv
    - group: nasqueron-irc
    - dir_mode: 770

#   -------------------------------------------------------------
#   Fetch and extract data
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/viperserv/data/dist/fantoir.zip:
  file.managed:
    - source: {{ pillar['fantoir']['dataset_url'] }}
    - source_hash: {{ pillar['fantoir']['dataset_hash'] }}
    - user: viperserv
    - group: nasqueron-irc

viperserv_fantoir_archive:
  archive.extracted:
    - name: /srv/viperserv/data
    - source: /srv/viperserv/data/dist/fantoir.zip
    - enforce_toplevel: False
    - user: viperserv
    - group: nasqueron-irc
    - require:
        - file: /srv/viperserv/data/dist/fantoir.zip

/srv/viperserv/data/FANTOIR.txt:
  file.symlink:
    - target: /srv/viperserv/data/{{ pillar['fantoir']['distname'] }}
    - user: viperserv
    - group: nasqueron-irc
    - require:
        - archive: viperserv_fantoir_archive

#   -------------------------------------------------------------
#   Street data
#
#   If the 109th character is "1", this is a 'voie'.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

viperserv_fantoir_streets:
  cmd.script:
    - source: salt://roles/viperserv/fantoir/files/extract_streets.py
    - args: FANTOIR.txt FANTOIR_STREETS.txt
    - cwd: /srv/viperserv/data/
    - creates: /srv/viperserv/data/FANTOIR_STREETS.txt
    - runas: viperserv
    - require:
        - file: /srv/viperserv/data/FANTOIR.txt
