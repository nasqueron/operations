Nasqueron operations
====================

Welcome to **[rOPS](https://devcentral.nasqueron.org/diffusion/OPS/)**,
the Nasqueron operations repository.

----------

Introduction
------------

Nasqueron infrastructure servers support our budding community
of creative people, writers, developers and thinkers.

Nasqueron follows the principle of "Infrastructure as Code"
to offer documentation, reproducibility, transparency and
to allow external contributions.

It contains:

 - server configuration
 - deployment information for our applications and services

We mainly rely on [Salt](https://docs.saltproject.io/en/latest/contents.html)
for deployment and automation.

Scope
-----

Both Nasqueron servers and side projects we manage are in scope.

For example, the [Eglide](http://www.eglide.org/) service is configured
through roles/core (common to every server) and roles/shellserver (specific).

Structure
---------

A. Services are organized in roles and units.

* Roles: a role is a goal a service accomplishes (e.g. mailserver, paas-docker)
* Units: a unit is a component needed to achieve this goal
  (e.g. an userland software collection, a nginx server)

Directories follow `roles/<role>/<unit>`.

Those files are known a **states**.

If configuration files for a unit should be stored,
a subfolder `files` is created at unit level.

If anything escape to the role and unit logic organization,
like for CVE hotfixes, `hotfixes/` directory is used.

B. Structured data is stored in the  `pillar/` directory.
Those files are known as **pillar**.

This data is structured as we found suitable to express it
cleanly, and queried from states, directly or through functions.

C. States should mostly be easy-to-read templates, without any more
programmation than simple if and for templating logic.

If more is needed, functions are created in Salt custom modules:

* Execution modules are stored in `_modules/`
* States modules are stored in `_states/`

D. This repository is the source of truth for users, groups and ports:

* UIDs document unique usernames and the UIDs for system accounts
* GIDs document the same information for the groups
* PORTS contain the list of reserved application ports

E. Units and integration tests are stored in `_tests/`

F. Resources used by automated tasks are stored in `_resources/`

Contribute
----------

Contributions are welcome to this repository, especially if you wish to:

 1. improve our infrastructure
 2. install or configure something on a Nasqueron server
 3. install or configure something on a project we manage (like Eglide)
 4. help to migrate services to Salt

You can follow this [contributor guide](https://agora.nasqueron.org/How%20to%20contribute%20code)
to send a commit for review. This procedure is open to everyone.

Issues can be reported on the [#Servers component](https://devcentral.nasqueron.org/tag/servers/)
on DevCentral, the Nasqueron Phabricator instance.

Support for contributors is provided on Libera #nasqueron-ops.

Inclusive terminology
---------------------

The repository uses the following terminology:

  - **Salt primary server**: server that issues commands to other servers, including itself
  - **Node**: a server, baremetal or VM configured by Salt

License
-------

A lot of configuration as code is trivial, and so ineligible for copyright per
[threshold of originality](https://en.wikipedia.org/wiki/Threshold_of_originality)

When this is not the case, the code is licensed under
[BSD-2-Clause](https://opensource.org/licenses/BSD-2-Clause)
if not otherwise specified.
