#   -------------------------------------------------------------
#   Salt — Hotfixes to mitigate bugs and security issues
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .salt
  - .CVE-2017-6074
  - .T1261-srv-data
  - .T1345-drop-jails-from-ysul
  - .MariaDB
  - .leap-seconds
  - .portsnap
  - .python3
  - .old-directories
  - .tmux
