=begin
===============================================================================
 MessageBox by efeberk
 Version: RGSS3
===============================================================================
 This script will allow to open a new messagebox window only with a text.
--------------------------------------------------------------------------------

Call MessageBox in Script:

messagebox(text, width)

width : width of the window

=end

class Window_MessageBox < Window_Base

  def initialize(x, y, text, width)
    super(x, y, width, fitting_height(1))
    refresh(text)
  end
  
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

class Scene_MessageBox < Scene_Base
  
  def start
    super
    create_message_window
    create_background
  end
  
  def prepare(text, width)
    @text = text
    @width = width
  end
  
  def update
    super
    if Input.repeat?(:B) || Input.repeat?(:C)
      SceneManager.return
    end
  end
  
  def create_message_window
    @message_window = Window_MessageBox.new(0, 0, @text, @width)
    @message_window.width = @width
    @message_window.x = (Graphics.width / 2) - (@message_window.width / 2)
    @message_window.y = (Graphics.height / 2) - (@message_window.height / 2)
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(100, 100, 100, 128)
  end
end

def messagebox(text, width)
    SceneManager.call(Scene_MessageBox)
    SceneManager.scene.prepare(text, width)
end