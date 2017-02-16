#!/bin/bash

# Backup script that backups up the internal SSD of this HTPC (/dev/sda) to an image on a NFS FileServer
# This backup is done through Clonezilla. Clonezilla-specific commands can be found at /etc/grub.d/40_custom
# This script is only as preparation for the backup and actual launch of Clonezilla

# Set certain variables
set -e

SCRIPT_DIR=$(dirname `which $0`)
GRUB_BOOT_DIR="/media/sda2-ata-ADATA_SP310_2D51/boot" #location of the grub boot directory
GRUB_CONFIG_FILE="/media/sda2-ata-ADATA_SP310_2D51/boot/grub/grub.cfg" #location of the grub config file
GRUB_DEFAULT="LibreELEC"
GRUB_REBOOT="Clonezilla"
NFS_SERVER=10.124.161.101

# Create NFS mounting directory
mkdir $SCRIPT_DIR/nfs

# Mount NFS Share
mount -t nfs $NFS_SERVER:/home/fileserver/Media/SystemImage $SCRIPT_DIR/nfs/ -o nolock

# Delete previous backup
rm -rf $SCRIPT_DIR/nfs/HTPC

# Setting different LD_LIBRARY_PATH so grub commands can be used
export LD_LIBRARY_PATH=$SCRIPT_DIR:$LD_LIBRARY_PATH

# Set default boot entry
$SCRIPT_DIR/grub-set-default --boot-directory=$GRUB_BOOT_DIR $GRUB_DEFAULT

# Set Clonezilla Boot entry once
$SCRIPT_DIR/grub-reboot --boot-directory=$GRUB_BOOT_DIR $GRUB_REBOOT

# Warning sysadmin that a HTPC backup is about to begin
$SCRIPT_DIR/pushbullet.sh "HTPC: Monthly Backup Started" "Backup of your HTPC to an image on your
ArchServer over NFS using Clonezilla has begin. All configuration files are in the clonezilla backup addon files. This
backup takes about 30-45 minutes"

reboot