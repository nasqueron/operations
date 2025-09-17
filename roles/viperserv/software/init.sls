#   -------------------------------------------------------------
#   Salt — Deploy eggdrop park
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-17
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages with context %}

#   -------------------------------------------------------------
#   Software used by Dæghrefn
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

daeghrefn_software:
  pkg.installed:
    - pkgs:
      - tcl-Trf
      - tcludp
      - {{ packages['youtube-dl'] }}

# Dæghrefn also need php, ps, grep
# Gerrit code needs ssh, ssh-agent and ssh-add

#   -------------------------------------------------------------
#   Software used by TC2
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# TC2 needs logins, pw, mkdir, chown, hostname, id, sockstat, su, cat
#                   /usr/local/etc/rc.d/nginx, /usr/local/etc/rc.d/php-fpm,
#                   /usr/local/etc/rc.d/jenkins
# Those are expected to be on the system administrated.

#   -------------------------------------------------------------
#   Software used by vendor scripts
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# bseen requires cp
