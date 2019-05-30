=begin
===============================================================================
 Scene_SProposals by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can see sent proposals to another people.
--------------------------------------------------------------------------------
Used functions:

sentProposals
giveUp

Call:

SceneManager.call(Scene_SProposals)

=end

module EFE
  SP_GIVEUP_BUTTON = "Give up"
  SP_CANCEL_BUTTON = "Cancel"
  SP_HEADER_TEXT = "Sent Proposals"
  SP_GIVEUP_SUCCESS = "You gave up early"
  SP_GIVEUP_FAIL = "Couldn't give up. One more chance?"
end


class Window_SProposalCommand < Window_HorzCommand

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
    add_command(EFE::SP_GIVEUP_BUTTON,   :giveup)
    add_command(EFE::SP_CANCEL_BUTTON, :cancel)
  end
end
class Window_HeaderSProposal < Window_Base

  def initialize(x, y, text)
    super(x, y, 250, fitting_height(1))
    refresh(text)
  end
  
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

class Window_SProposalListCommand < Window_Command
  
  def initialize(x, y)
    super(x, y)
  end

  def draw_item(index)
    rect = item_rect_for_text(index)
    draw_text(rect.x, rect.y, contents_width, line_height, command_name(index), 1)
    
  end
  def window_width
    return 250
  end
  def window_height
    Graphics.height - 100
  end
  def make_command_list
    sProposals = sentProposals(GAME::NICKNAME_VARIABLE)
    sProposals.each {|i| add_command(i, i) }
  end

end

class Scene_SProposals < Scene_Base
  
  def start
    super
    create_background
    create_SProposalList_command
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_SProposalList_command
    @sproposallist_command_window = Window_SProposalListCommand.new(147, 50)
    @headerssproposal_command_window = Window_HeaderSProposal.new(147, 0, EFE::SP_HEADER_TEXT)
    @sproposal_command_window = Window_SProposalCommand.new(147, Graphics.height - 50)
    @sproposal_command_window.set_handler(:giveup,    method(:give_up))
    @sproposal_command_window.set_handler(:cancel,    method(:sproposal_cancel))
    @sproposallist_command_window.set_handler(:cancel,    method(:returning))
    @sproposallist_command_window.set_handler(:ok,    method(:list_ok))
    @sproposal_command_window.visible = false
    @sproposal_command_window.deactivate
  end

  def returning
    return_scene
  end
  
  def sproposal_cancel
    @sproposal_command_window.visible = false
    @sproposal_command_window.deactivate
    @sproposallist_command_window.activate
  end
  
  def list_ok
    @sproposal_command_window.visible = true
    @sproposal_command_window.activate
    @sproposallist_command_window.deactivate
  end
  
  def give_up
    $game_variables[GAME::COUPLE_PROPOSE_NICKNAME_VARIABLE] = @sproposallist_command_window.current_symbol
    $proposeSearch = ""
    if giveUp(GAME::NICKNAME_VARIABLE, GAME::COUPLE_PROPOSE_NICKNAME_VARIABLE)
      return_scene
      messagebox(EFE::SP_GIVEUP_SUCCESS, 250)
    else 
      return_scene
      messagebox(EFE::SP_GIVEUP_FAIL,300)
    end
  end
end 