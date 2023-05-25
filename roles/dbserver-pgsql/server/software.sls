#!py

#   -------------------------------------------------------------
#   Salt — Database server — PostgreSQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   PostgreSQL server
#
#   Packages to install:
#     - PostgreSQL, excepted on FreeBSD: already done in .build
#     - PostgreSQL contrib, if so configured in pillar
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_packages():
    packages = []
    map_packages = __salt__["jinja.load_map"]("map.jinja", "packages")

    if __grains__["os"] != "FreeBSD":
        packages.append(map_packages["postgresql"])

    if __salt__["pillar.get"]("dbserver_postgresql:server:with_contrib"):
        packages.append(map_packages["postgresql-contrib"])

    return packages


def run():
    packages = get_packages()

    if not packages:
        # FreeBSD server without contrib: no more package to install
        return {}

    return {
        "postgresql_server_software": {
            "pkg.installed": [
                {"pkgs": get_packages()},
            ]
        }
    }
