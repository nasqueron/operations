#!/bin/sh

#   -------------------------------------------------------------
#   Bootstrap script — FreeBSD
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Install Salt and try to connect to Complector
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

if [ "$(id -u)" -ne 0 ]; then
    echo "This command must be run as root." >&2
    exit 1
fi

#   -------------------------------------------------------------
#   Hello
#   ASCII art by Jason Balthis
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

printf "\n";
printf "\033[1;34m----------------------------------------------------------------------- \033[m\n";
printf "\033[31;1m                                                 ,        , \033[m\n";
printf "\033[31;1m                                                /(        )\` \033[m\n";
printf "\033[1;32m    FFFFFFF \033[31;1m                                    \ \___   / | \033[m\n";
printf "\033[1;32m    FF \033[31;1m                                         /- _  \`-/  \' \033[m\n";
printf "\033[1;32m    FF \033[31;1m                                        (/\/ \ \   /\ \033[m\n";
printf "\033[1;32m    FFFFF RR RRR  EEEEE   EEEEE \033[31;1m               / /   | \`    \ \033[m\n";
printf "\033[1;32m    FF    RRR    EE   EE EE   EE \033[31;1m              O O   ) /    | \033[m\n";
printf "\033[1;32m    FF    RR     EEEEEEE EEEEEEE \033[31;1m              \`-^--\'\`<    \' \033[m\n";
printf "\033[1;32m    FF    RR     EE      EE \033[31;1m                 (_.)  _  )   / \033[m\n";
printf "\033[1;32m    FF    RR      EEEEEE  EEEEEE \033[31;1m             \`.___/\`   / \033[m\n";
printf "\033[31;1m                                                \`-----/ \033[m\n";
printf "\033[1;32m    BBBBBB     SSSSS    DDDDDD \033[31;1m    <----.     __ / __   \ \033[m\n";
printf "\033[1;32m    BB   BB   SS   SS   DD   DD \033[31;1m   <----|====O)))==) \) /==== \033[m\n";
printf "\033[1;32m    BB   BB   SS        DD   DD \033[31;1m   <----\'    \`--\' \`.__,\' \ \033[m\n";
printf "\033[1;32m    BBBBBB     SSSSS    DD   DD \033[31;1m                |        | \033[m\n";
printf "\033[1;32m    BB   BB        SS   DD   DD \033[31;1m                 \       / \033[m\n";
printf "\033[1;32m    BB   BB   SS   SS   DD   DD \033[31;1m           ______( (_  / \______ \033[m\n";
printf "\033[1;32m    BBBBBB     SSSSS    DDDDDD \033[31;1m          ,\'  ,-----\'   |        \ \033[m\n";
printf "\033[31;1m                                         \`--{__________)        \/ \033[m\n\n";
printf "\033[1;34m--------------------------------------------------------------------- \033[m\n";
printf "\033[1;32m     Welcome to your new Nasqueron server, powered by \033[31;1mFreeBSD \033[m\n";
printf "\033[33;1m     Connecting the server to \033[31;1mComplector\033[m \033[33;1mto join the forest.\033[m\n";
printf "\033[1;34m--------------------------------------------------------------------- \033[m\n";
echo ""

#   -------------------------------------------------------------
#   Software installation
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pkg update && pkg upgrade
pkg install git tmux nano py311-salt py311-cryptography

#   -------------------------------------------------------------
#   Minimal salt configuration for this node
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

hostname -s > /usr/local/etc/salt/minion_id

echo "172.27.27.7 complector complector.nasqueron.drake" >> /etc/hosts

echo "master: complector.nasqueron.drake" > /usr/local/etc/salt/minion
echo "master_finger: 'ec:b8:cf:8d:be:7a:eb:3c:43:8d:3b:38:3f:0e:bb:47:f6:eb:a3:89:92:3d:b4:b1:8f:19:48:1f:d2:8f:c9:60'" >> /usr/local/etc/salt/minion

ifconfig | grep -q "inet 172.27.27." || echo "You need to configure an IP in 172.27.27.0/24" >&2
ifconfig | grep -q "inet 172.27.27." && /usr/local/etc/rc.d/salt_minion onestart || (salt --versions && echo "Failure log available at /var/log/salt/minion")
