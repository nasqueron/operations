#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-12-08
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Extra utilities
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/mastodon/extra_utilities:
  file.directory:
    - makedirs: True

/srv/mastodon/extra_utilities/clear-video-queue:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/mastodon/clear-video-queue.py
    - mode: 755

#   -------------------------------------------------------------
#   Provision extra utilities
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for instance in pillar['docker_containers']['mastodon_sidekiq'] %}

provision_clear_video_queue_{{ instance }}:
  cmd.run:
    - name: docker cp /srv/mastodon/extra_utilities/clear-video-queue {{ instance }}:/usr/bin/clear-video-queue
    - require:
        - file: /srv/mastodon/extra_utilities/clear-video-queue

{% endfor %}
