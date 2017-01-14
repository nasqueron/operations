#   -------------------------------------------------------------
#   Salt — Users accounts list
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2016-04-08
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Users accounts
#   -------------------------------------------------------------

shellusers:
  tomjerr:
    fullname: Tommy Aditya
    uid: 2001
  erol:
    fullname: Erol Unutmaz
    uid: 2002
  rashk0:
    fullname: Rashk0
    uid: 2003
  kazuya:
    fullname: Kazuya
    uid: 2004
  amj:
    fullname: Amaury J.
    uid: 2005
  dereckson:
    fullname: Sebastien Santoro
    {% if grains['os'] == 'FreeBSD' %}
    shell: /bin/tcsh
    {% else %}
    shell: /usr/bin/tcsh
    {% endif %}
    uid: 5001
  kalix:
    fullname: Yassine Hadj Messaoud
    uid: 5002
  shark:
    fullname: Shark
    uid: 2006
  rix:
    fullname: Rix
    uid: 2007
  kumkum:
    fullname: Kumkum
    uid: 2008
