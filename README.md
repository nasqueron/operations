Nasqueron operations
====================

Welcome to **[rOPS](https://devcentral.nasqueron.org/diffusion/OPS/)**, the Nasqueron operations repository.

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

We mainly rely on [SaltStack](https://docs.saltstack.com/en/latest/contents.html)
for deployment and automation.

Scope
-----

New services on our Docker engine (currently Dwellers) should be
deployed through this repository.

The [Eglide](http://www.eglide.org/) service is fully managed
through this repository.

Legacy services are in migration.

Structure
---------

Services are organized in roles and units.

* Roles: a role is a goal a service accomplishes (e.g. mailserver, paas-docker)
* Units: an unit is a component needed to achieve this goal
  (e.g. an userland software collection, a nginx server)

Directories follow `roles/<role>/<unit>`.

If configuration files for an unit should be stored,
a subfolder `files` is created at unit level.

The `pillar/ ` folder contains data about Eglide users,

The repository contains a legacy scripts folder, not handled by Salt,
and a config/forum for one set of our Discourse configuration.
They can be migrated to the role/unit structure.

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

Support for contributors is provided on Freenode #nasqueron-ops.

License
-------

A lot of configuration as code is trivial, and so ineligible for copyright per
[threshold of originality](https://en.wikipedia.org/wiki/Threshold_of_originality)

When this is not the case, the code is licensed under
[BSD-2-Clause](https://opensource.org/licenses/BSD-2-Clause)
if not otherwise specified.

