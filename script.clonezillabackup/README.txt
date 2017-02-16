Clonezillabackup

This addon will reboot your OpenELEC machine once into clonezilla then boot back into OpenELEC. It uses GRUB so a working multi-boot setup with GRUB is required. This addon uses GRUB 2.00 and has been tested with GRUB 1.99 and 2.00. Updates to GRUB can break this addon.

Manual editing files contained within the zip is required to get this addon working (preferably before installation).

script.clonezillabackup\bin\clonezillabackup.sh

GRUB_BOOT_DIR=


This points to the location where the /boot folder that GRUB uses is located. My Ubuntu partition where GRUB's boot directory is located is labelled 'ubuntu' and is mounted at /media/ubuntu, so I use /media/ubuntu/boot.

GRUB_DEFAULT=
GRUB_REBOOT=

The numbers following the above options correspond to your GRUB menu entries and they start from 0, so in the included file my GRUB_DEFAULT= entry (6) is the main OS (Openelec) and is the 7th entry in the GRUB menu. GRUB_REBOOT=, the OS I wish to reboot once into (5) is the 6th GRUB menu entry.

Reboot to your your steamos/grub install you need to edit /etc/default/grub and change the line

GRUB_DEFAULT=

to

GRUB_DEFAULT=saved

then exit and run

sudo update-grub 
sudo grub-set-default 6 #change number to OpenELEC GRUB menu entry number
sudo reboot

You should now be back in OpenELEC. Now select 'clonezilla' under Programs to use the addon and reboot once to the OS of your choice.

clonezillabackup is based on Reboot2oos-oe
http://openelec.tv/forum/128-addons/62352-addon-reboot-once-to-another-os#62765