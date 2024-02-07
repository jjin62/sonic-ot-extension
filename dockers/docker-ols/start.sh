#!/usr/bin/env bash
##start lldpd
CFGGEN_PARAMS=" \
    -d \
    -t /usr/share/sonic/templates/lldpd.conf.j2 \
    -t /usr/share/sonic/templates/lldpdSysDescr.conf.j2 \
"
sonic-cfggen $CFGGEN_PARAMS > /etc/lldpd.conf

#start molex apps
./runapp.sh
