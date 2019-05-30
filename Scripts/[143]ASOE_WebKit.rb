#===============================================================================
# ASOE Web Kit by Efeberk, Malagar
#
# Version: 1.0
# Special thanks: Ryex, Gustavo Bicalho, Kubiwa Taicho
#===============================================================================
#
# This script will allow to request to some servers WITHOUT posting.(Only GET)
# Used WINAPI functions:
#
# WinHTTPOpen
# WinnHTTLConnect
# WinHTTPOpenRequest
# WinHTTPSendRequest
# WinHTTPReceiveResponse
# WinHttpQueryDataAvailable
# WinHttpReadData
#
# Call:
#
# EFE.request(host, path, post, port)
#
# host : "www.rpgmakervxace.net" (without http:// prefix)
# path : "/forum/login.php" ( the directory path of your php file )
# post : "username=kfdsfdsl&password=24324234"
# port : 80 is default.
#
#===============================================================================
module WEBKIT
  
  # I took this method from Gustavo Bicalho's WebKit script. Special thanks him.
  def self.to_ws(str)
    str = str.to_s();
    wstr = "";
    for i in 0..str.size
      wstr += str[i,1]+"\0";
    end
    wstr += "\0";
    return wstr;
  end
  
  WinHttpOpen = Win32API.new('winhttp','WinHttpOpen',"PIPPI",'I')
  WinHttpConnect = Win32API.new('winhttp','WinHttpConnect',"PPII",'I')
  WinHttpOpenRequest = Win32API.new('winhttp','WinHttpOpenRequest',"PPPPPII",'I')
  WinHttpSendRequest = Win32API.new('winhttp','WinHttpSendRequest',"PIIIIII",'I')
  WinHttpReceiveResponse = Win32API.new('winhttp','WinHttpReceiveResponse',"PP",'I')
  WinHttpQueryDataAvailable = Win32API.new('winhttp', 'WinHttpQueryDataAvailable', "PI", "I")
  WinHttpReadData = Win32API.new('winhttp','WinHttpReadData',"PPIP",'I')
 
  #-------------------------------------------------------------------------------
  # req by Malagar
  #
  # A wrapper function for "request" with two crucial security measures added.
  # Also dumps vital debugging information into the console window.
  #-------------------------------------------------------------------------------
  def self.req(path, post="", code=true)
    p = ASOE::PATH+path+".php"
    if $game_switches[ASOE::SWI_DEBUG_MODE] == false && code == true
      $game_variables[ASOE::VAR_ACCOUNTCODE] += 1
      if post != ""
        post = "a="<<$game_variables[ASOE::VAR_ACCOUNTID].to_s<<"&c="<<$game_variables[ASOE::VAR_ACCOUNTCODE].to_s<<"&"<<post
      else
        post = "a="<<$game_variables[ASOE::VAR_ACCOUNTID].to_s<<"&c="<<$game_variables[ASOE::VAR_ACCOUNTCODE].to_s
      end
    end
    if $game_switches[ASOE::SWI_LOG_MODE] == true && path != ""
        p "OUT: " + path + "?" + post
    end
    result = self.request(ASOE::HOST, p, post)
    if $game_switches[ASOE::SWI_LOG_MODE] == true && result != ""
        p "IN : " + result
    end
    return result
  end
  
  #
  def self.request(host, path, post="",port=80)
    p = path
    if(post != "")
      p = p + "?" + post
    end
    p = p.to_s
    pwszUserAgent = ''
    pwszProxyName = ''
    pwszProxyBypass = ''
    httpOpen = WinHttpOpen.call(pwszUserAgent, 0, pwszProxyName, pwszProxyBypass, 0)
    if httpOpen
      httpConnect = WinHttpConnect.call(httpOpen, to_ws(host), port, 0)
      if httpConnect
        httpOpenR = WinHttpOpenRequest.call(httpConnect, nil, to_ws(p), "", '',0,0)
        if httpOpenR
          httpSendR = WinHttpSendRequest.call(httpOpenR, 0, 0 , 0, 0,0,0)
          if httpSendR
            httpReceiveR = WinHttpReceiveResponse.call(httpOpenR, nil)
            if httpReceiveR
              received = 0
              httpAvailable = WinHttpQueryDataAvailable.call(httpOpenR, received)
              if httpAvailable
                result = ' '*1024
                n = 0
                httpRead = WinHttpReadData.call(httpOpenR, result, 1024, o=[n].pack('i!'))
                n=o.unpack('i!')[0]
                if $game_switches[ASOE::SWI_DEBUG_MODE]
                  p n
                end
                if result[0,n] != nil # Modified by Malagar 19/07/2014
                  return result[0, n]
                else
                  return ASOE::ERROR_CODE
                end
              else
                msgbox_p("Error about query data available")
              end
            else
              msgbox_p("Error when receiving response")
            end
          else
            msgbox_p("Error when sending request")
          end
        else
          msgbox_p("Error when opening request")
        end
      else
        msgbox_p("Error when connecting to the host")
      end
    else
      msgbox_p("Error when opening connection")
    end
  end
  
end
#===============================================================================
# End
#===============================================================================