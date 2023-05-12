#!py

#   -------------------------------------------------------------
#   Salt — Provision user content
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------


def get_cron_path(user):
    """Get source cron path in operations repository."""
    return f"roles/devserver/userland-home/files/_crons/{user}"


def has_crontab(user):
    return salt["slsutil.file_exists"](get_cron_path(user))


def build_cron_file(user):
    cron_source_path = get_cron_path(user)

    return {
        "cron.file": [
            {"name": f"salt://{cron_source_path}"},
            {"user": user},
        ]
    }


def run():
    return {
        f"devserver_crontab_{user}": build_cron_file(user)
        for user in salt["forest.get_users"]()
        if has_crontab(user)
    }
