#!/usr/bin/env bash

#   -------------------------------------------------------------
#   NetBox :: Service starter
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

set -e

SERVICE_ROOT=/srv/netbox
APP_ROOT=$SERVICE_ROOT/netbox

source $SERVICE_ROOT/venv/bin/activate
cd $APP_ROOT/netbox
gunicorn --pid $PID_FILE --pythonpath $APP_ROOT -b "127.0.0.1:$APP_PORT" --config $SERVICE_ROOT/gunicorn.py netbox.wsgi
