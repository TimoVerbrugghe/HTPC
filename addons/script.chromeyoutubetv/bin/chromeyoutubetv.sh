#!/bin/bash

#############
# Variables #
#############
SCRIPT_DIR=$(dirname `which $0`)
logfile=$SCRIPT_DIR/addon.log

##########
# Script #
##########
printf "Killing Chromium" > $logfile 2>&1
killall chromium || true > $logfile 2>&1

printf "Put Kodi window in the background" > $logfile 2>&1
DISPLAY=:0 wmctrl -r kodi -b add,hidden

printf "Wait half a second before opening Google Chrome" > $logfile 2>&1
sleep 0.5

printf "Opening Chromium" > $logfile 2>&1
DISPLAY=:0 /usr/bin/chromium https://www.youtube.com/tv/ --kiosk --noerrdialogs > $logfile 2>&1

exit 0