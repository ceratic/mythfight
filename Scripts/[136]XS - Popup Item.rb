#==============================================================================
#   XS - Popup Item
#   Author: Nicke
#   Created: 06/04/2012
#   Edited: 19/09/2012
#   Version: 1.1c
#==============================================================================
# ☻ Utilidade ☻
#Cria uma janela onde é mostrado o item que o personagem adiquiriu.
#==============================================================================
# ☻ Instruções ☻
#Insira esse script no espaço de "Scripts Adicionais" do RPG Maker VX Ace. 
#Para fazer com que a janlea apareça, ative a Switch 90 e então use os comandos
#do evento para adionar itens, equipamentos e dinheiros.
#==============================================================================
# ☻ Requisitos ☻
#XS - Core Script.
#==============================================================================

($imported ||= {})["XAIL-POPUP-ITEM"] = true

module XAIL
  module POPUP_ITEM
  #--------------------------------------------------------------------------#
  # * Definições
  #--------------------------------------------------------------------------#
    # FONTE = [nome, tamanho, cor, negrito, sombra]
    FONT_ITEM = [["Anklada™", "Verdana"], 16, Color.new(202,255,200), true, true]
    FONT_AMT = [["Anklada™", "Verdana"], 24, Color.new(255,200,22), true, true]
    FONT_DESC = [["Anklada™", "Verdana"], 16, Color.new(255,255,255), true, true]
            
    # Defina a largura, altura e opacidade da janela.
    # Você também precisa-rá mudar o valor da switch para habilitar a janela.
    # Mostre/esconda cada texto usando o comando show_* items.
    # POP = [largura, altura, opacidade, switch_id, velocidade da animação, mostrar icone
    # mostrar nome, mostrar preço, mostrar quantidade, mostrare, mostrar linha]
    POP = [360, 100, 255, 90, 6, true, true, true, true, true, true]
    
    # POS_TYPE = :symbol
    # :screen = Posição da janela na tela. (padrão)
    # :player = Posição da janela próximo ao jogador.
    # Nota: Se você definir :player, a janela poderá não aparecer no mapa se
    # você colocá-lo no canto da tela.
    POS_TYPE = :screen
    
    # OFFSET = número.
    # Use isso para mudar a posição da janela.
    X_OFFSET = POP[0] / 2
    Y_OFFSET = POP[1] / 2
    
    # Mude a windowskin da janela.
    # SKIN = windowskin (localizado em Graphics/System folder)
    SKIN = nil
    
    # Icone do Gold = id do icone mostrado
    GOLD_ICON = 262
    
    # GOLD_ACQUIRED = string
    GOLD_ACQUIRED = "Adquirido — "
    
    # ITEM_ACQUIRED = string
    ITEM_ACQUIRED = "Adquirido — "
    
    # LINE_COLOR = [Cor, Sombra]
    LINE_COLOR = [Color.new(255,255,255,200), Color.new(0,0,0,160)]
    
    # Mostra a quantidade anterior e a próxima. Deixe vazio se não quiser que apareça.
    # AMOUNT_SYMBOL = string
    AMT_SYM_BEFORE = "  "
    AMT_SYM_AFTER = "x "
    
    # NO_POP_ITEM = {type, item_id}
    # type = :weapons, :item, :armour
    # item_id = number
    NO_POP_ITEM = {
      :weapons   => [2,3],
      :item      => [12,12],
      :armour    => [32,52,24],
    }
    
    # Escolha um botão para pesquisar sobre esse item
    # Pode ser habilitado e desabilitado, com cronometro apenas.
    # Set the time to the amount you wish to wait before the next item is displayed.
    # BUTTON = [enable_wait, button, time]
    BUTTON = [true, Input::C, 100]   
  end
end
# *** Don't edit below unless you know what you are doing. ***
#==============================================================================#
# ** Error Handler
#==============================================================================#
  unless $imported["XAIL-XS-CORE"]
    # // Error handler when XS - Core is not installed.
    msg = "The script %s requires the latest version of XS - Core in order to function properly."
    name = "XS - Popup Item"
    msgbox(sprintf(msg, name))
    exit
  end
#==============================================================================#
# ** Game_Interpreter
#==============================================================================#
class Game_Interpreter
  
  def pop(type, amount, index, params, param_index)
    # // Method to call the popup.
    if $game_switches[XAIL::POPUP_ITEM::POP[3]] && params[param_index] == 0
      index = (type == :gold) ? 0 : index
      SceneManager.scene.pop_item(type, amount, index)
    end
  end
  
  alias xail_pop_item_cmd_125 command_125
  def command_125(*args, &block)
    # // Method when gold changes.
    value = operate_value(@params[0], @params[1], @params[2])
    pop(:gold, value, 1, @params, 0)
    xail_pop_item_cmd_125(*args, &block)
  end

  alias xail_pop_item_cmd_126 command_126
  def command_126(*args, &block)
    # // Method when item changes.
    value = operate_value(@params[1], @params[2], @params[3])
    pop(:item, value, @params[0], @params, 1)
    xail_pop_item_cmd_126(*args, &block)
  end

  alias xail_pop_item_cmd_127 command_127
  def command_127(*args, &block)
    # // Method when weapon changes.
    value = operate_value(@params[1], @params[2], @params[3])
    pop(:weapons, value, @params[0], @params, 1)
    xail_pop_item_cmd_127(*args, &block)
  end
  
  alias xail_pop_item_cmd_128 command_128
  def command_128(*args, &block)
    # // Method when armour changes.
    value = operate_value(@params[1], @params[2], @params[3])
    pop(:armour, value, @params[0], @params, 1)
    xail_pop_item_cmd_128(*args, &block)
  end
  
end
#==============================================================================#
# ** Scene_Map
#==============================================================================#
class Scene_Map < Scene_Base
  
  def create_pop_window
    # // Method to create the popup window.
    case XAIL::POPUP_ITEM::POS_TYPE
    when :screen
      x, y = Graphics.width / 2 - XAIL::POPUP_ITEM::X_OFFSET, Graphics.height / 2 - XAIL::POPUP_ITEM::Y_OFFSET
    when :player
      x, y = $game_player.screen_x - XAIL::POPUP_ITEM::X_OFFSET, $game_player.screen_y - XAIL::POPUP_ITEM::Y_OFFSET
    end
    @pop_window = Window_Base.new(x, y, XAIL::POPUP_ITEM::POP[0], XAIL::POPUP_ITEM::POP[1])
    @pop_window.opacity = @pop_window.contents_opacity = XAIL::POPUP_ITEM::POP[2]
    @pop_window.windowskin = Cache.system(XAIL::POPUP_ITEM::SKIN) unless XAIL::POPUP_ITEM::SKIN.nil?
    if XAIL::POPUP_ITEM::POP[10]
      @lines = Window_Base.new(x, y, @pop_window.width, @pop_window.height)
      @lines.opacity = @lines.contents_opacity = 0
    end
  end
  
  def pop_item(type, amount, index)
    # // Method to display the popup.
    item = nil
    case type
    when :item # // Items.
      item = $data_items[index]
    when :weapons # // Weapons.
      item = $data_weapons[index]
    when :armour # // Armors.
      item = $data_armors[index]
    end
    # // Return if included in no popup.
    XAIL::POPUP_ITEM::NO_POP_ITEM.each_pair {|key,item_id|
      return if key == type && item_id.include?(item.id)
    }
    icon = item.nil? ? XAIL::POPUP_ITEM::GOLD_ICON : item.icon_index
    create_pop_window
    max = XAIL::POPUP_ITEM::POP[4] * 3
    # // Fade in windows.
    for i in 1..max
      update_basic
      @pop_window.contents_opacity = i * (255 / max)
      @lines.contents_opacity = i * (255 / max) if XAIL::POPUP_ITEM::POP[10]
    end
    gold_ac = XAIL::POPUP_ITEM::GOLD_ACQUIRED
    item_ac = XAIL::POPUP_ITEM::ITEM_ACQUIRED
    price = XAIL::POPUP_ITEM::POP[7] ? " (#{item.price} #{Vocab::currency_unit})" : "" unless item.nil?
    pop_item = item.nil? ? gold_ac + amount.to_s + " " + Vocab::currency_unit : item_ac + item.name + price
    pop_amt = XAIL::POPUP_ITEM::AMT_SYM_BEFORE + amount.to_s + XAIL::POPUP_ITEM::AMT_SYM_AFTER
    # // Draw icons.
    if XAIL::POPUP_ITEM::POP[5]
      @pop_window.draw_big_icon(icon, -2, -10, @pop_window.contents_width/4, @pop_window.contents_width/4, 100)
      @pop_window.draw_icon(icon, 2, 8) 
    end
    # // Draw item.
    @pop_window.draw_font_text(pop_item, 0, 10, @pop_window.contents_width-24, 1, XAIL::POPUP_ITEM::FONT_ITEM[0], XAIL::POPUP_ITEM::FONT_ITEM[1], XAIL::POPUP_ITEM::FONT_ITEM[2], XAIL::POPUP_ITEM::FONT_ITEM[3], XAIL::POPUP_ITEM::FONT_ITEM[4]) if XAIL::POPUP_ITEM::POP[6]
    # // Draw amount.
    @pop_window.draw_font_text(pop_amt, 0, 8, @pop_window.contents_width, 2, XAIL::POPUP_ITEM::FONT_AMT[0], XAIL::POPUP_ITEM::FONT_AMT[1], XAIL::POPUP_ITEM::FONT_AMT[2], XAIL::POPUP_ITEM::FONT_AMT[3], XAIL::POPUP_ITEM::FONT_AMT[4]) unless item.nil? || !XAIL::POPUP_ITEM::POP[8]
    if XAIL::POPUP_ITEM::POP[9]
      # // Draw description.
      @pop_window.contents.font.name = XAIL::POPUP_ITEM::FONT_DESC[0]
      @pop_window.contents.font.size = XAIL::POPUP_ITEM::FONT_DESC[1]
      @pop_window.contents.font.color = XAIL::POPUP_ITEM::FONT_DESC[2]
      @pop_window.contents.font.bold = XAIL::POPUP_ITEM::FONT_DESC[3]
      @pop_window.contents.font.shadow = XAIL::POPUP_ITEM::FONT_DESC[4]
      @pop_window.draw_text_ex_no_reset(2, 34, item.description) unless item.nil?
      @pop_window.reset_font_settings
    end
    # // Draw lines.
    if XAIL::POPUP_ITEM::POP[10]
      @lines.draw_line_ex(@pop_window.contents_width/4, -6, XAIL::POPUP_ITEM::LINE_COLOR[0], XAIL::POPUP_ITEM::LINE_COLOR[1])
      @lines.draw_line_ex(-@pop_window.contents_width/4, 24, XAIL::POPUP_ITEM::LINE_COLOR[0], XAIL::POPUP_ITEM::LINE_COLOR[1])
    end
    # // Fade in windows.
    count = 0
      loop do
        update_basic
        count += 1 unless XAIL::POPUP_ITEM::BUTTON[0]
        break if Input.trigger?(XAIL::POPUP_ITEM::BUTTON[1])
        break if count == XAIL::POPUP_ITEM::BUTTON[2] && !XAIL::POPUP_ITEM::BUTTON[0]
      end
      for i in 1..max
        update_basic
        @pop_window.contents_opacity = 255 - i * (255 / max)
        @lines.contents_opacity = 255 - i * (255 / max) if XAIL::POPUP_ITEM::POP[10]
      end
    dispose_popup
  end
  
  def dispose_popup
    # // Method to dispose the popup window.
    @pop_window = nil, @pop_window.dispose unless @pop_window.nil?
    @lines = nil, @lines.dispose unless @lines.nil? and !XAIL::POPUP_ITEM::POP[10]
  end
  
end # END OF FILE

#=*==========================================================================*=#
# ** END OF FILE
#=*==========================================================================*=#