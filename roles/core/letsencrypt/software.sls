#   -------------------------------------------------------------
#   Salt — Let's encrypt certificates
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-04-27
#   Description:    Provide a renewal service
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

letsencrypt_software:
  pkg.installed:
    {% if grains['os'] == 'FreeBSD' %}
    - name: py27-certbot
    {% else %}
    - name: certbot
    {% endif %}
