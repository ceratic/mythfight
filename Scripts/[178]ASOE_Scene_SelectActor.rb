#===============================================================================
# Scene_CreateCharacter by Efeberk, Malagar
#
# Version: 1.1
#===============================================================================
#
#===============================================================================

#--------------------------------------------------------------------------
# * 
#--------------------------------------------------------------------------
module EFE
  CC_ACCEPT_BUTTON = "Accept"
  CC_CANCEL_BUTTON = "Cancel"
  CC_HEADER_TEXT   = "Select Character"
  CC_SUCCESS       = "Character selected!"
  CC_FAIL_REGISTER = "Couldn't select character!"
  CC_FAIL_EXISTS   = "Character already exists on account!"
end

#--------------------------------------------------------------------------
# * 
#--------------------------------------------------------------------------
class Window_SelectCharCommand < Window_HorzCommand

  def initialize(x, y)
    super(x, y)
  end

  def window_width
    480
  end

  def col_max
    return 5
  end

  def make_command_list
    add_command(EFE::CC_ACCEPT_BUTTON, :accept)
    add_command(EFE::CC_CANCEL_BUTTON, :cancel)
  end
  
end

#--------------------------------------------------------------------------
# * 
#--------------------------------------------------------------------------
class Window_CharStats < Window_Base

  def initialize(x, y, id, actorslist)
    super(x, y, 480, fitting_height(4))
    @actorslist = []
    @actorslist = actorslist
    @id = id
    refresh
  end
  
  def update
    if self.active
      if Input.repeat?(:LEFT)
        @id -= 1 if @id > 1
      elsif Input.repeat?(:RIGHT)
        @id += 1 if @id < 9
      elsif Input.repeat?(:UP)
        @id -= 6 if @id > 6 
      elsif Input.repeat?(:DOWN)
        @id += 6 if @id < 7 && @actorslist.length > 6
      end
      if @id > @actorslist.length
        @id = @actorslist.length
      elsif @id < 0
        @id = 1
      end
      refresh
    end
  end
  
  def max_parameter(char_id, index)
    $data_classes[$game_actors[char_id].class_id].params[index, 99]
  end
  
  def refresh
    contents.clear
    draw_text(160, 0, 120, line_height, $game_actors[@id].class.name , 1)
    draw_text(10, 15, 120, line_height, Vocab::param(2), 1)
    draw_gauge(10, 25, 120,$game_actors[@id].atk.to_f/max_parameter(@id, 2), text_color(30), text_color(31))
    draw_text(10, 55, 120, line_height, Vocab::param(3), 1)
    draw_gauge(10, 65, 120,$game_actors[@id].def.to_f/max_parameter(@id, 3), text_color(14), text_color(17))
    draw_text(160, 15, 120, line_height, Vocab::param(0), 1)
    draw_gauge(160, 25, 120,$game_actors[@id].mhp.to_f/max_parameter(@id, 0), text_color(18), text_color(2))
    draw_text(160, 55, 120, line_height, Vocab::param(1), 1)
    draw_gauge(160, 65, 120,$game_actors[@id].mmp.to_f/max_parameter(@id, 1), text_color(22), text_color(23))
    draw_text(320, 15, 120, line_height, Vocab::param(7), 1)
    draw_gauge(320, 25, 120,$game_actors[@id].luk.to_f/max_parameter(@id, 7), text_color(27), text_color(27))
    draw_text(320, 55, 120, line_height, Vocab::param(6), 1)
    draw_gauge(320, 65, 120,$game_actors[@id].agi.to_f/max_parameter(@id, 6), tp_gauge_color1, tp_gauge_color2)
  end

end

#--------------------------------------------------------------------------
# * 
#--------------------------------------------------------------------------
class Window_HeaderCharCreate < Window_Base

  def initialize(x, y, text)
    super(x, y, 480, fitting_height(1))
    refresh(text)
  end
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

#--------------------------------------------------------------------------
# * 
#--------------------------------------------------------------------------
class Window_CharCreateList < Window_Command
  
  def initialize(x, y, actorslist)
    @actorslist = []
    @actorslist = actorslist
    super(x, y)
  end

  def window_height
    return 192
  end
  
  def window_width
    return 480
  end
  
  def draw_item(index)
    rect = item_rect(index)
    enabled = false
    if @actorslist.length > 0
      i = 0
      while i < @actorslist.length
        if @actorslist[i].to_i == index+1
         enabled = true
         break
        end
        i += 1
      end
    end
    if enabled
      draw_character($game_actors[index+1].character_name, $game_actors[index+1].character_index, rect.x+24, rect.y+32)
    end
  end
  
  def col_max
    return 6
  end

  def item_height
    return 36
  end

  def make_command_list
    @actorslist.length.times {|i| add_command(i, i+1) }
  end

end

#--------------------------------------------------------------------------
# * 
#--------------------------------------------------------------------------
class Scene_CharCreate < Scene_Base
  
  def start
    super
    create_background
    create_char_windows
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_char_windows
    @actorslist = ASOE_CORE.startingActors(ASOE::VAR_ACCOUNTNAME)
    @headercreate = Window_HeaderCharCreate.new(32, 0, EFE::CC_HEADER_TEXT)
    @charcreatelist = Window_CharCreateList.new(32, 50, @actorslist)
    @selectcharcommand = Window_SelectCharCommand.new(32, 366)
    @charstats = Window_CharStats.new(32, 242, 1, @actorslist)
    @charstats.activate
    @selectcharcommand.deactivate
    @selectcharcommand.visible = false
    @charcreatelist.set_handler(:ok,    method(:char_ok))
    @charcreatelist.set_handler(:cancel,    method(:return_scene))
    @selectcharcommand.set_handler(:accept,    method(:char_accept))
    @selectcharcommand.set_handler(:cancel,    method(:char_cancel))
  end
  
  def char_ok
    @charstats.deactivate
    @selectcharcommand.activate
    @selectcharcommand.visible = true
  end
  
  def char_accept
    var_account =  $game_variables[ASOE::VAR_ACCOUNTNAME]
    var_nickname = $game_variables[ASOE::VAR_ACTORNAME]
    actor_id = @actorslist[@charcreatelist.current_symbol.to_i-1].to_i
    #actor_id = @charcreatelist.current_symbol.to_i
    $game_variables[ASOE::VAR_ACTORID] = actor_id
    exists = ASOE_CORE.actorExists?(ASOE::VAR_ACCOUNTNAME, ASOE::VAR_ACTORID)
    if exists == false
      ASOE_CORE.nameActor(ASOE::VAR_ACTORNAME, ASOE::VAR_ACTORID)
      result = ASOE_CORE.updateActor(ASOE::VAR_ACCOUNTNAME, ASOE::VAR_ACTORID)  
      if result != ASOE::ERROR_CODE
        return_scene
        messagebox(EFE::CC_SUCCESS, 250)
      else
        #return_scene
        messagebox(EFE::CC_FAIL_REGISTER, 250)
      end
    else
      #return_scene
      messagebox(EFE::CC_FAIL_EXISTS, 250)
    end
  end
  
  def char_cancel
    @charcreatelist.activate
    @selectcharcommand.visible = false
  end
  
end
#===============================================================================
# End
#===============================================================================