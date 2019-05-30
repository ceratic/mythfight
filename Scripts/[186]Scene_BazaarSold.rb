=begin
===============================================================================
 Scene_BazaarSold by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can see her/his items which bought by another
 player in Bazaar. Player can withdraw his money.
--------------------------------------------------------------------------------
Used functions:

bazaarSold
bazaarReceive
updatePlayer

Call:

SceneManager.call(Scene_BazaarSold)

=end

module EFE
  BSO_RECEIVE_BUTTON = "Receive"
  BSO_CANCEL_BUTTON = "Cancel"
  BSO_SOLDCOUNT_TEXT = "Sold Count"
  BSO_REWARD_TEXT = "Reward"
  BSO_SUCCESS = "Reward received succesfully"
  BSO_FAIL = "Couldn't receive reward"
  BSO_HEADER_TEXT = "Sold Items"
end

class Window_BazaarSoldAccept < Window_HorzCommand

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
    add_command(EFE::BSO_RECEIVE_BUTTON,   :accept)
    add_command(EFE::BSO_CANCEL_BUTTON, :cancel)
  end
end

class Window_HeaderBazaarSold < Window_Base

  def initialize(x, y, text)
    super(x, y, 200, fitting_height(1))
    refresh(text)
  end
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end
end

class Window_BazaarSoldCommand < Window_Command
  
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
    received = text[4].to_i
    @received = received
    item = $data_items[item_id] if item_type == 0
    item = $data_weapons[item_id] if item_type == 1
    item = $data_armors[item_id] if item_type == 2
    draw_item_name(item, rect.x,rect.y)
    draw_icon(269, rect.x, rect.y + 24)
    draw_text(rect.x + 24, rect.y + 24 , contents_width, line_height, EFE::BSO_SOLDCOUNT_TEXT + " : " + item_count.to_s, 0)
    draw_icon(262, rect.x, rect.y + 48)
    draw_text(rect.x + 24, rect.y + 48, contents_width, line_height, EFE::BSO_REWARD_TEXT + " : " + received.to_s + Vocab::currency_unit, 0)
  end
  
  def window_width
    return 200
  end
  
  def item_height
    return 72
  end
  
  def window_height
    Graphics.height - 100
  end
  
  def make_command_list
    bazaarSoldList = ASOE_BAZAAR.bazaarSold(ASOE::VAR_ACCOUNTNAME)
    if(bazaarSoldList.length > 0)
      bazaarSoldList.each {|i| add_command(i, i)  }
    end
  end
end

class Scene_BazaarSold < Scene_Base
  
  def start
    super
    create_background
    create_BazaarSold_command
    create_accept
  end
  
  def create_accept
    x = @bazaarSold_command_window.x
    y = @bazaarSold_command_window.y + @bazaarSold_command_window.height
    @accept_window = Window_BazaarSoldAccept.new(x, y)
    @accept_window.set_handler(:cancel,    method(:accept_cancel))
    @accept_window.set_handler(:accept,    method(:accept_ok))
    @accept_window.hide.deactivate
  end
  
  def accept_cancel
    @accept_window.hide.deactivate
    @bazaarSold_command_window.activate
  end
    
  def accept_ok
    shop_id = @bazaarSold_command_window.id
    received = @bazaarSold_command_window.received
    if ASOE_BAZAAR.bazaarReceive(shop_id, received)
      $game_party.gain_gold(received)
      ASOE_CORE.updateAccount(ASOE::VAR_ACCOUNTNAME)
      return_scene
      messagebox(EFE::BSO_SUCCESS, 250)
    else
      return_scene
      messagebox(EFE::BSO_FAIL, 250)
    end
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_BazaarSold_command
    @bazaarSold_command_window = Window_BazaarSoldCommand.new(Graphics.width / 2 - 100, 50)
    @headerbazaarsold = Window_HeaderBazaarSold.new(Graphics.width / 2 - 100, 0, EFE::BSO_HEADER_TEXT)
    @bazaarSold_command_window.set_handler(:cancel,    method(:returning))
    @bazaarSold_command_window.set_handler(:ok,    method(:bazaarsold_ok))
  end

  def returning
    return_scene
  end
  
  def bazaarsold_ok
    @accept_window.show.activate
    @bazaarSold_command_window.deactivate
  end
end 