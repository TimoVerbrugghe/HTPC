#!/bin/bash
set -e
SCRIPT_DIR=$(dirname `which $0`)
logfile=$SCRIPT_DIR/addon.log

set -x
printf "Killing Chromium" > $logfile 2>&1
killall chromium || true > $logfile 2>&1

printf "Put Kodi window in the background" > $logfile 2>&1
DISPLAY=:0 wmctrl -r kodi -b add,hidden

printf "Freeze/stop kodi from running" > $logfile 2>&1
killall -STOP kodi.bin

printf "Wait half a second before opening Google Chrome" > $logfile 2>&1
sleep 0.5

printf "Opening Chrome" > $logfile 2>&1
DISPLAY=:0 /usr/bin/chromium https://www.youtube.com/tv/ --kiosk --noerrdialogs > $logfile 2>&1

printf "When Chromium is exited, make sure Chromium is really killed" > $logfile 2>&1
killall chromium || true > $logfile 2>&1

printf "Wait half a second before refocusing Kodi" > $logfile 2>&1
sleep 0.5

printf "Resume kodi" > $logfile 2>&1
killall -CONT kodi.bin

printf "Return focus to kodi after stopping Chrome" > $logfile 2>&1
DISPLAY=:0 wmctrl -r kodi -b remove,hidden
DISPLAY=:0 wmctrl -r kodi -b add,fullscreen
DISPLAY=:0 wmctrl -a kodi

exit 0