=begin
===============================================================================
 Scene_BazaarItemList by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can choose items/weapons/armors to sell them on
 Bazaar.
--------------------------------------------------------------------------------
Used functions:

Call:

SceneManager.call(Scene_BazaarItemList)

=end

module EFE
  BI_HEADER_TEXT = "Bazaar"
end

class Window_HeaderBazaarSell < Window_Base

  def initialize(x, y, text)
    super(x, y, 544, fitting_height(1))
    refresh(text)
  end
  
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

class Window_BazaarSellCommand < Window_Command
  
  
  def initialize(x, y)
    @type = 0
    super(x, y)
  end

  def draw_item(item)
    rect = item_rect_for_text(item)
    item = command_name(item)
    draw_item_name(item, rect.x, rect.y, true)
    draw_text(rect.x, rect.y, contents_width / 2 - 30, line_height, $game_party.item_number(item), 2)
  end
  
  def window_width
    return 544
  end
  
  def type=(type)
    @type = type
  end
  
  def item_height
    return 24
  end
  
  def col_max
    return 2
  end
  
  def window_height
    Graphics.height - 125
  end
  
  def make_command_list
    items = $game_party.items + $game_party.weapons + $game_party.armors
    items.each {|i| add_command(i, i) }
  end

end

class Scene_BazaarItemList < Scene_Base
  
  def start
    super
    create_background
    create_Bazaar_command
    create_help
  end
  
  def update
    super
    if @Bazaar_command_window.current_symbol
      @help_window.set_text(@Bazaar_command_window.current_symbol.description)
    end
  end
  
  def create_help
    @help_window = Window_Help.new(2)
    @help_window.x = 0
    @help_window.y = Graphics.height - 75
  end
  
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_Bazaar_command
    @Bazaar_command_window = Window_BazaarSellCommand.new(0, 50)
    @headerbazaar = Window_HeaderBazaarSell.new(0, 0, EFE::BI_HEADER_TEXT)
    @Bazaar_command_window.set_handler(:cancel,    method(:bazaar_cancel))
    @Bazaar_command_window.set_handler(:ok,    method(:bazaar_ok))
    @Bazaar_command_window.refresh
    @Bazaar_command_window.activate
    @Bazaar_command_window.select(0)
  end
  
  def bazaar_cancel
    return_scene
  end
  
  def bazaar_ok
    SceneManager.call(Scene_BazaarSell)
    SceneManager.scene.prepare(@Bazaar_command_window.current_symbol)
  end
  
end 