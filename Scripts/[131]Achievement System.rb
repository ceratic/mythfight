#========================================================================
#    Author:   Calestian
#    Name:     Achievement System
#    Created:  02-04-2015
#    Version:  1.4
#---------------------------------------------------------------------------
#                       VERSION HISTORY
#
#    v1.0 - Initial Release
#    v1.1 - Quick Bug Fix
#    v1.2 - Added Repeatable Achievements
#    v1.3 - Added Notification Sounds - Updated Prerequisites
#    v1.4 - Quick Fixes - Updated Event Methods
#---------------------------------------------------------------------------
#                       FEATURES
#    
#    * Achievement Categories
#    * Locked Achievements (Prerequisites)
#    * Completed Achievements (Colored)
#    * Achievement Rewards
#    * Achievement Point Rewards
#    * Achievement Progression Track
#    * Achievement Notification (Completed | Unlocked | Achievement Points Reached)
#---------------------------------------------------------------------------
#                       How to Setup
#
#    * Set in the Achievement_Categories array your Categories:
#         Achievement_Categories[index] = ["CategoryName", "CategoryDescription"]
#
#    * Set in the Achievements hash your achievement info:
#         :Prerequisite
#             Set to :none means there is no prerequisite 
#             Set to [AchievementID, Repeated, Objective]
#                e.g [0, 5, 200]
#         :Item => [ItemType, ItemID, Amount]
#             ItemType: 0 -> Item | 1 -> Armor | 2 -> Weapon
#             ItemID: Taken from Database
#             Amount: How many of the selected item to be given as a reward
#         :Repeatable => false | value
#             false -> One time Achievement
#             value (eg. 50) -> Repeatable value(50) times
#    
#    * Set in the Achievement_Point_Rewards array your AP rewards:
#         Achievement_Point_Rewards[index] = [[ItemType, ItemID, Amount], [ItemType, ItemID, Amount], ... , [ItemType, ItemID, Amount]
#  
#    * Edit Settings
#---------------------------------------------------------------------------
#                       How to Use
#
#    In the Event -> Script:
#       * gain_achievement(amount, index)     # Index -> Achievements Hash Index
#       * lose_achievement(amount, index)
#       *  set_achievement(amount, index)
#      
#       * gain_achievement_points(amount)
#       * lose_achievement_points(amount)
#       *  set_achievement_points(amount)
#
#       * achievement_name(index) 
#       * achievement_item(index)
#       * achievement_gold(index)
#       * achievement_points(index)
#       * achievement_title(index)
#       * achievement_repeated(index)
#       * achievement_progress(index)
#       * achievement_status(index)
#       * party_achievement_points
#---------------------------------------------------------------------------
#                       LICENSE INFO
#
#    Free for non-commercial & commercial use, as long as credit is given
#    to Calestian
#===========================================================================
 
#===========================================================================
# *** Editable Region
#===========================================================================
module Clstn_Achievement_System
 
  #--------------------------------------------------------------------------
  # * Achievement Categories
  #--------------------------------------------------------------------------
  Achievement_Categories = []
 
  Achievement_Categories[0] = ["General"      , "General Category Description"]
  Achievement_Categories[1] = ["Explore"      , "Explore the World"           ]
  Achievement_Categories[2] = ["Slayer"       , "Slay Stuff"                  ]
  Achievement_Categories[3] = ["Weapon Master", "Use Weapons"                 ]
  Achievement_Categories[4] = ["Competitive"  , "Be the best"                 ]
  Achievement_Categories[5] = ["PvP"          , "PvP Achievements"            ]
 
  #--------------------------------------------------------------------------
  # * Achievements
  #--------------------------------------------------------------------------
  Achievements = {
 
    0 => {
      :Name              => "Be awesome",
      :Tiers             => [5],
      :Help              => "Just be awesome",
      :Title             => "Awesome Guy",
      :RewardItem        => [0, 005, 50],
      :RewardGold        => 100,
      :Category          => "General",
      :AchievementPoints => 100,
      :Prerequisite      => :none,
      :Repeatable        => 5,
    },
   
    1 => {
      :Name              => "Treasure Hunter",
      :Tiers             => [50, 100, 150, 200, 250],
      :Help              => "Find Treasures",
      :Title             => :none,
      :RewardItem        => :none,
      :RewardGold        => :none,
      :Category          => "General",
      :AchievementPoints => :none,
      :Prerequisite      => [0, 2, 4],
      :Repeatable        => 10,
    },
   
    2 => {
      :Name              => "Key Collector",
      :Tiers             => [50, 100, 150, 200, 250],
      :Help              => "Find Keys",
      :Title             => "Key Collector",
      :RewardItem        => [0, 001, 50],
      :RewardGold        => 100,
      :Category          => "General",
      :AchievementPoints => 100,
      :Prerequisite      => :none,
      :Repeatable        => false,
    },
   
    3 => {
      :Name              => "House Explorer",
      :Tiers             => [50],
      :Help              => "Explore Houses",
      :Title             => "House Explorer",
      :RewardItem        => [0, 001, 50],
      :RewardGold        => 100,
      :Category          => "Explore",
      :AchievementPoints => 100,
      :Prerequisite      => :none,
      :Repeatable        => false,
    },
   
    4 => {
      :Name              => "Cave Explorer",
      :Tiers             => [50],
      :Help              => "Explore Caves",
      :Title             => "Cave Explorer",
      :RewardItem        => [0, 001, 50],
      :RewardGold        => 100,
      :Category          => "Explore",
      :AchievementPoints => 100,
      :Prerequisite      => :none,
      :Repeatable        => false,
    },
   
    5 => {
      :Name              => "Sea Explorer",
      :Tiers             => [50, 100, 150, 200],
      :Help              => "Explore Seas",
      :Title             => "Sea Explorer",
      :RewardItem        => [0, 001, 50],
      :RewardGold        => 100,
      :Category          => "Explore",
      :AchievementPoints => 100,
      :Prerequisite      => :none,
      :Repeatable        => 50,
    },
   
   
    6 => {
      :Name              => "Mountain Explorer",
      :Tiers             => [50, 100, 150],
      :Help              => "Explore Mountains",
      :Title             => "Mountain Explorer",
      :RewardItem        => [0, 001, 50],
      :RewardGold        => 100,
      :Category          => "Explore",
      :AchievementPoints => 100,
      :Prerequisite      => :none,
      :Repeatable        => 50,
    },
 
    7 => {
      :Name              => "Dragon Slayer",
      :Tiers             => [50, 100, 150, 200, 250],
      :Help              => "Kill Dragons",
      :Title             => "Dragon Slayer",
      :RewardItem        => [0, 001, 50],
      :RewardGold        => 100,
      :Category          => "Slayer",
      :AchievementPoints => 100,
      :Prerequisite      => :none,
      :Repeatable        => 50,
    },
   
    8 => {
      :Name              => "Demon Slayer",
      :Tiers             => [50, 100, 150, 200, 250],
      :Help              => "Kill Demons",
      :Title             => "Demon Slayer",
      :RewardItem        => [1, 001, 50],
      :RewardGold        => 100,
      :Category          => "Slayer",
      :AchievementPoints => 100,
      :Prerequisite      => :none,
      :Repeatable        => 50,
    },
   
    9 => {
      :Name              => "God Slayer",
      :Tiers             => [50, 100, 150, 200, 250],
      :Help              => "Kill Gods",
      :Title             => "God Slayer",
      :RewardItem        => [2, 001, 50],
      :RewardGold        => 100,
      :Category          => "Slayer",
      :AchievementPoints => 100,
      :Prerequisite      => :none,
      :Repeatable        => 50,
    },
   
    10 => {
      :Name              => "Rabbit Slayer",
      :Tiers             => [50, 100, 150, 200, 250],
      :Help              => "Kill Rabbits",
      :Title             => "Rabbit Slayer",
      :RewardItem        => [0, 001, 50],
      :RewardGold        => 100,
      :Category          => "Slayer",
      :AchievementPoints => 100,
      :Prerequisite      => :none,
      :Repeatable        => 50,
    },
   
  }
 
  Achievement_Point_Rewards    = []
  Achievement_Point_Rewards[0] = [1000,   [[1, 001, 50], [0, 001, 10], [2, 001, 30]]]
  Achievement_Point_Rewards[1] = [5000,   [[1, 001, 50], [0, 001, 10], [2, 001, 30]]]
  Achievement_Point_Rewards[2] = [10000,  [[1, 001, 50], [0, 001, 10], [2, 001, 30]]]
  Achievement_Point_Rewards[3] = [50000,  [[1, 001, 50], [0, 001, 10], [1, 001, 30]]]
  Achievement_Point_Rewards[4] = [100000, [[1, 001, 50], [0, 001, 10], [1, 001, 30]]]
 
   
  #-----------------------------------------------------------------------
  # * Settings
  #-----------------------------------------------------------------------
  Achievement_Display        = :Both     # :Color | :Icon | :Both
  Category_Icon_Disabled     = 337       # Category Icon when not Expanded
  Category_Icon_Enabled      = 345       # Category Icon when Expanded
  Achievement_Points_Icon    = 361       # Achievement_Points_Icon = IconID
  Achievement_Unlocked_Icon  = 359       # Achievement_Unlocked_Icon = IconID
  Achievement_Locked_Icon    = 243       # Achievement_Locked_Icon = IconID
  Achievement_Completed_Icon = 431       # Achievement_Completed_Icon = IconID
  Achievement_Points_color   = 21        # Achievement_Points_Color = ColorID
  Notification_Sound         = "Absorb2" # "SoundName"
  Notification_Window        = true      # Notification Window Enabled
   
#===========================================================================
# *** End of Editable Region
#===========================================================================
 
  #--------------------------------------------------------------------------
  # * Get Achievement Categories
  #--------------------------------------------------------------------------
  def self.get_achievement_categories
    @achievement_categories = []
    Achievement_Categories.each { |value|
      @achievement_categories.push(value[0])
    }
    return @achievement_categories
  end
 
  #--------------------------------------------------------------------------
  # * Get Category Achievements
  #--------------------------------------------------------------------------
  def self.get_category_achievements
    category = []
    Achievement_Categories.each { |key|
      temp = []
      Achievements.each_value { |value|
        temp.push(value[:Name]) if value[:Category] == key[0]
      }
      category.push(temp.empty? ? 0 : temp)
    }
    return category
  end
 
  #--------------------------------------------------------------------------
  # * Tier?
  #--------------------------------------------------------------------------
  def self.tier?(item)
    progress = $game_party.achievements[find_achievement_index(item[:Name])]
    item[:Tiers].size.times { |i|
      return item[:Tiers].size - 1 if item[:Tiers][-1] == progress
      return i if item[:Tiers][i] > progress
    }
  end
 
  #--------------------------------------------------------------------------
  # * Locked?
  #--------------------------------------------------------------------------
  def self.locked?(item)
    item = Achievements[find_achievement_index(item)] if item.is_a?(String)
    return false if item[:Prerequisite] == :none
    return completed?(item) ? false : true
  end
  
  #--------------------------------------------------------------------------
  # * Completed?
  #--------------------------------------------------------------------------
  def self.completed?(item)
    index = item[:Prerequisite][0]
    limit = item[:Prerequisite][1]
    tier  = item[:Prerequisite][2]
    return $game_party.achievement_repeated[index] >= limit && $game_party.achievements[index] >= tier ? true : false
  end
 
 
  #--------------------------------------------------------------------------
  # * Find Achievement Index
  #--------------------------------------------------------------------------
  def self.find_achievement_index(item)
    Achievements.size.times { |index|
      return index if item == Achievements[index][:Name]
    }
  end
 
  #--------------------------------------------------------------------------
  # * Find Category Index
  #--------------------------------------------------------------------------
  def self.find_category_index(item)
    Achievement_Categories.size.times { |index|
      return index if item[index][0] == Achievement_Categories[index]
    }
  end
 
  #--------------------------------------------------------------------------
  # * Get Achievement Point Rewards
  #--------------------------------------------------------------------------
  def self.get_point_rewards
    Achievement_Point_Rewards.each { |value|
      return value[0] if value[0] > $game_party.achievement_points
    }
    return Achievement_Point_Rewards[-1][0]
  end
  
  #--------------------------------------------------------------------------
  # * Get Achievement Status
  #--------------------------------------------------------------------------
  def self.get_achievement_status
    status = []
    Achievements.each_value { |value|
      value[:Prerequisite] == :none ? status.push(:Unlocked) : status.push(:Locked)
    }
    return status
  end
 
end
 
#===========================================================================
# *** Window Menu Command
#===========================================================================
class Window_MenuCommand < Window_Command
 
  #--------------------------------------------------------------------------
  # * Aliases
  #--------------------------------------------------------------------------
  alias :clstn_achievements_add_original_commands :add_original_commands
  alias :clstn_achievements_initialize            :initialize
  
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize 
    clstn_achievements_initialize
    $game_party.notifications.clear
    $game_party.notification_enabled = false
  end
 
  #--------------------------------------------------------------------------
  # * Original Command
  #--------------------------------------------------------------------------
  def add_original_commands
    clstn_achievements_add_original_commands
    add_command("Achievements", :achievements, true)
  end
 
end
 
#===========================================================================
# *** Window Achievement Header
#===========================================================================
class Window_AchievementHeader < Window_Base
 
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, 50)
    refresh
  end
 
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.font.size = 22
    next_reward = Clstn_Achievement_System::get_point_rewards
    change_color(text_color(Clstn_Achievement_System::Achievement_Points_color))
    draw_icon(Clstn_Achievement_System::Achievement_Points_Icon, 10, 0)
    draw_text(35, 1, contents.width, contents.height, $game_party.achievement_points)
    change_color(text_color(0))
    draw_text( 0, 1, contents.width, contents.height, "Next Reward: ", 1)
    change_color(text_color(Clstn_Achievement_System::Achievement_Points_color))
    draw_icon(Clstn_Achievement_System::Achievement_Points_Icon, 315, 1)
    draw_text(340, 2, contents.width, contents.height, next_reward)
  end
 
end
 
#===========================================================================
# *** Window Achievement Info
#===========================================================================
class Window_AchievementInfo < Window_Base
 
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize
    super(Graphics.width - 250, 50, Graphics.width - 295, Graphics.height - 50)
  end
 
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh(item, symbol)
    contents.clear
    @item = item
    if symbol == :category
      draw_name
    elsif symbol == :achievement
      @index = Clstn_Achievement_System::find_achievement_index(item[:Name])
      draw_name(false)
      draw_progress
      draw_reward
    end
  end
 
  #--------------------------------------------------------------------------
  # * Draw Name
  #--------------------------------------------------------------------------
  def draw_name(enabled = true)
    draw_information(22, enabled ? 16 : 0, 0, 0, enabled ? @item[0] : @item[:Name], 1)
    draw_information(20, enabled ? 0 : 16, 0, 30, enabled ? @item[1] : @item[:Help])
  end
 
  #--------------------------------------------------------------------------
  # * Draw Progress
  #--------------------------------------------------------------------------
  def draw_progress
    tier = Clstn_Achievement_System::tier?(@item)
    draw_information(22,  0,  0,  60, "Progression")
    draw_horz_line(75)
    draw_information(20,  0,  0,  90,      "Tier: ")
    draw_information(20, 16, 50,  90,          tier)
    draw_information(20,  0,  0, 120, "Objective: ")
    draw_information(20, 16, 90, 120, $game_party.achievements[@index].to_s + "/" + @item[:Tiers][tier].to_s)
    draw_gauge(0, 142, contents.width, get_achievement_rate(@item[:Tiers][tier], @index), text_color(22), text_color(23))
  end
 
  #--------------------------------------------------------------------------
  # * Draw Rewards
  #--------------------------------------------------------------------------
  def draw_reward
    repeatable  = check_variable_condition(@item[:Repeatable],        false)
    gold        = check_variable_condition(@item[:RewardGold],        :none)
    points      = check_variable_condition(@item[:AchievementPoints], :none)
    title       = check_variable_condition(@item[:Title],             :none)
    item_reward = check_variable_condition(@item[:RewardItem],        :none)
    draw_horz_line(185)
    draw_information(22, 0, 0, 170, "Rewards")
    draw_information(20, 0, 0, 200,  "Item: ")
    if item_reward == "-"
      draw_information(20, 16, 50, 200, "-")
    else
      draw_item_name($game_party.get_item(item_reward), 50, 204, true, 172)
    end
    draw_information(20,  0,  0, 230,     "Gold: ")
    draw_information(20, 16, 50, 230,         gold)
    draw_information(20,  0,  0, 260,    "Title: ")
    draw_information(20, 16, 60, 260,        title)
    draw_information(20, 21, 25, 289,       points)
    draw_icon(Clstn_Achievement_System::Achievement_Points_Icon, 0, 290)
    draw_prerequisites(repeatable)
  end
  
  #--------------------------------------------------------------------------
  # * Draw Prerequisites
  #--------------------------------------------------------------------------
  def draw_prerequisites(repeatable)
    draw_information(18, 16,  0, 320, "Repeatable") if repeatable && $game_party.achievement_repeated[@index] == -1 && $game_party.achievement_status[@index] != :Locked
    draw_information(18, 16,  0, 320, "Repeated" + "  " + $game_party.achievement_repeated[@index].to_s + "/" + Clstn_Achievement_System::Achievements[@index][:Repeatable].to_s) if repeatable && $game_party.achievement_repeated[@index] >= 0
    pre_achievement = Clstn_Achievement_System::Achievements
    if $game_party.achievement_status[@index] == :Locked
      pre_achievement = Clstn_Achievement_System::Achievements
      current_information = $game_party.achievement_repeated[@item[:Prerequisite][0]] >= @item[:Prerequisite][1] ? 2 : 1
      time = (@item[:Prerequisite][current_information] - pre_achievement[@index][:Prerequisite][current_information]) == 1  ? "once" : " times"
      prerequisite = time == "once" ? "" : @item[:Prerequisite][current_information]
      draw_information(18, 16,  0, 320, line = current_information == 1 ? "Repeat " : "Update ") 
      draw_information(18, 21, text_size(line).width, 320, name = pre_achievement[@item[:Prerequisite][0]][:Name])
      draw_information(18, 16, text_size(line).width + text_size(name).width, 320, " " + prerequisite.to_s + time)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Check Variable Condition
  #--------------------------------------------------------------------------
  def check_variable_condition(variable, condition)
    return variable == condition ? condition == false ? false : "-" : condition == false ? true : variable 
  end
  
  #--------------------------------------------------------------------------
  # * Draw Information
  #--------------------------------------------------------------------------
  def draw_information(font_size, color_id, x, y, text, allignment = 0)
    contents.font.size = font_size
    change_color(text_color(color_id))
    draw_text(x, y, contents.width, 30, text, allignment)
  end
 
  #--------------------------------------------------------------------------
  # * Draw Item Name
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    draw_icon(item.icon_index, x, y, enabled)
    change_color(text_color(16), enabled)
    draw_text(x + 24, y, width, line_height, item.name)
  end
 
  #--------------------------------------------------------------------------
  # * To Tier Number
  #--------------------------------------------------------------------------
  def to_tier(tier)
    case tier
    when 0
      return "I"
    when 1
      return "II"
    when 2
      return "III"
    when 3
      return "IV"
    when 4
      return "V"
    when 5
      return "VI"
    when 6
      return "VII"
    when 7
      return "VIII"
    when 8
      return "IX"
    when 9
      return "X"
    end
  end
 
  #--------------------------------------------------------------------------
  # * Get Achievement Rate
  #--------------------------------------------------------------------------
  def get_achievement_rate(objective, index)
    return ($game_party.achievements[index].to_f / objective.to_f)
  end
 
  #--------------------------------------------------------------------------
  # * Draw Horizontal Line
  #--------------------------------------------------------------------------
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, text_color(16))
  end
 
end
 
#===========================================================================
# *** Window Achievements
#===========================================================================
class Window_Achievements < Window_Selectable
 
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @achievement_info_window = Window_AchievementInfo.new
    @data = []
    @category = []
    @achievements = []
    @category_icons = []
    set_category_icons
    refresh
    select(0)
  end
 
  #--------------------------------------------------------------------------
  # * Category Icons
  #--------------------------------------------------------------------------
  def set_category_icons
    Clstn_Achievement_System::Achievement_Categories.each { |value|
      @category_icons.push(Clstn_Achievement_System::Category_Icon_Disabled)
    }
  end
 
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
 
  #--------------------------------------------------------------------------
  # * Get Item Max
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
 
  #--------------------------------------------------------------------------
  # * Make Item List
  #--------------------------------------------------------------------------
  def make_item_list
    @category = Clstn_Achievement_System::get_achievement_categories     unless !@category.empty?
    @achievements = Clstn_Achievement_System::get_category_achievements  unless !@achievements.empty?
    @data = Clstn_Achievement_System::get_achievement_categories         unless !@data.empty?
  end
 
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    contents.font.size = 22
    @category_helper = index == 0 ? index : @category_helper
    item = @data[index]
    rect = item_rect(index)
    change_color(text_color(0))
    if item && category?(item)
      draw_icon(@category_icons[@category_helper], rect.x + 10, rect.y)
      draw_text(rect.x + 40, rect.y, contents.width - 40, line_height, item)
      @category_helper += 1
    elsif item
      id = Clstn_Achievement_System::find_achievement_index(item)
      temp = find_item_achievement(item)
      change_color(text_color(21)) if $game_party.achievement_status[id] == :Completed && (Clstn_Achievement_System::Achievement_Display == :Color || Clstn_Achievement_System::Achievement_Display == :Both)
      if Clstn_Achievement_System::Achievement_Display == :Icon || Clstn_Achievement_System::Achievement_Display == :Both
        if $game_party.achievement_status[id] == :Completed
          icon = Clstn_Achievement_System::Achievement_Completed_Icon
        elsif $game_party.achievement_status[id] == :Locked
          icon = Clstn_Achievement_System::Achievement_Locked_Icon
        else
          icon = Clstn_Achievement_System::Achievement_Unlocked_Icon
        end
        draw_icon(icon, rect.x + 7, rect.y)
      else
        draw_icon(Clstn_Achievement_System::Achievement_Unlocked_Icon, rect.x + 7, rect.y)
      end
      draw_text(rect.x + 35, rect.y, rect.width, line_height, item)
      contents.font.size = 15
      change_color(text_color(16))
      draw_text(227, rect.y + 1, rect.width, line_height, "Locked") if $game_party.achievement_status[id] == :Locked
      change_color(text_color(0))
    end
  end
 
  #--------------------------------------------------------------------------
  # * Item Rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    update_info_window(@data[index])
    x_spacing = category?(@data[index]) ? 0 : 20
    rect = Rect.new
    rect.width = item_width - x_spacing
    rect.height = item_height
    rect.x = index % col_max * (item_width + spacing) + x_spacing
    rect.y = index / col_max * item_height
    rect
  end
 
  #--------------------------------------------------------------------------
  # * Update Info Window
  #--------------------------------------------------------------------------
  def update_info_window(item)
    if category?(item)
      item = find_item_category(item)
      symbol = :category
    else
      item = find_item_achievement(item)
      symbol = :achievement
    end
    @achievement_info_window.refresh(item, symbol)
  end
 
  #--------------------------------------------------------------------------
  # * Find Item Achievement
  #--------------------------------------------------------------------------
  def find_item_achievement(item)
    Clstn_Achievement_System::Achievements.each_value { |value|
      return value if value[:Name] == item
    }
  end
 
  #--------------------------------------------------------------------------
  # * Find Item Category
  #--------------------------------------------------------------------------
  def find_item_category(item)
    Clstn_Achievement_System::Achievement_Categories.each { |value|
      return value if value[0] == item
    }
  end
 
  #--------------------------------------------------------------------------
  # * Expand
  #--------------------------------------------------------------------------
  def expand
    data_index = get_data_index(item)
    @category_index = get_category_index(item)
    if category?(item)
      @category_icons[@category_index] = @category_icons[@category_index] == Clstn_Achievement_System::Category_Icon_Enabled ? Clstn_Achievement_System::Category_Icon_Disabled : Clstn_Achievement_System::Category_Icon_Enabled
      if @achievements[@category_index] != 0
        @achievements[@category_index].size.times { |i|
          expanded?(@category_index) ? @data.insert(data_index + 1 + i, @achievements[@category_index][i]) : @data.delete_at(data_index + 1)
        }
      end
    end
    refresh
  end
 
  #--------------------------------------------------------------------------
  # * Get Category Index
  #--------------------------------------------------------------------------
  def get_category_index(item)
    @category.size.times { |index|
      return index if @category[index] == item
    }
  end
 
  #--------------------------------------------------------------------------
  # * Get Data Index
  #--------------------------------------------------------------------------
  def get_data_index(item)
    @data.size.times { |index|
      return index if @data[index] == item
    }
  end
 
  #--------------------------------------------------------------------------
  # * Expanded?
  #--------------------------------------------------------------------------
  def expanded?(index)
    return @category_icons[index] == Clstn_Achievement_System::Category_Icon_Enabled && @category[index] != 0 ? true : false
  end
 
  #--------------------------------------------------------------------------
  # * Category?
  #--------------------------------------------------------------------------
  def category?(item)
    return @category.include?(item)
  end
 
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @achievement_info_window.dispose
  end
 
end
 
#===========================================================================
# *** Class Window_AchievementNotification
#===========================================================================
class Window_AchievementNotification < Window_Base
 
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize
    @window = $game_party.notifications[0][1]
    @item   = $game_party.notifications[0][0]
    super(x, 0, width, height)
    $game_party.notification_enabled = false
    refresh
  end
 
  #--------------------------------------------------------------------------
  # * Aliases
  #--------------------------------------------------------------------------
  alias :clstn_update_windowbase :update
 
  #--------------------------------------------------------------------------
  # * Get x
  #--------------------------------------------------------------------------
  def x
    case @window
    when :completed
      return Graphics.width / 4
    when :unlocked
      return Graphics.width / 4 + 28
    when :points
      return Graphics.width / 4 - 3
    end
  end
 
  #--------------------------------------------------------------------------
  # * Get Width
  #--------------------------------------------------------------------------
  def width
    case @window
    when :completed
      return Graphics.width / 2
    when :unlocked
      return Graphics.width / 2 - 56
    when :points
      return Graphics.width / 2 + 6
    end
  end
 
  #--------------------------------------------------------------------------
  # * Get Height
  #--------------------------------------------------------------------------
  def height
    case @window
    when :completed
      return Graphics.height - 310
    when :unlocked
      return 0 if @item.empty?
      return 50 + @item.size * 25
    when :points
      return 50 + @item[1].size * 26
    end
  end
 
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    RPG::SE.new(Clstn_Achievement_System::Notification_Sound, 80, 100).play
    case @window
    when :completed
      draw_completed
    when :unlocked
      draw_unlocked
    when :points
      draw_points
    end
  end
 
  #--------------------------------------------------------------------------
  # * Notification: Achievement Completed
  #--------------------------------------------------------------------------
  def draw_completed
    title = @item[:Title] == :none ? "-" : @item[:Title].to_s
    points =  @item[:AchievementPoints] == :none ? "-" : @item[:AchievementPoints]
    contents.font.size = 20
    draw_text(0, 0, contents.width, 20, "Achievement Completed!", 1)
    draw_horz_line(10)
    contents.font.size = 19
    draw_text(0, 20, contents.width, 30, @item[:Name], 1)
    draw_text(0, 40, contents.width, 30, "Title: " + title, 1)
    change_color(text_color(16))
    draw_icon(Clstn_Achievement_System::Achievement_Points_Icon, 90, 60)
    change_color(text_color(21))
    draw_text(115, 60, contents.width, 30, points, 0)
  end
 
  #--------------------------------------------------------------------------
  # * Notification: Achievement Unlocked
  #--------------------------------------------------------------------------
  def draw_unlocked
    contents.font.size = 20
    draw_text(0, 0, contents.width, 20, "Achievements Unlocked", 1)
    draw_horz_line(10)
    @item.size.times { |i|
      draw_text(0, 30 + 25 * i, contents.width, 20, @item[i], 1)
    }
  end
 
  #--------------------------------------------------------------------------
  # * Notification: Achievement Points Reached
  #--------------------------------------------------------------------------
  def draw_points
    draw_text(0, 0, contents.width, 20, "Achievement Point Rewards", 1)
    draw_horz_line(13)
    i = 0
    @item[1].each { |key|
      item = key
      draw_item_name($game_party.get_item(item), key[2], 0, 30 + 25 * i)
      i += 1
    }
  end
 
  #--------------------------------------------------------------------------
  # * Draw Item Name
  #--------------------------------------------------------------------------
  def draw_item_name(item, amount, x, y)
    return unless item
    contents.font.size = 21
    draw_icon(item.icon_index, x, y)
    draw_text(x + 24, y, contents.width, line_height, item.name)
    change_color(text_color(16))
    contents.font.size = 18
    draw_text(0, y - 1, contents.width, 30, "x" + amount.to_s, 2)
    change_color(text_color(0))
  end
 
  #--------------------------------------------------------------------------
  # * Draw Horizontal Line
  #--------------------------------------------------------------------------
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, text_color(16))
  end
 
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    if !disposed? && self.opacity > 0
      self.opacity -= 1
      self.contents_opacity -= 1
      self.back_opacity -= 1
    else
      $game_party.notifications.delete_at(0) unless $game_party.notifications.empty?
      if !$game_party.notifications.empty?
        $game_party.notification_enabled = true
        SceneManager.call(Scene_Map) 
      else
        $game_party.notification_enabled = false
      end
    end
  end
 
end
 
#===========================================================================
# *** Scene Menu
#===========================================================================
class Scene_Menu < Scene_MenuBase
 
  #--------------------------------------------------------------------------
  # * Aliases
  #--------------------------------------------------------------------------
  alias :clstn_create_command_window :create_command_window
 
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    clstn_create_command_window
    @command_window.set_handler(:achievements, method(:command_achievements))
  end
 
  #--------------------------------------------------------------------------
  # * Command Achievements
  #--------------------------------------------------------------------------
  def command_achievements
    SceneManager.call(Scene_Achievements)
  end
 
end
 
#===========================================================================
# *** Scene Achievements
#===========================================================================
class Scene_Achievements < Scene_Base
 
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    create_main_viewport
    create_achievement_windows
  end
 
  #--------------------------------------------------------------------------
  # * Create Achievement Window
  #--------------------------------------------------------------------------
  def create_achievement_windows
    create_achievement_header_window
    create_achievement_window
  end
 
  #--------------------------------------------------------------------------
  # * Create Achievement Header Window
  #--------------------------------------------------------------------------
  def create_achievement_header_window
     @achievementheader_window = Window_AchievementHeader.new
  end
 
  #--------------------------------------------------------------------------
  # * Create Achievement Window
  #--------------------------------------------------------------------------
  def create_achievement_window
    @achievement_window = Window_Achievements.new(0, 50, Graphics.width - 250, Graphics.height - 50)
    @achievement_window.set_handler(:ok,     method(:expand_ok   ))
    @achievement_window.set_handler(:cancel, method(:return_scene))
    @achievement_window.activate
  end
 
  #--------------------------------------------------------------------------
  # * Expand [OK]
  #--------------------------------------------------------------------------
  def expand_ok
    @achievement_window.expand
    @achievement_window.activate
  end
 
end
 
#===========================================================================
# *** Class Scene_Map
#===========================================================================
class Scene_Map < Scene_Base
 
  #--------------------------------------------------------------------------
  # * Aliases
  #--------------------------------------------------------------------------
  alias :clstn_create_all_windows_scene_map :create_all_windows
 
  #--------------------------------------------------------------------------
  # * Create All Windows
  #--------------------------------------------------------------------------
  def create_all_windows
    clstn_create_all_windows_scene_map
    create_notification_window unless Clstn_Achievement_System::Notification_Window == false || $game_party.notification_enabled == false
  end
 
  #--------------------------------------------------------------------------
  # * Create Notification Window
  #--------------------------------------------------------------------------
  def create_notification_window
    @notification_window = Window_AchievementNotification.new
    @notification_window.viewport = @viewport
  end
 
end
 
#===========================================================================
# *** Class Game_Party
#===========================================================================
class Game_Party < Game_Unit
 
  attr_accessor :achievements
  attr_accessor :achievement_points
  attr_accessor :achievement_repeated
  attr_accessor :achievement_status
  attr_accessor :notification_enabled
  attr_accessor :notifications
  #--------------------------------------------------------------------------
  # * Aliased
  #--------------------------------------------------------------------------
  alias :clstn_achievements_gameparty_initialize :initialize
 
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize
    clstn_achievements_gameparty_initialize
    @notification_enabled = false
    @achievement_points = 0
    @notifications = []
    @achievements = []
    @achievement_repeated = []
    @achievement_status = []
    init_achievements
    init_achievement_repeated
    init_achievement_status
  end
 
  #--------------------------------------------------------------------------
  # * Initialize Achievements
  #--------------------------------------------------------------------------
  def init_achievements
    Clstn_Achievement_System::Achievements.each_value { |value|
      @achievements.push(0)
    }
  end
  
  #--------------------------------------------------------------------------
  # * Initialize Achievement Repeated
  #--------------------------------------------------------------------------
  def init_achievement_repeated
    Clstn_Achievement_System::Achievements.each_value { |value|
      @achievement_repeated.push(-1)
    }
  end
  
  #--------------------------------------------------------------------------
  # * Initialize Achievement Status
  #--------------------------------------------------------------------------
  def init_achievement_status
    @achievement_status = Clstn_Achievement_System::get_achievement_status
  end
 
  #--------------------------------------------------------------------------
  # * Achievement Completed
  #--------------------------------------------------------------------------
  def achievement_completed(index)
    array = Clstn_Achievement_System::Achievements[index]
    if @achievements[index] >= array[:Tiers][-1]
      check_status_completed(index)
      @achievements[index] = array[:Tiers][array[:Tiers].size - 1]
      next_reward = Clstn_Achievement_System::get_point_rewards
      gain_gold(array[:RewardGold])                                     unless array[:RewardGold]        == :none
      gain_item(get_item(array[:RewardItem]), array[:RewardItem][2])    unless array[:RewardItem]        == :none
      @achievement_points += array[:AchievementPoints]                  unless array[:AchievementPoints] == :none
      notification(array, :completed)
      next_achievement(next_reward)
    end
    unlocked = check_unlock(index)
    notification(unlocked, :unlocked) unless unlocked.empty?
  end
 
  #--------------------------------------------------------------------------
  # * Next Achievement
  #--------------------------------------------------------------------------
  def next_achievement(next_reward)
    if @achievement_points >= next_reward
      array = Clstn_Achievement_System::Achievement_Point_Rewards
      index = find_achievement_reward_index(next_reward)
      array[index][1].each { |key|
        item = key
        gain_item(get_item(item), key[2])
      }    
      notification(array[index], :points)
    end
  end
 
  #--------------------------------------------------------------------------
  # * Find Achievement Reward Index
  #--------------------------------------------------------------------------
  def find_achievement_reward_index(next_reward)
    array = Clstn_Achievement_System::Achievement_Point_Rewards
    array.size.times { |index|
      return index if array[index][0] == next_reward
    }
  end
  
  #--------------------------------------------------------------------------
  # * Check Status Completed
  #--------------------------------------------------------------------------
  def check_status_completed(index)
    array = Clstn_Achievement_System::Achievements[index]
    if array[:Repeatable] == false
      @achievement_status[index] = :Completed if array[:Tiers][-1] == @achievements[index]
    else
      @achievement_status[index] = :Completed if array[:Tiers][-1] == @achievements[index] && @achievement_repeated[index] == array[:Repeatable]
    end
  end
 
  #--------------------------------------------------------------------------
  # * Check Unlocked
  #--------------------------------------------------------------------------
  def check_unlock(index)
    unlocked = []
    item = Clstn_Achievement_System::Achievements
    Clstn_Achievement_System::Achievements.size.times { |i|
      unlocked.push(item[i][:Name]) if completed?(item[i], index, i)
    }
    return unlocked
  end
  
  #--------------------------------------------------------------------------
  # * Completed?
  #--------------------------------------------------------------------------
  def completed?(item, index, i)
    return false if item[:Prerequisite] == :none
    if item[:Prerequisite][0] == index
      limit = item[:Prerequisite][1]
      tier  = item[:Prerequisite][2]
      if @achievements[index] >= tier && @achievement_repeated[index] >= limit && @achievement_status[i] == :Locked
        @achievement_status[i] = :Unlocked
        return true
      else
        return false
      end
    end
  end
 
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def get_item(item)
    case item[0]
    when 0; item = $data_items[item[1]]
    when 1; item = $data_weapons[item[1]]
    when 2; item = $data_armors[item[1]]
    end
    return item
  end
 
  #--------------------------------------------------------------------------
  # * Notifications [Trigger]
  #--------------------------------------------------------------------------
  def notification(item, symbol)
    @notification_enabled = true
    temp = [item, symbol]
    @notifications.push(temp)
    SceneManager.call(Scene_Map) unless @notifications.size > 1
  end
 
end
 
#===========================================================================
# *** Class Game_Interpreter
#===========================================================================
class Game_Interpreter
 
  #--------------------------------------------------------------------------
  # * Increase Achievements
  #--------------------------------------------------------------------------
  def gain_achievement(amount, index)
    item = Clstn_Achievement_System::Achievements[index]
    tier = Clstn_Achievement_System::tier?(Clstn_Achievement_System::Achievements[index])
    if $game_party.achievements[index] != item[:Tiers][-1]
      if !Clstn_Achievement_System::locked?(item)
        if amount <= item[:Tiers][tier]
          $game_party.achievements[index] += amount
          set_achievement(item[:Tiers][tier], index) if $game_party.achievements[index] > Clstn_Achievement_System::Achievements[index][:Tiers][tier]
        else
          set_achievement(item[:Tiers][tier], index)
        end
      end
      $game_party.achievement_completed(index)
      if $game_party.achievements[index] == item[:Tiers][-1] && item[:Repeatable] != false && item[:Repeatable] > $game_party.achievement_repeated[index]
        $game_party.achievements[index] = 0
        $game_party.achievement_repeated[index] += 1
      end
    end
  end
 
  #--------------------------------------------------------------------------
  # * Decrease Achievements
  #--------------------------------------------------------------------------
  def lose_achievement(amount, index)
    item = Clstn_Achievement_System::Achievements[index]
    if $game_party.achievements[index] != item[:Tiers][-1]
      $game_party.achievements[index] -= amount unless Clstn_Achievement_System::locked?(Clstn_Achievement_System::Achievements[index])
    end
  end
 
  #--------------------------------------------------------------------------
  # * Set Achievements
  #--------------------------------------------------------------------------
  def set_achievement(amount, index)
    item = Clstn_Achievement_System::Achievements[index]
    if $game_party.achievements[index] != item[:Tiers][-1]
      $game_party.achievements[index] = amount unless Clstn_Achievement_System::locked?(Clstn_Achievement_System::Achievements[index])
      $game_party.achievement_completed(index)
      if $game_party.achievements[index] == item[:Tiers][-1] && item[:Repeatable] != false && item[:Repeatable] > $game_party.achievement_repeated[index]
        $game_party.achievements[index] = 0
        $game_party.achievement_repeated[index] += 1
      end
    end
  end
 
  #--------------------------------------------------------------------------
  # * Gain Achievement Points
  #--------------------------------------------------------------------------
  def gain_achievement_points(amount)
    $game_party.achievement_points += amount
  end
 
  #--------------------------------------------------------------------------
  # * Lose Achievement Points
  #--------------------------------------------------------------------------
  def lose_achievement_points(amount)
    $game_party.achievement_points -= amount
  end
 
  #--------------------------------------------------------------------------
  # * Set Achievement Points
  #--------------------------------------------------------------------------
  def set_achievement_points(amount)
    $game_party.achievement_points = amount
  end
  
  #--------------------------------------------------------------------------
  # * Get Achievement Name
  #--------------------------------------------------------------------------
  def achievement_name(index)
    return Clstn_Achievement_System::Achievements[index][:Name]
  end
  
  #--------------------------------------------------------------------------
  # * Get Achievement Item Reward
  #--------------------------------------------------------------------------
  def achievement_item(index)
    return $game_party.get_item(Clstn_Achievement_System::Achievements[index][:RewardItem]).name
  end
  
  #--------------------------------------------------------------------------
  # * Get Achievement Gold Reward
  #--------------------------------------------------------------------------
  def achievement_gold(index)
    return Clstn_Achievement_System::Achievements[index][:RewardGold]
  end
  
  #--------------------------------------------------------------------------
  # * Get Achievement Points Reward
  #--------------------------------------------------------------------------
  def achievement_points(index)
    return Clstn_Achievement_System::Achievements[index][:AchievementPoints]
  end
  
  #--------------------------------------------------------------------------
  # * Disable Achievements
  #--------------------------------------------------------------------------
  def achievement_title(index)
    return Clstn_Achievement_System::Achievements[index][:Title]
  end
  
  #--------------------------------------------------------------------------
  # * Get Achievement Times Repeated 
  #--------------------------------------------------------------------------
  def achievement_repeated(index)
    return $game_party.achievement_repeated[index]
  end
  
  #--------------------------------------------------------------------------
  # * Get Achievement Progress
  #--------------------------------------------------------------------------
  def achievement_progress(index)
    return $game_party.achievements[index]
  end
  
  #--------------------------------------------------------------------------
  # * Get Achievement Status
  #--------------------------------------------------------------------------
  def achievement_status(index)
    return false if Clstn_Achievement_System::Achievement[index][:Repeatable] == false
    return $game_party.achievement_status[index]
  end
  
  #--------------------------------------------------------------------------
  # * Get Party Achievement Points
  #--------------------------------------------------------------------------
  def party_achievement_points
    return $game_party.achievement_points
  end
  
end