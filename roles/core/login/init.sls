#   -------------------------------------------------------------
#   Set login capabilities
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-01-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os'] == 'FreeBSD' %}

/etc/login.conf:
  file.managed:
    - source: salt://roles/core/login/files/login.conf
    - mode: 644

compile_login_db:
  cmd.run:
    - name: cap_mkdb /etc/login.conf
    - onchanges:
      - file: /etc/login.conf

{% endif %}

#   -------------------------------------------------------------
#   Locales
#
#   Each system should at least provide en_US.UTF-8.
#
#   Any being is welcome to add any locale in this section.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os_family'] == 'RedHat' %}

locales_packages:
  pkg.installed:
    - pkgs:
      - glibc-langpack-en

{% endif %}
