#!/bin/bash

#############
# Variables #
#############

GIT_LOG="/home/htpc/logs/gitupdate.log"

####################
# Gitupdate Script #
####################

printf "Starting HTPC Git Auto Update. Time & Date right now is $(date)\n" >> $GIT_LOG 2>&1

# This script is called by the gitupdate systemd service. 
# It updates all git repositories on the system and then does any post-processing needed to update applications

# Reset any changes done in the HTPCGit repository (updating is only done one-way or by manually committing!)
su htpc -c "git -C /home/htpc/HTPCGit/ reset --hard" >> $GIT_LOG 2>&1

# Updating Git repositories
su htpc -c "git -C /home/htpc/HTPCGit/ pull" >> $GIT_LOG 2>&1

## Post Processing
# Set right permission for scripts, since they lose execution permission after doing git update
chmod -R +x /home/htpc/HTPCGit/scripts/ >> $GIT_LOG 2>&1
chmod -R +x /home/htpc/HTPCGit/addons/script.chromeyoutubetv/bin/chromeyoutubetv.sh >> $GIT_LOG 2>&1
chmod -R +x /home/htpc/HTPCGit/addons/script.chrome/bin/chrome.sh >> $GIT_LOG 2>&1
chmod -R +x /home/htpc/HTPCGit/addons/script.parsec/bin/parsec.sh >> $GIT_LOG 2>&1

# Systemd reload after potential update from systemd files
systemctl daemon-reload >> $GIT_LOG 2>&1

# Restart services for which config files are linked to samba
systemctl restart smb nmb >> $GIT_LOG 2>&1

printf "HTPC Git update finished.\n\n" >> $GIT_LOG 2>&1