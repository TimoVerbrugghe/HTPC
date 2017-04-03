#!/bin/bash
#Edit the lines between the #####'s
#Use the following command to list GRUB boot entries (you need to update it with the correct path to 'grub.cfg'):
#sed -n '/menuentry/s/.*\(["'\''].*["'\'']\).*/\1/p' /path/to/grub.cfg
set -e

#####

SCRIPT_DIR=$(dirname `which $0`)
GRUB_DEFAULT=0
GRUB_REBOOT="Windows"

#####

/usr/bin/grub-set-default $GRUB_DEFAULT
/usr/bin/grub-reboot $GRUB_REBOOT

reboot