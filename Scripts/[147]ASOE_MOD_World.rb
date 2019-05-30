#===============================================================================
# ASOE World Module by Malagar
#
# Version: 1.0
#===============================================================================
module ASOE_WORLD

  #-------------------------------------------------------------------------------
  # worldMaintenance by Malagar
  #
  # 
  #-------------------------------------------------------------------------------
  def self.worldMaintenance()
   result = WEBKIT.req("asoe_world/asoe_world_worldMaintenance", "")
  end
  
  #-------------------------------------------------------------------------------
  # getNews by Malagar
  #-------------------------------------------------------------------------------
  def self.getNews()
    result = WEBKIT.req("asoe_world/asoe_world_getNews", "")
    return result.split(';') if result.length > 1
    return []
  end
  
  #-------------------------------------------------------------------------------
  # getPopulation by Malagar
  #-------------------------------------------------------------------------------
  def self.getPopulation()
    result = WEBKIT.req("asoe_world/asoe_world_getPopulation", "")
    return result.to_i if result != nil
  end

  #-------------------------------------------------------------------------------
  # getLimit, setLimit by Malagar
  #-------------------------------------------------------------------------------
  def self.getLimit()
   result = WEBKIT.req("asoe_world/asoe_world_getLimit", "")
   return result.to_i if result != nil
  end

  def self.setLimit(int_limit)
   result = WEBKIT.req("asoe_world/asoe_world_setLimit", "limit="<<int_limit.to_s)
  end
  
  #-------------------------------------------------------------------------------
  # getRegister, setRegister by Malagar
  #-------------------------------------------------------------------------------
  def self.getRegister()
    result = WEBKIT.req("asoe_world/asoe_world_getRegister", "")
    if result.to_i = 1
      return true
    else
      return false
    end
  end

  def self.setRegister(bol_register)
    if bol_register = true
      register = "1"
    else
      register = "0"
    end
    result = WEBKIT.req("asoe_world/asoe_world_setRegister", "register="<<register)
  end
   
  #-------------------------------------------------------------------------------
  # xyz by Malagar - padding, reserved for future development
  #-------------------------------------------------------------------------------
  def self.setNews()
    
  end

  def self.getOnline()
  end
  
  def self.addOnline()
  end
  
  def self.removeOnline()
  end
  
  def self.getMessage()
  
  end

  def self.setMessage()
  
  end

  def self.getAdminPassword()
  
  end

  def self.setAdminPassword()
  
  end

  def self.getModPassword()
  
  end

  def self.setModPassword()
  
  end

  def self.getWorldPassword()
  
  end

  def self.setWorldPassword()
  
  end

  def self.getSystemPassword()
  
  end

  def self.setSystemPassword()
  
  end

  def self.getId()
  
  end

end
#===============================================================================
# End
#===============================================================================