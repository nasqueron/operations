# Webserver content

## Goal of this role

This role provisions the `/var/wwwroot` folder with the website content,
when there is a custom logic to prepare it, like a specific Git repository
to clone, or a build process to follow.

These roles do NOT describe web server configuration,
which is done in other `webserver-` roles.

## Structure

This role doesn't follow the role/unit folder hierarchy.

Instead, it follows a tld/domain/subdomain.sls logic.

For example, the folder for the `*.acme.tld` sites will be `tld/acme`.
This structure goal is to play nice with the Salt include syntax, as dots
are a directory separator.

The bipbip.acme.tld site will be described in `tld/acme/bipbip.sls` file.

The _generic folder offers common solutions to generic problems
like provision a .env file with database credentials or secret key.

## Add a new domain

  1. Create a new folder hierarchy for the domain
  2. Include a `init.sls` file for your subdomains
  3. Declare the new domain in pillar/webserver

For example, the tld/acme/init.sls file could be:
```
include:
  - .www
  - .acme
```

Alphabetical order is followed, but www is generally first.

In the pillar file, a website is assigned to a role.

If you wish to deploy all the sites in one role, you can directly include
the folder, and your init.sls will do the rest.

If not, you can list the path to the subdomain file, without the .sls extension.

For example, to deploy bipbip.acme.tld (`tld/acme/bipbip.sls`) on servers
with the shellserver role:

```
shellserver:
  - .tld/acme/bibpip
```

## Prune old files

If you need to prune a former website, you can add
the directory to the /hotfixes/old-directories.sls state.

There is no need to revert your commit when the
directories or files are deleted.
