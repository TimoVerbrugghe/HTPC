#!/bin/bash

#############
# Variables #
#############
SCRIPT_DIR=$(dirname `which $0`)
logfile=$SCRIPT_DIR/addon.log

##########
# Script #
##########
printf "Killing Parsec" > $logfile 2>&1
killall parsec || true > $logfile 2>&1

printf "Put Kodi window in the background" > $logfile 2>&1
DISPLAY=:0 wmctrl -r kodi -b add,hidden

printf "Wait half a second before opening Parsec" > $logfile 2>&1
sleep 0.5

printf "Opening Parsec" > $logfile 2>&1
DISPLAY=:0 /usr/bin/parsec server_id=116766:client_overlay=0:app_lan_quality=2:app_wan_quality:2 > $logfile 2>&1

exit 0