=begin
===============================================================================
 Scene_CoupleList by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can see all couples in server.
--------------------------------------------------------------------------------
Used functions:

coupleList

Call:

SceneManager.call(Scene_CoupleList)

=end

module EFE
  CL_HEADER_TEXT = "Couple List"
end


class Window_HeaderCoupleList < Window_Base

  def initialize(x, y, text)
    super(x, y, 250, fitting_height(1))
    refresh(text)
  end
  
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

class Window_CoupleListCommand < Window_Command
  
  def initialize(x, y)
    super(x, y)
  end

  def draw_item(text)
    rect = item_rect_for_text(text)
    text = command_name(text)
    draw_icon(122, 90, rect.y, true)
    draw_text(0, rect.y, 90, line_height, text.split(':')[0], 1)
    draw_text(120, rect.y, 105, line_height, text.split(':')[1], 1)
    
  end
  def window_width
    return 250
  end
  def window_height
    Graphics.height - 100
  end
  def make_command_list
    coupleListe = coupleList()#<< method
    coupleListe.each {|i| add_command(i, i)  }
  end

end

class Scene_CoupleList < Scene_Base
  
  def start
    super
    create_background
    create_CoupleList_command
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_CoupleList_command
    @CoupleList_command_window = Window_CoupleListCommand.new(147, 50)
    @headercouplelist = Window_HeaderCoupleList.new(147, 0, EFE::CL_HEADER_TEXT)
    @CoupleList_command_window.set_handler(:cancel,    method(:returning))
    @CoupleList_command_window.set_handler(:ok,    method(:guild_ok))
  end

  def returning
    return_scene
  end
  
  def guild_ok
    @CoupleList_command_window.activate
  end
  
  
end 