# Usage: add to your .cshrc file the following alias:
# alias precmd 'source ~/bin/update-git-prompt'

setenv GIT_BRANCH_CMD "sh -c 'git branch --no-color 2> /dev/null' | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'"
set prompt="%B%/%b `$GIT_BRANCH_CMD`] "
