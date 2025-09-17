Nasqueron operations
====================

Welcome to **[rOPS](https://devcentral.nasqueron.org/diffusion/OPS/)**,
the Nasqueron operations repository.

------------
Introduction
------------

This repository contains the configuration of our infrastructure servers,
mostly relying on [Salt](https://docs.saltproject.io/en/latest/contents.html)
for deployment and automation.

Additional utilities for humans and Terraform provisioning are also provided.

Nasqueron infrastructure servers support our community
of creative people, writers, developers and thinkers.

Nasqueron follows the principle of *Infrastructure as Code*
to offer documentation, reproducibility, transparency and
to allow external contributions.

-----------------
Content and scope
-----------------

The repository contains:

 - server configuration
 - deployment information for our applications and services

Combining this repository with NetBox, the goal is to constitute
an exhaustive inventory and source of truth for our infrastructure.

Both Nasqueron servers and side projects we manage are in scope.

For example, the [Eglide](http://www.eglide.org/) service is configured through
`roles/core` (common to every server) and `roles/shellserver` (specific).

---------
Structure
---------

This repository is organized as follows:

### A. Services

Services are organized in roles and units.

* **Roles:** a role is a full high-level service (e.g., mailserver, paas-docker)
* **Units:** a unit is a component to achieve the service's goals
  (e.g., a userland software collection, a nginx server)

Directories follow `roles/<role>/<unit>`.

Those files are known as **states** or **formulas**.
They are generally written in YAML, with Jinja2 templating.

If configuration files for a unit should be stored,
a subfolder `files/` is created at unit level.

The `top.sls` file defines which states are loaded by server,
while the `services.sls` describes service configurations
that aren't server-specific.

The `map.jinja` file is used to provide “Omni-OS” configuration:
as we deploy onto several Linux distributions (Debian, Rocky) and FreeBSD,
we need to provide a way to map packages and directories.

*Note:* If anything escapes to the role and unit logic organization,
like for CVE hotfixes, `hotfixes/` directory is used.

### B. Structured data

Structured data is stored in the  `pillar/` directory.
Those files are known as **pillar**.

This data is structured as we found suitable to express it
cleanly, and queried from states, directly or through functions.

Each pillar .sls file is directly written in YAML.

The `top.sls` file defines which pillar files are loaded by server,
while the `tower.sls` file acts similarly and allows more flexibility.

### C. SaltStack modules

While states offer powerful templating capabilities, they can easily become
too complex to maintain when evolving from declarations to full programs.

For this reason, we use Salt modules to express more complex logic.
Modules are written in Python. The Python functions can directly be called
from states.

The modules are stored in the following directories:

* Execution modules are stored in `_modules/`
* States modules are stored in `_states/`

As any program, modules should be tested. See section E.

### D. UNIX resources assignments

This repository is the source of truth for service accounts, groups and ports:

* UIDs document unique usernames and the UIDs for system accounts
* GIDs document the same information for the groups
* PORTS contain the list of reserved application ports

When a service needs any of those resources, they are assigned in those files.

### E. Tests

Unit and integration tests are stored in `_tests/`

You can test the correctness of several repository aspects:
  - Salt configuration files in `_tests/config/`
  - Salt execution modules in `_tests/modules/`
  - Salt pillar in `_tests/pillar/`
  - Scripts deployed within this repository in `_tests/scripts/`

If you add a new directory, you should add a corresponding entry in `Makefile`.

### F. Resources

Resources used by automated tasks to generate repository files are stored
in `_resources/`, for example, templates for new services.

### G. Utilities

Scripts and other utilities to be run by Nasqueron Operations SIG members
are stored in `utils/`.

----------
Contribute
----------

Contributions are welcome to this repository, especially if you wish to:

 1. improve our infrastructure
 2. install or configure something on a Nasqueron server
 3. install or configure something on a project we manage (like Eglide)
 4. automate deployment of one of your Nasqueron projects

You can follow this [contributor guide](https://agora.nasqueron.org/How%20to%20contribute%20code)
to send a commit for review. This procedure is open to everyone.

Issues can be reported on the [#Servers component](https://devcentral.nasqueron.org/tag/servers/)
on DevCentral, the Nasqueron Phabricator instance.

Documentation about the repository and tips for IDEs are available on Agora:
https://agora.nasqueron.org/Operations_grimoire/Operations_repository

Minimum Salt version: 3006

Support for contributors is provided on Libera #nasqueron-ops.

---------------------
Inclusive terminology
---------------------

The repository uses the following terminology:

  - **Salt primary server**: a server that issues commands to other servers or itself
  - **Node**: a server, baremetal or VM configured by Salt

Nasqueron follows the inclusive language conventions to ensure that our
community is welcoming to everyone.

-------
License
-------

A lot of configuration as code is trivial, and so ineligible for copyright per
[threshold of originality](https://en.wikipedia.org/wiki/Threshold_of_originality)

When this is not the case, the code is licensed under
[BSD-2-Clause](https://opensource.org/licenses/BSD-2-Clause)
if not otherwise specified.
