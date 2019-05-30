#===============================================================================
# ASOE Reward Window by Malagar
#
# Version: 1.0
# SceneManager.call(Scene_Reward)
#===============================================================================

class Window_RewardCommand < Window_HorzCommand

  def initialize(x, y)
    super(x, y)
  end

  def window_width
    250
  end

  def col_max
    return 1
  end

  def make_command_list
    add_command("Collect",  :collect)
  end
  
end

class Window_RewardHeader < Window_Base

  def initialize(x, y, title)
    super(x, y, 250, fitting_height(1))
    @title = title
    refresh()
  end
  
  def refresh()
    Font.default_bold = true
    if @title != nil && @title != ""
      draw_text(4, 0, contents_width, line_height, @title, 1)
    else
      draw_text(4, 0, contents_width, line_height, "Claim Reward!", 1)
    end
    Font.default_bold = false
  end

end

class Window_RewardProfile < Window_Base

  def initialize(x, y, rewardData)
    #name, description, exp, accountgain, gold, items, icon, variables, switches
    @rewarddata = rewardData
    @rdescription = @rewarddata.split(';')[1]
    @rexp = @rewarddata.split(';')[2]
    @rgold = @rewarddata.split(';')[4]
    @ritems = @rewarddata.split(';')[5]
    super(x, y, 250, fitting_height(6))
    refresh()
  end
  
  def refresh()
    draw_text_ex(4, 0, @rdescription)
    draw_icon(ASOE_REWARDS::ICON_GOLD, 36, line_height*3)
    draw_text_ex(60, line_height*3, @rgold.to_s)
    draw_icon(ASOE_REWARDS::ICON_EXP, 128, line_height*3)
    draw_text_ex(152, line_height*3, @rexp.to_s)
  end

end

#--------------------------------------------------------------------------
# * 
#--------------------------------------------------------------------------
class Scene_Reward < Scene_Base
  
  def prepare(rewardData)
    #name, description, exp, accountgain, gold, items, icon, variables, switches
    @rewarddata = rewardData
    @rewardtitle = @rewarddata.split(';')[0]
    @rewardicon = @rewarddata.split(';')[6]
  end
  
  def start
    super
    create_background
    create_RewardDetails_command
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_RewardDetails_command
    @RewardHeader = Window_RewardHeader.new((Graphics.width/2)-125, 50, @rewardtitle)
    @RewardProfile = Window_RewardProfile.new((Graphics.width/2)-125, 100, @rewarddata)
    @NewsCommand = Window_RewardCommand.new((Graphics.width/2)-125, 300)
    @NewsCommand.set_handler(:collect, method(:back_ok))
  end

  def back_ok
    return_scene
  end
  
end
#===============================================================================
# End
#===============================================================================