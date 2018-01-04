#!/bin/bash

# Arch Auto update script. Runs pacman update without input needed from admin/user and puts everything in a logfile. 
# Will notify user if update has gone wrong.

################
# Requirements #
################

# Pacman has to be able to run without a sudo password, which can be set up by modifying sudoers file
	# EDITOR=nano visudo
	# fileserver ALL=(ALL) NOPASSWD: /usr/bin/pacman

#############
# Variables #
#############

PUSHBULLET_SCRIPT="/home/htpc/HTPCGit/scripts/pushbullet.sh"
UPDATE_LOG="/home/htpc/logs/autoupdate.log"

#####################
# Autoupdate Script #
#####################

printf "Starting Arch Auto Update. Time & Date right now is $(date)\n" >> $UPDATE_LOG 2>&1
su htpc -c "pacaur -Syu --noedit --noconfirm" >> $UPDATE_LOG 2>&1
systemctl daemon-reload

# Getting return code from pacman. If this return code is not 0 (so an error has occured with the pacman update), notify system administrator
errorval="$?"
if [ $errorval -ne 0 ]; then
  $PUSHBULLET_SCRIPT "ERROR - HTPC Auto update failed" "During auto update, the pacman installer failed installing updates (error code different than 0)." >/dev/null 2>&1
	exit 1
else
  printf "Arch Auto update has finished without errors\n\n" >> $UPDATE_LOG 2>&1
  exit 0
fi
