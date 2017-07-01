import xbmc, xbmcgui, os, xbmcaddon, stat

addon = xbmcaddon.Addon()
script_path = addon.getAddonInfo('path')
script_file = 'chromeyoutubetv.sh'
script = os.path.join(script_path, 'bin', script_file)

xbmc.executebuiltin("XBMC.PlayerControl(Stop)")
print(script)
os.chmod(script, stat.S_IRWXU)
os.system(script)