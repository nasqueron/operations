#   -------------------------------------------------------------
#   Salt - Operations repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Allow to generate repository content
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

RM=rm -f
MV=mv

#   -------------------------------------------------------------
#   Main targets
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

all: repo

clean: clean-repo

#   -------------------------------------------------------------
#   Build targets - repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

repo: roles/webserver-content/init.sls

roles/webserver-content/init.sls:
	tmpfile=`mktemp /tmp/make-rOPS-generate-webcontent-index.XXXXXX` ; \
	utils/generate-webcontent-index.py > "$$tmpfile" ;\
	${MV} "$$tmpfile" roles/webserver-content/init.sls

clean-repo:
	${RM} roles/webserver-content/init.sls
