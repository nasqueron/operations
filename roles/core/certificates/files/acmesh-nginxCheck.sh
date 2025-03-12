#!/bin/sh

#   -------------------------------------------------------------
#   Let's encrypt
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/core/certificates/files/acmesh-nginxCheck.sh
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

nginx_test() {
	nginx_output="$(nginx -t 2>&1)"
	nginx_return_code="$?"

	if [ "$nginx_return_code" -eq 0 ] && echo "${nginx_output}" | grep warn >&2; then
		return 2;
	else
		return "$nginx_return_code";
	fi;
}

nginx_test && nginx -s reload
