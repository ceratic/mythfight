#===============================================================================
# ASOE Core Module by Efeberk, Malagar
#
# Version: 1.0
#===============================================================================
module ASOE_CORE
  
  #-------------------------------------------------------------------------------
  # flag functions by Malagar
  # 
  # Two important functions that must be used before and after each and every
  # important action. This updates the client data to the server database and
  # also makes some security checks and multi login checks.
  #
  # raiseFlag - should be used BEFORE every important action
  # lowerFlag - should be used AFTER every important action
  #-------------------------------------------------------------------------------
  def self.raiseFlag(var_accountname)
    checkLogin(var_accountname)
    if $game_switches[ASOE::SWI_RAISE_FLAG] == true
      lowerFlag(var_accountname)
    end
    $game_switches[ASOE::SWI_RAISE_FLAG] = true
    $game_switches[ASOE::SWI_CHAT_SHOW] = false
    $game_switches[ASOE::SWI_CHAT_ENABLED] = false
    $game_switches[ASOE::SWI_AUTOUPDATE] = false
    $game_switches[ASOE::SWI_CHECKSUM] = false
    $game_switches[ASOE::SWI_HOTKEYS_ACTIVE] = false
    $game_timer.stop
    SceneManager.scene.chat_window_refresh
  end

  def self.lowerFlag(var_accountname, force=false)
    checkLogin(var_accountname)
    updateAll(var_accountname, force)
    $game_switches[ASOE::SWI_RAISE_FLAG] = false
    $game_switches[ASOE::SWI_CHAT_SHOW] = false
    $game_switches[ASOE::SWI_CHAT_ENABLED] = false
    $game_switches[ASOE::SWI_AUTOUPDATE] = true
    $game_switches[ASOE::SWI_CHECKSUM] = true
    $game_switches[ASOE::SWI_HOTKEYS_ACTIVE] = true
    $game_timer.start (2 * Graphics.frame_rate)
    SceneManager.scene.chat_window_refresh
  end
  
  #-------------------------------------------------------------------------------
  # nameActor by Malagar
  #
  # Changes an actors name via script. Had to turn this into a function because
  # the lenghty script commands won't fit into the script box of events.
  #-------------------------------------------------------------------------------
  def self.nameActor(var_actorname, var_actor_id)
    $game_actors[$game_variables[var_actor_id]].name = $game_variables[var_actorname]
  end

  #-------------------------------------------------------------------------------
  # hasLocation, memorizeLocation, recallLocation by Malagar
  #
  # Just some simple functions to check if we have already memorized the last
  # position of the player, to memorize a location or teleport to the last one.
  # Its based on data saved within game variables, something that is not possible
  # by using the event command "teleport".
  #-------------------------------------------------------------------------------
  def self.hasLocation?()
    if ($game_variables[ASOE::VAR_LAST_PLAYER_MAP] != 0)
      return true
    else
      return false
    end
  end
  
  def self.memorizeLocation()
    $game_variables[ASOE::VAR_LAST_PLAYER_DIR] = $game_player.direction
    $game_variables[ASOE::VAR_LAST_PLAYER_MAP] = $game_map.map_id
    $game_variables[ASOE::VAR_LAST_PLAYER_X]   = $game_player.x
    $game_variables[ASOE::VAR_LAST_PLAYER_Y]   = $game_player.y
  end

  def self.recallLocation()
    if $game_variables[ASOE::VAR_LAST_PLAYER_MAP] != 0
      $game_player.reserve_transfer($game_variables[ASOE::VAR_LAST_PLAYER_MAP], $game_variables[ASOE::VAR_LAST_PLAYER_X], $game_variables[ASOE::VAR_LAST_PLAYER_Y], $game_variables[ASOE::VAR_LAST_PLAYER_DIR])
    end
  end
 
  #-------------------------------------------------------------------------------
  # login by Efeberk, Malagar
  #-------------------------------------------------------------------------------
  def self.login(var_accountname, var_password)
    if $game_switches[ASOE::SWI_LOGGED_IN] == false
      checkVersion(var_accountname)
      if $game_switches[ASOE::SWI_LOGIN_ENABLED] = false
        return false
      else
        result = WEBKIT.req("asoe_core/asoe_core_login", "accountname="<<$game_variables[var_accountname]<<"&password="<<$game_variables[var_password])
        if result != nil
          if !result.include?(ASOE::ERROR_CODE)
            logdate = result
            if logdate != ""
              logAccount(var_accountname)
              refreshAccount(var_accountname)
              refreshParty(var_accountname, true)
              ASOE_WORLD.worldMaintenance()
              $game_switches[ASOE::SWI_CHAT_ENABLED] = true
              $game_switches[ASOE::SWI_LOGGED_IN] = true
              $game_switches[ASOE::SWI_CHECKSUM] = true
              $game_switches[ASOE::SWI_AUTOUPDATE] = true
              return true
            else
              $game_switches[ASOE::SWI_LOGGED_IN] = false
              return false
            end
          else
            $game_switches[ASOE::SWI_LOGGED_IN] = false
            return false
          end
        else
          $game_switches[ASOE::SWI_LOGGED_IN] = false
          return false
        end
      end
    end
  end

  #-------------------------------------------------------------------------------
  # logout by Malagar
  #-------------------------------------------------------------------------------
  def self.logout(var_accountname)
    if $game_switches[ASOE::SWI_LOGGED_IN] == true
      updateAll(var_accountname, true)
      $game_switches[ASOE::SWI_LOGGED_IN] = false
      $game_switches[ASOE::SWI_AUTOUPDATE] = false
      $game_switches[ASOE::SWI_CHAT_ENABLED] = false
      $game_switches[ASOE::SWI_CHECKSUM] = false
    end
  end

  #-------------------------------------------------------------------------------
  # logAccount, loggedTime by Efeberk, Malagar
  #-------------------------------------------------------------------------------
  def self.logAccount(var_accountname)
    result = WEBKIT.req("asoe_core/asoe_core_logAccount", "accountname="<<$game_variables[var_accountname])
    $game_variables[ASOE::VAR_TIMESTAMP] = result.to_i
    $game_variables[ASOE::VAR_CHAT_TIMESTAMP] = result.to_i
    ASOE_CHAT.updateTime(ASOE::VAR_CHAT_TIMESTAMP)
    return result.to_i
  end

  def self.loggedTime(var_accountname)
    result = WEBKIT.req("asoe_core/asoe_core_loggedTime", "accountname="<<$game_variables[var_accountname])
    return result.to_i
  end

  #-------------------------------------------------------------------------------
  # addPenalty, check , updateChecksum, Checksum, checkVersion by Malagar
  #
  # This function fulfills multiply purposes: It is the first server request that is
  # sent when a new client connects. This script transfers the security code and
  # checks if registration is currently possible. It also transmits the current
  # version and a download link.
  #-------------------------------------------------------------------------------
  def self.addPenalty(var_accountname, value)
    result = WEBKIT.req("asoe_core/asoe_core_addPenalty", "accountname="<<$game_variables[var_accountname]<<"&value="<<value.to_s)
    if !result.include?(ASOE::ERROR_CODE)
      if result.to_i >= ASOE::NUM_BANLEVEL_MAX
        $game_switches[ASOE::SWI_LOGGED_IN] = false
        $game_switches[ASOE::SWI_CHAT_SHOW] = false
        $game_switches[ASOE::SWI_CHAT_ENABLED] = false
        msgbox_p("Fraud detected! Please contact administrator for clearance.")
        SceneManager.goto(Scene_Title)
      end
    end
  end
  
  def self.actorCheckSum(var_actorid)
    if var_actorid != ""
      actor_id = $game_variables[var_actorid].to_i
      mhp = $game_actors[actor_id].param(0)
      mmp = $game_actors[actor_id].param(1)
      atk = $game_actors[actor_id].param(2)
      defe = $game_actors[actor_id].param(3)
      mat = $game_actors[actor_id].param(4)
      mdf = $game_actors[actor_id].param(5)
      agi = $game_actors[actor_id].param(6)
      luk = $game_actors[actor_id].param(7)
      return mhp.to_s<<mmp.to_s<<atk.to_s<<defe.to_s<<mat.to_s<<mdf.to_s<<agi.to_s<<luk.to_s
    end
    return 0
  end
  
  def self.checkActorChecksum(var_accountname, var_actorid)
    if var_accountname != "" && var_actorid != "" && $game_switches[ASOE::SWI_CHECKSUM] == true
      checksum = self.actorCheckSum(var_actorid)
      p "checksum: " + checksum.to_s # debug
      result = WEBKIT.req("asoe_core/asoe_core_checkActorChecksum", "accountname="<<$game_variables[var_accountname]<<"&actorid="<<$game_variables[var_actorid].to_s<<"&checksum="<<checksum.to_s)
      if !result.include?(ASOE::ERROR_CODE)
        return true
      else
        return false
      end
    else
      return true
    end
  end
  
  def self.updateActorChecksum(var_accountname, var_actorid)
    if var_accountname != "" && var_actorid != ""
      checksum = actorCheckSum(var_actorid)
      result = WEBKIT.req("asoe_core/asoe_core_updateActorChecksum", "accountname="<<$game_variables[var_accountname]<<"&actorid="<<$game_variables[var_actorid].to_s<<"&checksum="<<checksum.to_s)
      if !result.include?(ASOE::ERROR_CODE)
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
  def self.AccountCheckSum(var_accountname)
    if var_accountname != ""
     
    end
  end
  
  def self.checkAccountCheckSum(var_accountname)
   if var_accountname != ""
      checksum = self.AccountCheckSum(var_accountname)
      result = WEBKIT.req("asoe_core/asoe_core_checkAccountChecksum", "accountname="<<$game_variables[var_accountname]<<"&checksum="<<checksum.to_s)
      if !result.include?(ASOE::ERROR_CODE)
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
  def self.updateAccountCheckSum(var_accountname)
    if var_accountname != ""
      checksum = self.AccountCheckSum(var_accountname)
      result = WEBKIT.req("asoe_core/asoe_core_updateAccountChecksum", "accountname="<<$game_variables[var_accountname]<<"&checksum="<<checksum.to_s)
      if !result.include?(ASOE::ERROR_CODE)
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
  def self.checkVersion(var_accountname)
    result = WEBKIT.req("asoe_core/asoe_core_checkVersion", "accountname="<<$game_variables[var_accountname], false)
    if result != nil
      result = result.split(";");
      $game_variables[ASOE::VAR_ACCOUNTID] = result[0].to_i
      logon = result[1].to_i
      if logon == 0
        $game_switches[ASOE::SWI_LOGIN_ENABLED] = false
      else
        $game_switches[ASOE::SWI_LOGIN_ENABLED] = true
      end
      $game_variables[ASOE::VAR_ACCOUNTCODE] = result[2].to_i
      version = result[3].to_i
      link = result[4]
      if version == nil
        $game_switches[ASOE::SWI_LOGGED_IN] = false
        msgbox_p("Unable to connect to game server!")
        SceneManager.call(Scene_End)
      elsif version != ASOE::VERSION
        $game_switches[ASOE::SWI_LOGGED_IN] = false 
        msgbox_p("Your game version is out of date!")
         if link != nil     
           link = "http://www." + link
           msgbox_p("Patch download started, please update your game folder now and restart!")
           system("start #{ link }")
         end
         SceneManager.exit
      end
    else
      $game_switches[ASOE::SWI_LOGGED_IN] = false
      msgbox_p("Unable to connect to game server!")
      SceneManager.call(Scene_End)
    end
  end
 
#-------------------------------------------------------------------------------
# refreshAccount by Malagar
#
# Basically this refreshes the general account data like the carried items,
# the total party gold, steps taken, map position etc.
# as well as all variables and switches - but NOT the actual party members.
#-------------------------------------------------------------------------------
def self.refreshAccount(var_accountname)
  result = WEBKIT.req("asoe_core/asoe_core_refreshAccount", "accountname="<<$game_variables[var_accountname])
  if result != nil
    result = result.split(";")
    $game_party.init_all_items
    times = result[0].to_i- $game_party.steps
    times.times { $game_party.increase_steps }
    items = result[1].split(",")
    items.each { |i| $game_party.gain_item($data_items[i.split(":")[0].to_i], i.split(":")[1].to_i)}
    weapons = result[2].split(",")
    weapons.each { |i| $game_party.gain_item($data_weapons[i.split(":")[0].to_i], i.split(":")[1].to_i)}
    armors = result[3].split(",")
    armors.each { |i| $game_party.gain_item($data_armors[i.split(":")[0].to_i], i.split(":")[1].to_i)}
    map_id = result[4].split(":")[0].to_i
    player_x = result[4].split(":")[1].to_i
    player_y = result[4].split(":")[2].to_i
    dir = result[4].split(":")[3].to_i
    $game_variables[ASOE::VAR_LAST_PLAYER_MAP] = map_id
    $game_variables[ASOE::VAR_LAST_PLAYER_X] = player_x
    $game_variables[ASOE::VAR_LAST_PLAYER_Y] = player_y
    $game_variables[ASOE::VAR_LAST_PLAYER_DIR] = dir
    $game_party.lose_gold($game_party.max_gold)
    $game_party.gain_gold(result[5].to_i)
    $game_variables[ASOE::VAR_GUILD_NAME] = result[6]
    $game_variables[ASOE::VAR_ACCOUNTGROUP] = result[7]
    gotVariables = getAllVariables(var_accountname)
    gotVariables.each {|i|
    vid = i.split(":")[0].to_i
    vval = i.split(":")[1].to_i
    $game_variables[vid] = vval
    }
    gotSwitches = getAllSwitches(var_accountname)
    gotSwitches.each {|i|
    vid = i.split(":")[0].to_i
    i.split(":")[1].to_i == 1 ? vval = true : vval = false
    $game_switches[vid] = vval
    }
    $game_variables[ASOE::VAR_LAST_PLAYER_MAP] = map_id
    $game_variables[ASOE::VAR_LAST_PLAYER_X]   = player_x
    $game_variables[ASOE::VAR_LAST_PLAYER_Y]   = player_y
    $game_player.reserve_transfer(map_id, player_x, player_y, 2)
  end
end

#-------------------------------------------------------------------------------
# refreshActor by Efeberk, Malagar
#
# This function pulls the data of a single actor from the server and updates
# that actor accordingly. This covers hp, mp, skills, states and equipment but
# does NOT affect the other party members or general attributes like gold etc.
#-------------------------------------------------------------------------------
def self.refreshActor(var_accountname, actor_id, target_id=0, initalize)
  result = WEBKIT.req("asoe_core/asoe_core_refreshActor", "actorid="<<actor_id.to_s<< "&accountname="<<$game_variables[var_accountname])
  if target_id != 0
    theid = target_id
  else
    theid = actor_id
  end
  if result != nil
    result = result.split(";")
    level = result[0].to_i
    theclass = result[1].to_i
    character_name = result[2].to_s
    character_index = result[3].to_i
    face_name = result[4].to_s
    face_index = result[5].to_i
    $game_actors[theid].set_graphic(character_name, character_index, face_name, face_index)
    $game_actors[theid].name = result[6].to_s
    hp = result[7].to_i
    mp = result[8].to_i
    mhp = result[9].to_i
    mmp = result[10].to_i
    atk = result[11].to_i
    defe = result[12].to_i
    mat = result[13].to_i
    mdf = result[14].to_i
    agi = result[15].to_i
    luk = result[16].to_i
    $game_actors[theid].change_level(level, false)
    equipped = result[17].split(',')
    skills = result[18].split(',')
    states = result[19].split(',')
    exp = result[20].to_i
    $game_actors[theid].change_exp(exp, false)
    pos = result[21].to_i
    equipped.each_index {|i| 
    if equipped[i].to_i > 0
      item = $data_armors[equipped[i].to_i]
      item = $data_weapons[equipped[i].to_i] if i == 0
      $game_actors[theid].force_change_equip(i, item)
    end}
    $game_player.refresh
    $game_actors[theid].add_param(0, -$game_actors[theid].mhp)
    $game_actors[theid].add_param(1, -$game_actors[theid].mmp)
    $game_actors[theid].add_param(2, -$game_actors[theid].atk)
    $game_actors[theid].add_param(3, -$game_actors[theid].def)
    $game_actors[theid].add_param(4, -$game_actors[theid].mat)
    $game_actors[theid].add_param(5, -$game_actors[theid].mdf)
    $game_actors[theid].add_param(6, -$game_actors[theid].agi)
    $game_actors[theid].add_param(7, -$game_actors[theid].luk)
    $game_actors[theid].add_param(0, mhp)
    $game_actors[theid].add_param(1, mmp)
    $game_actors[theid].add_param(2, atk)
    $game_actors[theid].add_param(3, defe)
    $game_actors[theid].add_param(4, mat)
    $game_actors[theid].add_param(5, mdf)
    $game_actors[theid].add_param(6, agi)
    $game_actors[theid].add_param(7, luk)
    $game_actors[theid].hp = hp
    $game_actors[theid].mp = mp
    skills.each {|i| $game_actors[theid].learn_skill(i.to_i)}
    states.each {|i| $game_actors[theid].add_state(i.split(':')[0].to_i)}
    if initalize
      $game_party.add_actor(theid)
    end
  end
end

#-------------------------------------------------------------------------------
# refreshParty by Malagar
#
# This function pulls the data of all actors from the server and updates
# those actors accordingly. This covers hp, mp, skills, states and equipment but
# does NOT affect the other party members or general attributes like gold etc.
#-------------------------------------------------------------------------------
def self.refreshParty(var_accountname, initalize)
  actorslist = ""
  actorslist = actorList(var_accountname)
  if actorslist.length > 0
    i = 0
    while i < actorslist.length
      if actorslist[i] != nil
        $game_variables[ASOE::VAR_ACTORID] = actorslist[i]
        refreshActor(var_accountname, actorslist[i].to_i, initalize)
      end
      i += 1
    end
  end
end

#-------------------------------------------------------------------------------
# refreshAll by Malagar
#
#-------------------------------------------------------------------------------
def self.refreshAll(var_accountname)
  refreshAccount(var_accountname)
  refreshParty(var_accountname)
end

#-------------------------------------------------------------------------------
# actorList by Malagar
#
# This function simply pulls a list of all actors associated to one account.
#-------------------------------------------------------------------------------
def self.actorList(var_accountname)
  result = WEBKIT.req("asoe_core/asoe_core_actorList", "accountname="<<$game_variables[var_accountname])
  return result.split(";") if result.length > 0
  return []
end

#-------------------------------------------------------------------------------
# startingActors by Malagar
#
# This function simply pulls a list of all actors available at character creation.
#-------------------------------------------------------------------------------
def self.startingActors(var_accountname)
  result = WEBKIT.req("asoe_core/asoe_core_startingActors", "")
  return result.split(":") if result.length > 0
  return []
end

#-------------------------------------------------------------------------------
# updateAccount by Malagar
#
# Updates account data like gold, steps, inventory and map location. This script
# does not update the individual actors within the party. This script will
# overwrite all the accounts data stored on the server.
#-------------------------------------------------------------------------------
def self.updateAccount(var_accountname)
   steps = $game_party.steps.to_s
   items = ""
   $game_party.items.each{|i| items += i.id.to_s + ":" + $game_party.item_number(i).to_s + "," }
   weapons = ""
   $game_party.weapons.each{|i| weapons += i.id.to_s  + ":" + $game_party.item_number(i).to_s +  "," }
   armors = ""
   $game_party.armors.each{|i| armors += i.id.to_s  + ":" + $game_party.item_number(i).to_s +  "," }
   map_location = $game_map.map_id.to_s+":"+$game_player.x.to_s+":"+$game_player.y.to_s
   gold = $game_party.gold
   group =  $game_variables[ASOE::VAR_ACCOUNTGROUP]
   if checkAccountCheckSum(var_accountname) == true
     #csum = accountCheckSum(var_accountname)
     result = WEBKIT.req("asoe_core/asoe_core_updateAccount", "&accountname="<<$game_variables[var_accountname]<<"&steps="<<steps<<"&items="<<items<<"&weapons="<<weapons<<"&armors="<<armors<<"&mapLocation="<<map_location<<"&gold="<<gold.to_s<<"&group="<<group.to_s)
   else
     addPenalty(var_accountname, ASOE::NUM_BANLEVEL_MAX)
   end
end

#-------------------------------------------------------------------------------
# updateActor by Efeberk, Malagar
#
# This updates a single actor on a single account by sending the actors data
# to the server. It will overwrite all the actors data stored on the server.
#-------------------------------------------------------------------------------
def self.updateActor(var_accountname, var_actor_id)
  accountname = $game_variables[var_accountname]
  actor_id = $game_variables[var_actor_id].to_i
  theclass = $game_actors[actor_id].class_id
  character_name = $game_actors[actor_id].character_name
  character_index = $game_actors[actor_id].character_index.to_s
  face_name = $game_actors[actor_id].face_name
  face_index = $game_actors[actor_id].face_index.to_s
  actorname = $game_actors[actor_id].name
  level = $game_actors[actor_id].level.to_s
  equipped = ""
  $game_actors[actor_id].equips.each{|i| 
  if i == nil
    equipped += "0,"
  else
    equipped += i.id.to_s + ","
  end
  }
  skills = ""
  $game_actors[actor_id].skills.each{|i| skills += i.id.to_s + "," }
  states = ""
  $game_actors[actor_id].states.each{|i| states += i.id.to_s + "," }
  hp = $game_actors[actor_id].hp.to_s
  mp = $game_actors[actor_id].mp.to_s
  mhp = $game_actors[actor_id].param(0)
  mmp = $game_actors[actor_id].param(1)
  atk = $game_actors[actor_id].param(2)
  defe = $game_actors[actor_id].param(3)
  mat = $game_actors[actor_id].param(4)
  mdf = $game_actors[actor_id].param(5)
  agi = $game_actors[actor_id].param(6)
  luk = $game_actors[actor_id].param(7)
  exp = $game_actors[actor_id].exp.to_s
  csum = 0
  ugroup = 0
  if actorExists?(var_accountname, var_actor_id) == true
    position = $game_actors[actor_id].index
    if checkActorChecksum(var_accountname, var_actor_id) == true
      result = WEBKIT.req("asoe_core/asoe_core_updateActor", "&actorname="<<actorname.to_s<<"&accountname="<<accountname.to_s<<"&character_name="<<character_name.to_s<<"&character_index="<<character_index.to_s<<"&face_name="<<face_name.to_s<<"&face_index="<<face_index.to_s<<"&actor_id="<<actor_id.to_s<<"&level="<<level<<"&equipped="<<equipped<<"&skills="<<skills<<"&states="<<states<<"&hp="<<hp<<"&mp="<<mp<<"&mhp="<<mhp.to_s<<"&mmp="<<mmp.to_s<<"&atk="<<atk.to_s<<"&def="<<defe.to_s<<"&mat="<<mat.to_s<<"&mdf="<<mdf.to_s<<"&agi="<<agi.to_s<<"&luk="<<luk.to_s<<"&exp="<<exp<<"&position="<<position.to_s<<"&usergroup="<<ugroup.to_s<<"&class="<<theclass.to_s)
    else
      addPenalty(var_accountname, ASOE::NUM_BANLEVEL_MAX)
    end
  else
    $game_party.add_actor(actor_id)
    position = $game_party.all_members.size.to_i
    result = registerActor(actorname, accountname, level, character_name, character_index, face_name, face_index, actor_id, equipped, skills, states, hp, mp, mhp, mmp, atk, defe, mat, mdf, agi, luk, exp, position, ugroup, theclass)
    if result == true
      updateActorChecksum(var_accountname, var_actor_id)
    end
  end
end

#-------------------------------------------------------------------------------
# updateAll by Malagar
#
#-------------------------------------------------------------------------------
def self.updateAll(var_accountname, force=false)
  if $game_switches[ASOE::SWI_CHANGED] == true || force == true
    updateAccount(var_accountname)
    updateParty(var_accountname)
    $game_switches[ASOE::SWI_CHANGED] = false
  end
end

#-------------------------------------------------------------------------------
# updateParty by Malagar
#
# This updates all actors on a single account by sending the actors data
# to the server. It will overwrite all the actor data stored on the server.
#-------------------------------------------------------------------------------
def self.updateParty(var_accountname)
  actorslist = ""
  actorslist = actorList(var_accountname)
  if actorslist.length > 0
    i = 0
    while i < actorslist.length
      if actorslist[i] != nil
        $game_variables[ASOE::VAR_ACTORID] = actorslist[i]
        updateActor(var_accountname, ASOE::VAR_ACTORID)
      end
      i += 1
    end
  end
end

#-------------------------------------------------------------------------------
# registerAccount by Efeberk, Malagar
#
# This basically creates a new user account on the server database.
# Account names are unique, there can be no duplicates.
#-------------------------------------------------------------------------------
def self.registerAccount(var_accountname, var_password)
  if $game_switches[ASOE::SWI_LOGGED_IN] = false
    return false
  else
    result = WEBKIT.req("asoe_core/asoe_core_registerAccount", "accountname="<<$game_variables[var_accountname].to_s<<"&password="<<$game_variables[var_password].to_s, false)
    if !result.include?(ASOE::ERROR_CODE)
      checkVersion(var_accountname)
      return true
    else
      return false
    end
  end
end

#-------------------------------------------------------------------------------
# deleteAccount by Malagar
#
# Removes an account and all corresponding Actors from the database.
#-------------------------------------------------------------------------------
def self.deleteAccount(var_accountname, var_password)
  result = WEBKIT.req("asoe_core/asoe_core_deleteAccount", "accountname="<<$game_variables[var_accountname]<<"&password="<<$game_variables[var_password])
  return !result.include?(ASOE::ERROR_CODE)
end

#-------------------------------------------------------------------------------
# changeAccountPassword by Malagar
#
# Changes an accounts password to the new one. Is checked server-side before
# execution. Should be checked client-side before calling this method.
#-------------------------------------------------------------------------------
def self.changePassword(var_accountname, var_old_password, var_new_password)
  result = WEBKIT.req("asoe_core/asoe_core_changeAccountPassword", "accountname="<<$game_variables[var_accountname]<<"&oldpassword="<<$game_variables[var_old_password]<<"&newpassword="<<$game_variables[var_new_password])
  return !result.include?(ASOE::ERROR_CODE)
end

#-------------------------------------------------------------------------------
# registerActor by Efeberk, Malagar
#
#-------------------------------------------------------------------------------
def self.registerActor(actorname, accountname, level, character_name, character_index, face_name, face_index, actor_id, equipped, skills, states, hp, mp, mhp, mmp, atk, defe, mat, mdf, agi, luk, exp, position, usergroup, theclass)
  result = WEBKIT.req("asoe_core/asoe_core_registerActor", "actorname="<<actorname.to_s<<"&accountname="<<accountname.to_s<<"&level="<<level.to_s<<"&character_name="<<character_name.to_s<<"&character_index="<<character_index.to_s<<"&face_name="<<face_name.to_s<<"&face_index="<<face_index.to_s<<"&actor_id="<<actor_id.to_s<<"&equipped="<<equipped.to_s<<"&skills="<<skills.to_s<<"&states="<<states.to_s<<"&hp="<<hp.to_s<<"&mp="<<mp.to_s<<"&mhp="<<mhp.to_s<<"&mmp="<<mmp.to_s<<"&atk="<<atk.to_s<<"&def="<<defe.to_s<<"&mat="<<mat.to_s<<"&mdf="<<mdf.to_s<<"&agi="<<agi.to_s<<"&luk="<<luk.to_s<<"&exp="<<exp.to_s<<"&position="<<position.to_s<<"&usergroup="<<usergroup.to_s<<"&class="<<theclass.to_s)
   if !result.include?(ASOE::ERROR_CODE)
    return true
  else
    return false
  end
end

#-------------------------------------------------------------------------------
# AccountExists? by Efeberk, Malagar
#-------------------------------------------------------------------------------
def self.accountExists?(var_accountname)
  result = WEBKIT.req("asoe_core/asoe_core_accountExists", "accountname="<<$game_variables[var_accountname])
  if !result.include?(ASOE::ERROR_CODE)
    return true
  else
    return false
  end
end

#-------------------------------------------------------------------------------
# ActorExists? by Efeberk, Malagar
#-------------------------------------------------------------------------------
def self.actorExists?(var_accountname, var_actor_id)
  result = WEBKIT.req("asoe_core/asoe_core_actorExists", "accountname="<<$game_variables[var_accountname]<<"&actorid="<<$game_variables[var_actor_id])
  if !result.include?(ASOE::ERROR_CODE)
    return true
  else
    return false
  end
end
#-------------------------------------------------------------------------------
# AccountGold by Efeberk, Malagar
#-------------------------------------------------------------------------------
def self.getAccountGold(var_accountname)
  result = WEBKIT.req("asoe_core/asoe_core_getAccountGold", "accountname="<<$game_variables[var_accountname])
  return result.to_i
end

#-------------------------------------------------------------------------------
# Switch Functions by Efeberk, Malagar
# Value is the switch's value, where 1 = true and 0 = false
#-------------------------------------------------------------------------------
def self.getSwitch(id, var_accountname)
  result = WEBKIT.req("asoe_core/asoe_core_getSwitch", "id="<<id.to_s<<"&accountname="<<$game_variables[var_accountname])
  return result.to_i == 1
end

def self.setSwitch(id, var_accountname)
  $game_switches[id] ? value = "1" : value = "0"
  result = WEBKIT.req("asoe_core/asoe_core_setSwitch", "id="<<id.to_s<<"&value="<<value<<"&accountname="<<$game_variables[var_accountname])
  return !result.include?(ASOE::ERROR_CODE)
end

def self.getAllSwitches(var_accountname)
  result = WEBKIT.req("asoe_core/asoe_core_getAllSwitches", "accountname="<<$game_variables[var_accountname])
  return result.split(";") if result.length > 1
  return []
end

def self.setSwitches(start_id, end_id, var_accountname)
  
end

#-------------------------------------------------------------------------------
# Variable Functions by Efeberk, Malagar
# Variables are always numerical
#-------------------------------------------------------------------------------
def self.getVariable(id, var_accountname, isNumber = true)
  result = WEBKIT.req("asoe_core/asoe_core_getVariable", "id="<<id.to_s<<"&accountname="<<$game_variables[var_accountname])
  return result.to_i
end

def self.setVariable(id, var_accountname)
  value = $game_variables[id].to_s
  result = WEBKIT.req("asoe_core/asoe_core_setVariable", "id="<<id.to_s<<"&value="<<value<<"&accountname="<<$game_variables[var_accountname])
  return !result.include?(ASOE::ERROR_CODE)
end

def self.getAllVariables(var_accountname)
  result = WEBKIT.req("asoe_core/asoe_core_getAllVariables", "accountname="<<$game_variables[var_accountname])
  return result.split(";") if result.length > 1
  return []
end

def self.setAllVariables(start_id, end_id, var_accountname)
  
end

#-------------------------------------------------------------------------------
# checkLogin by Efeberk, Malagar
#
# This script performs two important security checks:
# 1. If the client is correctly connected to the server
# 2. If another person also logged to same account
#-------------------------------------------------------------------------------
def self.checkLogin(var_accountname)
  if $game_switches[ASOE::SWI_LOGGED_IN] == false
    $game_switches[ASOE::SWI_RAISE_FLAG] = false
    $game_switches[ASOE::SWI_CHAT_SHOW] = false
    $game_switches[ASOE::SWI_CHAT_ENABLED] = false
    msgbox_p("Not logged in or connection to server lost!")
    SceneManager.goto(Scene_Title)
  end
  #if $game_variables[ASOE::VAR_TIMESTAMP] != loggedTime(var_accountname)
  #  $game_switches[ASOE::SWI_LOGGED_IN] = false
  #  $game_switches[ASOE::SWI_RAISE_FLAG] = false
  #  $game_switches[ASOE::SWI_CHAT_SHOW] = false
  #  $game_switches[ASOE::SWI_CHAT_ENABLED] = false
  #  msgbox_p("Multi login detected!")
  #  SceneManager.goto(Scene_Title)
  #end
end

#===============================================================================

#===============================================================================
# Ranking Functions by Efeberk, Malagar
#===============================================================================

def self.getVariableRanking(id)
  result = WEBKIT.req("asoe_core/asoe_getVariableRanking", "id="<<id.to_s)
  return result.split(';')
end

#===============================================================================

end
#===============================================================================
# End
#===============================================================================