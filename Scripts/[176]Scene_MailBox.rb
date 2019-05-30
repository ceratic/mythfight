=begin
===============================================================================
 Scene_MailBox by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can see mails from another people.
--------------------------------------------------------------------------------
Used functions:

mailList

Call:

SceneManager.call(Scene_MailBox)

=end


module EFE
  MAIL_ICONS = [529, 528]
  MB_SENDER_TEXT = "Sender"
  MB_HEADER_TEXT = "Mail Box"
end

class Window_HeaderMailBox < Window_Base

  def initialize(x, y, text)
    super(x, y, 250, fitting_height(1))
    refresh(text)
  end
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

class Window_MailBoxCommand < Window_Command
  
  def initialize(x, y)
    super(x, y)
  end

  def draw_item(text)
    rect = item_rect_for_text(text)
    text = command_name(text)
    draw_icon(EFE::MAIL_ICONS[text.split(':')[3].to_i], rect.x, rect.y, true)
    draw_text(rect.x+32, rect.y, contents_width, line_height, text.split(':')[0], 0)
    draw_text(rect.x-10, rect.y+25, contents_width, line_height, EFE::MB_SENDER_TEXT + " : " + text.split(':')[2], 2)
  end
  
  def window_width
    return 250
  end
  
  def item_height
    return 48
  end
  
  def window_height
    Graphics.height - 100
  end
  
  def make_command_list
    mailBox = ASOE_MAIL.mailList(ASOE::VAR_ACCOUNTNAME)
    if(mailBox.length > 0)
      mailBox.each {|i| add_command(i, i)  }
    end
  end

end

class Scene_MailBox < Scene_Base
  
  def start
    super
    create_background
    create_MailBox_command
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_MailBox_command
    @MailBox_command_window = Window_MailBoxCommand.new(147, 50)
    @headercouplelist = Window_HeaderMailBox.new(147, 0, EFE::MB_HEADER_TEXT)
    @MailBox_command_window.set_handler(:cancel,    method(:returning))
    @MailBox_command_window.set_handler(:ok,    method(:mail_ok))
  end

  def returning
    return_scene
  end
  
  def mail_ok
    return_scene
    SceneManager.call(Scene_MailDetails)
    SceneManager.scene.prepare(@MailBox_command_window.current_symbol)
  end
  
end 