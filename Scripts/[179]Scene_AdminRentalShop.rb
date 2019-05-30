=begin
===============================================================================
 Scene_AdminRentalShop by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can withdraw gold which earned from owned
 rental shop.
--------------------------------------------------------------------------------
Used functions:

getAdminShop
withdrawShop

Call:

SceneManager.call(Scene_AdminRentalShop)

Note : Must check user has a rental shop before call the scene.
Note2 : Owner can't buy items from rented a shop by her/him.

=end

module EFE
  ARS_WITHDRAW_BUTTON = "Withdraw Gold"
  ARS_CANCEL_BUTTON = "Cancel"
  ARS_MSG_COULDNT_GET_DATA = "Couldn't get datas of the shop"
  ARS_CHEAP_TEXT = "Cheap"
  ARS_NORMAL_TEXT = "Normal"
  ARS_HARD_TEXT = "Hard"
  ARS_OWNER_TEXT = "Owner"
  ARS_EXPV_TEXT = "Expensiveness"
  ARS_GAINED_TEXT = "Gained Gold"
  ARS_REMAINING_TEXT = "Remaining Time"
  ARS_WITHDRAW_SUCCESS = "Withdrawed succesfully"
  ARS_WITHDRAW_FAIL = "Couldn't withdraw gold"
end

class Window_AdminRentCommands < Window_HorzCommand

  def initialize(x, y)
    super(x, y)
  end

  def window_width
    return 280
  end

  def item_width
    return 120
  end
  
  def col_max
    return 2
  end

  def make_command_list
    add_command(EFE::ARS_WITHDRAW_BUTTON,   :withdraw)
    add_command(EFE::ARS_CANCEL_BUTTON, :cancel)
  end
end

class Window_AdminRentalShopBuy < Window_Selectable

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
        if @expensiveness == EFE::ARS_CHEAP_TEXT then @price[item] = item.price - (item.price / 2)  
        elsif @expensiveness == EFE::ARS_NORMAL_TEXT then @price[item] = item.price  
        elsif @expensiveness == EFE::ARS_HARD_TEXT then @price[item] = item.price + (item.price / 2)  
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


class Window_AdminRentShopDetails < Window_Base
  
  attr_reader   :gained 
  
  def initialize(x, y, details)
    super(x, y, window_width, fitting_height(7))
    @name = details[0]
    @owner = details[1]
    @type = details[2]
    case details[3]
    when "0"
      @expensiveness = EFE::ARS_CHEAP_TEXT
    when "1"
      @expensiveness = EFE::ARS_NORMAL_TEXT
    when "2"
      @expensiveness = EFE::ARS_HARD_TEXT
    end
    @fee = details[4]
    @gained = details[6].to_i
    @remained = details[7].to_i
    @remained = @remained / 3600
    refresh
  end

  def window_width
    return 240
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
    draw_text(0, 24, contents.width, line_height, EFE::ARS_OWNER_TEXT + " : " + @owner, 1)
    draw_text(0, 60, contents.width, line_height, EFE::ARS_EXPV_TEXT + " : " + @expensiveness, 1)
    change_color(text_color(14))
    draw_text(0, 100, contents.width, line_height, EFE::ARS_GAINED_TEXT + " : " + @gained.to_s, 1)
    change_color(normal_color)
    draw_text(0, 140, contents.width, line_height, EFE::ARS_REMAINING_TEXT + " : " + @remained.to_s + " hours", 1)
  end

end

class Scene_AdminRentalShop < Scene_MenuBase

  def prepare
     @details = ASOE_VENDOR.getAdminShop(ASOE::VAR_RENT_SHOP_ID)
     if @details == []
       return_scene
       messagebox(EFE::MSG_COULDNT_GET_DATA, 300)
     end
  end

  def start
    super
    create_help_window
    create_details_window
    create_buy_window
    create_commands_window
  end

  def create_commands_window
    @commands_window = Window_AdminRentCommands.new(@buy_window.width+5,@details_window.y + @details_window.height)
    @commands_window.set_handler(:withdraw,     method(:on_withdraw_ok))
    @commands_window.set_handler(:cancel,     method(:on_buy_cancel))
  end
  
  def create_details_window
    @details_window = Window_AdminRentShopDetails.new(280, 100, @details)
    @details_window.viewport = @viewport
  end

  def on_withdraw_ok
    result = ASOE_VENDOR.withdrawShop(ASOE::VAR_RENT_SHOP_ID)
    if !result.include?(ASOE::ERROR_CODE)
      $game_party.gain_gold(result.to_i)
      ASOE_CORE.updateAccount(ASOE::VAR_ACCOUNTNAME)
      return_scene
      messagebox(EFE::ARS_WITHDRAW_SUCCESS, 250)
    else
      ASOE_CORE.updateAccount(ASOE::VAR_ACCOUNTNAME)
      return_scene
      messagebox(EFE::ARS_WITHDRAW_FAIL, 250)
    end
  end

  def create_buy_window
    @goods = @details[5].split(':')
    @newgoods = []
    @goods.each {|i| @newgoods.push([@type.to_i, i.to_i, 0,0,0 ]) }
    wy = @help_window.y + @help_window.height
    wh = Graphics.height - (@help_window.height*2) + 22
    @buy_window = Window_AdminRentalShopBuy.new(0, wy, wh, @newgoods, @details_window.expensiveness)
    @buy_window.width = @buy_window.width - 50 
    @buy_window.viewport = @viewport
    @buy_window.help_window = @help_window
    @buy_window.status_window = @status_window
    @buy_window.set_handler(:cancel, method(:on_buy_cancel))
    @buy_window.unselect
    activate_buy_window
  end

  def activate_buy_window
    @buy_window.money = money
    @buy_window.show.activate
  end

  def on_buy_cancel
    SceneManager.return
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
