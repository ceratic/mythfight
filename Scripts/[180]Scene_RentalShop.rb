=begin
===============================================================================
 Scene_RentalShop by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can buy items from rental shop which rented 
 from another player.
--------------------------------------------------------------------------------
Used functions:

getShop
sendFee
updatePlayer

Call:

SceneManager.call(Scene_RentalShop)

Note : Must check user is owner of the rental shop.
If true, user shouldn't enter the rental shop. 

=end

module EFE
  RS_CHEAP_TEXT = "Cheap"
  RS_NORMAL_TEXT = "Normal"
  RS_HARD_TEXT = "Hard"
  RS_COULDNT_GET_DATAS = "Couldn't receive datas"
  RS_OWNER_TEXT = "Owner"
  RS_EXPV_TEXT = "Expensiveness"
  RS_GOLD_TEXT = "Your Gold"
end

class Window_RentalShopNumber < Window_Selectable

  attr_reader   :number              

  def initialize(x, y, height)
    super(x, y, window_width, height)
    @item = nil
    @max = 1
    @price = 0
    @number = 1
    @currency_unit = Vocab::currency_unit
  end

  def window_width
    return 304
  end

  def set(item, max, price, currency_unit = nil)
    @item = item
    @max = max
    @price = price
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
    draw_item_name(@item, 0, item_y)
    draw_number
    draw_total_price
  end

  def draw_number
    change_color(normal_color)
    draw_text(cursor_x - 28, item_y, 22, line_height, "×")
    draw_text(cursor_x, item_y, cursor_width - 4, line_height, @number, 2)
  end

  def draw_total_price
    width = contents_width - 8
    draw_currency_value(@price * @number, @currency_unit, 4, price_y, width)
  end

  def item_y
    contents_height / 2 - line_height * 3 / 2
  end

  def price_y
    contents_height / 2 + line_height / 2
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
    cursor_rect.set(cursor_x, item_y, cursor_width, line_height)
  end
end


class Window_RentalShopBuy < Window_Selectable

  attr_reader   :status_window            # Status window

  def initialize(x, y, height, shop_goods, expensiveness)
    super(x, y, window_width, height)
    @shop_goods = shop_goods
    @money = 0
    @expensiveness = expensiveness
    refresh
    select(0)
  end

  def window_width
    return 304
  end

  def item_max
    @data ? @data.size : 1
  end

  def item
    @data[index]
  end

  def money=(money)
    @money = money
    refresh
  end

  def current_item_enabled?
    enable?(@data[index])
  end

  def price(item)
    @price[item]
  end

  def enable?(item)
    item && price(item) <= @money && !$game_party.item_max?(item)
  end

  def refresh
    make_item_list
    create_contents
    draw_all_items
  end

  def make_item_list
    @data = []
    @price = {}
    @shop_goods.each do |goods|
      case goods[0]
      when 0;  item = $data_items[goods[1]]
      when 1;  item = $data_weapons[goods[1]]
      when 2;  item = $data_armors[goods[1]]
      end
      if item
        @data.push(item)
        if @expensiveness == EFE::RS_CHEAP_TEXT then @price[item] = item.price - (item.price / 2)  
        elsif @expensiveness == EFE::RS_NORMAL_TEXT then @price[item] = item.price  
        elsif @expensiveness == EFE::RS_HARD_TEXT then @price[item] = item.price + (item.price / 2)  
        end
      end
    end
  end

  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    rect.width -= 4
    draw_text(rect, price(item), 2)
  end
  
  def status_window=(status_window)
    @status_window = status_window
    call_update_help
  end
  
  def update_help
    @help_window.set_item(item) if @help_window
    @status_window.item = item if @status_window
  end
end


class Window_RentShopDetails < Window_Base
  
  def initialize(x, y, details)
    super(x, y, window_width, fitting_height(6))
    @name = details[0]
    @owner = details[1]
    @type = details[2]
    case details[3]
    when "0"
      @expensiveness = EFE::RS_CHEAP_TEXT
    when "1"
      @expensiveness = EFE::RS_NORMAL_TEXT
    when "2"
      @expensiveness = EFE::RS_HARD_TEXT
    end
    @fee = details[4]
    refresh
  end

  def window_width
    return 220
  end
  
  def expensiveness
    @expensiveness
  end
  
  def currency_unit
    Vocab::currency_unit
  end

  def refresh
    contents.clear
    change_color(text_color(12))
    draw_text(0, 0, contents.width, line_height, @name, 1)
    change_color(normal_color)
    draw_text(0, 24, contents.width, line_height, EFE::RS_OWNER_TEXT + " : " + @owner, 1)
    draw_text(0, 60, contents.width, line_height, EFE::RS_EXPV_TEXT + " : " + @expensiveness, 1)
    change_color(text_color(14))
    draw_text(0, 100, contents.width, line_height, EFE::RS_GOLD_TEXT + " : " + $game_party.gold.to_s, 1)
    change_color(normal_color)
  end

end

class Scene_RentalShop < Scene_MenuBase

  def prepare
     @details = ASOE_VENDOR.getShop(ASOE::VAR_RENT_SHOP_ID)
     if @details == []
       return_scene
       messagebox(EFE::RS_COULDNT_GET_DATAS, 250)
     end
  end

  def start
    super
    create_help_window
    create_details_window
    create_buy_window
    create_number_window
  end

  def create_details_window
    
    @details_window = Window_RentShopDetails.new(280, 100, @details)
    @details_window.viewport = @viewport
  end

  def create_number_window
    wy = @help_window.y + @help_window.height
    wh = Graphics.height - @help_window.height
    @number_window = Window_RentalShopNumber.new(0, wy, wh)
    @number_window.viewport = @viewport
    @number_window.width = @buy_window.width + 50
    @number_window.hide
    @number_window.set_handler(:ok,     method(:on_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
  end

  def create_buy_window
    @goods = @details[5].split(':')
    @newgoods = []
    @goods.each {|i| @newgoods.push([@type.to_i, i.to_i, 0,0,0 ]) }
    wy = @help_window.y + @help_window.height
    wh = Graphics.height - (@help_window.height*2) + 22
    @buy_window = Window_RentalShopBuy.new(0, wy, wh, @newgoods, @details_window.expensiveness)
    @buy_window.width = @buy_window.width - 50 
    @buy_window.viewport = @viewport
    @buy_window.help_window = @help_window
    @buy_window.status_window = @status_window
    activate_buy_window
    @buy_window.set_handler(:ok,     method(:on_buy_ok))
    @buy_window.set_handler(:cancel, method(:on_buy_cancel))
  end

  def activate_buy_window
    @buy_window.money = money
    @buy_window.show.activate
  end

  def command_buy
    activate_buy_window
  end

  def on_buy_ok
    @item = @buy_window.item
    @buy_window.hide
    @details_window.x = @details_window.x + 35
    @number_window.set(@item, max_buy, buying_price, currency_unit)
    @number_window.show.activate
  end

  def on_buy_cancel
    SceneManager.return
  end

  def on_number_ok
    Sound.play_shop
    do_buy(@number_window.number)
    end_number_input
    @details_window.x = @details_window.x - 35
    @details_window.refresh
  end

  def on_number_cancel
    Sound.play_cancel
    @details_window.x = @details_window.x - 35
    end_number_input
  end

  def do_buy(number)
    $game_party.lose_gold(number * buying_price)
    $game_party.gain_item(@item, number)
    ASOE_VENDOR.sendFee(ASOE::VAR_RENT_SHOP_ID, number)
    ASOE_CORE.updateAccount(ASOE::VAR_ACCOUNTNAME)
  end

  def end_number_input
    @number_window.hide
    activate_buy_window
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

  def currency_unit
    @details_window.currency_unit
  end

  def buying_price
    @buy_window.price(@item)
  end
end
