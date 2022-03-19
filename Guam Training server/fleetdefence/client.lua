PlayerMap = {}
PlayerRMap = {}
PlayerBMap = {}
SetPlayer = SET_CLIENT:New():FilterStart()

mission = " not set " 


resethours = 8
hourstoreset = 8
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
restarthour = nowHour + resethours
serverrestart = 15
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
	if nowHour == (serverrestart - 1) then
		if nowminute == 0 then
			if hrleft ~= true then
				MESSAGE:New("" .. serverrestart .. ":00 Server Restart in 1 hour",15):ToAll()
				hrleft = true
			end
		elseif nowminute == 30 then
			if left30 ~= true then
				MESSAGE:New("" .. serverrestart .. ":00 Server Restart in 30 Minutes",15):ToAll()
				left30 = true
			end
		elseif nowminute == 45 then
			if left45 ~= true then
				MESSAGE:New("" .. serverrestart .. ":00 Server Restart in 15 Minutes",15):ToAll()
				left45 = true
			end
		elseif nowminute == 50 then
			if left50 ~= true then
				MESSAGE:New("" .. serverrestart .. ":00 Server Restart in 10 Minutes",15):ToAll()
				left50 = true
			end
		elseif nowminute == 55 then
			if left55 ~= true then
				MESSAGE:New("" .. serverrestart .. ":00 Server Restart in 5 Minutes Forced Save has occured.",15):ToAll()
				updatevalues()
				save()
				ctldsavedata()
				saveadmingroups()
				save_groups()
				left55 = true
			end
		elseif nowminute == 59 then
			if left59 ~= true then
				MESSAGE:New("" .. serverrestart .. ":00 Server Restart in 1 Minute All items now saved",15):ToAll()
				updatevalues()
				save()
				ctldsavedata()
				saveadmingroups()
				save_groups()
				left59 = true
			end
		end
	end
	
    SetPlayer:ForEachClient(function(PlayerClient)
      local PlayerID = PlayerClient.ObjectName
      local Coalition = PlayerClient:GetCoalition()
      local col = "Red Coalition"
	  local mission = activeareairan
      if Coalition == 2 then
        col = "Blue Coalition Forces"
		mission = activearea
      end
      local PlayerName = PlayerClient:GetPlayerName()
      if PlayerClient:IsAlive() then
        if PlayerMap[PlayerID] ~= true then
          PlayerMap[PlayerID] = true
          local MessageText = "Welcome to the Task Group Warrior Mission Server: ".. PlayerName .. "\n Powered By Moose, Player Donations, OverlordBot, Lots of Pain Killers, and lets not forget the space server Hamsters! \n THE EYES BOO GO FOR THE EYES! \n Current Server time is: ".. nowHour .. ":" .. nowminute .."\n You are on " ..col..", Please check the mission brief for more information ALT+B \n Please Join the DISCORD https://discord.gg/6Ufnf2Q \n Supplied by core members of Http://TaskGroupWarrior.Info \n Current Time is: " .. currenttime .. " Server Mission Cycle:" .. restarttime .." \n A Reset will always happen at " .. serverrestart .. ":00  Sydney Australia time. \n "
          MESSAGE:New(MessageText,15,"Server Info",true):ToClient(PlayerClient)
          hm(" > `- Ground Crew:` " .. PlayerClient:GetPlayerName() .. " is in the pit, straps are tight, their " ..PlayerClient:GetTypeName() .. " belonging to " .. col .. " is fueled and ready to go \n > Good Luck Out there")
		  SCHEDULER:New(nil,function() 
			local msgtext = "Please Read the Briefing"
			MESSAGE:New(msgtext,120,"Mission Tasking Info",true):ToClient(PlayerClient)
		  end,nil,120)
        end
      else
        if PlayerMap[PlayerID] ~= false then
          PlayerMap[PlayerID] = false
        end      
      end      
     end) 
end

SCHEDULER:New(nil,permanentPlayerCheck,{},1,1)
