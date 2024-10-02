#!py

#   -------------------------------------------------------------
#   Poudriere :: Jails
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Data helper methods
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def get_kernel_version():
    # "14.1-RELEASE-p5" -> "14.1-RELEASE"
    return "-".join(__grains__["kernelrelease"].split("-")[0:2])


#   -------------------------------------------------------------
#   Configuration provider
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def provide_port_state(name, path):
    name = name.replace("-", "_")

    return "poudriere_ports_" + name, {
        "cmd.run": [
            {"name": f"poudriere ports -c -m null -M {path} -p {name}"},
            {"creates": f"/usr/local/etc/poudriere.d/ports/{name}"},
        ]
    }


def provide_port_states():
    ports = __pillar__.get("poudriere", {}).get("ports", {})

    return dict([provide_port_state(name, path) for name, path in ports.items()])


def run():
    major = __grains__["osmajorrelease"]
    version = get_kernel_version()
    arch = __grains__["cpuarch"]

    # Base jail and ports tree
    states = {
        "poudriere_jails_base": {
            "cmd.run": [
                {"name": f"poudriere jail -c -j base{major} -v {version} -a {arch}"},
                {"creates": f"/usr/local/poudriere/jails/base{major}"},
            ]
        },

        "poudriere_ports_default": {
            "cmd.run": [
                {"name": "poudriere ports -c -m git+https -B main"},
                {"creates": "/usr/local/poudriere/ports/default"},
            ]
        },
    }

    # Additional block according pillar
    states.update(provide_port_states())

    return states
