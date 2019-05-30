#===============================================================================
# ASOE Overwrites by Malagar
#===============================================================================

#==============================================================================
# Scene Title
#==============================================================================
class Scene_Title < Scene_Base
  def start
    SceneManager.clear
    Graphics.freeze
    DataManager.setup_new_game
    $game_map.autoplay
    SceneManager.goto(Scene_Map)
  end
  
  def terminate
    SceneManager.snapshot_for_background
    Graphics.fadeout(Graphics.frame_rate)
  end
end

#==============================================================================
# Scene Menu
#==============================================================================
class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * [Go to Title] Command
  #--------------------------------------------------------------------------
  def command_to_title
    close_command_window
    fadeout_all
    ASOE_CORE.logout(ASOE::VAR_ACCOUNTNAME)
    SceneManager.goto(Scene_Title)
  end
  #--------------------------------------------------------------------------
  # * [Exit Game] Command
  #--------------------------------------------------------------------------
  def command_game_end
    ASOE_CORE.logout(ASOE::VAR_ACCOUNTNAME)
    SceneManager.call(Scene_End)
  end
end

#==============================================================================
# Game_Party
#==============================================================================
class Game_Party < Game_Unit
  attr_reader   :actors
  
  alias efeberk_scenecharacter_gameparty_initialize initialize
  def initialize
    efeberk_scenecharacter_gameparty_initialize
  end
  
  def set_party_order_to_array(array)
    @actors = Array.new(array)
  end
  
  def add_actor_at(actor_id, index)
    @actors.insert(index, actor_id) unless @actors.include?(actor_id)
    $game_player.refresh
    $game_map.need_refresh = true
  end

end

#==============================================================================
# Game_Interpreter
#==============================================================================
class Game_Interpreter
 def add_actor(actor_id, index = $game_party.all_members.size, initialize = false)
  actor = $game_actors[actor_id]
  if actor
   if initialize
    $game_actors[actor_id].setup(actor_id)
   end
   index = $game_party.all_members.size if index > $game_party.all_members.size
   $game_party.add_actor_at(actor_id, index)
  end
 end
end 

#==============================================================================
# Game_BattlerBase
#==============================================================================
class Game_BattlerBase
  attr_reader   :state_steps
  alias efeberk_battlebase_initialize initialize
  def initialize
    efeberk_battlebase_initialize
  end
end

#==============================================================================
# Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  alias :new_code_level_up :level_up
  
  def level_up
    $game_variables[ASOE::VAR_ACTORID] = self.id
    if ASOE_CORE.checkActorChecksum(ASOE::VAR_ACCOUNTNAME, ASOE::VAR_ACTORID) == true
      new_code_level_up
      ASOE_CORE.updateActorChecksum(ASOE::VAR_ACCOUNTNAME, ASOE::VAR_ACTORID)
    else
      ASOE_CORE.addPenalty(ASOE::VAR_ACCOUNTNAME, ASOE::NUM_BANLEVEL_MAX)
    end
  end
  
end