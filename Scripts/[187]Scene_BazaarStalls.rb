=begin
===============================================================================
 Scene_BazaarStalls by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can see her/his stalls in Bazaar.
--------------------------------------------------------------------------------
Used functions:

bazaarStalls
bazaarRemove
bazaarItem
updatePlayer

Call:

SceneManager.call(Scene_BazaarStalls)

=end

module EFE
  BST_REMOVE_BUTTON = "Remove"
  BST_CANCEL_BUTTON = "Cancel"
  BST_REMAINING_TEXT = "Remaining"
  BST_PRICE_TEXT = "Price"
  BST_RECEIVED_TEXT = "Received"
  BST_SUCCESS = "Removed succesfully"
  BST_FAIL = "Couldn't remove, you still have earnings left!"
  BST_HEADER_TEXT = "Your Stalls"
end

class Window_BazaarStallsAccept < Window_HorzCommand

  def initialize(x, y)
    super(x, y)
  end

  def window_width
    return 200
  end

  def col_max
    return 2
  end

  def make_command_list
    add_command(EFE::BST_REMOVE_BUTTON,   :accept)
    add_command(EFE::BST_CANCEL_BUTTON, :cancel)
  end
end

class Window_HeaderBazaarStalls < Window_Base

  def initialize(x, y, text)
    super(x, y, 200, fitting_height(1))
    refresh(text)
  end
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end
end

class Window_BazaarStallsCommand < Window_Command
  
  attr_reader   :id
  attr_reader   :received
  
  def initialize(x, y)
    @received = 0
    @id = 0
    super(x, y)
  end

  def draw_item(text)
    rect = item_rect_for_text(text)
    text = command_name(text)
    text = text.split(':')
    @id = text[0].to_i
    item_type = text[1].to_i
    item_id = text[2].to_i
    item_count = text[3].to_i
    price = text[4].to_i
    received = text[5].to_i
    @received = received
    item = $data_items[item_id] if item_type == 0
    item = $data_weapons[item_id] if item_type == 1
    item = $data_armors[item_id] if item_type == 2
    draw_item_name(item, rect.x,rect.y)
    draw_icon(261, rect.x, rect.y + 24)
    draw_text(rect.x + 24, rect.y + 24 , contents_width, line_height, EFE::BST_REMAINING_TEXT + " : " + item_count.to_s, 0)
    draw_icon(361, rect.x, rect.y + 48)
    draw_text(rect.x + 24, rect.y + 48, contents_width, line_height, EFE::BST_PRICE_TEXT + " : " + price.to_s + Vocab::currency_unit, 0)
    draw_icon(262, rect.x, rect.y + 72)
    if received > 0 then change_color(text_color(14)) end
    draw_text(rect.x + 24, rect.y + 72, contents_width, line_height, EFE::BST_RECEIVED_TEXT + " : " + received.to_s + Vocab::currency_unit, 0)
    change_color(normal_color)
  end
  
  def window_width
    return 200
  end
  
  def item_height
    return 96
  end
  
  def window_height
    Graphics.height - 100
  end
  
  def make_command_list
    bazaarStallList = ASOE_BAZAAR.bazaarStalls(ASOE::VAR_ACCOUNTNAME)
    if(bazaarStallList.length > 0)
      bazaarStallList.each {|i| add_command(i, i)  }
    end
  end
end

class Scene_BazaarStalls < Scene_Base
  
  def start
    super
    create_background
    create_BazaarStalls_command
    create_accept
  end
  
  def create_accept
    x = @bazaarStalls_command_window.x
    y = @bazaarStalls_command_window.y + @bazaarStalls_command_window.height
    @accept_window = Window_BazaarStallsAccept.new(x, y)
    @accept_window.set_handler(:cancel,    method(:accept_cancel))
    @accept_window.set_handler(:accept,    method(:accept_ok))
    @accept_window.hide.deactivate
  end
  
  def accept_cancel
    @accept_window.hide.deactivate
    @bazaarStalls_command_window.activate
  end
    
  def accept_ok
    shop_id = @bazaarStalls_command_window.id
    result = ASOE_BAZAAR.bazaarItem(shop_id)
    item_type = result[0].to_i
    item_id = result[1].to_i
    item_count = result[2].to_i
    item = $data_items[item_id] if item_type == 0
    item = $data_weapons[item_id] if item_type == 1
    item = $data_armors[item_id] if item_type == 2
    if ASOE_BAZAAR.bazaarRemove(shop_id)
      $game_party.gain_item(item, item_count)
      ASOE_CORE.updateAccount(ASOE::VAR_ACCOUNTNAME)
      return_scene
      messagebox(EFE::BST_SUCCESS, 250)
    else
      return_scene
      messagebox(EFE::BST_FAIL, 250)
    end
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_BazaarStalls_command
    @bazaarStalls_command_window = Window_BazaarStallsCommand.new(Graphics.width / 2 - 100, 50)
    @headerbazaarstalls = Window_HeaderBazaarStalls.new(Graphics.width / 2 - 100, 0, EFE::BST_HEADER_TEXT)
    @bazaarStalls_command_window.set_handler(:cancel,    method(:returning))
    @bazaarStalls_command_window.set_handler(:ok,    method(:bazaarstall_ok))
  end

  def returning
    return_scene
  end
  
  def bazaarstall_ok
    @accept_window.show.activate
    @bazaarStalls_command_window.deactivate
  end
end 