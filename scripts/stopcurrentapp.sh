#!/bin/bash
## This script will stop the currently running window/application, except if the application is Kodi. Afterwards, the script will return focus to the Kodi window.

#############
# Variables #
#############
logfile=/home/htpc/logs/stopapp.log
currentwindowid=$(DISPLAY=:0 xdotool getwindowfocus)
currentwindowname=$(DISPLAY=:0 xdotool getwindowname $currentwindowid)


if [ "$currentwindowname" = "Kodi" ]; then
	# echo "Success!"
	exit 0
else
	printf "Closing currently running application" > $logfile 2>&1
	currentwindowpid=$(DISPLAY=:0 xdotool getwindowpid $currentwindowid)
	kill $currentwindowpid > $logfile 2>&1

	printf "Wait half a second before returning to Kodi" > $logfile 2>&1
	sleep 0.5

	printf "Resume kodi" > $logfile 2>&1
	killall -CONT kodi.bin

	printf "Return focus to kodi after stopping Chrome" > $logfile 2>&1
	su htpc -c "DISPLAY=:0 wmctrl -r kodi -b remove,hidden"
	su htpc -c "DISPLAY=:0 wmctrl -r kodi -b add,fullscreen"
	su htpc -c "DISPLAY=:0 wmctrl -a kodi"
fi

exit 0