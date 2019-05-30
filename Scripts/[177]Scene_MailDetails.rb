=begin
===============================================================================
 Scene_MailDetails by efeberk
 Version: RGSS3
===============================================================================
 This script will allow player can see chosen mail's details 
--------------------------------------------------------------------------------
Used functions:

readMail

Call:

SceneManager.call(Scene_MailDetails)
SceneManager.scene.prepare(mail)

=end

module EFE
  MD_BACK_BUTTON = "Back"
  MD_TITLE_TEXT = "Title"
  MD_SENDER_TEXT = "Sender"
end

class Window_MailDetailsCommand < Window_HorzCommand

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
    add_command(EFE::MD_BACK_BUTTON,   :back)
  end
end

class Window_MailOtherDetails < Window_Selectable

  def initialize(x, y, text)
    super(x, y, 250, fitting_height(1))
    refresh(text)
  end
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

class Window_HeaderDetails < Window_Selectable

  def initialize(x, y, text)
    super(x, y, 250, fitting_height(1))
    refresh(text)
  end
  
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

class Window_MailDetails < Window_Base

  def initialize(x, y, text)
    super(x, y, 250, fitting_height(text.length/20))
    refresh(text)
  end
  
  
  def refresh(text)
    #text = text.split(':')[1]
    #m_length = text.length / 21
    #m_length.times {|i| text.insert(20*(i+1), "\n") }
    draw_text_ex(4, 0, text)
  end

end

class Scene_MailDetails < Scene_Base
  
  def prepare(text)
    ASOE_MAIL.readMail(text.split(':')[4])
    @text = text
  end
  
  def start
    super
    create_background
    create_MailDetails_command
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def create_MailDetails_command
    @MailDetails_command_window = Window_MailDetails.new(147, 50, @text)
    @headermaildetails = Window_HeaderDetails.new(147, 0, EFE::MD_TITLE_TEXT + " : " + @text.split(':')[0])
    @otherdetails = Window_HeaderDetails.new(147, @MailDetails_command_window.height + 51, EFE::MD_SENDER_TEXT + ":" + @text.split(':')[2])
    @mail_details_command = Window_MailDetailsCommand.new(147, @MailDetails_command_window.height + 100)
    @mail_details_command.set_handler(:back,    method(:back_ok))
  end

  
  def back_ok
    return_scene
    SceneManager.call(Scene_MailBox)
  end
  
end 