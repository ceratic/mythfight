#==========================================================================
# Iavra Game.ini Access
# -------------------------------------------------------------------------
# - Purpose:
# Be a simple utility module that can be used to read from and write to the 
# Game.ini file.
# -------------------------------------------------------------------------
# - Prerequisites:
# None
# -------------------------------------------------------------------------
# - Terms of Use:
# Free to use for both commercial and non-commercial games. Please give credit.
# -------------------------------------------------------------------------
# - How to Use:
# Place above all scripts, that should take use of it.
#
# Check the presence of the script like this:
#
# if(($imported ||= {})[:iavra_ini_access])
#    # use the script
# else
#    # do something else
# end
#
# Load/write a key in the ini file:
#
# IAVRA::INI.load("section name", "key name", "default value")
# IAVRA::INI.save("section name", "key name", "value to be saved")
# -------------------------------------------------------------------------
# - FAQ:
# None so far
# -------------------------------------------------------------------------
# - Credits:
# Iavra
#==========================================================================

if ($build == 1)


($imported ||= {})[:iavra_ini_access] = true

module IAVRA
  module INI
    
    #==========================================================================
    # Path to the ini file. Shouldn't need to be changed.
    #==========================================================================
    
    FILENAME = "./config.dll"
    
    #==========================================================================
    # The Win API functions used to read and write ini files.
    #==========================================================================
    
    GetPrivateProfileString = Win32API.new('kernel32', 'GetPrivateProfileString', 'ppppip', 'i')
    WritePrivateProfileString = Win32API.new('kernel32', 'WritePrivateProfileString', 'pppp', 'i')
    
    #==========================================================================
    # Wrapper methods for the Win API.
    #==========================================================================
    
    def self.load(section, key, default)
      buffer = [].pack("x256")
      l = GetPrivateProfileString.call(section, key, default, buffer, buffer.size, FILENAME)
      buffer[0, l]
    end
    
    def self.save(section, key, value)
      WritePrivateProfileString.call(section, key, value.to_s, FILENAME)
    end
    
  end
end


end