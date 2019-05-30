#===============================================================================
# ASOE MatchMaking Window by Malagar
#
# Version: 1.0
# SceneManager.call(Scene_MatchMaking)
#===============================================================================

class Window_MatchCommand < Window_HorzCommand

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
    add_command("Cancel", :cancel)
    add_command("Next",   :next)
    add_command("Fight",  :fight)
  end
  
end

class Window_MatchHeader < Window_Base

  def initialize(x, y)
    super(x, y, 250, fitting_height(1))
    refresh()
  end
  
  def refresh()
    draw_text(0, 0, contents_width, line_height, "Arena Opponent Finder", 1)
  end

end

class Window_MatchProfile < Window_Base

  def initialize(x, y, accountname, profiledata)
    super(x, y, 500, fitting_height(1))
    @accountname = accountname
    @level = profiledata[0]
    @exp = profiledata[1]
    @score = profiledata[2]
    @rank = profiledata[3]
    @guild = profiledata[4]
    @logDate = profiledata[5]
    @icon = profiledata[6]
    refresh()
  end
  
  def refresh()
    draw_icon(@icon.to_i, 0, 0)
    draw_text_ex(24, 0, @accountname)
    draw_text_ex(120, 0, "LVL: " + @level.to_s)
    draw_text_ex(150, 0, "Rank: " + @rank.to_s)
  end

end

class Window_MatchParty < Window_Base

  def initialize(x, y, partydata)
    super(x, y, 500, 300)
    @member = []
    i=0
    for members in partydata
      @member = members.split(':')
      
      draw_face(@member[3].to_s, @member[4].to_i, 0, line_height*i, true)
      draw_text_ex(100, line_height*i, $game_actors[@member[0].to_i].actor.name)
      draw_text_ex(200, line_height*i, "LVL: " + @member[5].to_s)
      i+=1
    end
    refresh()
  end
  
  def refresh()
  end

end

#--------------------------------------------------------------------------
# * 
#--------------------------------------------------------------------------
class Scene_MatchMaking < Scene_Base
  
  def prepare()
    @profiledata = []
    @partydata = []
    @profiledata = ASOE_PROFILE.getProfile(ASOE::VAR_ACCOUNTNAME)
    @partydata   = ASOE_PROFILE.getActors(ASOE::VAR_ACCOUNTNAME)
    @accountname = $game_variables[ASOE::VAR_ACCOUNTNAME]
  end
  
  def start
    super
    prepare
    create_background
    create_NewsDetails_command
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_NewsDetails_command
    @MatchHeader = Window_MatchHeader.new((Graphics.width/2)-125, 0)
    @MatchProfile = Window_MatchProfile.new((Graphics.width/2)-250, 50, @accountname, @profiledata)
    @MatchParty = Window_MatchParty.new((Graphics.width/2)-250, 100, @partydata)
    @NewsCommand = Window_MatchCommand.new((Graphics.width/2)-125, (Graphics.height/2)+155)
    @NewsCommand.set_handler(:cancel, method(:back_ok))
    @NewsCommand.set_handler(:next, method(:back_ok))
    @NewsCommand.set_handler(:fight, method(:back_ok))
  end

  def back_ok
    return_scene
  end
  
end
#===============================================================================
# End
#===============================================================================