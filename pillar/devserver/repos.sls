#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

# Supported VCS: git/hg/svn (git by default)

user_repositories:
  dereckson:
    /home/dereckson/dev/dereckson/git-achievements:
      source: git@github.com:dereckson/git-achievements.git

    /home/dereckson/.software/hg-prompt:
      source: https://hg.stevelosh.com/hg-prompt/
      vcs: hg
