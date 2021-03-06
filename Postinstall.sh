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
		# Move getty@_override.conf to /etc/systemd/system/getty@.service.d/override.conf

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
		
## Autologin
systemctl edit getty@tty1

	[Service]
	ExecStart=
	ExecStart=-/usr/bin/agetty --autologin root --noclear %I $TERM

## NFS Share mounting
# Create folders for Movies & TVShows
mkdir /home/htpc/Movies
mkdir /home/htpc/TVShows

# Change /etc/fstab file as presented in the config/fstab file to do a system nfs mount on boot of ArchServer NFS Shares (faster & more reliable than libnfs in Kodi GUI)

## Kodi start & volume max at boot
cp /etc/X11/xinit/xinitrc ~/.xinitrc
nano ~/.xinitrc
	exec openbox-session &
	exec amixer sset Master unmute &
	exec amixer sset Master 100% &
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

	# Enable devmon at startup with root permissions (needed for mounting)
	systemctl enable devmon@root.service

## Silent boot
	nano /etc/default/grub
		GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=0 rd.systemd.show_status=false rd.udev.log-priority=0 vt.global_cursor_default=0"
		GRUB_TIMEOUT=0

	nano /etc/sysctl.d/20-quiet-printk.conf
		kernel.printk = 3 3 3 3

	grub-mkconfig -o /boot/grub/grub.cfg	

## Firewall
	# Set up UFW according to ufwrules in config folder

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

	## Enable network discovery of Samba servers for Windows 10
	# Go to "Turn Windows Features On or Off"
	# Enable SMB/CIFS 1.0 features
	# Restart PC

## Clonezilla backup timer
	# Move clonezillabackup.timer & clonezillabackup.service to /etc/systemd/system/
	systemctl enable clonezillabackup.timer
	systemctl start clonezillabackup.timer

	# Put clonezilla.iso (downloaded from clonezilla.org) in /home/htpc/clonezilla.iso

	# Install clonezillabackup addon in kodi

## Change boot image
	nano /etc/default/grub
		GRUB_BACKGROUND=/home/htpc/HTPCGit/pictures/kodi_splash.png

	grub-mkconfig -o /boot/grub/grub.cfg

## Disable ALT-F4 for kodi
	# Create local configuration files for openbox
	cp -R /etc/xdg/openbox/ ~/.config/

	nano ~/.config/openbox/rc.xml
		# Under <!-- Keybindings for windows -->, Add ALT-F5 option & change the scope of the ALT-F4 option
		<keybind key="A-F4">
			<action name="If">
			  <title>Kodi</title>
			  <then><!-- Do nothing for Kodi --></then>
			  <else>
			   <action name="Close" />
			  </else>
			 </action>
		</keybind>

		<keybind key="A-F5">
			<action name="Execute">
				<command>/home/htpc/HTPCGit/scripts/stopcurrentapp.sh</command>
			</action>
		</keybind>

## Enable suspend & wake
	# Create udev rule for Flirc so it is able to wake from suspend (idVender = 20a0 & idProduct = 0001)
		nano /etc/udev/rules.d/90-keyboardwakeup.rules
			SUBSYSTEM=="usb", ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="0001" RUN+="/bin/sh -c 'echo enabled > /sys$env{DEVPATH}/../power/wakeup'"

	# Make sure usb devices are not suspended
		nano /etc/default/grub
			GRUB_CMDLINE_LINUX_DEFAULT="usbcore.autosuspend=-1"

	# Enable sleep detection in the flirc app (advanced settings)
	# Enable Suspend settings in Kodi: Settings -> System -> Power Saving -> Shutdown Function = Suspend
	# Set timer for suspend in Kodi: Settings -> System -> Power Saving -> Shutdown Function Timer