=begin
===============================================================================
 Scene_GuildList by efeberk
 Version: RGSS3
===============================================================================
 This script will allow to open guild list window that contains all guilds in 
 server.
--------------------------------------------------------------------------------
Used functions:

guildList

Call:

SceneManager.call(Scene_GuildList)

=end

module EFE
  GL_JOIN_BUTTON = "Join"
  GL_CANCEL_BUTTON = "Cancel"
  GL_HEADER_TEXT = "Guild List"
  GL_JOIN_SUCCESS = "Joined succesfully"
  GL_JOIN_FAIL = "Couldn't join"
end

class Window_JoinGuild < Window_HorzCommand

  def initialize(x, y)
    super(x, y)
  end

  def window_width
    250
  end

  def col_max
    return 2
  end

  def make_command_list
    add_command(EFE::GL_JOIN_BUTTON,   :join)
    add_command(EFE::GL_CANCEL_BUTTON, :cancel)
  end
end

class Window_HeaderGuildList < Window_Base

  def initialize(x, y, text)
    super(x, y, 250, fitting_height(1))
    refresh(text)
  end
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

class Window_GuildListCommand < Window_Command
  
  def initialize(x, y)
    super(x, y)
  end

  def draw_item(index)
    rect = item_rect_for_text(index)
    draw_icon(command_name(index).split(':')[1].to_i, rect.x, rect.y, true)
    draw_text(rect.x, rect.y, contents_width, line_height, command_name(index).split(':')[0], 1)
  end
  
  def window_width
    return 250
  end
  
  def window_height
    Graphics.height - 100
  end
  
  def make_command_list
    guilds = ASOE_GUILD.guildList()#a method 
    guildSearch = "" if $guildSearch == 0
    guilds.each {|i| add_command(i, i.split(':')[0]) if i.split(':')[0].downcase.include?($guildSearch.to_s.downcase) }
  end

end

class Scene_GuildList < Scene_Base
  
  def start
    super
    create_background
    create_GuildList_command
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_GuildList_command
    @GuildList_command_window = Window_GuildListCommand.new(147, 50)
    @hRank_command_window = Window_HeaderGuildList.new(147, 0, EFE::GL_HEADER_TEXT)
    @joinGuild_command_window = Window_JoinGuild.new(147, Graphics.height - 50)
    @joinGuild_command_window.set_handler(:join,    method(:guild_join))
    @joinGuild_command_window.set_handler(:cancel,    method(:guild_cancel))
    @GuildList_command_window.set_handler(:cancel,    method(:returning))
    @GuildList_command_window.set_handler(:ok,    method(:guild_ok))
    @joinGuild_command_window.deactivate
    @joinGuild_command_window.visible = false
  end

  def returning
    return_scene
  end
  
  def guild_ok
    @joinGuild_command_window.visible = true
    @joinGuild_command_window.activate
  end
  
  def guild_join
    $game_variables[ASOE::VAR_GUILD_JOIN_NAME] = @GuildList_command_window.current_symbol
    $guildSearch = ""
    if ASOE_GUILD.joinGuild(ASOE::VAR_ACCOUNTNAME, ASOE::VAR_GUILD_JOIN_NAME)
      $game_variables[ASOE::VAR_GUILD_NAME] = $game_variables[ASOE::VAR_GUILD_JOIN_NAME]
      return_scene
      messagebox(EFE::GL_JOIN_SUCCESS, 250)
    else 
      return_scene
      messagebox(EFE::GL_JOIN_FAIL, 200)
    end
  end
  
  def guild_cancel
    @joinGuild_command_window.visible = false
    @joinGuild_command_window.deactivate
    @GuildList_command_window.activate
  end
end 