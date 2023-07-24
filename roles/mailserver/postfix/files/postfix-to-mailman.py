#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Mailman transport for postfix
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Source:         postfix-to-mailman-2.1.py
#   Description:    Interface mailman to a postfix with a mailman transport.
#                   Does not require the creation of _any_ aliases to connect
#                   lists to the mail system.
#   License:        GPLv2
#   Authors:        Original script for qmail by Bruce Perens, March 1999
#
#                   Dax Kelson, dkelson@gurulabs.com, Sept 2002.
#                   Converted from qmail to postfix interface
#
#                   Jan 2003: Fixes for Mailman 2.1
#                   Thanks to Simen E. Sandberg <senilix@gallerbyen.net>
#
#                   Feb 2003: Change the suggested postfix transport to support VERP
#                   Thanks to Henrique de Moraes Holschuh <henrique.holschuh@ima.sp.gov.br>
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   README
#
#   It catches all mail to a virtual domain, eg "lists.example.com".
#   It looks at the  recipient for each mail message and decides if the mail is
#   addressed to a valid list or not, and bounces the message with a helpful
#   suggestion if it's not addressed to a list. It decides if it is a posting,
#   a list command, or mail to the list administrator, by checking for the
#   -admin, -owner, and -request addresses. It will recognize a list as soon
#   as the list is created, there is no need to add _any_ aliases for any list.
#   It recognizes mail to postmaster, mailman-owner, abuse, mailer-daemon, root,
#   and owner, and routes those mails to MailmanOwner as defined in the
#   configuration variables, above.
#   -------------------------------------------------------------


import os
import sys
import re
import string


#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# Mailman home directory.
MailmanHome = "/usr/local/mailman"

# Postmaster and abuse mail recipient.
MailmanOwner = "{{ mailmanAbuse }}"

# Where mailman scripts reside
MailmanScripts = "/usr/local/mailman"


#   -------------------------------------------------------------
#   Postfix / mailman transport methods
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def main():
    os.nice(5)  # Handle mailing lists at non-interactive priority.
    # delete this if you wish

    os.chdir(MailmanHome + "/lists")

    try:
        local = sys.argv[2]
    except IndexError:
        # This might happen if we're not using Postfix
        sys.stderr.write("LOCAL not set?\n")
        sys.exit(1)

    local = string.lower(local)
    local = re.sub("^mailman-", "", local)

    names = ("root", "postmaster", "mailer-daemon", "mailman-owner", "owner", "abuse")
    for name in names:
        if name == local:
            os.execv("/usr/sbin/sendmail", ("/usr/sbin/sendmail", MailmanOwner))
            sys.exit(0)

    type = "post"
    types = (
        ("-admin$", "admin"),
        ("-owner$", "owner"),
        ("-request$", "request"),
        ("-bounces$", "bounces"),
        ("-confirm$", "confirm"),
        ("-join$", "join"),
        ("-leave$", "leave"),
        ("-subscribe$", "subscribe"),
        ("-unsubscribe$", "unsubscribe"),
    )

    for i in types:
        if re.search(i[0], local):
            type = i[1]
            local = re.sub(i[0], "", local)

    if os.path.exists(local):
        os.execv(
            MailmanScripts + "/mail/mailman",
            (MailmanScripts + "/mail/mailman", type, local),
        )
    else:
        bounce()
    sys.exit(75)


def bounce():
    bounce_message = """\
TO ACCESS THE MAILING LIST SYSTEM: Start your web browser on
http://%s/
That web page will help you subscribe or unsubscribe, and will
give you directions on how to post to each mailing list.\n"""
    sys.stderr.write(bounce_message % (sys.argv[1]))
    sys.exit(1)


try:
    sys.exit(main())
except SystemExit as argument:
    sys.exit(argument)

except Exception as argument:
    info = sys.exc_info()
    trace = info[2]
    sys.stderr.write("%s %s\n" % (sys.exc_info()[0], argument))
    sys.stderr.write("Line %d\n" % (trace.tb_lineno))
    sys.exit(75)  # Soft failure, try again later.
