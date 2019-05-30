=begin
===============================================================================
 Scene_Propose by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can propose to another lady/lad.
--------------------------------------------------------------------------------
Used functions:

sex
proposeTo

Call:

SceneManager.call(Scene_Propose)

=end

module EFE
  P_PROPOSE_BUTTON = "Propose"
  P_CANCEL_BUTTON = "Cancel"
  P_HEADER_TEXT = "Propose a lady/lad"
  P_SUCCESS = "Proposed succesfully"
  P_FAIL = "Couldn't propose"
  P_HAS_COUPLE = "This user has a couple"
end

class Window_ProposeCommand < Window_HorzCommand

  def initialize(x, y)
    super(x, y)
  end

  def window_width
    250
  end

  def col_max
    return 2
  end

  def make_command_list
    add_command(EFE::P_PROPOSE_BUTTON,   :propose)
    add_command(EFE::P_CANCEL_BUTTON, :cancel)
  end
end
class Window_HeaderPropose < Window_Base

  def initialize(x, y, text)
    super(x, y, 250, fitting_height(1))
    refresh(text)
  end
  
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

class Window_ProposeListCommand < Window_Command
  
  def initialize(x, y)
    super(x, y)
  end

  def draw_item(index)
    rect = item_rect_for_text(index)
    draw_icon(EFE::SEX_ICONS[command_name(index).split(';')[1].to_i-1], rect.x, rect.y, true)
    draw_text(rect.x, rect.y, contents_width, line_height, command_name(index).split(';')[0], 1)
    
  end
  def window_width
    return 250
  end
  def window_height
    Graphics.height - 100
  end
  def make_command_list
    proposeList = sex(GAME::GENDER_VARIABLE)
    $proposeSearch = "" if $game_variables[GAME::COUPLE_SEARCH_NICKNAME_VARIABLE] == 0
    proposeList.each {|i| add_command(i, i.split(';')[0]) if i.split(';')[0].downcase.include?($proposeSearch.to_s.downcase) }
  end

end

class Scene_Propose < Scene_Base
  
  def start
    super
    create_background
    create_ProposeList_command
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_ProposeList_command
    @proposelist_command_window = Window_ProposeListCommand.new(147, 50)
    @headerpropose_command_window = Window_HeaderPropose.new(147, 0, EFE::P_HEADER_TEXT)
    @propose_command_window = Window_ProposeCommand.new(147, Graphics.height - 50)
    @propose_command_window.set_handler(:propose,    method(:propose_ok))
    @propose_command_window.set_handler(:cancel,    method(:propose_cancel))
    @proposelist_command_window.set_handler(:cancel,    method(:returning))
    @proposelist_command_window.set_handler(:ok,    method(:list_ok))
    @propose_command_window.visible = false
    @propose_command_window.deactivate
  end

  def returning
    return_scene
  end
  
  def list_ok
    @propose_command_window.visible = true
    @propose_command_window.activate
  end
  
  def propose_ok
    $game_variables[GAME::COUPLE_PROPOSE_NICKNAME_VARIABLE] = @proposelist_command_window.current_symbol
    $proposeSearch = ""
    if !userHasCouple?(GAME::COUPLE_PROPOSE_NICKNAME_VARIABLE) && !userHasCouple?(GAME::NICKNAME_VARIABLE)
      if proposeTo(GAME::NICKNAME_VARIABLE, GAME::COUPLE_PROPOSE_NICKNAME_VARIABLE)
        return_scene
        messagebox(EFE::P_SUCCESS, 200)
      else 
        return_scene
        messagebox(EFE::P_FAIL, 200)
      end
    else
      return_scene
      messagebox(EFE::P_HAS_COUPLE, 200)
    end
  end
  
  def propose_cancel
    @propose_command_window.visible = false
    @propose_command_window.deactivate
    @proposelist_command_window.activate
  end
end 