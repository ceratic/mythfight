#===============================================================================
# ASOE Vendor Module by Malagar
#
# Version: 1.0
#===============================================================================
module ASOE_VENDOR

#===============================================================================
# Rental Shop Functions by efeberk
#===============================================================================

def self.getShop(var_id)
  result = WEBKIT.req("asoe_vendor/asoe_vendor_getshop", "id="<<$game_variables[var_id].to_s)
  return result.split(';') if result.length > 1
  return []
end

def self.getAdminShop(var_id)
  result = WEBKIT.req("asoe_vendor/asoe_vendor_getadminshop", "id="<<$game_variables[var_id].to_s)
  return result.split(';') if result.length > 1
  return []
end

def self.sendFee(var_id, count)
  result = WEBKIT.req("asoe_vendor/asoe_vendor_sendfee", "id="<<$game_variables[var_id].to_s<<"&count="<<count.to_s)
  return !result.include?(ASOE::ERROR_CODE)
end

def self.rentShop(id, name, owner, type, expensiveness, fee, items)
  result = WEBKIT.req("asoe_vendor/asoe_vendor_rentshop", "&id="<<id<<"&name="<<name<<"&owner="<<owner<<"&type="<<type<<"&expensiveness="<<expensiveness<<"&period=86400"<<"&fee="<<fee<<"&items="<<items)
  return !result.include?(ASOE::ERROR_CODE)
end

def self.shopOwner?(var_accountname, var_id)
  result = WEBKIT.req("asoe_vendor/asoe_vendor_shopowner", "owner="<<$game_variables[var_accountname]<<"&id="<<$game_variables[var_id].to_s)
  return result.include?(ASOE::ERROR_OK)
end

def self.availableShop?(var_id)
  result = WEBKIT.req("asoe_vendor/asoe_vendor_availableshop", "id="<<$game_variables[var_id].to_s)
  if result.include?(ASOE::ERROR_CODE)
    return false
  else
    return true
  end
end

def self.withdrawShop(var_id)
  result = WEBKIT.req("asoe_vendor/asoe_vendor_withdrawshop", "id="<<$game_variables[var_id].to_s)
  return result
end

def self.getShopPrice(var_id)
  result = WEBKIT.req("asoe_vendor/asoe_vendor_getshopprice", "id="<<$game_variables[var_id].to_s)
  return result.to_i
end

end
#===============================================================================
# End
#===============================================================================