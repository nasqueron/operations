#!/usr/bin/env python3


import json
import sys


POLL_TIME = 3600000


#   -------------------------------------------------------------
#   Configuration methods
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def generate_config(account, repositories):
    repos = [get_repo_config(account, repo) for repo in repositories]

    return {
        "max-concurrent-indexers": 2,
        "dbpath": "data",
        "title": f"{account} code search".title(),
        "health-check-uri": "/healthz",
        "repos": dict(repos),
    }


def get_repo_config(account, repo):
    return repo[0], {
        "url": f"https://www.github.com/{account}/{repo[0]}.git",
        "vcs-config": {
            "ref": repo[1],
        },
        "ms-between-poll": POLL_TIME,
    }


#   -------------------------------------------------------------
#   Application entry point
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def run(account):
    repos = [line.strip().split(",") for line in sys.stdin]

    config = generate_config(account, repos)
    print(json.dumps(config))


if __name__ == "__main__":
    try:
        account = sys.argv[1]
    except IndexError:
        print("Usage:", sys.argv[0], "<GitHub org account>", file=sys.stderr)
        sys.exit(2)

    run(account)
