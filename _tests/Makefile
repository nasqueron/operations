test: test-python test-bats

test-python:
	python -m unittest discover modules
	python -m unittest discover pillar
	python -m unittest discover scripts/python

test-bats:
	bats scripts/bats/test_edit_acme_dns_accounts.sh
	bats roles/bats/test_webserver_content.sh

#   -------------------------------------------------------------
#   Configuration test specific to the primary server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test-config:
	cd config/salt-primary && make test
