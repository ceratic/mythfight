#===============================================================================
# ASOE Timer Module by Malagar
#
# Version: 1.0
#===============================================================================
module ASOE_TIMER

  def self.convertTime(time)
    days = time / 86400
    hours = time / 3600
    minutes = time / 60
    return days + ":" + hours + ":" + minutes
  end

  def self.convertDays(time)
    days = time / 86400
    if days < 0
      days = 0
    end
    return days
  end
 
  def self.convertHours(time)
    hours = time / 3600
    if hours < 0
      hours = 0
    end
    return hours
  end

   def self.convertMinutes(time)
    minutes = time / 60
    if minutes < 0
      minutes = 0
    end
    return minutes
  end

  def self.getTime()
    result = WEBKIT.req("asoe_timer/asoe_timer_getTime", "")
    return result.to_i
  end
  
  def self.getTimer(var_accountname, var_timer_id)
    result = WEBKIT.req("asoe_timer/asoe_timer_getTimer", "accountname="<<$game_variables[var_accountname]<<"&id="<<$game_variables[var_timer_id])
    return result.to_i
  end
  
  def self.setTimer(var_accountname, var_timer_id, days, hours, minutes)
    result = WEBKIT.req("asoe_timer/asoe_timer_setTimer", "accountname="<<$game_variables[var_accountname]<<"&id="<<$game_variables[var_timer_id]<<"&days="<<days.to_s<<"&hours="<<hours.to_s<<"&minutes="<<minutes.to_s)
    if !result.include?(ASOE::ERROR_CODE)
      return true
    else
      return false
    end
  end
  
  def self.deleteTimer(var_accountname, var_timer_id)
    result = WEBKIT.req("asoe_timer/asoe_timer_deleteTimer", "accountname="<<$game_variables[var_accountname]<<"&id="<<$game_variables[var_timer_id])
    if !result.include?(ASOE::ERROR_CODE)
      return true
    else
      return false
    end
  end
  
  def self.timeOver(var_accountname, var_timer_id)
    time = WEBKIT.req("asoe_timer/asoe_timer_getTime", "")
    timer = WEBKIT.req("asoe_timer/asoe_timer_getTimer", "accountname="<<$game_variables[var_accountname]<<"&id="<<$game_variables[var_timer_id])
    if time > timer
      return true
    else
      return false
    end
  end

   def self.timePassed(var_accountname, var_timer_id)
    time = WEBKIT.req("asoe_timer/asoe_timer_getTime", "").to_i
    timer = WEBKIT.req("asoe_timer/asoe_timer_getTimer", "accountname="<<$game_variables[var_accountname]<<"&id="<<$game_variables[var_timer_id]).to_i
    time = time - timer
    return time
   end
 
end
#===============================================================================
# End
#===============================================================================