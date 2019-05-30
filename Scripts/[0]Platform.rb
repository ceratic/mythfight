=begin
================================================================================
Build Checker                                                       Version 1.0
by Ceratic                                                          Jul 19 2015
--------------------------------------------------------------------------------

[ Introduction ]++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Einfaches Programm um alle WIN32API Befehle bei Linux und MACOS zu Deaktivern
  einfach ´nur weil ich kA hab wie ich das per Config.dll mache xD
 
  
  Wobei 
  1 = Windows 
  2 = Linux und oder MacOSX

================================================================================

=end

#$build = 1

f = File.open('config.dll', "r")
a = f.readlines
$build = a[8].to_i
f.close


