=begin
===============================================================================
 Scene_BazaarSell by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can sell item/weapon/armor which chosen in
 Scene_BazaarItemList
--------------------------------------------------------------------------------
Used functions:

checkMultiLogin
canSellBazaar?
bazaarSell
updatePlayer

Call:

SceneManager.call(Scene_BazaarSell)
SceneManager.scene.prepare(item)

item : chosen item in Scene_BazaarItemList

=end

module EFE
  BS_PPP_TEXT = "PPP"
  BS_PUTONBAZAAR_BUTTON = "Put on Bazaar"
  BS_CANCEL_BUTTON = "Cancel"
  BS_COUNT_TEXT = "Count"
  BS_SELLER_TEXT = "Seller"
  BS_SUCCESS = "Item sent bazaar successfully"
  BS_FAIL = "Couldn't put item on bazaar"
  BS_MAX_REACHED = "Maximum count of stalls reached"
  BS_PRICE = "Avg. Price"
end

class Window_HelpBazaarSell < Window_Base

  def initialize(x, y, text)
    super(x, y, 300, fitting_height(1))
    refresh(text)
  end
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end
end

class Window_BazaarSellPrice < Window_Selectable

  attr_reader   :number              

  def initialize(x, y, height, number)
    super(x, y, window_width, height)
    @max = 1
    @number = number
    @currency_unit = Vocab::currency_unit
  end

  def window_width
    return 150
  end

  def set(max, currency_unit = nil)
    @max = max
    @currency_unit = currency_unit if currency_unit
    @number = number
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
    draw_text(0, 0, contents_width, line_height, EFE::BS_PPP_TEXT + " : ")
    draw_text(0, 0, contents_width - 10, line_height, @number, 2)
  end


  def cursor_width
    figures * 10 + 40
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
    if Input.press?(:A) && Input.press?(:UP) && Input.press?(:RIGHT) then change_number(10000)
    elsif Input.press?(:A) && Input.press?(:DOWN) && Input.press?(:LEFT) then change_number(-10000)
    elsif Input.press?(:A) && Input.press?(:UP) then change_number(1000)
    elsif Input.press?(:A) && Input.press?(:DOWN) then change_number(-1000)
    elsif Input.press?(:A) && Input.repeat?(:RIGHT) then change_number(100)
    elsif Input.press?(:A) && Input.repeat?(:LEFT) then change_number(-100)
    else
      change_number(1)   if Input.repeat?(:RIGHT)
      change_number(-1)  if Input.repeat?(:LEFT)
      change_number(10)  if Input.repeat?(:UP)
      change_number(-10) if Input.repeat?(:DOWN)
    end
  end

  def change_number(amount)
    @number = [[@number + amount, @max].min, 1].max
  end

  def update_cursor
    cursor_rect.set(cursor_x, 0, cursor_width, line_height)
  end

end

class Window_BazaarSellAccept < Window_HorzCommand

  def initialize(x, y)
    super(x, y)
  end

  def window_width
    return 300
  end

  def col_max
    return 2
  end

  def make_command_list
    add_command(EFE::BS_PUTONBAZAAR_BUTTON,   :accept)
    add_command(EFE::BS_CANCEL_BUTTON, :cancel)
  end
end

class Window_BazaarSellNumber < Window_Selectable

  attr_reader   :number              

  def initialize(x, y, height)
    super(x, y, window_width, height)
    @max = 1
    @number = 1
    @currency_unit = Vocab::currency_unit
  end

  def window_width
    return 150
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
    draw_text(0, 0, contents_width, line_height, EFE::BS_COUNT_TEXT + " : ")
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


class Window_BazaarSellDetails < Window_Base

  def initialize(x, y, item)
    super(x, y, 300, fitting_height(3))
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
    draw_item_name(item, 0,7)
    draw_horz_line(27)
    draw_text_ex(0, 43, EFE::BS_SELLER_TEXT + " : " + $game_variables[ASOE::VAR_ACCOUNTNAME])
    draw_text_ex(140,43, EFE::BS_PRICE + " : " + item.price.to_s)
    end

end

#-------------------------------------------------------------------------------
# Scene_BazaarSell by Efeberk
#
#-------------------------------------------------------------------------------
class Scene_BazaarSell < Scene_Base
  
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
    @details = Window_BazaarSellDetails.new(0, 0, @item)
    @details.x = (Graphics.width / 2) - (@details.width / 2)
    @details.y = (Graphics.height / 2) - (@details.height / 2)
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_number
    @number_window = Window_BazaarSellNumber.new(@details.x , @details.y + @details.height, 50)
    @number_window.set($game_party.item_number(@item), Vocab::currency_unit)
    @number_window.set_handler(:ok,     method(:on_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
    @number_window.activate
  end
  
  def create_others
    x = @details.x + (@details.width / 2)
    y = @details.y + @details.height
    @bazaar_price = Window_BazaarSellPrice.new(x, y, 50, @item.price)
    @bazaar_price.set(999999, Vocab::currency_unit)
    @bazaar_price.set_handler(:ok,     method(:on_price_ok))
    @bazaar_price.set_handler(:cancel, method(:on_price_cancel))
    @bazaar_price.hide
    @bazaar_accept = Window_BazaarSellAccept.new(0, 0)
    @bazaar_accept.set_handler(:accept,    method(:accept_ok))
    @bazaar_accept.set_handler(:cancel,    method(:accept_cancel))
    @bazaar_accept.deactivate.hide
    @helpbazaarsold = Window_HelpBazaarSell.new(@number_window.x, @number_window.y + @number_window.height + 50, "PPP = Price Per Piece")
  end
  
  def on_price_ok
    x = @details.x + (@details.width / 2)
    y = @details.y + @details.height
    @bazaar_accept.x = @details.x
    @bazaar_accept.y = y + @bazaar_price.height
    @bazaar_accept.show.activate
    @bazaar_price.deactivate
  end
  
  def on_price_cancel
    @bazaar_price.deactivate.hide
    @number_window.activate
  end
  
  def on_number_cancel
    return_scene
  end
  
  def on_number_ok
    x = @details.x + (@details.width / 2)
    y = @details.y + @details.height
    text = (@item.price * @number_window.number).to_s
    @bazaar_price.x = x
    @bazaar_price.y = y
    @bazaar_price.show.activate
  end
  
  def accept_ok
    seller = $game_variables[ASOE::VAR_ACCOUNTNAME]
    type = 0 if @item.is_a?(RPG::Item)
    type = 1 if @item.is_a?(RPG::Weapon)
    type = 2 if @item.is_a?(RPG::Armor)
    item_id = @item.id
    price = @bazaar_price.number
    count = @number_window.number
    if ASOE_BAZAAR.canSellBazaar?(ASOE::VAR_ACCOUNTNAME)
      if ASOE_BAZAAR.bazaarSell(seller, type, item_id, count, price)
        return_scene
        $game_party.lose_item(@item, count)
        ASOE_CORE.updateAccount(ASOE::VAR_ACCOUNTNAME)
        messagebox(EFE::BS_SUCCESS, 300)
      else
        return_scene
        messagebox(EFE::BS_FAIL, 250)
      end
    else
      return_scene
      messagebox(EFE::BS_MAX_REACHED, 350)
    end
  end
  
  def accept_cancel
    @bazaar_accept.deactivate.hide
    @bazaar_price.activate
  end
  
  def lose_item(item_type, item_id, count)
    item = $data_items[item_id] if item_type == 0
    item = $data_weapons[item_id] if item_type == 1
    item = $data_armors[item_id] if item_type == 2
    $game_party.lose_item(item, count)
    ASOE_CORE.updateAccount(ASOE::VAR_ACCOUNTNAME)
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