### Instructions to install Retrospect addon

# Clone bitbucket git repo of Retrospect to /home/htpc/RetrospectGit
mkdir /home/htpc/RetrospectGit
git clone https://bitbucket.org/basrieter/xbmc-online-tv.git /home/htpc/RetrospectGit

# Create symlinks to the retrospect addon
cd /home/htpc/.kodi/addons
ln -s /home/htpc/RetrospectGit/RetrospectGit/net.rieter.xot
ln -s /home/htpc/RetrospectGit/RetrospectGit/net.rieter.xot.channel.be

# Change Retrospect settings