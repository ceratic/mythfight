#===============================================================================
# ASOE Couple Module by Malagar
#
# Version: 1.0
#===============================================================================
module ASOE_COUPLE
  
#===============================================================================
# Couple Functions by efeberk
# Malagar Comment: - OBSOLETE, was not updated to reflect the party based
# handling of accounts.
#===============================================================================

def self.userHasCouple?(var_accountname)
  result = WEBKIT.req("asoe_couple/asoe_couple_userHasCouple", "accountname="<<$game_variables[var_accountname])
  return !result.include?("notexists")
end

def self.nicknameHasCouple?(accountname)
  result = WEBKIT.req("asoe_couple/asoe_couple_userHasCouple", "accountname="<<accountname.to_s)
  return !result.include?("notexists")
end

def self.coupleInfos(var_accountname)
  result = WEBKIT.req("asoe_couple/asoe_couple_coupleInfos", "accountname="<<$game_variables[var_accountname])
  return result.split(':') if result.length > 1
  return []
end

def self.leaveCouple(var_accountname)
  result = WEBKIT.req("asoe_couple/asoe_couple_leaveCouple", "accountname="<<$game_variables[var_accountname])
  return !result.include?(ASOE::ERROR_CODE)
end

def self.sex(var_gender)
  result = WEBKIT.req("asoe_couple/asoe_couple_breed", "gender="+$game_variables[var_gender].to_s)
  array = result.split(':')
  return array if result.length > 1
  return []
end

def self.proposeTo(var_accountname, var_receiver)
  result = WEBKIT.req("asoe_couple/asoe_couple_proposeTo", "accountname="<<$game_variables[var_accountname]<<"&receiver="<<$game_variables[var_receiver])
  return !result.include?(ASOE::ERROR_CODE)
end

def self.increaseCouplePoints(var_accountname, var_increment)
  result = WEBKIT.req("asoe_couple/asoe_couple_increaseCouplePoints", "accountname="<<$game_variables[var_accountname]<<"&increment="<<$game_variables[var_increment].to_s)
  return !result.include?(ASOE::ERROR_CODE)
end  

def self.receivedProposals(var_accountname)
  result = WEBKIT.req("asoe_couple/asoe_couple_receivedProposals", "accountname="+$game_variables[var_accountname].to_s)
  print result
  array = result.split(':')
  return array if result.length > 1
  return []
end

def self.sentProposals(var_accountname)
  result = WEBKIT.req("asoe_couple/asoe_couple_sentProposals", "accountname="+$game_variables[var_accountname].to_s)
  array = result.split(':')
  return array if result.length > 1
  return []
end

def self.makeCouple(var_accountname, var_receiver)
  result = WEBKIT.req("asoe_couple/asoe_couple_makeCouple", "nickname="<<$game_variables[var_accountname]<<"&receiver="<<$game_variables[var_receiver])
  return !result.include?(ASOE::ERROR_CODE)
end

def self.giveUp(var_accountname, var_receiver)
  result = WEBKIT.req("asoe_couple/asoe_couple_giveUp", "accountname="<<$game_variables[var_accountname]<<"&receiver="<<$game_variables[var_receiver])
  return !result.include?(ASOE::ERROR_CODE)
end

def self.coupleList
  result = WEBKIT.req("asoe_couple/asoe_couple_coupleList", "")
  return result.split(';') if result.length > 1
  return []
end

end
#===============================================================================
# End
#===============================================================================