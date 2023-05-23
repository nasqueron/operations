#   -------------------------------------------------------------
#   Salt — Tomcat execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Tomcat users and roles
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def extract_roles_from_users(users):
    return set(
        role for _, args in users.items() if "roles" in args for role in args["roles"]
    )
