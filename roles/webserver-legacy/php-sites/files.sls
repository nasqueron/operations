#   -------------------------------------------------------------
#   Salt — Provision PHP websites
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Sites content
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for domain, site in pillar['web_php_sites'].items() %}

{% if 'target' in site %}

{{ site['target'] }}:
  file.recurse:
    - source: salt://{{ site['source'] }}
    - exclude_pat: E@.git
    - include_empty: True
    - dir_mode: 711
    - file_mode: keep
    - user: {{ site['user'] }}
    - group: web

{% endif %}

{% endfor %}
