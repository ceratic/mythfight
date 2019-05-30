=begin
===============================================================================
 Scene_RProposals by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can see received proposals from another people.
--------------------------------------------------------------------------------
Used functions:

receivedProposals
makeCouple

Call:

SceneManager.call(Scene_RProposals)

=end

module EFE
  RP_HEADER_TEXT = "Received Proposals"
  RP_ACCEPT_BUTTON = "Accept"
  RP_REJECT_BUTTON = "Reject"
  RP_CANCEL_BUTTON = "Cancel"
  RP_SUCCESS = "Accepted succesfully"
  RP_FAIL = "Couldn't accept"
end

class Window_ProposalCommand < Window_HorzCommand

  def initialize(x, y)
    super(x, y)
  end

  def window_width
    250
  end

  def col_max
    return 3
  end

  def make_command_list
    add_command(EFE::RP_ACCEPT_BUTTON,   :accept)
    add_command(EFE::RP_REJECT_BUTTON, :reject)
    add_command(EFE::RP_CANCEL_BUTTON, :cancel)
  end
end

class Window_HeaderProposal < Window_Base

  def initialize(x, y, text)
    super(x, y, 250, fitting_height(1))
    refresh(text)
  end
  
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

class Window_ProposalListCommand < Window_Command
  
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
    rProposals = receivedProposals(GAME::NICKNAME_VARIABLE)
    rProposals.each {|i| add_command(i, i) }
  end

end

class Scene_RProposals < Scene_Base
  
  def start
    super
    create_background
    create_ProposalList_command
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_ProposalList_command
    @proposallist_command_window = Window_ProposalListCommand.new(147, 50)
    @headerproposal_command_window = Window_HeaderProposal.new(147, 0, EFE::RP_HEADER_TEXT)
    @proposal_command_window = Window_ProposalCommand.new(147, Graphics.height - 50)
    @proposal_command_window.set_handler(:accept,    method(:propose_accept))
    @proposal_command_window.set_handler(:reject,    method(:propose_reject))
    @proposal_command_window.set_handler(:cancel,    method(:returning))
    @proposallist_command_window.set_handler(:cancel,    method(:returning))
    @proposallist_command_window.set_handler(:ok,    method(:list_ok))
    @proposal_command_window.deactivate
    @proposal_command_window.visible = false
  end

  def returning
    return_scene
  end
  
  def list_ok
    @proposal_command_window.visible = true
    @proposal_command_window.activate
  end
  
  def propose_accept
    $game_variables[GAME::COUPLE_PROPOSE_NICKNAME_VARIABLE] = @proposallist_command_window.current_symbol
    $proposeSearch = ""
    if makeCouple(GAME::NICKNAME_VARIABLE, GAME::COUPLE_PROPOSE_NICKNAME_VARIABLE)
      return_scene
      messagebox(EFE::RP_SUCCESS, 200)
    else 
      return_scene
      messagebox(EFE::RP_FAIL, 200)
    end
  end
  
  def propose_reject
    @proposal_command_window.visible = false
    @proposal_command_window.deactivate
    @proposallist_command_window.activate
  end
end 