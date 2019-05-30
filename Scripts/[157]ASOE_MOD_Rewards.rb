#===============================================================================
# ASOE Reward Module by Malagar
#
# Version: 1.0
#===============================================================================
module ASOE_REWARDS
  
  ICON_EXP  = 117
  ICON_GOLD = 361
  
  #-------------------------------------------------------------------------------
  # getReward by Malagar
  #
  #-------------------------------------------------------------------------------

  def self.getReward(var_accountname, id)
    result = WEBKIT.req("asoe_rewards/asoe_rewards_getreward", "accountname="<<$game_variables[var_accountname]<<"&id="<<id.to_s)
    if result != ASOE::ERROR_CODE && result != nil
      SceneManager.call(Scene_Reward)
      SceneManager.scene.prepare(result)
    end
    #return result
    #name, description, exp, accountgain, gold, items, icon, variables, switches

    #show achievement window if true
    #display achievement data
  end
  
  #UnlockReward
  #ResetReward
  
end
#===============================================================================
# End
#===============================================================================