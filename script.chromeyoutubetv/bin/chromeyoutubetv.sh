#!/bin/bash
logfile=/var/log/addon.log
set -x
printf "Killing Chrome" > $logfile 2>&1
killall chrome || true > $logfile 2>&1

printf "Starting Ubuntu chroot" > $logfile 2>&1
/storage/data/ubuntu/usr/sbin/chroot /storage/data/ubuntu /bin/bash -x << EOF > $logfile 2>&1

printf "Exporting PATH" > $logfile 2>&1
export PATH=$PATH:/bin:/usr/local/sbin:/usr/sbin:/sbin > $logfile 2>&1

printf "Chmodding /dev/shm" > $logfile 2>&1
chmod 1777 /dev/shm > $logfile 2>&1

printf "Changing to user HTPC" > $logfile 2>&1
su htpc

printf "Starting Unclutter" > $logfile 2>&1
unclutter -idle 0.01 -root &

printf "Put Kodi window in the background" > $logfile 2>&1
DISPLAY=:0 wmctrl -r kodi -b add,hidden

printf "Wait half a second before opening Google Chrome" > $logfile 2>&1
sleep 0.5

printf "Opening Chrome, directly focusing screen" > $logfile 2>&1
DISPLAY=:0 wmctrl -r "google-chrome https://www.youtube.com/tv/ --kiosk --noerrdialogs" -b add,fullscreen & google-chrome https://www.youtube.com/tv/ --kiosk --noerrdialogs > $logfile 2>&1

printf "When Chrome is exited, make sure Chrome & Unclutter are really killed" > $logfile 2>&1
killall chrome
killall unclutter

printf "Wait half a second before refocusing Kodi" > $logfile 2>&1
sleep 0.5

printf "Return focus to kodi after stopping Chrome" > $logfile 2>&1
DISPLAY=:0 wmctrl -r kodi -b remove,hidden
DISPLAY=:0 wmctrl -r kodi -b add,fullscreen
DISPLAY=:0 wmctrl -a kodi

EOF