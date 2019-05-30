=begin
===============================================================================
 Location API by efeberk
 Version: RGSS3
===============================================================================
 This script will allow you can fetch location datas from ipinfodb website.
 URL : http://api.ipinfodb.com/v3/ip-city/?key=API_KEY
--------------------------------------------------------------------------------
Used functions:

Call:

location

=end
$location = []

def location
   result = EFE.request("api.ipinfodb.com", "/v3/ip-city/", "key=b32d8579b5f99b722cf0a8c41fbd760dc6809028d3c2710f4b613825bebd5667")
   $location = result.split(';')
   return $location[0] == 'OK'
end