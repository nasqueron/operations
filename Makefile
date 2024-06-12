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

repo: roles/webserver-content/init.sls \
	roles/webserver-core/nginx/files/ocsp-ca-certs.pem \
	.git/hooks/pre-commit

webserver-content-index: clean-webserver-content-index roles/webserver-content/init.sls

roles/webserver-content/init.sls:
	utils/generate-webcontent-index.py > roles/webserver-content/init.sls

roles/webserver-core/nginx/files/ocsp-ca-certs.pem:
	utils/generate-ocsp-bundle.sh > roles/webserver-core/nginx/files/ocsp-ca-certs.pem

.git/hooks/pre-commit:
	pre-commit install

clean-webserver-content-index:
	${RM} roles/webserver-content/init.sls

clean-repo: clean-webserver-content-index
	${RM} .git/hooks/pre-commit
	${RM} roles/webserver-core/nginx/files/ocsp-ca-certs.pem

#   -------------------------------------------------------------
#   Build targets - API
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

api: $(API_DIR)/all-states.json

$(API_DIR)/all-states.json:
	${MKDIR} ${API_DIR}
	utils/show-local-states.py > ${API_DIR}/all-states.json

clean-api:
	${RM} ${API_DIR}/all-states.json
