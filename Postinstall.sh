##################
## POST-INSTALL ##
##################

## Enable ssh for easier configuration
systemctl start sshd

nano /etc/ssh/sshd_config
	PermitRootLogin yes

## Dualboot with Windows
	# Install Windows on seperate partition
	# After install, boot in Archlinux iso
	mount /dev/sda1 /mnt
	cp /mnt/EFI/arch/grubx64.efi /mnt/EFI/boot/bootx64.efi

	# Reboot into arch
	# Move 40_custom to /etc/grub.d/40_custom (this add the Windows menu option in grub boot menu)
	grub-mkconfig -o /boot/grub/grub.cfg

	# It could be that you still need to change the boot order in the bios to put arch first

## General Recommendations
# https://wiki.archlinux.org/index.php/General_recommendations

	useradd -m -G wheel,power,audio,video,network,optical,storage -s /bin/bash htpc
	EDITOR=nano visudo
		htpc ALL=(ALL) ALL
		# To allow grub-set-default, grub-reboot, mount & rm to run without password (for clonezillabackup & reboot2windows)
		htpc ALL=(ALL) NOPASSWD: /usr/bin/grub-set-default
		htpc ALL=(ALL) NOPASSWD: /usr/bin/grub-reboot
		htpc ALL=(ALL) NOPASSWD: /usr/bin/mount
		htpc ALL=(ALL) NOPASSWD: /usr/bin/rm


## Mirrors
	# Create reflector pacman hook
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

## Create new user
	useradd -m -G wheel,video,audio,network,optical,storage,power -s /bin/bash fileserver
	EDITOR=nano visudo
		fileserver ALL=(ALL) ALL

## Console Improvements
	# Bash Additions - Bash Tips & Tricks
		# Command not found
		pkgfile --update
		
		# Search for commands in non-installed packages if command not found
		nano ~/.bashrc
		source /usr/share/doc/pkgfile/command-not-found.bash

	# Console prompt - Console Bach prompt
		# Terminfo escape sequences
		
		# Change escape sequence to color green & give a custom message
		nano .bashrc
		GREEN="\[$(tput setaf 2)\]"
		RESET="\[$(tput sgr0)\]"

		export PS1="${GREEN}\\u@\h \\W${RESET}> "

	# Add screenfetch prompt
		nano ~/.bashrc
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
	exec amixer sset Master unmute &
	exec amixer sset Master 100% &
	exec devmon &
	exec unclutter -idle 0.01 -root &
	exec /usr/bin/kodi-standalone -- :0 -nolisten tcp vt1

nano ~/.bash_profile
	[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx &> /dev/null

## Devmon
	nano /etc/udevil/udevil.conf
		# add hfsplus to allowed filesystems
		# allowed_types = $KNOWN_FILESYSTEMS, file, hfsplus

	# Move 99-udisks2.rules to /etc/udev/rules.d

	mkdir /media

## Silent boot
	nano /etc/default/grub
		GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=0 rd.systemd.show_status=false rd.udev.log-priority=0 vt.global_cursor_default=0"
		GRUB_TIMEOUT=0

	nano /etc/sysctl.d/20-quiet-printk.conf
		kernel.printk = 3 3 3 3

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

		# Move smb.conf to /etc/samba/smb.conf

		# Enable & start service
		systemctl enable avahi-daemon.service
		systemctl start avahi-daemon.service

	# create samba password
	sudo smbpasswd -a htpc
		# Enter password

	# Enable systemd samba services
	systemctl enable smbd.service nmbd.service

## Clonezilla backup timer
	# Move clonezillabackup.timer & clonezillabackup.service to /etc/systemd/system/
	systemctl enable clonezillabackup.timer
	systemctl start clonezillabackup.timer

	# Put clonezilla.iso (downloaded from clonezilla.org) in /home/htpc/clonezilla.iso

	# Install clonezillabackup addon in kodi

## Change boot image
	# Put boot image in /root/kodi_splash.png
	nano /etc/default/grub
		GRUB_BACKGROUND=/home/htpc/kodi_splash.png

	grub-mkconfig -o /boot/grub/grub.cfg

## Steam Install

## Plymouth Install