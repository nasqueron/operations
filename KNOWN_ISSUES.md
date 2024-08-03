# Known issues

Bugs are documented on **DevCentral**, our Phabricator instance.

Issues specific to the Salt configuration are located at
https://devcentral.nasqueron.org/project/view/67/

More general servers issues are located are
https://devcentral.nasqueron.org/tag/servers/

This file documents the issues where the Salt states are generally correct
but where some situations can be troublesome, with the workaround to apply.

## Role: devserver

### pefs-kmod and FreeBSD major versions upgrade

After a new FreeBSD release, the kernel modules can be compiled
against a version incompatible with the installed kernel.

We hitted twice this issue with pefs-kmod, for FreeBSD 11.1 and 14.0.

**Workaround**

Install pefs-kmod through ports (that requires /usr/src),
load the module, then require the module to be autoloaded
on boot.

```
$ cd /usr/ports/sysutils/pefs-kmod
$ make build deinstall reinstall
$ kldload pefs
$ grep -q pefs_load /boot/loader.conf || cat >> /boot/loader.conf
pefs_load="YES"
```
