#!py

#   -------------------------------------------------------------
#   Salt — Provision PHP websites — php-fpm pools
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Description:    When a site is declared to be served by
#                   an instance, pools from other instances
#                   should be deleted if they exist.
#
#                   That allows to move pools among instances.
#   -------------------------------------------------------------


def get_etc_dir():
    if __grains__['os'] == 'FreeBSD':
        return "/usr/local/etc"

    return "/etc"


def files_to_delete_if_they_exist():
    files = []
    etc_dir = get_etc_dir()
    for instance in __pillar__['php_fpm_instances']:
        files.extend([etc_dir + "/php-fpm.d/" + instance + "-pools/" + site['user'] + ".conf"
                      for _, site in __pillar__['web_php_sites'].items()
                      if site['php-fpm'] != instance])

    return files


def run():
    config = {}

    # Task: delete php-fpm stale files
    for file in files_to_delete_if_they_exist():
        config[file] = {"file.absent": []}

    return config
