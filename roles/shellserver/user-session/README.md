This component provides commands and configuration files
used by the users' shells.

[ whom-diff ]

We provide the following files:

* `whom` prints by alphabetical order the list of connected users
* `whom-diff` looks for difference with previous call and prints it
* /etc/csh.logout takes care of cleanup

To enable it, add to ~/.cshrc:

```lang=sh,name=.cshrc
setenv SESSION_ID `whom-diff -s`
alias precmd whom-diff
```
