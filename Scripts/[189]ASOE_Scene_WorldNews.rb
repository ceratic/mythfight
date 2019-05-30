#===============================================================================
# ASOE WorldNews Window by Malagar
#
# Version: 1.0
#SceneManager.call(Scene_WorldNews)
#===============================================================================

class Window_NewsCommand < Window_HorzCommand

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
    add_command("Ok",   :back)
  end
  
end

class Window_NewsHeader < Window_Base

  def initialize(x, y)
    super(x, y, 250, fitting_height(1))
    refresh()
  end
  
  def refresh()
    draw_text(0, 0, contents_width, line_height, "ASOE SERVER WORLD NEWS", 1)
  end

end

class Window_NewsTitle < Window_Base

  def initialize(x, y, icon, text)
    super(x, y, 250, fitting_height(1))
    refresh(text, icon)
  end
  
  def refresh(text, icon)
    draw_icon(icon.to_i, 0, 0)
    draw_text(24, 0, contents_width, line_height, text.upcase, 1)
  end

end

class Window_NewsDetails < Window_Base

  def initialize(x, y, text)
    super(x, y, 250, 100)
    refresh(text)
  end
  
  def refresh(text)
    draw_text_ex(4, 0, text)
  end

end

#--------------------------------------------------------------------------
# * 
#--------------------------------------------------------------------------
class Scene_WorldNews < Scene_Base
  
  def prepare()
    @rawtext = ASOE_WORLD.getNews()
    @title = []
    @icon = []
    @text = []
    for news in @rawtext
      @title.push news.split(':')[0].to_s
      @icon.push news.split(':')[1].to_i
      @text.push news.split(':')[2].to_s
    end
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
    @NewsHeader = Window_NewsHeader.new((Graphics.width/2)-125, 0)
    if @icon[0] > 0
      @NewsHeader1 = Window_NewsTitle.new(10, 50, @icon[0], @title[0])
      @NewsDetails1 = Window_NewsDetails.new(10, 100, @text[0])
    end
    if @icon[1] > 0
      @NewsHeader2 = Window_NewsTitle.new((Graphics.width/2)+10, 50, @icon[1], @title[1])
      @NewsDetails2 = Window_NewsDetails.new((Graphics.width/2)+10, 100, @text[1])
    end
    if @icon[2] > 0
      @NewsHeader3 = Window_NewsTitle.new(10, (Graphics.height/2), @icon[2], @title[2])
      @NewsDetails3 = Window_NewsDetails.new(10, (Graphics.height/2)+50, @text[2])
    end
    if @icon[3] > 0
      @NewsHeader4 = Window_NewsTitle.new((Graphics.width/2)+10, (Graphics.height/2), @icon[3], @title[3])
      @NewsDetails4 = Window_NewsDetails.new((Graphics.width/2)+10, (Graphics.height/2)+50, @text[3])
    end
  
    @NewsCommand = Window_NewsCommand.new((Graphics.width/2)-125, (Graphics.height/2)+155)
    @NewsCommand.set_handler(:back, method(:back_ok))
  end

  def back_ok
    return_scene
  end
  
end
#===============================================================================
# End
#===============================================================================