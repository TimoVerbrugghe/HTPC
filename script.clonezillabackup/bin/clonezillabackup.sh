#!/bin/bash

# Backup script that backups up the internal SSD of this HTPC (/dev/sda) to an image on a NFS FileServer
# This backup is done through Clonezilla. Clonezilla-specific commands can be found at /etc/grub.d/40_custom
# This script is only as preparation for the backup and actual launch of Clonezilla

# Set certain variables
set -e

SCRIPT_DIR=$(dirname `which $0`)
GRUB_DEFAULT=0
GRUB_REBOOT="Clonezilla"
NFS_SERVER=10.124.161.101
PUSHBULLET_API=o.xYd9Q85uxflrzlSXukayL0XFiYfSfdqf
PUSHBULLET_TITLE="HTPC: Monthly Backup Started"
PUSHBULLET_MSG="Backup of your HTPC to an image on your ArchServer over NFS using Clonezilla has begin. All configuration files are in the clonezilla backup addon files. This backup takes about 30-45 minutes."

# Create NFS mounting directory
mkdir $SCRIPT_DIR/nfs || true

# Mount NFS Share
mount -t nfs $NFS_SERVER:/home/fileserver/Media/SystemImage $SCRIPT_DIR/nfs/ -o nolock

# Delete previous backup
rm -rf $SCRIPT_DIR/nfs/HTPC || true

# Set default boot entry
/usr/bin/grub-set-default $GRUB_DEFAULT

# Set Clonezilla Boot entry once
/usr/bin/grub-reboot $GRUB_REBOOT

# Warning sysadmin that a HTPC backup is about to begin
/usr/bin/curl -u $PUSHBULLET_API: https://api.pushbullet.com/v2/pushes -d type=note -d title="$PUSHBULLET_TITLE" -d body="$PUSHBULLET_MSG"

reboot