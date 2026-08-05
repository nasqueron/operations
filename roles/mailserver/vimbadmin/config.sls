#   -------------------------------------------------------------
#   Salt — Provision ViMbAdmin Config
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set db = pillar["vimbadmin_config"]["db"] %}
{% set securityCredentials = pillar["vimbadmin_config"]["security"] %}
{% from "map.jinja" import dirs, packages_prefixes with context %}
{% set uids = pillar["uids"] %}
{% set gids = pillar["gids"] %}

mailbox:
  group.present:
    - gid: {{ gids["mailbox"] }}
    - system: True

mailbox_mail_user:
  user.present:
    - name: mailbox
    - uid: {{ uids["mailbox"] }}
    - gid: {{ gids["mailbox"] }}
    - system: True
    - home: /var/run/web/mailbox_mail_user

/var/mail/_archive:
  file.directory:
    - user: {{ uids["mailbox"] }}
    - group: {{ gids["mailbox"] }}
    - mode: 700
    - makedirs: True

/var/mail/_virtual:
  file.directory:
    - user: {{ uids["mailbox"] }}
    - group: {{ gids["mailbox"] }}
    - mode: 700
    - makedirs: True

/var/vimbadmin:
  file.directory:
    - user: web-org-nasqueron-mail-admin
    - group: web
    - mode: 710
    - makedirs: True

{% for subdir in ["cache", "log", "session", "template_c", "tmp/captchas"] %}

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
          GID: {{ gids["mailbox"] }}
          UID: {{ uids["mailbox"] }}
        security:
          salt: {{ salt["credentials.read_secret"](securityCredentials)["salt"] | yaml_dquote }}
          osRememberMeSalt: {{ salt["credentials.read_secret"](securityCredentials)["osRememberMeSalt"] | yaml_dquote }}
          mailboxSaltPassword: {{ salt["credentials.read_secret"](securityCredentials)["mailboxSaltPassword"] | yaml_dquote }}
