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
pacstrap /mnt base base-devel btrfs-progs openssh wget curl ufw smartmontools sudo ntfs-3g intel-ucode ttf-dejavu libcdio libdvdread libdvdcss libdvdnav grub efibootmgr alsa-utils xorg-server xorg-xinit xf86-video-intel mesa-libgl libva-intel-driver screenfetch openbox chromium kodi bluez python2-pybluez libnfs libplist libcec lirc lsb-release pulseaudio shairplay unrar unzip unclutter gptfdisk dosfstools parted hfsprogs xfsprogs nfs-utils ufw samba avahi nss-mdns pkgfile udisks2 udevil

## Fstab
# After generating fstab, be sure to change to current fstab with right mounting options.

## Timezone
# Set timezone with the following command
timedatectl set-timezone Europe/Brussels

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
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch-grub --boot-directory=/boot --debug
grub-mkconfig -o /boot/grub/grub.cfg

## FOLLOW FIRST THINGS TO DO AFTER INSTALL

systemctl start sshd

nano /etc/ssh/sshd_config
	PermitRootLogin yes


##################
## POST-INSTALL ##
##################

## General Recommendations
# https://wiki.archlinux.org/index.php/General_recommendations

## Mirrors
	# Install reflector
	# https://wiki.archlinux.org/index.php/Reflector

	# Create pacman hook
		# Move mirrorupgrade.hook to /etc/pacman.d/hooks/

	# Create systemd service & weekly systemd timer
		# Move reflector.service & reflector.timer to /etc/systemd/system/

## Booting
	# Num Lock activation

## Multimedia
	# Sound - Setting default device
	# See which sound devices are detected
		cat /proc/asound/modules

	# Select module that you need and make it permanent device 0
		nano /etc/modprobe.d/alsa-base.conf
			options <module> index=0

	# Set default alsa device to device zero
		nano /usr/share/alsa/alsa.conf
			defaults.ctl.card 0
			defaults.pcm.card 0

## Networking
	# Synchronize time
	timedatectl set-timezone Europe/Brussels

## System Service
	# File Index & Search

## Console Improvements
	# Bash Additions - Bash Tips & Tricks
		# Command not found
		pkgfile --update
		
		# Search for commands in non-installed packages if command not found
		source /usr/share/doc/pkgfile/command-not-found.bash

	# Console prompt - Console Bach prompt
		# Terminfo escape sequences
		
		# Change escape sequence to color green & give a custom message
		GREEN="\[$(tput setaf 2)\]"
		RESET="\[$(tput sgr0)\]"

		export PS1="${GREEN}\\u@\h \\W${RESET}> "

	# Add screenfetch prompt
		if [ -f /usr/bin/screenfetch ]; then screenfetch; fi

## Autologin
systemctl edit getty@tty1

	[Service]
	ExecStart=
	ExecStart=-/usr/bin/agetty --autologin root --noclear %I $TERM

## Kodi start & volume max at boot
cp /etc/X11/xinit/xinitrc ~/.xinitrc
nano ~/.xinitrc
	exec openbox-session &
	exec setxkbmap be &
	exec amixer sset Master unmute &
	exec amixer sset Master 100% &
	exec unclutter -idle 0.01 -root &
	exec /usr/bin/kodi-standalone -- :0 -nolisten tcp vt1

nano ~/.bash_profile
	[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx &> /dev/null

## Devmon
	systemctl enable devmon@root.service
	nano /etc/udevil/udevil.conf
		# add hfsplus to allowed filesystems

	# Move 99-udisks2.rules to /etc/udev/rules.d

	mkdir /media

## Silent boot
	nano /etc/default/grub
		GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=0 rd.systemd.show_status=false rd.udev.log-priority=0 vt.global_cursor_default=0"
		GRUB_TIMEOUT=0

	nano /etc/sysctl.d/20-quiet-printk.conf
		kernel.printk = 3 3 3 3

	grub-mkconfig -o /boot/grub/grub.cfg	

## Change boot image
	# Put boot image in /root/kodi_splash.png
	nano /etc/default/grub
		GRUB_BACKGROUND=/root/kodi_splash.png

	grub-mkconfig -o /boot/grub/grub.cfg

## Firewall
	ufw default deny
	ufw allow from 10.124.161.0/24 to any port 22 proto tcp # to keep ssh running if you are doing this install over ssh
	# Allowing samba
	ufw allow from 10.124.161.0/24 to any port 137 proto udp
	ufw allow from 10.124.161.0/24 to any port 138 proto udp
	ufw allow from 10.124.161.0/24 to any port 139 proto tcp
	ufw allow from 10.124.161.0/24 to any port 445 proto tcp
	ufw enable

## Samba Server
	## Avahi
		# Set up avahi local hostname resolution
		nano /etc/nsswitch.conf
			hosts: files mdns_minimal [NOTFOUND=return] dns myhostname

		# Advertise smb server on Avahi network
		# Move smb.service to /etc/avahi/services/

		# Enable & start service
		systemctl enable avahi-daemon.service
		systemctl start avahi-daemon.service

	# Move correct smb.conf (config/smb.conf) to /etc/samba/smb.conf
	mkdir /root/Public

	# create samba password
	smbpasswd -a root
		# Enter password

	# Enable systemd samba services
	systemctl enable smbd.service nmbd.service