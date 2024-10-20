#   -------------------------------------------------------------
#   Salt — Provision ViMbAdmin Config
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set db = pillar["vimbadmin_config"]["db"] %}
{% set securityCredentials = pillar["vimbadmin_config"]["security"] %}
{% from "map.jinja" import packages_prefixes with context %}

mailbox:
  group.present:
    - gid: 6000
    - system: True

mailbox_mail_user:
  user.present:
    - name: mailbox
    - uid: 6000
    - gid: 6000
    - system: True
    - home: /var/run/web/mailbox_mail_user

vimbadmin_install_packages:
  pkg.installed:
    - pkgs:
      - {{ packages_prefixes.pecl }}memcache
      - {{ packages_prefixes.php }}pear-Services_JSON
      - {{ packages_prefixes.php }}pdo_pgsql
      - {{ packages_prefixes.php }}gettext
      - {{ packages_prefixes.php }}xml

/var/mail/_archive:
  file.directory:
    - user: 6000
    - group: 6000
    - mode: 700
    - makedirs: True

/var/mail/_virtual:
  file.directory:
    - user: 6000
    - group: 6000
    - mode: 700
    - makedirs: True

/var/vimbadmin:
  file.directory:
    - user: web-org-nasqueron-mail-admin
    - group: web
    - mode: 710
    - makedirs: True

{% for subdir in ['cache', 'log', 'session', 'template_c', 'tmp/captchas'] %}

/var/vimbadmin/{{ subdir }}:
  file.directory:
    - user: web-org-nasqueron-mail-admin
    - group: web
    - mode: 710
    - makedirs: True

{% endfor %}

/var/wwwroot/nasqueron.org/admin.mail/application/configs/application.ini:
  file.managed:
    - source: salt://roles/mailserver/vimbadmin/files/application.ini
    - mode: 400
    - user: web-org-nasqueron-mail-admin
    - template: jinja
    - context:
        db:
          database: {{ db["database"] }}
          username: {{ salt["credentials.get_username"](db["credential"]) }}
          password: {{ salt["credentials.get_password"](db["credential"]) }}
          host: {{ pillar["nasqueron_services"][db["service"]] }}
        defaultDomain: "@nasqueron.org"
        dirs: {{ dirs }}
        dir_app_var: /var/vimbadmin/
        identity:
          autobot:
            name: "ViMbAdmin Autobot"
            email: "autobot@nasqueron.org"
          email: "support@nasqueron.org"
          mailer:
            name: "ViMbAdmin Autobot"
            email: "do-not-reply@nasqueron.org"
          name: "Nasqueron Operations SIG"
          orgname: "Nasqueron"
          sitename: "ViMbAdmin"
          siteurl: "https://admin.mail.nasqueron.org"
        mailbox:
          archive: "/var/mail/_archive"
          dir: "/var/mail/_virtual"
          GID: 6000
          UID: 6000
        security:
          salt: {{ salt["credentials.read_secret"](securityCredentials)["salt"] | yaml_dquote }}
          osRememberMeSalt: {{ salt["credentials.read_secret"](securityCredentials)["osRememberMeSalt"] | yaml_dquote }}
          mailboxSaltPassword: {{ salt["credentials.read_secret"](securityCredentials)["mailboxSaltPassword"] | yaml_dquote }}
