#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Salt - Show local states
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Gets the list of states to run from the topfile,
#                   then gets their state data.
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------


import json
import subprocess


#   -------------------------------------------------------------
#   Show state information
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run_salt_command(command, *args):
    full_command = ["salt-call", "--local", "--output=json", command, *args]

    process = subprocess.run(full_command, capture_output=True, check=True)
    return json.loads(process.stdout)


def get_states_from_top():
    return run_salt_command("state.show_top")["local"]["base"]


def get_state(state):
    try:
        return run_salt_command("state.show_sls", state)["local"]
    except subprocess.CalledProcessError:
        return {}


#   -------------------------------------------------------------
#   Application entry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run():
    states = {state: get_state(state) for state in get_states_from_top()}
    print(json.dumps(states))


if __name__ == "__main__":
    run()
