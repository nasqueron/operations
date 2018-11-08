#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Staging :: write a commit message for submodule update
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-10-27
#   License:        Trivial work, not eligible to copyright
#
#   Thanks to joki for the git diff-files and ls-tree hint
#   https://stackoverflow.com/a/52908906/1930997
#   -------------------------------------------------------------


from git import Repo
from os import path
import re
import subprocess

class SubmoduleCommit:

    def __init__(self, repo_path, submodule_path):
        self.repo_path = repo_path
        self.submodule_path = submodule_path
        self.repo = Repo(self.submodule_path)

    def craft_commit(self):
        lines = []

        old_hash = self.get_old_hash()
        new_hash = self.get_new_hash()

        lines.append("Bump " + path.basename(self.submodule_path)
                     + " to " + new_hash[:12])
        lines.append("")
        lines.extend(self.get_commits_lines(old_hash, new_hash))

        return "\n".join(lines)

    def get_old_hash(self):
        output = subprocess.check_output(['git', 'ls-tree',
                                          '@', self.submodule_path],
                                         cwd=self.repo_path,
                                         encoding="utf-8")
        matches = re.search('.*commit ([a-f0-9]*).*', output.strip())
        return matches.group(1)

    def get_new_hash(self):
        return str(self.repo.head.commit)

    @staticmethod
    def format_commit_line(commit):
        commit_hash = str(commit)[:12]
        title = commit.message.split("\n")[0]

        return "    * {} {}".format(commit_hash, title)

    def get_commits_lines(self, hash_base, hash_head):
        commits_lines = []

        for commit in self.repo.iter_commits(hash_head):
            if str(commit) == hash_base:
                break

            line = self.format_commit_line(commit)
            commits_lines.append(line)

        return commits_lines

    def has_submodule_been_updated(self):
        process = subprocess.run(['git', 'diff-files', '--quiet',
                                  self.submodule_path],
                                 cwd=self.repo_path)
        return process.returncode != 0


def run(repo_path):
    repo = Repo(repo_path)

    submodules = [SubmoduleCommit(repo_path, submodule.name)
                  for submodule in repo.submodules]

    commits = [submodule.craft_commit()
               for submodule in submodules
               if submodule.has_submodule_been_updated()]

    print("\n\n".join(commits))


def determine_current_repo():
    return Repo('.', search_parent_directories=True).working_tree_dir


if __name__ == "__main__":
    current_repo_path = determine_current_repo()
    run(current_repo_path)
