#===============================================================================
# ASOE Bazaar Module by Malagar
#
# Version: 1.0
#===============================================================================
module ASOE_BAZAAR
  
#===============================================================================
# Bazaar Functions by efeberk
#===============================================================================

def self.bazaarList
  result = WEBKIT.req("asoe_bazaar/asoe_bazaar_bazaarlist", "")
  return result.split('-') if result.length > 1
  return []
end

def self.bazaarBuy(id, price, count)
  result = WEBKIT.req("asoe_bazaar/asoe_bazaar_bazaarbuy", "id="<<id.to_s<<"&price="<<price.to_s<<"&count="<<count.to_s)
  return !result.include?(ASOE::ERROR_CODE)
end

def self.canBuyBazaar?(var_accountname, price)
  result = WEBKIT.req("asoe_bazaar/asoe_bazaar_canbuybazaar", "accountname="<<$game_variables[var_accountname].to_s<<"&price="<<price.to_s)
  return !result.include?(ASOE::ERROR_CODE)
end

def self.bazaarSell(seller, item_type, item_id, item_count, price)
  result = WEBKIT.req("asoe_bazaar/asoe_bazaar_bazaarsell", "accountname="<<seller.to_s<<"&item_type="<<item_type.to_s<<"&item_id="<<item_id.to_s<<"&item_count="<<item_count.to_s<<"&price="<<price.to_s)
  return !result.include?(ASOE::ERROR_CODE)
end

def self.canSellBazaar?(var_accountname)
  result = WEBKIT.req("asoe_bazaar/asoe_bazaar_cansellbazaar", "accountname="<<$game_variables[var_accountname].to_s)
  return !result.include?(ASOE::ERROR_CODE)
end

def self.bazaarSold(var_accountname)
  result = WEBKIT.req("asoe_bazaar/asoe_bazaar_bazaarsold", "accountname="<<$game_variables[var_accountname])
  return result.split(';') if result.length > 1
  return []
end

def self.bazaarReceive(id, price)
  result = WEBKIT.req("asoe_bazaar/asoe_bazaar_bazaarreceive", "id="<<id.to_s<<"&price="<<price.to_s)
  return !result.include?(ASOE::ERROR_CODE)
end

def self.bazaarStalls(var_accountname)
  result = WEBKIT.req("asoe_bazaar/asoe_bazaar_bazaarstalls", "accountname="<<$game_variables[var_accountname])
  return result.split(';') if result.length > 1
  return []
end

def self.bazaarRemove(shop_id)
  result = WEBKIT.req("asoe_bazaar/asoe_bazaar_bazaarremove", "id="<<shop_id.to_s)
  return !result.include?(ASOE::ERROR_CODE)
end

def self.bazaarItem(shop_id)
  result = WEBKIT.req("asoe_bazaar/asoe_bazaar_bazaaritem", "id="<<shop_id.to_s)
  return result.split(':') if result.length > 1
  return []
end

end
#===============================================================================
# End
#===============================================================================