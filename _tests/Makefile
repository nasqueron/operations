test: test-python test-roles test-bats

test-python:
	python -m unittest discover modules
	python -m unittest discover pillar
	python -m unittest discover scripts/python

test-bats:
	bats scripts/bats/test_edit_acme_dns_accounts.sh

#   -------------------------------------------------------------
#   Tests for roles
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test-roles: test-roles-dns

test-roles-dns:
	roles/python/dns/run_test_dns_zones.sh

#   -------------------------------------------------------------
#   Configuration test specific to the primary server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test-config:
	cd config/salt-primary && make test
