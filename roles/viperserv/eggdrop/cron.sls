#!py

#   -------------------------------------------------------------
#   Salt — Deploy eggdrop park
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-11-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Data helper methods
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_etc_dir():
  if __grains__['os'] == 'FreeBSD':
    return "/usr/local/etc"

  return "/etc"


def get_bin_dir():
    if __grains__['os'] == 'FreeBSD':
        return "/usr/local/bin"

    return "/bin"


def get_eggdrops():
    '''Filter eggdrops to select the ones with ensure_is_live: True'''
    return [botname
            for botname, bot
            in __pillar__['viperserv_bots'].items()
            if 'ensure_is_live' in bot and bot['ensure_is_live']]


#   -------------------------------------------------------------
#   Configuration provider
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run():
    script = get_bin_dir() + '/ensure-eggdrops-are-live'

    return {
        get_etc_dir() + '/eggdrops-live.conf': {'file.managed': [
            {'source': 'salt://roles/viperserv/eggdrop/files/eggdrops-live.conf'},
            {'template': 'jinja'},
            {'context': {
                'eggdrops': get_eggdrops()
            }},
        ]},

        script: {'file.managed': [
            {'source': 'salt://roles/viperserv/eggdrop/files/ensure-eggdrops-are-live.sh'},
            {'mode': 755},
        ]},

        'eggdrop_crontab': {'cron.present': [
            {'name': script},
            {'minute': '*/5'},
            {'identifier': 'viperserv.eggdrop'},
        ]}
    }
