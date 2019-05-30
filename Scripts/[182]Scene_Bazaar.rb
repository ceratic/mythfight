=begin
===============================================================================
 Scene_Bazaar by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can see items/weapons/armors which selling by
 another players. Player can buy items from another player's stall.
--------------------------------------------------------------------------------
Used functions:

bazarList

Call:

SceneManager.call(Scene_Bazaar)

=end

module EFE
  B_ITEMS_BUTTON = "Items"
  B_WEAPONS_BUTTON = "Weapons"
  B_ARMORS_BUTTON = "Armors"
  B_HEADER_TEXT = "Bazaar"
end

class Window_HeaderBazaar < Window_Base

  def initialize(x, y, text)
    super(x, y, 544, fitting_height(1))
    refresh(text)
  end
  
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

class Window_BazaarItemCategory < Window_HorzCommand

  def initialize(x, y)
    super(x, y)
  end

  def window_width
    return 544
  end

  def col_max
    return 3
  end

  def make_command_list
    add_command(EFE::B_ITEMS_BUTTON,   :items)
    add_command(EFE::B_WEAPONS_BUTTON, :weapons)
    add_command(EFE::B_ARMORS_BUTTON, :armors)
  end
end

class Window_BazaarCommand < Window_Command
  
  
  def initialize(x, y)
    @type = 0
    super(x, y)
  end

  def draw_item(item)
    rect = item_rect_for_text(item)
    item = command_name(item)
    item_type = item[2].split(':')[0].to_i
    item_id = item[2].split(':')[1].to_i
    item_count = item[2].split(':')[2].to_i
    item_price = item[3].to_i
    case item_type
    when 0
      item_result = $data_items[item_id]
    when 1
      item_result = $data_weapons[item_id]
    when 2
      item_result = $data_armors[item_id]
    end
    draw_item_name(item_result, rect.x, rect.y, true)
    draw_text(rect.x, rect.y+24, contents_width, line_height, item_price.to_s + Vocab::currency_unit + " x" + item_count.to_s, 0)
  end
  
  def window_width
    return 544
  end
  
  def type=(type)
    @type = type
  end
  
  def item_height
    return 48
  end
  
  def col_max
    return 2
  end
  
  def window_height
    Graphics.height - 175
  end
  def make_command_list
    player_name = $game_variables[ASOE::VAR_ACCOUNTNAME]
    items = ASOE_BAZAAR.bazaarList
    items.each {|i| 
    i = i.split(';')
    if i[2].split(':')[0].to_i == @type && i[4] == "0" && player_name != i[1]
      add_command(i, i)  
    end
    }
  end

end

class Scene_Bazaar < Scene_Base
  
  def start
    super
    create_background
    create_Bazaar_command
    create_categories
    create_help
  end
  
  def update
    super
    if  @Bazaar_command_window.current_symbol
      type = @Bazaar_command_window.current_symbol[2].split(':')[0].to_i
      item_id = @Bazaar_command_window.current_symbol[2].split(':')[1].to_i
      item = $data_items[item_id] if type == 0
      item = $data_weapons[item_id] if type == 1
      item = $data_armors[item_id] if type == 2
      @help_window.set_text(item.description)
    end
  end
  
  def create_help
    @help_window = Window_Help.new(2)
    @help_window.x = 0
    @help_window.y = Graphics.height - 75
  end
  
  def create_categories
    @item_category = Window_BazaarItemCategory.new(0, 50)
    @item_category.set_handler(:ok,    method(:item_category_ok))
    @item_category.set_handler(:cancel,    method(:item_category_cancel))
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_Bazaar_command
    @Bazaar_command_window = Window_BazaarCommand.new(0, 100)
    @headerbazaar = Window_HeaderBazaar.new(0, 0, EFE::B_HEADER_TEXT)
    @Bazaar_command_window.set_handler(:cancel,    method(:bazaar_cancel))
    @Bazaar_command_window.set_handler(:ok,    method(:bazaar_ok))
    @Bazaar_command_window.deactivate
    @Bazaar_command_window.unselect
  end

  def item_category_cancel
    SceneManager.return
  end
  
  def item_category_ok
    @Bazaar_command_window.type = 0 if @item_category.current_symbol == :items
    @Bazaar_command_window.type = 1 if @item_category.current_symbol == :weapons
    @Bazaar_command_window.type = 2 if @item_category.current_symbol == :armors
    @Bazaar_command_window.refresh
    @Bazaar_command_window.activate
    @item_category.deactivate
    @Bazaar_command_window.select(0)
  end
  
  def bazaar_cancel
    @Bazaar_command_window.deactivate
    @item_category.activate
    @Bazaar_command_window.unselect
    @help_window.clear
  end
  
  def bazaar_ok
    SceneManager.call(Scene_BazaarBuy)
    SceneManager.scene.prepare(@Bazaar_command_window.current_symbol)
  end
  
end 