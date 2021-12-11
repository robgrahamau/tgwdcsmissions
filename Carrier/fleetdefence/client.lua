PlayerMap = {}
PlayerRMap = {}
PlayerBMap = {}
balive = 0
SetPlayer = SET_CLIENT:New():FilterStart()
SetPlayerRed = SET_CLIENT:New():FilterCoalitions("red"):FilterStart()
SetPlayerBlue = SET_CLIENT:New():FilterCoalitions("blue"):FilterStart()
Scoring = SCORING:New("Scoring")
trigger.action.setUserFlag("SSB",100)

if os ~= nil then
        nowTable = os.date('*t')
        nowYear = nowTable.year
        nowMonth = nowTable.month
        nowDay = nowTable.day
        nowHour = nowTable.hour
        nowminute = nowTable.min
        nowsec = nowTable.secs
    else
       nowTable = {}
        nowYear = "test"
        nowMonth = "test"
        nowDay = "test"
        nowHour = "test"
        nowminute = "test"
        nowsec = "test"
    end

missionstarttime = nowYear .. "/" .. nowMonth .. "/" .. nowDay .. " @ " .. nowHour .. ":" .. nowminute 
restarthour = nowHour + 6
  if restarthour > 23 then 
    restarthour = restarthour - 24
  end

  restarttime = "" .. restarthour ..":".. nowminute ..""

local function permanentPlayerCheck()
    -- BASE:E("PPCHECK")
    if os ~= nil then
      do
        nowTable = os.date('*t')
        nowYear = nowTable.year
        nowMonth = nowTable.month
        nowDay = nowTable.day
        nowHour = nowTable.hour
        nowminute = nowTable.min
      end
    else
       nowTable = {}
        nowYear = "test"
        nowMonth = "test"
        nowDay = "test"
        nowHour = "test"
        nowminute = "test"
    end
    currenttime = "H" .. nowHour .. ":" .. nowminute 
      SetPlayerRed:ForEachClient(function(PlayerClient) 
      local PlayerID = PlayerClient.ObjectName
      if PlayerClient:GetGroup() ~= nil then
      end
      if PlayerClient:IsAlive() then
        if PlayerRMap[PlayerID] ~= true then
          PlayerRMap[PlayerID] = true
          MESSAGE:New("Welcome to TGW Carrier Defense Mission",30):ToClient(PlayerClient)
        end
      else
        if PlayerRMap[PlayerID] ~= false then
          PlayerRMap[PlayerID] = false
        end
      end
    end)
    SetPlayerBlue:ForEachClient(function(PlayerClient) 
      local PlayerID = PlayerClient.ObjectName
      local group = nil
        if PlayerClient:GetGroup() ~= nil then
          group = PlayerClient:GetGroup()
        end
         if PlayerClient:IsAlive() then
           if PlayerBMap[PlayerID] ~= true then
            PlayerBMap[PlayerID] = true
             MESSAGE:New("Welcome to the TGW Carrier Defense Mission, Please read the Briefing for more information.",120):ToClient(PlayerClient)
             balive = balive + 1
           end    
         else
          if PlayerBMap[PlayerID] ~= false then
                PlayerBMap[PlayerID] = false
                balive = balive - 1
                if balive < 0 then
                  balive = 0
                  BASE:E("Balive was less then 0 shouldn't be possible so we are setting to 0")
                end
          end
       end
    end)
end

SCHEDULER:New(nil,permanentPlayerCheck,{},1,1)
