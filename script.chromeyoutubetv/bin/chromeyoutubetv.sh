#!/bin/sh
killall chrome || true
/storage/data/ubuntu/usr/sbin/chroot /storage/data/ubuntu /bin/bash -x << EOF
chmod 1777 /dev/shm
su htpc
unclutter -idle 0.01 -root;
google-chrome https://www.youtube.com/tv/ --kiosk --noerrdialogs
sleep 2
wmctrl -a Chrome
exit 0