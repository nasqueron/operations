#   -------------------------------------------------------------
#   Salt - Operations repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Allow to generate repository or API content
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

HOST_NAME != hostname -s
HOST_DOMAIN != hostname -d
API_DIR=/var/wwwroot/$(HOST_DOMAIN)/$(HOST_NAME)/datasources/infra

RM=rm -f
MKDIR=mkdir -p
MV=mv
SALT=salt
TF=terraform

#   -------------------------------------------------------------
#   Main targets
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

_default: repo

all: repo api

clean: clean-repo clean-api

test:
	(cd _tests && make)

#   -------------------------------------------------------------
#   Build targets - repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

repo: .git/hooks/pre-commit

.git/hooks/pre-commit:
	pre-commit install

clean-repo:
	${RM} .git/hooks/pre-commit

#   -------------------------------------------------------------
#   Build targets - API
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

api: $(API_DIR)/all-states.json

$(API_DIR)/all-states.json:
	${MKDIR} ${API_DIR}
	utils/show-local-states.py > ${API_DIR}/all-states.json

clean-api:
	${RM} ${API_DIR}/all-states.json

#   -------------------------------------------------------------
#   Deployment targets
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

deploy-secrets:
	(cd terraform/openbao && ${TF} init && ${TF} apply)
	${SALT} windriver state.sls_id /usr/local/etc/secrets/rhyne-wyse.yaml roles/reports/rhyne-wyse/config
	${SALT} windriver state.sls_id /srv/viperserv/.credentials roles/viperserv/eggdrop/config
	${SALT} -G 'roles:router' state.sls_id /usr/local/etc/secrets/carp-secretsmith.yaml roles/router/carp
