=begin
===============================================================================
 Scene_RentShop by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can rent an empty shop. So player will receive
 fee per purchase.
 
 Expensiveness for pricing item price. 
 Cheap for (item price / 2)
 Normal for item price
 Hard for (item price * 2)
--------------------------------------------------------------------------------
Used functions:

availableShop?
rentShop

Call:

SceneManager.call(Scene_RentShop)

Note : before call, shop name must be set.

=end

module EFE
  AVAILABLE_ITEMS = [1,2,3,4,5,6,7,8,9,10,11,12,16]
  AVAILABLE_WEAPONS = [1,2,3,4,5,6,7,8,9,10,11,12,13]
  AVAILABLE_ARMORS = [1,2,3,4,5,6,7,8,9,10,11,12,13]
  RSH_MSG_RENTED_SUCCESFULLY = "Rented Succesfully."
  RSH_MSG_BOUGHT_BEFORE = "Rented already, you late"
  RSH_MSG_INS = "Insufficient gold"
  RSH_MSG_ERROR_RENT = "Couldn't rent this shop"
  RSH_HELP_TEXT1 = "Fee : Income per purchase"
  RSH_HELP_TEXT2 = "Select items you want to sell and press RIGHT button."
  RSH_OWNER_TEXT = "Owner"
  RSH_EXPV_TEXT = "Expensiveness"
  RSH_TYPE_TEXT = "Type"
  RSH_FEE_TEXT = "Fee"
  RSH_ITEMS_BUTTON = "Items"
  RSH_WEAPONS_BUTTON = "Weapons"
  RSH_ARMORS_BUTTON = "Armors"
  RSH_RENTSHOP_BUTTON = "Rent Shop!"
  RSH_CANCEL_BUTTON = "Cancel"
  RSH_CHEAP_TEXT = "Cheap"
  RSH_NORMAL_TEXT = "Normal"
  RSH_HARD_TEXT = "Hard"
end

class Window_RentShopHelp < Window_Base
  
  def initialize(x, y)
    super(x, y, window_width, fitting_height(4))
    refresh
  end

  def window_width
    return 294
  end

  def refresh
    contents.clear
    draw_text(0, 0, contents.width, line_height, EFE::RSH_HELP_TEXT1, 0)
    draw_text(0, 24, contents.width, line_height, EFE::RSH_HELP_TEXT2, 0)
  end

end

class Window_RentShopDetail < Window_Base
  
  attr_reader :name
  attr_reader :owner
  attr_reader :type
  attr_reader :expensiveness
  attr_reader :fee
  
  def initialize(x, y, details)
    super(x, y, window_width, fitting_height(7))
    @name = details[0]
    @owner = details[1]
    @type = details[2]
    @expensiveness = details[3]
    @fee = details[4]
    refresh
  end

  def type=(type)
    @type = type
  end
  
  def expensiveness=(expensiveness)
    @expensiveness = expensiveness
  end
  
  def fee=(fee)
    @fee = fee
  end
  
  def type=(type)
    @type = type
  end
  
  def window_width
    return 294
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
    draw_text(0, 24, contents.width, line_height, EFE::RSH_OWNER_TEXT + " : " + @owner, 1)
    draw_text(0, 60, contents.width, line_height, EFE::RSH_EXPV_TEXT + " : " + @expensiveness, 1)
    draw_text(0, 100, contents.width, line_height, EFE::RSH_TYPE_TEXT + " : " + @type , 1)
    draw_text(0, 136, contents.width, line_height, EFE::RSH_FEE_TEXT + " : " + @fee , 1)
  end

end

class Window_RentItemCategory < Window_HorzCommand

  def initialize(x, y)
    super(x, y)
  end

  def window_width
    return 250
  end

  def col_max
    return 3
  end

  def make_command_list
    add_command(EFE::RSH_ITEMS_BUTTON,   :items)
    add_command(EFE::RSH_WEAPONS_BUTTON, :weapons)
    add_command(EFE::RSH_ARMORS_BUTTON, :armors)
  end
end

class Window_RentShopAccept < Window_HorzCommand

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
    add_command(EFE::RSH_RENTSHOP_BUTTON,   :accept)
    add_command(EFE::RSH_CANCEL_BUTTON, :cancel)
  end
end

class Window_RentShopExpe < Window_HorzCommand

  def initialize(x, y)
    super(x, y)
  end
  
  def draw_item(index)
    text = command_name(index)
    change_color(text_color(11), command_enabled?(index)) if text == EFE::RSH_CHEAP_TEXT
    change_color(text_color(14), command_enabled?(index)) if text == EFE::RSH_NORMAL_TEXT
    change_color(text_color(18), command_enabled?(index)) if text == EFE::RSH_HARD_TEXT
    draw_text(item_rect_for_text(index), command_name(index), alignment)
    change_color(normal_color)
  end
  
  def window_width
    return 294
  end

  def col_max
    return 3
  end

  def make_command_list
    add_command(EFE::RSH_CHEAP_TEXT,   :cheap)
    add_command(EFE::RSH_NORMAL_TEXT, :normal)
    add_command(EFE::RSH_HARD_TEXT, :expensive)
  end
end

class Window_RentItemList < Window_Command
  
  attr_reader    :accepted_items
  attr_reader    :items
  
  def initialize(x, y, id)
    @id = id
    @items = []
    @accepted_items = []
    super(x, y)
  end
  
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    draw_icon(item.icon_index, x, y, enabled)
    draw_text(x + 24, y, width, line_height, item.name)
  end
  
  
  def draw_item(item)
    rect = item_rect_for_text(item)
    item = command_name(item)
    change_color(normal_color)
    change_color(text_color(12)) if @accepted_items.include?(item.id)
    draw_item_name(item, rect.x, rect.y)
  end
  
  def current_item_enabled?
    return true
  end
  
  def id=(id)
    @id = id
  end

  def window_width
    return 250
  end
  
  def window_height
    Graphics.height - 222
  end
  
  def make_command_list
    @items = $data_items if @id == 0
    @items = $data_weapons if @id == 1
    @items = $data_armors if @id == 2
    ava = EFE::AVAILABLE_ITEMS if @id == 0
    ava = EFE::AVAILABLE_WEAPONS if @id == 1
    ava = EFE::AVAILABLE_ARMORS if @id == 2
    if @id != -1
      ava.each {|i| add_command(items[i], i) } 
    end
  end

end

class Scene_RentShop < Scene_Base
  
  def start
    super
    create_background
    create_windows
  end
  
  def update
    super
    if Input.repeat?(:RIGHT) && @item_list.active && @item_list.accepted_items.length > 0
      @item_list.deactivate
      @item_details.type = @item_category.current_data[:name]
      @item_details.refresh
      @item_expensiveness.activate
      @item_expensiveness.select(0)
    end
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_windows
    @item_list = Window_RentItemList.new(0, 75, -1)
    name = $game_variables[ASOE::VAR_CREATE_RENT_SHOP_NAME]
    owner = $game_variables[ASOE::VAR_ACCOUNTNAME]
    type = ""
    expensiveness = ""
    fee = ""
    details = name , owner,type,expensiveness, fee
    @item_details = Window_RentShopDetail.new(250, 77, details)
    @item_list.deactivate
    @item_list.unselect
    @item_category = Window_RentItemCategory.new(0, 27)
    @item_list.set_handler(:cancel,    method(:item_list_cancel))
    @item_list.set_handler(:ok,    method(:item_list_ok))
    @item_category.set_handler(:ok,    method(:item_category_ok))
    @item_category.set_handler(:cancel,    method(:item_category_cancel))
    @item_category.activate
    @item_expensiveness = Window_RentShopExpe.new(250, 27)
    @item_expensiveness.set_handler(:ok,    method(:expensiveness_ok))
    @item_expensiveness.set_handler(:cancel,    method(:expensiveness_cancel))
    @item_expensiveness.unselect
    @item_expensiveness.deactivate
    @help_window = Window_Help.new(2)
    @help_window.set_text(EFE::RSH_HELP_TEXT1 + "\n" + EFE::RSH_HELP_TEXT2)
    @help_window.x = 0
    @help_window.y = Graphics.height - 75
    
    @accept_window = Window_RentShopAccept.new(Graphics.width/2 - 125, 280)
    @accept_window.set_handler(:accept,    method(:accept_ok))
    @accept_window.set_handler(:cancel,    method(:accept_cancel))
    @accept_window.deactivate
    @accept_window.visible = false
  end

  def accept_cancel
    @item_expensiveness.activate
    @item_expensiveness.select(0)
    @accept_window.deactivate
    @accept_window.visible = false
  end
  
  def accept_ok
    index = ASOE::VAR_RENT_SHOP_ID
    rentPrice = ASOE_VENDOR.getShopPrice(index)
    name = $game_variables[ASOE::VAR_CREATE_RENT_SHOP_NAME]
    owner = $game_variables[ASOE::VAR_ACCOUNTNAME]
    items = ""
    @item_list.accepted_items.each {|i|
    items += i.to_s + ":"
    }
    items[-1] = ''
    type = "0" if @item_category.current_symbol == :items
    type = "1" if @item_category.current_symbol == :weapons
    type = "2" if @item_category.current_symbol == :armors
    case @item_expensiveness.current_symbol
      when :cheap
        expe = "0"
      when :normal
        expe = "1"
      when :expensive
        expe = "2"
    end
    fee = @item_details.fee.to_i
    if ASOE_VENDOR.availableShop?(index)
      if $game_party.gold >= rentPrice
        #if ASOE_VENDOR.getShopPrice(i)
        if ASOE_VENDOR.rentShop($game_variables[index].to_s, name, owner, type, expe, fee.to_s, items)
          $game_party.lose_gold(rentPrice)
          ASOE_CORE.updateAccount(ASOE::VAR_ACCOUNTNAME)
          return_scene
          messagebox(EFE::RSH_MSG_RENTED_SUCCESFULLY,200)
        else
          return_scene
          messagebox(EFE::RSH_MSG_ERROR_RENT,200)
        end
      else
        return_scene
        messagebox(EFE::RSH_MSG_INS,200)
      end
    else
        return_scene
        messagebox(EFE::RSH_MSG_BOUGHT_BEFORE, 250)
    end
  end
  
  def expensiveness_ok
    fee = 0
    @item_list.accepted_items.each {|i|
      fee += @item_list.items[i].price + 5
    }
    fee = (fee / @item_list.accepted_items.length)
    fee -= fee / 2 if @item_expensiveness.current_data[:name] == EFE::RSH_CHEAP_TEXT
    fee += fee / 2 if @item_expensiveness.current_data[:name] == EFE::RSH_HARD_TEXT
    fee = fee / 3
    @item_details.fee = fee.to_s
    @item_details.expensiveness = @item_expensiveness.current_data[:name]
    @item_details.refresh
    @accept_window.activate
    @accept_window.visible = true
  end
  
  def expensiveness_cancel
    @item_expensiveness.deactivate
    @item_list.activate
  end
  
  def item_category_cancel
    SceneManager.return
  end
  
  def item_list_ok
    if @item_list.accepted_items.include?(@item_list.current_symbol.to_i)
      @item_list.accepted_items.delete(@item_list.current_symbol.to_i)
    else
      @item_list.accepted_items.push(@item_list.current_symbol.to_i)
    end
    @item_list.refresh
    @item_list.activate
  end
  
  def item_category_ok
    @item_list.id = 0 if @item_category.current_symbol == :items
    @item_list.id = 1 if @item_category.current_symbol == :weapons
    @item_list.id = 2 if @item_category.current_symbol == :armors
    @item_list.refresh
    @item_list.activate
    @item_list.select(0)
  end
  
  def item_list_cancel
    @item_list.unselect
    @item_list.accepted_items.clear
    @item_category.activate
  end
end