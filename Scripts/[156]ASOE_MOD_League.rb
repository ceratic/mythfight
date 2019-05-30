#===============================================================================
# ASOE League Module by Malagar
#
# Version: 1.0
#===============================================================================
module ASOE_LEAGUE
  
  #-------------------------------------------------------------------------------
  # addAccountEXP, addAccountRank by Malagar
  #
  #-------------------------------------------------------------------------------

  def self.addEXP(var_accountname, var_value)
    result = WEBKIT.req("asoe_profile/asoe_profile_addEXP", "accountname="<<$game_variables[var_accountname]<<"&value="<<$game_variables[var_value])
    if !result.include?(ASOE::ERROR_CODE)
      return true
    else
      return false
    end
    #check account level up
  end
  
  def self.addRank(var_accountname, var_value)
    result = WEBKIT.req("asoe_profile/asoe_profile_addRank", "accountname="<<$game_variables[var_accountname]<<"&value="<<$game_variables[var_value])
    if !result.include?(ASOE::ERROR_CODE)
      return true
    else
      return false
    end
    #check league changes
  end
    
  def self.getProfile(var_accountname)
    result = WEBKIT.req("asoe_profile/asoe_profile_getProfile", "accountname="<<$game_variables[var_accountname].to_s)
    return result.split(';') if result.length > 1
    return []
  end
  
  def self.getMatches(var_accountname)
    result = WEBKIT.req("asoe_profile/asoe_profile_getMatches", "accountname="<<$game_variables[var_accountname].to_s)
    return result.split(';') if result.length > 1
    return []
  end
  
  def self.getActors(var_accountname)
    result = WEBKIT.req("asoe_profile/asoe_profile_getActors", "accountname="<<$game_variables[var_accountname].to_s)
    return result.split(';') if result.length > 1
    return []
  end
  
end
#===============================================================================
# End
#===============================================================================