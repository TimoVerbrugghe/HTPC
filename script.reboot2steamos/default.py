import xbmc, xbmcgui, os, xbmcaddon, stat

dialog1 = "Reboot to SteamOS"
dialog2 = "Do you want to reboot to SteamOS?"

addon = xbmcaddon.Addon()
script_path = addon.getAddonInfo('path')
script_file = 'reboot2steamos.sh'
script = os.path.join(script_path, 'bin', script_file)

dialog = xbmcgui.Dialog()
if dialog.yesno(dialog1, dialog2):
  xbmc.executebuiltin("XBMC.PlayerControl(Stop)")
  print(script)
  os.chmod(script, stat.S_IRWXU)
  os.system(script)
