#===============================================================================
# ASOE Configuration by Efeberk, Malagar
#
# Version: 1.0
#===============================================================================
#
#
#===============================================================================

Font.default_size = 18
Font.default_name = ["Arial"]
Font.default_bold = false
Font.default_italic = false
Font.default_shadow = false
Font.default_outline = false
Font.default_color.set(255,255,255,255)
Font.default_out_color.set(0,0,0,0)

$loginDatas = []
$logDate = 0

$guildSearch = ""
$proposeSearch = ""

module ASOE
  #-------------------------------------------------------------------------------
  # ASOE Configuration
  # 
  #-------------------------------------------------------------------------------
  HOST                = "www.ceratic.de"
  PATH                = "/game/"
  VERSION             = 1000                                          # = v1.000
  #-------------------------------------------------------------------------------
  # ASOE Configurable Constants
  #-------------------------------------------------------------------------------
  #NUM_
  #NUM_
  #NUM_
  
  #-------------------------------------------------------------------------------
  # --- Do not touch anything below this line, unless you want to integrate this
  #     script into an existing project when vars/switches are already in use ---
  #-------------------------------------------------------------------------------

  #-------------------------------------------------------------------------------
  # ASOE Numerical Constants
  #-------------------------------------------------------------------------------
  NUM_GROUP_PLAYER    = 10                        # Basic Group for all players
  NUM_GROUP_ADMIN     = 20                        # Group for all Admins
  NUM_BANLEVEL_MAX    = 10
  #-------------------------------------------------------------------------------
  # ASOE Variables
  #-------------------------------------------------------------------------------
  VAR_ACCOUNTNAME           = 1                   # VAR Current Account Name
  VAR_PASSWORD              = 2                   # VAR Current Account Password
  VAR_ACCOUNTCODE           = 3                   # VAR Current Account Security Code
  VAR_ACTORNAME             = 4                   # VAR Current Actor Name
  VAR_ACCOUNTGROUP          = 5                   # VAR Current Account Group (10=normal, 20=moderator/GM, 30=admin, 40=system)
  VAR_ACTORID               = 6                   # VAR Current Actor ID
  VAR_TIMESTAMP             = 7                   # VAR Current Logged Timestamp
  VAR_ACCOUNTID             = 8                   # VAR Current Account ID
  VAR_NEWPASSWORD           = 9                   # VAR New Account Password
  #10
  
  VAR_ACC_EXP               = 11                  # VAR Account Experience
  VAR_ACC_LEVEL             = 12                  # VAR Account Level
  VAR_ACC_RANK              = 13                  # VAR Account Rank
  # 14,15,16
  
  VAR_GUILD_ICON            = 17                  # VAR 
  VAR_GUILD_NAME            = 18                  # VAR
 
  VAR_GUILD_SEARCH_NAME     = 19                  # VAR
  VAR_GUILD_JOIN_NAME       = 20                  # VAR
  VAR_GUILD_MESSAGE         = 21                  # VAR
  VAR_GUILD_POINTS          = 22                  # VAR
  #23,24,25,26
  
  VAR_CHAT_MESSAGE          = 27                  # VAR Chat Entered Message
  VAR_CHAT_CHANNEL          = 28                  # VAR Chat Current Channel
  VAR_CHAT_TIMESTAMP        = 29                  # VAR Chat Update Timestamp
  #30, 31
  
  VAR_UPDATE_CYCLE          = 32                  #
  #33,34,35,36
  
  VAR_MAIL_SEND_TITLE       = 37                  # VAR Mail Title
  VAR_MAIL_SEND_MESSAGE     = 38                  # VAR Mail message body
  VAR_MAIL_SEND_TO          = 39                  # VAR Mail Receiver
  VAR_MAIL_SEND_ITEM        = 40                  # VAR Number of Items to send (or gold coins)
  VAR_MAIL_SEND_TYPE        = 41                  # VAR Sent Item type
  VAR_MAIL_SEND_AMOUNT      = 42                  # VAR Item ID to send
 
  VAR_RENT_SHOP_ID          = 43                  # VAR 
  VAR_CREATE_RENT_SHOP_NAME = 44                  # VAR 
  VAR_RENTAL_SHOP_PRICE     = 45                  # VAR 
  VAR_LAST_PLAYER_DIR       = 46                  # VAR Last Player Direction
  VAR_LAST_PLAYER_MAP       = 47                  # VAR Last Player Map
  VAR_LAST_PLAYER_X         = 48                  # VAR Last Player X
  VAR_LAST_PLAYER_Y         = 49                  # VAR Last Player Y
  VAR_TIMER_ID              = 50                  # VAR Current Timer ID
  VAR_TIMER_TIMESTAMP       = 51                  # VAR Current Timestamp
  #52,53,54,55,56,57,58
  
  COUPLE_PROPOSE_NICKNAME_VARIABLE = 59
  COUPLE_SEARCH_NICKNAME_VARIABLE = 60

  #-------------------------------------------------------------------------------
  # ASOE Switches
  #-------------------------------------------------------------------------------
  SWI_SHOW_LOCATION  = 1                         # SWI Show Real Location?
  SWI_RAISE_FLAG     = 2                         # SWI Synchro Flag up?
  SWI_DEBUG_MODE     = 3                         # SWI Debug Mode on?
  SWI_LOGGED_IN      = 4                         # SWI Successfully logged in?
  SWI_CHANGED        = 5                         # SWI Something changed?
  SWI_LOG_MODE       = 6                         # SWI debug logging mode on?
  SWI_LOGIN_ENABLED  = 7                         # SWI Login currently enabled?
  SWI_CHAT_ENABLED   = 8                         # SWI Chat currently enabled?
  SWI_CHAT_SHOW      = 9                         # SWI Chat currently hidden?
  SWI_CHAT_EXPANDED  = 10                        # SWI Chat window expanded?
  SWI_HOTKEYS_ACTIVE = 11                        # SWI Hotkeys 0-9 active?
  SWI_CHECKSUM       = 12                        # SWI Is Checksum currently active?
  SWI_AUTOUPDATE     = 13                        # SWI Is Auto Update active?
  
  #-------------------------------------------------------------------------------
  # ASOE String Constants
  #-------------------------------------------------------------------------------
  ERROR_CODE         = "asoe_error"              # An error occured / also means FALSE
  ERROR_OK           = "asoe_ok"                 # All is OK / also means TRUE
  DIVIDER_MAIN       = ";"                       # 
  DIVIDER_SUB        = ":"                       # 
  
end
#===============================================================================
# End
#===============================================================================