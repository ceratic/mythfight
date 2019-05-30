#===============================================================================
# Miscellaneous Options
# By Jet10985 (Jet)
#===============================================================================
# This snippet will allow you to perform additional customization on some
# of the "Finer Details" of your game, not available in the Editor.
# This script has: 14 customization options.
#===============================================================================
# Overwritten Methods:
# None
#-------------------------------------------------------------------------------
# Aliased methods:
# DataManager: make_filename, save_file_exists?
# Game_System: japanese?
#===============================================================================
module MiscellaneousOptions
  
  #=============================================================================
  # Font Options
  #=============================================================================
  
  #-----------------------------------------------------------------------------
  # This is what font the game will use by default
  # You may use a single font, or multiples in the form of an array
  # When using multiple fonts, the game will go through the array until
  # it finds a font the player has installed.
  #-----------------------------------------------------------------------------
  Font.default_name = ["Verdana", "Arial", "Courier New"]
  
  #-----------------------------------------------------------------------------
  # This is how big font is by default.
  #-----------------------------------------------------------------------------
  Font.default_size = 20
  
  #-----------------------------------------------------------------------------
  # This determines if text is drawn in bold or not, by default.
  #-----------------------------------------------------------------------------
  Font.default_bold = false
  
  #-----------------------------------------------------------------------------
  # This determines if text is drawn in italic or not, by default.
  #-----------------------------------------------------------------------------
  Font.default_italic = false
  
  #-----------------------------------------------------------------------------
  # This determines if text is drawn with a shadow or not, by default.
  #-----------------------------------------------------------------------------
  Font.default_shadow = true
  
  #-----------------------------------------------------------------------------
  # This determines what color text if drawn in by default.
  #-----------------------------------------------------------------------------
  Font.default_color = Color.new(255, 255, 255)
  
  #-----------------------------------------------------------------------------
  # This determines if text is drawn with an outline
  #-----------------------------------------------------------------------------
  Font.default_outline = true
  
  #-----------------------------------------------------------------------------
  # This determines if what color text's outline will be drawn in
  #-----------------------------------------------------------------------------
  Font.default_out_color = Color.new(0, 0, 0, 128)
  
  #-----------------------------------------------------------------------------
  # Is the game in Japanese?
  #-----------------------------------------------------------------------------
  JAPANESE = false
  
  #=============================================================================
  # Windows Options
  #=============================================================================
  
  #-----------------------------------------------------------------------------
  # This determines if the Game's Process Priority will be heightened to "High"
  # at startup. This may, or may not, help some lag issues.
  #-----------------------------------------------------------------------------
  HIGH_PROCESS = true
  
  #-----------------------------------------------------------------------------
  # This determines if the Mouse Cursor should be hidden will inside the game.
  # This only applies if the mouse is inside the Game's window.
  #-----------------------------------------------------------------------------
  HIDE_MOUSE = true
  
  #-----------------------------------------------------------------------------
  # This determines if the window should be resizable.
  # By default, the game window is not resizable without script calls.
  # Note this does not increase the Game's graphic displaying abilities,
  # and will cause graphics stretching/shrinking.
  #-----------------------------------------------------------------------------
  ALLOW_RESIZING = false
  
  #=============================================================================
  # Game Options
  #=============================================================================
  
  #-----------------------------------------------------------------------------
  # This determines what size the game window should be. Max: 640x480
  # Must be increments of 32
  #-----------------------------------------------------------------------------
  #Graphics.resize_screen(544, 416)
  
  #-----------------------------------------------------------------------------
  # This determines if Save Files will be saved into the AppData folder
  # in windows, instead of the directory of the game.
  # In Windows XP: C:\Documents and Settings\UserName\Application Data\GAME_NAME
  # In Windows Vista/7: C:\Users\UserName\AppData\Roaming\GAME_NAME
  #-----------------------------------------------------------------------------
  SAVE_IN_APPDATA = true
  
  #-----------------------------------------------------------------------------
  # What is your game's name? This will only be used if you use SAVE_IN_APPDATA
  #-----------------------------------------------------------------------------
  GAME_NAME = "MythFight"
  
end

#===============================================================================
# DON'T EDIT FURTHER UNLESS YOU KNOW WHAT TO DO.
#===============================================================================

module MiscellaneousOptions
  
  def self.handle
    a = Win32API.new('kernel32', 'GetPrivateProfileString', 'pppplp', 'l')
    b = Win32API.new('user32', 'FindWindow', 'pp', 'i')
    a.call("Game", "Title", "", title = "\0" * 256, 256, ".//Game.ini")
    return b.call("RGSS Player", title.delete!("\0"))
  end
end

if MiscellaneousOptions::HIDE_MOUSE
  Win32API.new('user32', 'ShowCursor', 'i', 'i').call(0)
end
if MiscellaneousOptions::HIGH_PROCESS
  Win32API.new('kernel32','SetPriorityClass','pi','i').call(-1, 256)
end
if MiscellaneousOptions::ALLOW_RESIZING
  Win32API.new('user32', 'SetWindowLong', 'lll', 'l').call(
    MiscellaneousOptions.handle, -16, 0x10C70000|0x00080000)
end
if MiscellaneousOptions::SAVE_IN_APPDATA
  f = "#{ENV['APPDATA']}\\#{MiscellaneousOptions::GAME_NAME}"
  Dir.mkdir(f) unless File.directory?(f)
  Dir.mkdir("#{f}\\Saves") unless File.directory?("#{f}\\Saves")
end

class << DataManager
  
  alias jet3849_save_file_exists save_file_exists?
  def save_file_exists?(*args, &block)
    if MiscellaneousOptions::SAVE_IN_APPDATA
      f = "#{ENV['APPDATA']}\\#{MiscellaneousOptions::GAME_NAME}"
      Dir.entries("#{f}\\Saves").size > 2
    else
      jet3849_save_file_exists(*args, &block)
    end
  end
  
  alias jet2734_make_filename make_filename
  def make_filename(index)
    if MiscellaneousOptions::SAVE_IN_APPDATA
      f = "#{ENV['APPDATA']}\\#{MiscellaneousOptions::GAME_NAME}"
      return "#{f}\\Saves\\#{sprintf("Save%02d.rvdata2", index + 1)}"
    else
      jet2734_make_filename(index)
    end
    
  end
end

class Game_System
  
  alias jet2734_japanese japanese?
  def japanese?(*args, &block)
    $data_system.japanese = MiscellaneousOptions::JAPANESE
    jet2734_japanese(*args, &block)
  end
end