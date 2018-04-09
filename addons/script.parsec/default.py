import xbmc, xbmcgui, os, xbmcaddon, stat

addon = xbmcaddon.Addon()
script_path = addon.getAddonInfo('path')
script_file = 'parsec.sh'
script = os.path.join(script_path, 'bin', script_file)

xbmc.executebuiltin("XBMC.PlayerControl(Stop)")
xbmc.executebuiltin("XBMC.InhibitIdleShutdown(true)")

print(script)
os.chmod(script, stat.S_IRWXU)
os.system(script)

xbmc.executebuiltin("XBMC.InhibitIdleShutdown(false)")