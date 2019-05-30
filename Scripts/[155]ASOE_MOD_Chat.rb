#===============================================================================
# ASOE Chat Module by Malagar
#
# Version: 1.0
#===============================================================================
module ASOE_CHAT

  @ChatText = []
  
  #-------------------------------------------------------------------------------
  # getChat by Malagar
  #
  #-------------------------------------------------------------------------------
  def self.popChat()
    if @ChatText.size > 0
      return @ChatText.pop
    else
      return nil
    end
  end
  
  def self.getChat()
    if @ChatText.size > 0
      return @ChatText[ChatText.size]
    else
      return nil
    end
  end
  
  #-------------------------------------------------------------------------------
  # updateTime by Malagar
  #
  #-------------------------------------------------------------------------------
  def self.updateTime(var_time)
    result = WEBKIT.req("asoe_chat/asoe_chat_updateTime", "")
    if result != nil
      $game_variables[var_time] = result.to_i
    end
  end

  #-------------------------------------------------------------------------------
  # updateChat by Malagar
  #
  #-------------------------------------------------------------------------------

  def self.updateChat(var_channel, var_time)
    result = WEBKIT.req("asoe_chat/asoe_chat_getChat", "channel="<<$game_variables[var_channel].to_s<<"&time="<<$game_variables[var_time].to_s)
    if !result.include?(ASOE::ERROR_CODE)
      if result.length > 1
        result2 = result.split(";")
      else
        result2 = result
        end
        if result2.length > 0
          for chats in result2
              chatline = chats.split(":")
              if chatline.length > 0
                @ChatText.unshift "\\c[" + chatline[1].to_s + "]" + chatline[2].to_s + "\\c[0]"
              end
          end
     end
    end
  end
  #-------------------------------------------------------------------------------
  # postChat by Malagar
  #
  # 
  #
  #-------------------------------------------------------------------------------
  def self.postChat(var_accountname, var_message, type=0, var_channel=0)
    if $game_variables[var_message] != "" &&  $game_variables[var_message] != 0
      if $game_variables[var_accountname] != "" && $game_variables[var_accountname] != 0
        $game_variables[var_message] = "[" + $game_variables[var_accountname] + "] " + $game_variables[var_message]
        result = WEBKIT.req("asoe_chat/asoe_chat_postChat", "sender="<<$game_variables[var_accountname].to_s<<"&message="<<$game_variables[var_message].to_s<<"&type="<<type.to_s<<"&channel="<<$game_variables[var_channel].to_s)
        $game_variables[var_message] = ""
      end
    end
  end

end
#===============================================================================
# End
#===============================================================================