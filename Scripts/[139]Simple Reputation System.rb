=begin
# ------------------------------------------------------------------------------
#             XIV's Simple Reputation System (SRS) for RGSS3
# ------------------------------------------------------------------------------
# Translator to RGSS3 : efeberk
# Owner: XIV
# Version: 1.1
# Created Date: 22.11.2010
# Converted Date : 12.05.2013
# ==============================================================================

# Credits $ Thanks:
# - a big thank-you goes to OriginalWij for his "Chest Item Pop-Up 2" script from 
#   where I got the pop-up text box code for this script,if you use SRS you should 
#   definitely credit him and efeberk.

# Function:
# Creates a new scene for managing character/faction reputation. Removes the need of tons
# for variables for each individual character/faction reputation value.

# Instructions:
# 1. Paste above Main.
# 2. Learn the method calls.
# 3. Customize the script to your liking using the customization section below.
# 4. Use and enjoy!

# Tips & Tricks:
# - you should note that the reputation scene is called with an event command
#   so if you want to call this scene from the menu you should either use the
#   included menu patch (if you don't use any menu altering scripts) or you
#   can check for a custom menu script that allows for easy command addition,
#   if you fail to do it yourself you should contact me at rpgmakervx.net forums
#   and I'll see what I can do

# Method calls:
# Call these methods in the "Script.." event command:

# - SceneManager.call(Scene_Rep) => calls the reputation scene

# - add_rep("name") => adds the name to the list where name is the name of the 
#   character or faction

# - change_rep("name", value) => where name is the name of the char's/faction's
#   reputation you want to change and value is, well, value by which you want to
#   increase the reputation (use negative value if you want to subtract)

# - check_rep("name", var) => saves the reputation value of the char/faction
#   into a variable with ID var

# - rep_defined?("name") => returns true if there is a char/faction in the
#   reputation list, should be used in a conditional branch

# - delete_rep("name") => removes the char/faction from the reputation list

module XIV
  module SimRep
# ------------------------------------------------------------------------------
# *Customization
# ------------------------------------------------------------------------------
  # Change the title of the scene
  TITLE = "Reputation"
  
  # While this switch is OFF the text pop-up will show when you change reputation
  # or add a new char/faction to the list
  POPUP_SWITCH = 99
  
  # Determine the speed of the text pop-up (0-slowest, 4-fastest)
  POPUP_SPEED = 2
  
  # Set this to true if you want the text window to pop up (otherwise it will be
  # static)
  POPUP = false
  
  # Set this to false if you don't want a sound to play on pop-up
  PLAY_SOUND = true
  # Sound to play upon pop-up
  S_NAME   = 'Audio/SE/Chime2'
  S_VOLUME = 100
  S_PITCH  = 150
  
  # Set this to true if you want a button press to terminate the window
  BUTTON_WAIT = false
  # Which buttons should be pressed to terminate the pop-up window
  BUTTON_1 = Input::C
  BUTTON_2 = Input::B
  
  # Frames to wait to terminate the pop-up window automatically (if the above is
  # false)
  TIME = 60
# ------------------------------------------------------------------------------
# *End Customization
# ------------------------------------------------------------------------------
  end
end


#-------------------------------------------------------------------------------
# - reputation data dump
#-------------------------------------------------------------------------------
class Game_System
  attr_accessor :rep_name  
  attr_accessor :rep_val
  
  alias rep_initialize initialize
  def initialize
    rep_initialize
    @rep_name = []
    @rep_val = []
  end
end

#-------------------------------------------------------------------------------
# - control methods
#-------------------------------------------------------------------------------
class Game_Interpreter
  $scene1 = Scene_Menu.new(0)
  def add_rep(name)
    $game_system.rep_name.push name
    $game_system.rep_val.push 0
    $scene1.item_popup(name,0) unless $game_switches[XIV::SimRep::POPUP_SWITCH] 
  end
  
  def change_rep(name, value)
    $game_system.rep_val[$game_system.rep_name.index(name)] += value
    $scene1.item_popup(name,value) unless $game_switches[XIV::SimRep::POPUP_SWITCH]
  end
  
  def check_rep(name,var)
    ret = $game_system.rep_val[$game_system.rep_name.index(name)]
    $game_variables[var] = ret
  end
  
  def rep_defined?(name)
    for i in 0...$game_system.rep_name.size
      if $game_system.rep_name[i] == name
        return true
      end
    end
    return false
  end
        
  
  def delete_rep(name)
    del = $game_system.rep_name.index(name)
    $game_system.rep_name.delete_at(del)
    $game_system.rep_val.delete_at(del)
    $scene1.item_popup(name,0,true) unless $game_switches[XIV::SimRep::POPUP_SWITCH] 
  end
end

    
#-------------------------------------------------------------------------------
# - window setting
#-------------------------------------------------------------------------------

class Window_Help < Window_Base
  
  def set_text_rep(text)
    if text != @text
      @text = text
    end
    contents.clear
    draw_text(0,0,Graphics.width,24,@text, 1)
  end
end
    

class Window_Reputation < Window_Selectable
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @column_max = 1
    self.index = 0
    @data = $game_system.rep_name
    refresh
  end
  
  def refresh
    @item_max = @data.size
    create_contents
    for i in 0...@item_max
      draw_item(i)
    end
  end
  
  def draw_rep_name(name, x, y)
    if name != nil
      self.contents.font.color = normal_color
      self.contents.draw_text(x+10, y, 172, line_height, name)
    end
  end
  
  def sign(num)
    if num > 0
      self.contents.font.color.set(0,255,0)
      sign = "+%d"
    elsif num < 0
      self.contents.font.color.set(255,0,0)
      sign = "%d"
    elsif num == 0
      sign = "%d"
    end
    return sign
  end
  
  def draw_item(index)
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    item = @data[index]
    if item != nil
      number = $game_system.rep_val[index]
      rect.width -= 4
      draw_rep_name(@data[index], rect.x, rect.y)
      self.contents.draw_text(rect, sprintf(sign(number), number), 2)
      self.contents.font.color = normal_color
    end
  end  
end
#-------------------------------------------------------------------------------
# - popup window by OriginalWij
#-------------------------------------------------------------------------------
class Scene_Base
  def item_popup(text, amount, del=false)
    x = $game_player.screen_x - 26
    y = $game_player.screen_y - 48
    @popup_window = Window_Base.new(x, y, 56, 56)
    @popup_window.opacity = @popup_window.contents_opacity = 0
    if $game_party.in_battle
      @popup_window.x = (Graphics.width - @popup_window.width) / 2
      @popup_window.y = Graphics.height / 2 - 64
    end
    max = XIV::SimRep::POPUP_SPEED * 4 + 16
    for i in 1..max
      @popup_window.contents_opacity = i * (256 / max)
      @popup_window.y -= (32 / max)
      @popup_window.update
      Graphics.update
    end
    if XIV::SimRep::PLAY_SOUND
      Audio.se_play(XIV::SimRep::S_NAME, XIV::SimRep::S_VOLUME, XIV::SimRep::S_PITCH)
    end
    
    if del  
      am_str = "REMOVED!"
    elsif amount > 0 
      am_str = "+"+amount.to_s
    elsif amount < 0 
      am_str = amount.to_s
    elsif amount == 0
      am_str = "NEW!"
    end
    
    width = @popup_window.contents.text_size(text).width + 10
    a_width = @popup_window.contents.text_size(am_str).width
    x = (Graphics.width - (width + a_width + 32)) / 2
    y = (Graphics.height - 56) / 2
    y += 32 if XIV::SimRep::POPUP
    @name_window = Window_Base.new(x, y, width + a_width + 32, 56)
    @name_window.opacity = @name_window.contents_opacity = 0
    w = width + a_width
    
    if amount > 0
      @name_window.contents.font.color.set(0,255,0)
    elsif amount < 0
      @name_window.contents.font.color.set(255,46,0)
    elsif amount == 0
      @name_window.contents.font.color.set(255,255,0)
    end
    
    @name_window.contents.draw_text(width, 0, w, 24, am_str)
    @name_window.contents.font.color.set(255,255,255)
    @name_window.contents.draw_text(0, 0, w, 24, text)
    for i in 1..max
      @name_window.y -= (32 / max) if XIV::SimRep::POPUP
      @name_window.contents_opacity = i * (256 / max)
      @name_window.opacity = i * (256 / max)
      @name_window.update
      Graphics.update
    end
    count = 0
    loop do
      Graphics.update
      Input.update
      count += 1 unless XIV::SimRep::BUTTON_WAIT
      break if Input.trigger?(XIV::SimRep::BUTTON_1) and XIV::SimRep::BUTTON_WAIT
      break if Input.trigger?(XIV::SimRep::BUTTON_2) and XIV::SimRep::BUTTON_WAIT
      break if count == XIV::SimRep::TIME and !XIV::SimRep::BUTTON_WAIT
    end
    for i in 1..max
      @popup_window.contents_opacity = 256 - i * (256 / max)
      @name_window.opacity = 256 - i * (256 / max)
      @name_window.contents_opacity = 256 - i * (256 / max)
      @popup_window.update
      @name_window.update
      Graphics.update
    end
    @popup_window.dispose
    @name_window.dispose
    Input.update
  end
end

#-------------------------------------------------------------------------------
# - reputation scene processing
#-------------------------------------------------------------------------------
class Scene_Rep < Scene_MenuBase
  def start
    super
    create_main_viewport
    create_background
    @viewport = Viewport.new(0, 0, 544, 416)
    @help_window = Window_Help.new(1)
    @help_window.viewport = @viewport
    x = (Graphics.width/2)-165
    @rep_window = Window_Reputation.new(x, 56,350, 360)
    @rep_window.viewport = @viewport
    @rep_window.help_window = @help_window
    @rep_window.active = true
    @help_window.set_text_rep(XIV::SimRep::TITLE)
  end
  
  def terminate
    super
    @help_window.dispose
    @rep_window.dispose
    @viewport.dispose
  end
  
  def return_scene
    SceneManager.return
  end
  
  def update
    super
    update_all_windows
    @help_window.update
    @rep_window.update
    if @rep_window.active
      update_rep_selection
    end
  end
  
  def update_rep_selection
    if Input.trigger?(Input::
      Sound.play_cancel
      return_scene
    end
  end
  
end 
=end