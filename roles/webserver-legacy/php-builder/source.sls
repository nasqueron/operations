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


def get_custom_builds():
    return __pillar__.get("php_custom_builds", {})


def get_release_builds():
    return {
        name: build
        for (name, build) in get_custom_builds().items()
        if build["mode"] == "release"
    }


def get_release_versions():
    versions = [
        (build["version"], build["hash"]) for build in get_release_builds().values()
    ]

    return set(versions)


def get_archive_path(version):
    return "/opt/php/_archives/php-" + version + ".tar.bz2"


def get_build_directories():
    return [get_build_directory(build) for build in get_custom_builds()]


def get_build_directory(build):
    return "/opt/php/_builds/" + build


def get_install_directory(build):
    return "/opt/php/" + build


def get_extract_archive_command(archive, directory):
    return "tar xjf " + archive + " --strip-components=1 -C " + directory


#   -------------------------------------------------------------
#   ./configure
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_configure(version, build):
    if version.startswith("5.6"):
        cmd = (
            "./configure --prefix=/opt/php/{target} --disable-cgi "
            "--enable-fpm --with-fpm-user=app --with-fpm-group=app "
            "--enable-mysqlnd --enable-bcmath --with-bz2 --enable-calendar "
            "--with-curl --with-gd --with-jpeg-dir --enable-gd-native-ttf "
            "--enable-mbstring --with-mcrypt --with-mysqli --with-pdo-mysql "
            "--enable-pcntl --with-xsl --with-readline "
            "--with-openssl=/opt/openssl-legacy "
            "--with-zlib --enable-zip"
        )

        return cmd.format(target=build)

    raise Exception("Unknown ./configure for PHP v" + version)


#   -------------------------------------------------------------
#   Configuration provider
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run():
    config = {}

    builder_user = "builder"
    build_directories = get_build_directories()
    directories_to_create = ["/opt/php", "/opt/php/_archives", "/opt/php/_builds"]

    # Task: create directories
    directories_to_create.extend(build_directories)
    for directory in directories_to_create:
        config[directory] = {"file.directory": [{"user": builder_user}]}

    # Task: fetch archives
    for version, archive_hash in get_release_versions():
        archive = get_archive_path(version)
        url = "https://www.php.net/distributions/php-" + version + ".tar.bz2"

        config[archive] = {
            "file.managed": [
                {"source": url},
                {"source_hash": archive_hash},
                {"user": builder_user},
            ]
        }

    # Task: extract archives to build directories
    for build_name, build in get_release_builds().items():
        archive = get_archive_path(build["version"])
        directory = get_build_directory(build_name)
        command = get_extract_archive_command(archive, directory)

        config["php_build_" + build_name + "_phase1_extract"] = {
            "cmd.run": [
                {"name": command},
                {"runas": builder_user},
                {"creates": directory + "/configure.in"},
            ]
        }

        if build["version"] < "7":
            # New versions of Onigurama requires a patch not merged in 5.6.38
            # See https://bugs.php.net/bug.php?id=76113
            config["php_build_" + build_name + "_phase1_patch"] = {
                "file.patch": [
                    {"name": directory + "/ext/mbstring/php_mbregex.c"},
                    {
                        "source": "salt://roles/webserver-legacy/php-builder/files/fix-bug-76113.patch"
                    },
                ]
            }

    # Task: build PHP
    # Task: install PHP
    for build_name, build in get_custom_builds().items():
        build_directory = get_build_directory(build_name)
        install_directory = get_install_directory(build_name)

        config["php_build_" + build_name + "_phase2_compile"] = {
            "cmd.run": [
                {
                    "names": [
                        get_configure(build["version"], build_name),
                        "make",
                        "touch .built",
                    ]
                },
                {"cwd": build_directory},
                {"runas": builder_user},
                {"creates": build_directory + "/.built"},
            ]
        }

        config["php_build_" + build_name + "_phase2_install"] = {
            "cmd.run": [
                {"name": "make install"},
                {"cwd": build_directory},
                {"creates": install_directory + "/bin/php"},
            ]
        }

    return config
