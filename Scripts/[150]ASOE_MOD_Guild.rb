#===============================================================================
# ASOE Guild Module by Malagar
#
# Version: 1.0
#===============================================================================
module ASOE_GUILD
  
def self.guildExists?(var_guildname)
  result = WEBKIT.req("asoe_guild/asoe_guild_exists", "guildname="<<$game_variables[var_guildname])
  if result.include?(ASOE::ERROR_CODE)
    return false
  else
    return true
  end
end

def self.createGuild(var_accountname, var_guildname, var_icon)
  result = WEBKIT.req("asoe_guild/asoe_guild_create", "accountname="<<$game_variables[var_accountname]<<"&guildname="<<$game_variables[var_guildname]<<"&icon="<<$game_variables[var_icon])
  return !result.include?(ASOE::ERROR_CODE)
end

def self.accountHasGuild?(var_accountname)
  result = WEBKIT.req("asoe_guild/asoe_guild_hasguild", "accountname="<<$game_variables[var_accountname])
  $game_variables[ASOE::VAR_GUILD_NAME] = result
  return !result.include?(ASOE::ERROR_CODE)
end

def self.guildList
  result = WEBKIT.req("asoe_guild/asoe_guild_list", "")
  return result.split(";") if result.length > 1
  return []
end

def self.joinGuild(var_accountname, var_join_guildname)
  result = WEBKIT.req("asoe_guild/asoe_guild_join", "accountname="<<$game_variables[var_accountname]<<"&guildname="<<$game_variables[var_join_guildname])
  return !result.include?(ASOE::ERROR_CODE)
end
  
def self.leaveGuild(var_accountname, var_guildname)
  result = WEBKIT.req("asoe_guild/asoe_guild_leave", "accountname="<<$game_variables[var_accountname]<<"&guildname="<<$game_variables[var_guildname])
  if result.include?(ASOE::ERROR_CODE)
    return false
  else
    return true
  end
end
  
def self.guildInfo(var_guildname)
  result = WEBKIT.req("asoe_guild/asoe_guild_info", "guildname="<<$game_variables[var_guildname])
  return result.split(":") if result.length > 1
  return []
end

def self.guildMembers(var_guildname)
  result = WEBKIT.req("asoe_guild/asoe_guild_members", "guildname="+$game_variables[var_guildname])
  array = result.split(":")
  return array if result.length > 1
  return []
end

def self.increaseGuildPoints(var_guildname, var_increment)
  result = WEBKIT.req("asoe_guild/asoe_guild_addpoints", "guildname="<<$game_variables[var_guildname]<<"&increment="<<$game_variables[var_increment].to_s)
  return !result.include?(ASOE::ERROR_CODE)
end 

def self.increaseGuildGold(var_guildname, var_increment)
  result = WEBKIT.req("asoe_guild/asoe_guild_addgold", "guildname="<<$game_variables[var_guildname]<<"&increment="<<$game_variables[var_increment].to_s)
  return !result.include?(ASOE::ERROR_CODE)
end 

def self.isGuildOwner(var_accountname, var_guildname)
  result = WEBKIT.req("asoe_guild/asoe_guild_isowner", "guildname="<<$game_variables[var_guildname]<<"&accountname="<<$game_variables[var_accountname])
  return result.to_i > 0
end

def self.changeGuildMessage(var_guildname, var_guildmessage)
  result = WEBKIT.req("asoe_guild/asoe_guild_changemessage", "guildname="<<$game_variables[var_guildname]<<"&message="<<$game_variables[var_guildmessage])
  return !result.include?(ASOE::ERROR_CODE)
end

end
#===============================================================================
# End
#===============================================================================