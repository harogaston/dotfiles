#!/bin/bash

UPDATEURL="https://freedns.afraid.org/dynamic/update.php?TmRuRlhNZHFPVlU4dDNUallZYzlUb3NVOjE3OTc1MTQ3"
DOMAIN="harogaston.mooo.com"

registered=$(echo `drill harogaston.mooo.com | grep harogaston` | sed -r 's/.*\ ([0-9+|\.]{4})/\1/')

current=$(wget -q -O - http://checkip.dyndns.org|sed s/[^0-9.]//g)

#echo "Registered: $registered"
#echo "Current: $current"

[ "$registered" != "$current" ] && {
	wget -q -O /dev/null $UPDATEURL
	echo "IP Actualizada"
}
