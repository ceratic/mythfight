=begin
===============================================================================
 Scene_GuildIcons by efeberk
 Version: RGSS3
===============================================================================
 This script will allow to open icons window that you can select your guild 
 icon.
--------------------------------------------------------------------------------
Used functions:

guildExists?
createGuild

Call:

SceneManager.call(Scene_Icons)

Note : Before call this window, guild name must be set

=end

module EFE
  GUILD_ICONS = [96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,
  111,112,113,114,115,116,117,118,119,120]
  GC_HEADER_TEXT = "Select icon for your guild"
  GC_ACCEPT_BUTTON = "Accept"
  GC_CANCEL_BUTTON = "Cancel"
  GC_MSGBOX_SUCCESS = "Guild has been created succesfully"
  GC_MSGBOX_ERROR = "Guild couldn't be created."
  GC_MSGBOX_EXISTS = "Guild name already exists in the system"
end

class Window_SelectGuildIcon < Window_HorzCommand
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    300
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 2
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(EFE::GC_ACCEPT_BUTTON,   :accept)
    add_command(EFE::GC_CANCEL_BUTTON, :cancel)
  end
end
class Window_HeaderGuildIcon < Window_Base

  def initialize(x, y, text)
    super(x, y, 300, fitting_height(1))
    refresh(text)
  end
  
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end
class Window_IconsCommand < Window_Command
  
  def initialize(x, y)
    super(x, y)
  end

  def draw_item(index)
    rect = item_rect(index)
    draw_icon(EFE::GUILD_ICONS[index], rect.x + 1, rect.y, true)
    
  end
  
  def col_max
    return 5
  end
  
  def window_width
    return 300
  end
  def window_height
    return [(EFE::GUILD_ICONS.length / col_max) * 30, 400].min
  end
  def make_command_list
    EFE::GUILD_ICONS.each {|i| add_command(i, i) }
  end

end

class Scene_GuildIcons < Scene_Base
  
  def start
    super
    create_background
    create_icons_command
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_icons_command
    @hicons_command_window = Window_HeaderGuildIcon.new(122, 0, EFE::GC_HEADER_TEXT)
    @icons_command_window = Window_IconsCommand.new(122, 50)
    @createGuild_command_window = Window_SelectGuildIcon.new(122, 200)
    @createGuild_command_window.set_handler(:accept,    method(:guild_accept))
    @createGuild_command_window.set_handler(:cancel,    method(:guild_cancel))
    @createGuild_command_window.visible = false
    @icons_command_window.set_handler(:cancel,    method(:returning))
    @icons_command_window.set_handler(:ok,    method(:icons_ok))
  end

  def returning
    return_scene
  end

  def guild_accept
    $game_variables[ASOE::VAR_GUILD_ICON] = @icons_command_window.current_symbol.to_s
    if !ASOE_GUILD.guildExists?(ASOE::VAR_GUILD_NAME)
      if ASOE_GUILD.createGuild(ASOE::VAR_ACCOUNTNAME, ASOE::VAR_GUILD_NAME,ASOE::VAR_GUILD_ICON)
        return_scene
        messagebox(EFE::GC_MSGBOX_SUCCESS, 350)
      else
        return_scene
        messagebox(EFE::GC_MSGBOX_ERROR, 250)
      end
    else
      return_scene
      messagebox(EFE::GC_MSGBOX_EXISTS, 350)
    end
      
  end
  
  def icons_ok
    @createGuild_command_window.visible = true
    @createGuild_command_window.activate
  end
  
  def guild_cancel
    @icons_command_window.activate
    @createGuild_command_window.visible = false
  end
end 

