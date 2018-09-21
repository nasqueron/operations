#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-08
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

# Supported VCS: git/hg/svn (git by default)

user_repositories:
  dereckson:
    /home/dereckson/dev/dereckson/git-achievements:
      source: git@github.com:dereckson/git-achievements.git

    /home/dereckson/.software/hg-prompt:
      source: http://bitbucket.org/sjl/hg-prompt/
      vcs: hg
