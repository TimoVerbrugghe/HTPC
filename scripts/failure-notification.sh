#!/bin/bash
UNIT=$1

/home/htpc/HTPCGit/scripts/pushbullet.sh "HTPC: \"$1\" failed" "WARNING - The unit \"$1\" has failed according to systemd. You can find more information in the systemd log (journalctl -xe)."