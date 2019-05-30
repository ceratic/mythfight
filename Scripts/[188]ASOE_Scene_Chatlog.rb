
class Window_ChatLog < Window_Base
  
  WIDTH = 500
  HEIGHT = 75
  HEIGHT_EXPANDED = 175
  MAX_CHAT = 30
  ChatBuffer = []
  
  def initialize
    super(0,0,WIDTH,HEIGHT)
    self.x = (Graphics.width/2) - (WIDTH/2)
    self.y = Graphics.height - HEIGHT
    check_visible
    draw_chat
  end
 
  def add_chat(text)
    if text != nil
      ChatBuffer.unshift text
    end
    if ChatBuffer.size > MAX_CHAT
      ChatBuffer.pop
    end
    check_visible
    draw_chat
  end
  
  def draw_chat
    contents.clear
    create_contents
    yoffset = self.oy + self.contents_height
    for chats in ChatBuffer
      yoffset = yoffset - self.line_height
      draw_text_ex(2,yoffset,chats)
    end
  end
   
  def check_visible
    if $game_switches[ASOE::SWI_CHAT_ENABLED] == true && $game_switches[ASOE::SWI_CHAT_EXPANDED] == true
      self.height = HEIGHT_EXPANDED
      self.y = Graphics.height - self.height
    else
      self.height = HEIGHT
      self.y = Graphics.height - self.height
    end
    if $game_switches[ASOE::SWI_CHAT_ENABLED] == true && $game_switches[ASOE::SWI_CHAT_SHOW] == true
      self.opacity = 255
      self.contents_opacity = 255
      self.visible = true
    else
      self.opacity = 0
      self.contents_opacity = 0
      self.visible = false
    end
  end

end

class Game_Interpreter
  
  def chat_window_add_chat(text)
    return unless SceneManager.scene_is?(Scene_Map)
    SceneManager.scene.chat_window_add_chat(text)
  end
  
  def chat_window_refresh
    return unless SceneManager.scene_is?(Scene_Map)
    SceneManager.scene.chat_window_refresh
  end
  
end

class Scene_Map < Scene_Base
  
  alias original_create_all_windows create_all_windows
  def create_all_windows
    original_create_all_windows
    create_chat_window
  end
  
  alias scene_map_post_transfer_cw post_transfer
  def post_transfer
    scene_map_post_transfer_cw
    chat_window_refresh
  end

  def create_chat_window
    @chat_window = Window_ChatLog.new
  end
    
  def chat_window_add_chat(text)
    @chat_window.add_chat(text)
  end
  
  def chat_window_refresh
    @chat_window.check_visible
    @chat_window.draw_chat
  end
  
end