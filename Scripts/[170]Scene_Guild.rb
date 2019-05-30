=begin
===============================================================================
 Scene_Guild by efeberk
 Version: RGSS3
===============================================================================
 This script will allow to open guild details of player.
--------------------------------------------------------------------------------
Used functions:

guildInfos
guildMembers

Call:

SceneManager.call(Scene_Guild)

=end

module EFE
  SEX_ICONS = [191, 188]
  G_MESSAGE_TEXT = "Message";
  G_POINTS_TEXT = "Points"
  G_GOLD_TEXT = "Gold"
  G_WELCOME_TEXT = "Welcome"
  G_TOTAL_MMBRS_TEXT = "Total Members"
  G_OWNER_TEXT = "Owner"
end

class Window_GuildMessage < Window_Base

  def initialize(x, y, text, text2, text3)
    super(x, y, 250, fitting_height(5))
    refresh(text, text2, text3)
  end
  
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, line_color)
  end
  
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
  
  def refresh(text, text2, text3)
    draw_text(0, 0, contents_width, line_height, EFE::G_MESSAGE_TEXT, 1)
    draw_horz_line(12)
    draw_text(0, 25, contents_width, line_height, text, 1)
    draw_text(0, 75, 75, line_height, EFE::G_POINTS_TEXT, 1)
    draw_horz_line(87)
    draw_text(0, 100, 75, line_height, text2, 1)
    draw_text(0, 75, contents_width, line_height, EFE::G_GOLD_TEXT, 2)
    draw_text(0, 100, contents_width, line_height, text3, 2)
  end

end


class Window_GuildName < Window_Base

  def initialize(x, y, text, icon)
    super(x, y, 250, fitting_height(2))
    refresh(text, icon)
  end
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, line_color)
  end
  
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
  
  def refresh(text,icon)
    draw_icon(icon.to_i, 0, 0, true)
    draw_text(0, 0, contents_width, line_height, text, 1)
    draw_horz_line(12)
    draw_text(0, 25, contents_width, line_height, EFE::G_WELCOME_TEXT, 1)
  end

end

class Window_GuildTotal < Window_Base

  def initialize(x, y, text)
    super(x, y, 170, fitting_height(2))
    refresh(text)
  end
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, line_color)
  end
  
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, EFE::G_TOTAL_MMBRS_TEXT, 1)
    draw_horz_line(12)
    draw_text(0, 25, contents_width, line_height, text, 1)
  end

end

class Window_GuildMemberList < Window_Command
  
  def initialize(x, y)
    super(x, y)
  end

  def draw_item(item)
    rect = item_rect_for_text(item)
    item = command_name(item)
    draw_icon(EFE::SEX_ICONS[item.split(';')[1].to_i - 1], rect.x, rect.y, true)
    draw_text(rect.x, rect.y, contents_width, line_height, item.split(';')[0], 1)
    
  end
  def window_width
    return 170
  end
  def window_height
    Graphics.height - 146
  end
  def make_command_list
    guildAllMembers = ASOE_GUILD.guildMembers(ASOE::VAR_GUILD_NAME)
    guildAllMembers.each {|i| add_command(i, i) }
  end

end
class Window_GuildOwner < Window_Base

  def initialize(x, y, text)
    super(x, y, 170, fitting_height(2))
    refresh(text)
  end
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, line_color)
  end
  
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, EFE::G_OWNER_TEXT, 1)
    draw_horz_line(12)
    draw_text(0, 25, contents_width, line_height, text, 1)
  end

end

class Scene_Guild < Scene_Base
  
  def start
    super
    create_background
    create_items
  end
  
  def create_items
    guildInfos = ASOE_GUILD.guildInfo(ASOE::VAR_GUILD_NAME)
    @guildowner = Window_GuildOwner.new(330, 0, guildInfos[0])
    @guildname = Window_GuildName.new(80, 0, $game_variables[ASOE::VAR_GUILD_NAME], guildInfos[1])
    @guildmessage = Window_GuildMessage.new(80, 73, guildInfos[2], guildInfos[3], guildInfos[4]) #.gsub(/[^0-9]/))
    @guildmembers = Window_GuildMemberList.new(330, 73)
    @guildmembers.set_handler(:cancel,    method(:return_scene))
    @guildtotal = Window_GuildTotal.new(330, Graphics.height - 73, (@guildmembers.item_max).to_s)
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
end