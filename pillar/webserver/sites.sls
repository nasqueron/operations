#   -------------------------------------------------------------
#   Salt — Sites to provision on the legacy web server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Sites deployed through Jenkins CD
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_content_jenkins_cd:
  webserver-legacy:
    - api
    - assets
    - autoconfig
    - docker
    - docs
    - launch
    - www

#   -------------------------------------------------------------
#   Tweaks
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_autochmod:
  - /var/wwwroot/dereckson.be/www
