all: generate-webcontent-index

generate-webcontent-index:
	tmpfile=`mktemp /tmp/make-rOPS-generate-webcontent-index.XXXXXX` ; \
	utils/generate-webcontent-index.py > "$$tmpfile" ;\
	mv "$$tmpfile" roles/webserver-content/init.sls
