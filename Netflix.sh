## Installing & enabling netflix on HTPC with Kodi

# Install the repo by installing the zip from this github page
	https://github.com/CastagnaIT/plugin.video.netflix

# Install the Cryptdome python library
	yay -Syu python2-pip
	python2 -m pip install --user pycryptodomex

# Install the netflix addon from the repo

# Enable the setting 'show notification instead of modal dialog for errors" under expert

# Installing Widevine CRM
# Ensure that the addon can write to the inputstream adaptive folder
	cd /usr/lib/kodi/addons
	chown -R htpc inputstream.adaptive
	chmod 740 -R inputstream.adaptive

# Open the Netflix Addon, sign in & try to play one 
