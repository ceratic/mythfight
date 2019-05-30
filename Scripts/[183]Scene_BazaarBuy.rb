=begin
===============================================================================
 Scene_BazaarBuy by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can buy chosen item/weapon/armor in Scene_Bazaar
--------------------------------------------------------------------------------
Used functions:

checkMultiLogin
canBuyBazaar?
bazaarBuy
updatePlayer

Call:

SceneManager.call(Scene_BazaarBuy)
SceneManager.scene.prepare(item)

item : chosen item in Scene_Bazaar

=end

module EFE
  BB_BUYITEM_BUTTON = "Buy Item"
  BB_CANCEL_BUTTON = "Cancel"
  BB_COUNT_TEXT = "Count"
  BB_SELLER_TEXT = "Seller"
  BB_SUCCESS = "Bought item succesfully"
  BB_FAIL = "Couldn't buy item"
  BB_INS_GOLD = "Insufficient gold"
end

class Window_BazaarPrice < Window_Base

  def initialize(x, y)
    super(x, y, 125, fitting_height(1))
  end
  
  
  def refresh(text)
    contents.clear
    draw_text(0, 0, contents_width, line_height, text + Vocab::currency_unit, 1)
  end

end

class Window_BazaarAccept < Window_HorzCommand

  def initialize(x, y)
    super(x, y)
  end

  def window_width
    return 250
  end

  def col_max
    return 2
  end

  def make_command_list
    add_command(EFE::BB_BUYITEM_BUTTON,   :accept)
    add_command(EFE::BB_CANCEL_BUTTON, :cancel)
  end
end

class Window_BazaarNumber < Window_Selectable

  attr_reader   :number              

  def initialize(x, y, height)
    super(x, y, window_width, height)
    @max = 1
    @number = 1
    @currency_unit = Vocab::currency_unit
  end

  def window_width
    return 125
  end

  def set(max, currency_unit = nil)
    @max = max
    @currency_unit = currency_unit if currency_unit
    @number = 1
    refresh
  end

  def currency_unit=(currency_unit)
    @currency_unit = currency_unit
    refresh
  end

  def refresh
    contents.clear
    draw_number
  end

  def draw_number
    change_color(normal_color)
    draw_text(0, 0, contents_width, line_height, EFE::BB_COUNT_TEXT + " : ")
    draw_text(0, 0, contents_width - 10, line_height, @number, 2)
  end


  def cursor_width
    figures * 10 + 12
  end

  def cursor_x
    contents_width - cursor_width - 4
  end

  def figures
    return 2
  end

  def update
    super
    if active
      last_number = @number
      update_number
      if @number != last_number
        Sound.play_cursor
        refresh
      end
    end
  end

  def update_number
    change_number(1)   if Input.repeat?(:RIGHT)
    change_number(-1)  if Input.repeat?(:LEFT)
    change_number(10)  if Input.repeat?(:UP)
    change_number(-10) if Input.repeat?(:DOWN)
  end

  def change_number(amount)
    @number = [[@number + amount, @max].min, 1].max
  end

  def update_cursor
    cursor_rect.set(cursor_x, 0, cursor_width, line_height)
  end
end


class Window_BazaarDetails < Window_Base

  def initialize(x, y, item)
    super(x, y, 250, fitting_height(3))
    refresh(item)
  end
  
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
  
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, line_color)
  end
  
  def refresh(item)
    item_type = item[2].split(':')[0].to_i
    item_id = item[2].split(':')[1].to_i
    item_result = $data_items[item_id] if item_type == 0
    item_result = $data_weapons[item_id] if item_type == 1
    item_result = $data_armors[item_id] if item_type == 2
    draw_item_name(item_result, 0,7)
    draw_horz_line(27)
    draw_text_ex(0, 43, EFE::BB_SELLER_TEXT + " : " + item[1])
  end

end


class Scene_BazaarBuy < Scene_Base
  
  def prepare(item)
    @item = item
  end
  
  def start
    super
    create_background
    create_details
    create_number
    create_others
  end
  
  def create_details
    @details = Window_BazaarDetails.new(0, 0, @item)
    @details.x = (Graphics.width / 2) - (@details.width / 2)
    @details.y = (Graphics.height / 2) - (@details.height / 2)
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_number
    @number_window = Window_BazaarNumber.new(@details.x , @details.y + @details.height, 50)
    @number_window.set(@item[2].split(':')[2].to_i, Vocab::currency_unit)
    @number_window.set_handler(:ok,     method(:on_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
    @number_window.activate
  end
  
  def create_others
    @bazaar_price = Window_BazaarPrice.new(0, 0)
    @bazaar_price.hide
    @bazaar_accept = Window_BazaarAccept.new(0, 0)
    @bazaar_accept.set_handler(:accept,    method(:accept_ok))
    @bazaar_accept.set_handler(:cancel,    method(:accept_cancel))
    @bazaar_accept.deactivate.hide
  end
  
  def on_number_cancel
    return_scene
  end
  
  def on_number_ok
    x = @details.x + (@details.width / 2)
    y = @details.y + @details.height
    text = (@item[3].to_i * @number_window.number).to_s
    @bazaar_price.x = x
    @bazaar_price.y = y
    @bazaar_price.refresh(text)
    @bazaar_price.show
    @bazaar_accept.x = @details.x
    @bazaar_accept.y = y + @bazaar_price.height
    @bazaar_accept.show.activate
  end
  
  def accept_ok
    type = @item[2].split(':')[0].to_i
    id = @item[0].to_i
    item_id = @item[2].split(':')[1].to_i
    price = @item[3].to_i #* @number_window.number
    count = @number_window.number
    if ASOE_BAZAAR.canBuyBazaar?(ASOE::VAR_ACCOUNTNAME, price*count)
      if ASOE_BAZAAR.bazaarBuy(id, price, count)
        return_scene
        gain_item(type, item_id, count, price)
        ASOE_CORE.updateAccount(ASOE::VAR_ACCOUNTNAME)
        messagebox(EFE::BB_SUCCESS, 200)
      else
        return_scene
        messagebox(EFE::BB_FAIL, 200)
      end
    else
      return_scene
      messagebox(EFE::BB_INS_GOLD, 200)
    end
  end
  
  def accept_cancel
    @bazaar_accept.deactivate.hide
    @bazaar_price.hide
    @number_window.activate
  end
  
  def gain_item(item_type, item_id, count, price)
    item = $data_items[item_id] if item_type == 0
    item = $data_weapons[item_id] if item_type == 1
    item = $data_armors[item_id] if item_type == 2
    $game_party.gain_item(item, count)
    $game_party.lose_gold(count * price)
  end
  
  def max_buy
    max = $game_party.max_item_number(@item) - $game_party.item_number(@item)
    buying_price == 0 ? max : [max, money / buying_price].min
  end

  def max_sell
    $game_party.item_number(@item)
  end

  def money
    $game_party.gold
  end


  def buying_price
    @buy_window.price(@item)
  end
  
end