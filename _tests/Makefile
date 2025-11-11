CURRENT_DIR != pwd
MODULES_DIR = ${CURRENT_DIR}/../_modules

test: test-python test-roles test-bats

test-python: test-modules test-pillar test-python-scripts

test-modules:
	PYTHONPATH="${CURRENT_DIR}:${MODULES_DIR}" python -m unittest discover modules

test-pillar:
	PYTHONPATH="${CURRENT_DIR}" python -m unittest discover pillar

test-python-scripts:
	PYTHONPATH="${CURRENT_DIR}" python -m unittest discover scripts/python

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
