#===============================================================================
# ASOE Mail Module by Malagar
#
# Version: 1.0
#===============================================================================
module ASOE_MAIL

  def self.mailList(var_accountname)
    result = WEBKIT.req("asoe_mail/asoe_mail_list", "accountname="<<$game_variables[var_accountname])
    return result.split(';') if result.length > 1
    return []
  end

  def self.readMail(mail_id)
    result = WEBKIT.req("asoe_mail/asoe_mail_read", "mail="<<mail_id)
    return !result.include?(ASOE::ERROR_CODE)
  end

  def self.sendMail(var_title, var_message, var_from, var_to, var_item, var_type, var_amount)
    #if $game_variables[var_to] != $game_variables[var_from]
      result = WEBKIT.req("asoe_mail/asoe_mail_send", "accountname="<<$game_variables[var_from]<<"&receiver="<<$game_variables[var_to]<<"&title="<<$game_variables[var_title]<<"&message="<<$game_variables[var_message]<<"&item="<<$game_variables[var_item].to_s<<"&type="<<$game_variables[var_type].to_s<<"&amount="<<$game_variables[var_amount].to_s)
      if !result.include?(ASOE::ERROR_CODE)
        return true
      else
        return false
      end
    #end
  end

  def self.clearMails(var_accountname)
    result = WEBKIT.req("asoe_mail/asoe_mail_clear", "accountname="<<$game_variables[var_accountname])
    return !result.include?(ASOE::ERROR_CODE)
  end
  
end
#===============================================================================
# End
#===============================================================================