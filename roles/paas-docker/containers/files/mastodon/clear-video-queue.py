#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Mastodon - clear stuck video tasks from queue
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-12-08
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/paas-docker/containers/files/mastodon/clear-video-queue.py
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>


import subprocess


PS_COLUMN_PID = 0
PS_COLUMN_TIME = 3
PS_COLUMN_COMMAND = 4

SUSPECT_COMMANDS = ["ffmpeg"]

MAX_TIME = 30


def parse_time(time):
    time_parts = [int(token) for token in time.split(":")]
    return time_parts[0] * 60 + time_parts[1]


def process_time_is_up(time):
    return parse_time(time) > MAX_TIME


def process_is_suspect(command):
    for suspect_command in SUSPECT_COMMANDS:
        if command.startswith(suspect_command):
            return True

    return False


def extract_pid(ps_output_line):
    if not ps_output_line[0].isdigit():
        return None

    tokens = ps_output_line.split(None, 4)
    extracted_pid = int(tokens[PS_COLUMN_PID])
    time = tokens[PS_COLUMN_TIME]
    command = tokens[PS_COLUMN_COMMAND]

    if process_time_is_up(time) and process_is_suspect(command):
        return extracted_pid

    return None


def extract_pids(output):
    extracted_pids = [extract_pid(line) for line in output]

    return [
        extracted_pid for extracted_pid in extracted_pids if extracted_pid is not None
    ]


def get_kill_command(pids_to_kill):
    command = ["kill", "-9 "]
    command.extend([str(pid_to_kill) for pid_to_kill in pids_to_kill])

    return command


if __name__ == "__main__":
    ps_output = subprocess.check_output(["ps", "x"])
    ps_data = [line.strip() for line in ps_output.strip().split("\n")]

    pids = extract_pids(ps_data)
    kill_command = get_kill_command(pids)

    subprocess.call(kill_command)
