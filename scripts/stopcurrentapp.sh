#!/bin/bash
## This script will stop the currently running window/application, except if the application is Kodi. Afterwards, the script will return focus to the Kodi window.

#############
# Variables #
#############
logfile="/home/htpc/logs/stopapp.log"
currentwindowid=$(DISPLAY=:0 xdotool getwindowfocus)
currentwindowname=$(DISPLAY=:0 xdotool getwindowname $currentwindowid)


if [ "$currentwindowname" = "Kodi" ]; then
	printf "Application identified as Kodi\n\n" >> $logfile 2>&1
	exit 0
else
	printf "Closing currently running application\n" >> $logfile 2>&1
	currentwindowpid=$(DISPLAY=:0 xdotool getwindowpid $currentwindowid)
	kill $currentwindowpid > $logfile 2>&1

	printf "Wait half a second before returning to Kodi\n" >> $logfile 2>&1
	sleep 0.5

	printf "Return focus to kodi after stopping Chrome\n\n" >> $logfile 2>&1
	DISPLAY=:0 wmctrl -v -r kodi -b remove,hidden >> $logfile 2>&1
	DISPLAY=:0 wmctrl -v -r kodi -b add,fullscreen >> $logfile 2>&1
	DISPLAY=:0 wmctrl -v -a kodi >> $logfile 2>&1
fi

exit 0