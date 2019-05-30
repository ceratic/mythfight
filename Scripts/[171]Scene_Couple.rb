=begin
===============================================================================
 Scene_Couple by efeberk
 Version: RGSS3
===============================================================================
 This script will allow to open couple details of player.
--------------------------------------------------------------------------------
Used functions:

coupleInfos
leaveCouple

Call:

SceneManager.call(Scene_Couple)

=end

module EFE
  CP_POINTS_TEXT = "Couple Points"
  CP_COUPLES_TEXT = "Couples"
  CP_LEAVE_BUTTON = "Leave Cpl"
  CP_CANCEL_BUTTON = "Cancel"
  CP_LEAVE_SUCCESS = "You broke up succesfully"
  CP_LEAVE_FAIL = "Couldn't break up. God says think twice"
end

class Window_CoupleStatus < Window_Base

  def initialize(x, y, text)
    super(x, y, 250, fitting_height(5))
    refresh(text)
  end
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, line_color)
  end
  
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
  
  def refresh(text)
    p = EFE::CP_POINTS_TEXT + " : "+text[2].to_i.to_s
    draw_text(0, 0, contents_width, line_height, EFE::CP_COUPLES_TEXT, 1)
    draw_horz_line(12)
    draw_icon(122, 95, 40, true)
    draw_text(0, 40, 90, line_height, text[0], 1)
    draw_text(120, 40, 105, line_height, text[1], 1)
    draw_text(0, 85, contents_width, line_height, p, 1)
  end

end
class Window_LeaveCouple < Window_HorzCommand

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
    add_command(EFE::CP_LEAVE_BUTTON,   :leave)
    add_command(EFE::CP_CANCEL_BUTTON, :cancel)
  end
end
class Scene_Couple < Scene_Base
  
  def start
    super
    create_background
    create_items
  end
  
  def create_items
    coupleInfo = coupleInfos(GAME::NICKNAME_VARIABLE)
    @couplestatus = Window_CoupleStatus.new(147, 150, coupleInfo)
    @coupleleave = Window_LeaveCouple.new(147, 295)
    @coupleleave.set_handler(:leave,    method(:leave_couple))
    @coupleleave.set_handler(:cancel,    method(:couple_cancel))
  end
  
  def leave_couple
    return_scene
    if(leaveCouple(GAME::NICKNAME_VARIABLE))
      messagebox(EFE::CP_LEAVE_SUCCESS, 250)
    else
      messagebox(EFE::CP_LEAVE_FAIL, 350)
    end
  end
  
  def couple_cancel
    return_scene
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
end