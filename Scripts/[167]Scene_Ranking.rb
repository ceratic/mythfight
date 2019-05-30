module EFE
  RANK_ICONS = [125, 126, 127, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186]
end

class Window_HeaderRanking < Window_Base

  def initialize(x, y, text)
    super(x, y, 250, fitting_height(1))
    refresh(text)
  end
  
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

class Window_RankingCommand < Window_Command
  
  def initialize(x, y, ranking)
    @ranking = ranking
    super(x, y)
  end

  def draw_item(index)
    item = command_name(index)
    name = item.split(':')[0]
    value = item.split(':')[1]
    rect = item_rect_for_text(index)
    draw_icon(EFE::RANK_ICONS[index], rect.x, rect.y, true)
    draw_text(rect.x+32, rect.y, contents_width, line_height, name, 0)
    draw_text(rect.x-10, rect.y, contents_width, line_height, value, 2)
    
  end
  def window_width
    return 250
  end
  def window_height
    Graphics.height - 50
  end
  def make_command_list
    @ranking.each {|i| add_command(i, i) }
  end

end

class Scene_Ranking < Scene_Base
  
  def start
    super
    create_background
    create_Ranking_command
  end
  
  def prepare(title, ranking)
    @title = title
    @ranking = ranking
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_Ranking_command
    @Ranking_command_window = Window_RankingCommand.new(200, 50, @ranking)
    @hRank_command_window = Window_HeaderRanking.new(200, 0, @title)
    @Ranking_command_window.set_handler(:cancel,    method(:return_scene))
    @Ranking_command_window.set_handler(:ok,    method(:name_of))
  end

  def name_of
    @Ranking_command_window.activate
  end
end 