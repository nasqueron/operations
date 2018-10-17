#!py

#   -------------------------------------------------------------
#   Salt — Compile custom PHP builds
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-10-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Builds and versions helper methods
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_release_builds():
    return {name: build
            for (name, build) in __pillar__["php_custom_builds"].items()
            if build["mode"] == "release"}


def get_release_versions():
    versions = [(build['version'], build['hash'])
                for build in get_release_builds().values()]

    return set(versions)


def get_build_directories():
  return ["/opt/php/_builds/" + build['version']
          for build in get_release_builds().values()]


def get_archive_path(version):
    return "/opt/php/_archives/php-" + version + ".tar.bz2"


def get_extract_archive_command(archive, directory):
    return "tar xjf " + archive + " --strip-components=1 -C " + directory


#   -------------------------------------------------------------
#   Configuration provider
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run():
    config = {}

    builder_user = 'builder'
    directories_to_create = ['/opt/php', '/opt/php/_archives', '/opt/php/_builds']

    # Task: create directories
    directories_to_create.extend(get_build_directories())
    for directory in directories_to_create:
        config[directory] = {'file.directory': [{'user': builder_user}]}

    # Task: fetch archives
    # Task: extract archives to build directories
    for version, archive_hash in get_release_versions():
        archive = get_archive_path(version)
        url = "http://fr2.php.net/get/php-" + version + ".tar.bz2/from/this/mirror"
        directory = "/opt/php/_builds/" + version
        command = get_extract_archive_command(archive, directory)

        config[archive] = {'file.managed': [
            {'source': url},
            {'source_hash': archive_hash},
            {'user': builder_user},
        ]}

        config["php_build_" + version] = {'cmd.run': [
            {'name': command},
            {'user': builder_user},
            {'creates': directory + "/configure.in"},
        ]}

    return config
