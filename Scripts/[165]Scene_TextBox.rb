#===============================================================================
# Note Input RGSS2
# By Jet10985 (Jet)
# Input Script by: OriginalWij and Yanfly
# Improved and converted to RGSS3 by efeberk
# Tiny improvements by Malagar
#===============================================================================
# This script will allow the player to freely type notes inside a textbox using
# the keyboard.
# This script has: 5 customization options.
#===============================================================================
# Overwritten Methods:
# None
#-------------------------------------------------------------------------------
# Aliased methods:
# None
#===============================================================================
#--------------------------------------------------------------------------------
=begin

Call Textbox in Event Script Command:

enter_text(text, variableid, width_windows, min_char, max_char, password=false)


=end

class Window_HelpTextBox < Window_Base

  def initialize(x, y, width, text)
    super(x, y, width, fitting_height(1))
    refresh(text)
  end
  
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

class Window_HeaderTextBox < Window_Base

  def initialize(x, y, width, text)
    super(x, y, width, fitting_height(1))
    refresh(text)
  end
  
  
  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end
class Window_TextBox < Window_Selectable
  
  attr_reader :text
  attr_reader :ref_text
  
  include NoteInput
  
  def initialize(x, y, width, height, password)
    super(x, y, width, height)
    self.contents.font.name = NOTE_FONT
    self.contents.font.size = NOTE_SIZE
    self.contents.font.color = NOTE_COLOR
    @password = password
    @wait_count = 0
    @text = 0
    @ref_text = ""
    @clear_or_draw = false
    refresh
  end
  
  def refresh
    self.contents.clear
    space_taken = 0
    new_text = ""
    fixed = ""
    $game_system.note_input_texts[@text].each_word {|word|
      space_taken += self.contents.text_size("#{word} ").width
      if word == "\x00"
        space_taken += self.contents.text_size(" ").width
      elsif word == "\x01"
        new_text.concat("\r\n")
        space_taken = 0
      elsif space_taken > self.contents.width
        space_taken = 0
        new_text.concat("\r\n#{word}")
        space_taken += self.contents.text_size("#{word} ").width
      else
        new_text.concat(" #{word}")
      end
    }
    i = 0
    new_text.each_line {|line|
    
      if @password #Added 26/07/2014 by Malagar
        j = 1
        while j < line.length
          #if line[j,1] != ""
            fixed = fixed + "*"
          #end
          j += 1
        end
        fixed = fixed.gsub(/[\r\n]/i, "")
      else
      fixed = line.gsub(/[\r\n]/i, "")   
      end #End Edit

      self.contents.draw_text(0, i * NOTE_WLH, self.contents.width, NOTE_WLH, fixed)
      i += 1
    }
    @ref_text = new_text
    update(true)
  end
  
  def update(bypass = false)
    @wait_count -= 1 unless @wait_count == 0
    return unless bypass || @wait_count == 0
    @wait_count = 30
    ny = (@ref_text.lines.size - 1) * NOTE_WLH
    if @ref_text.lines[@ref_text.lines.size - 1].nil?
      nx = 0
    else
      nx = self.contents.text_size(@ref_text.lines[
      @ref_text.lines.size - 1].gsub(/[\r\n]/i, "")).width
    end
    index_line = self.contents.text_size("|")
    if @clear_or_draw
      self.contents.clear_rect(nx, ny, index_line.width, index_line.height)
    else
      self.contents.draw_text(nx, ny, index_line.width, index_line.height, "|")
    end
    @clear_or_draw = !@clear_or_draw
  end
  
  def add_key(letter, max)
    return if letter == ""
    i = @ref_text.lines.size
    i -= 1 unless i == 0
    if @ref_text.length > max then return; end
    if i != 0 and self.contents.text_size(
        @ref_text.lines[i] + letter).width > self.contents.width ||
        " \x01 " == letter
      if (@ref_text.lines.size * NOTE_WLH + NOTE_WLH > self.contents.height)
        Sound.play_buzzer
        return
      end
    end
    $game_system.note_input_texts[@text].concat(letter)
    refresh
  end
  
  def remove_key
    f = $game_system.note_input_texts[@text].each_letter
    if ["\x00", "\x01"].include?(f[f.size - 2])
      f.pop
      f.pop
    end
    f.pop
    f.push("") if f.empty?
    $game_system.note_input_texts[@text] = f.inject {|a, b| a + b }
    refresh
  end
  
  def text=(t)
    @text = t
    if @text < 0
      @text = $game_system.note_input_texts.size - 1
    elsif @text == $game_system.note_input_texts.size
      @text = 0
    end
    refresh
  end
end

class Scene_TextBox < Scene_Base
  
  def initialize
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def prepare(text, var, width, min, max, password)
    @text = text
    @var = var
    @min = min
    @max = max
    @width = width
    @password = password
  end
  
  def start
    super
    create_background
    @headertext = Window_HeaderTextBox.new((Graphics.width / 2) - (@width / 2), 150, @width, @text)
    min = @min-1
    @helptext = Window_HelpTextBox.new((Graphics.width / 2) - (@width / 2), 252, @width, "Min/Max Char : "+ min.to_s + "/" + @max.to_s)
    @textbox_window = Window_TextBox.new((Graphics.width / 2) - (@width / 2), 200, @width, 50, @password)
    @textbox_window.set_handler(:ok,    method(:textbox_ok))
    @textbox_window.set_handler(:cancel,    method(:textbox_cancel))
    @textbox_window.text = 0
    @index = 0
  end
  
  def textbox_ok
    result = @textbox_window.ref_text
    if result.length >= @min
      result[0, 1] = ''
      $game_variables[@var] = result
      $game_system.note_input_texts = [""]
      return_scene
    end
    @textbox_window.update
  end
  
  def textbox_cancel
    result = ""
    $game_variables[@var] = result
    $game_system.note_input_texts = [""]
    return_scene
  end
  

  def update
    super
    #update_menu_background
    NoteInput.update
    if NoteInput.trigger?(NoteInput::ESC)
      textbox_cancel
      return
    end
    if Input.trigger?(Input::LEFT)
      @textbox_window.text -= 1
    elsif Input.trigger?(Input::RIGHT)
      @textbox_window.text += 1
    elsif NoteInput.trigger?(NoteInput::BACK)
      @textbox_window.remove_key
    elsif NoteInput.trigger?(NoteInput::SPACE)
      @textbox_window.add_key(" \x00 ", @max)
    elsif NoteInput.trigger?(NoteInput::ENTER)
      textbox_ok
    else
      @textbox_window.add_key(NoteInput.key_type, @max)
    end
    @textbox_window.update
  end
  
  def terminate
    super
    
    @textbox_window.dispose
    @headertext.dispose
  end
end


class Game_Interpreter
  def enter_text(text, var, width, min, max, password=false)
    SceneManager.call(Scene_TextBox)
    SceneManager.scene.prepare(text, var, width, min, max, password)
    Fiber.yield while SceneManager.scene_is?(Scene_TextBox)
  end
end