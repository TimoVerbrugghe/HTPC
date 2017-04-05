###############################
## Arch installation on HTPC ##
###############################

##################
## Installation ##
##################

## Instructions to set up ArchServer based on the Installation Guide found on Archwiki

## If additional steps need to be taken outside of the wiki installation guide, the title of the step will be in comments, followed by the additional steps/commands

##  (Optional) Wireless Installation
# If installation needs to be done wirelessly, first check if the wireless card is loaded (firmware/etc...) through lspci -k & dmesg | grep firmware
# If wireless card is loaded -> search for wireless networks through wifi-menu -o & go through the steps
# netctl start <profile name given during wifi-menu>

## Format the partitions
# EFI -> FAT32 (mkfs.fat -F32 /dev/sdxY)
# Boot partition -> ext4
# After partition formatting, enable swap on the swap partition
mkswap /dev/sda3
swapon /dev/sda3

## Install the base packages
# Install these additional packages
pacstrap /mnt base base-devel btrfs-progs openssh wget curl ufw smartmontools sudo ntfs-3g intel-ucode ttf-dejavu libcdio libdvdread libdvdcss libdvdnav grub efibootmgr alsa-utils xorg-server xorg-xinit xf86-video-intel mesa-libgl libva-intel-driver screenfetch openbox chromium kodi bluez bluez-utils python2-pybluez libnfs libplist libcec lirc lsb-release pulseaudio shairplay unrar unzip unclutter gptfdisk dosfstools parted hfsprogs xfsprogs nfs-utils ufw samba avahi nss-mdns pkgfile udisks2 udevil reflector mlocate

## Fstab
# After generating fstab, be sure to change to current fstab with right mounting options.

## Timezone
# Set timezone with the following command
ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime
timedatectl set-ntp true

## Network Configuration
# Use netctl to assign a static IP Address
# https://wiki.archlinux.org/index.php/Netctl#Wired

# Get current interface name
ip addr

# /etc/netctl/staticIPwired
Interface= <interfacename>
Connection=ethernet
IP=static
Address=('10.124.161.102/24')
Gateway=('10.124.161.93')
DNS=('8.8.8.8' '8.8.4.4')
TimeoutUp=300
TimeoutCarrier=300

# /etc/netctl/hooks/status

	#!/bin/sh
	ExecUpPost="systemctl start network-online.target"
	ExecDownPre="systemctl stop network-online.target"

netctl enable staticIPwired

## Bootloader installation
# Make sure all partitions are mounted to the correct folders!
# Mount /boot/ first before mounting /boot/efi!
arch-chroot /mnt /bin/bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch --boot-directory=/boot --debug
grub-mkconfig -o /boot/grub/grub.cfg

	## UEFI - Troubleshooting
		# Make sure all other UEFI boot options (from previous installs) are erased using efibootmgr
		# It could be that the bootloader has to have bootx64.efi in the esp/EFI/boot/ folder. If so, copy /mnt/boot/efi/EFI/arch/grubx64.efi to /mnt/boot/efi/EFI/boot/bootx64.efi