#   -------------------------------------------------------------
#   Salt — MediaWiki farm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-19
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/var/dataroot:
  file.directory

{% for store in pillar['mediawiki_datastores'] %}

# $wgUploadDirectory
/var/dataroot/{{ store }}/images:
  file.directory:
    - user: mediawiki
    - group: mediawiki
    - makedirs: True

# $wgCacheDirectory
/var/cache/mediawiki/{{ store }}:
  file.directory:
    - user: mediawiki
    - group: mediawiki
    - makedirs: True

{% endfor %}
