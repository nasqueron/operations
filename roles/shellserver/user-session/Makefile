PREFIX=/usr/local
INSTALL=install
INSTALL_DATA=${INSTALL} -m 0644

install:
	${INSTALL_DATA} files/csh.logout /etc/
	${INSTALL} files/whom.sh ${PREFIX}/bin/whom
	${INSTALL} files/whom-diff.sh ${PREFIX}/bin/whom-diff
