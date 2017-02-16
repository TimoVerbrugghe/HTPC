#!/bin/bash
#Edit the lines between the #####'s
#Use the following command to list GRUB boot entries (you need to update it with the correct path to 'grub.cfg'):
#sed -n '/menuentry/s/.*\(["'\''].*["'\'']\).*/\1/p' /path/to/grub.cfg
set -e

#####

SCRIPT_DIR=$(dirname `which $0`)
GRUB_BOOT_DIR="/media/sda2-ata-ADATA_SP310_2D51/boot" #location of the grub boot directory
GRUB_CONFIG_FILE="/media/sda2-ata-ADATA_SP310_2D51/boot/grub/grub.cfg"  #location of the grub config file
GRUB_DEFAULT="LibreELEC"
GRUB_REBOOT="Windows"

#####

export LD_LIBRARY_PATH=$SCRIPT_DIR:$LD_LIBRARY_PATH
$SCRIPT_DIR/grub-set-default --boot-directory=$GRUB_BOOT_DIR $GRUB_DEFAULT
$SCRIPT_DIR/grub-reboot --boot-directory=$GRUB_BOOT_DIR $GRUB_REBOOT
reboot
