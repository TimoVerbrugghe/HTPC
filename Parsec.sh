## Parsec Installation on HTPC

# Step 1: Install pacaur
	# See AUR steps as described in the ArchServer Repository - First things to do after install

# Step 2: Downgrade expat (if necessary)
	# Uninstall expat
		pacman -Rns expat

	# Add expat to the IgnorePkg line
		nano /etc/pacman.conf
			IgnorePkg   = expat

	# Download expat 2.2.4
		wget https://archive.archlinux.org/packages/e/expat/expat-2.2.4-1-x86_64.pkg.tar.xz
		pacman -U

# Install parsec
	pacaur -Syu parsec-bin

# Fix sndio link
	sudo ln -s /usr/lib/libsndio.so /usr/lib/libsndio.so.6.1