-- templates
fighters = {"MIG25_T","MIG25_2","MIG31_T","MIG31_2","MIG23_T","MIG23_2","MIG21_T","MIG21_2","SU27_T","SU27_2","MIG29F"}
bombers = {"TU-22m3", "MIG27", "Bear","TU-22m3_2", "MIG27_2", "Bear_2","JF17","J11","MIG29AS","SU33-1"}

-- spawn zones (not currently used)

NSpawn = ZONE_POLYGON:New("NZone",GROUP:FindByName("NorthSpawnZone"))
CSpawn = ZONE_POLYGON:New("CZone",GROUP:FindByName("NorthSpawnZone2"))
ESpawn = ZONE_POLYGON:New("NZone",GROUP:FindByName("NorthSpawnZone3"))
Teddy = UNIT:FindByName("TDY")
Forrest = UNIT:FindByName("CVN74")
cvnfleet = GROUP:FindByName("CVN71")
texaco11spawn = SPAWN:New("Texaco11")
texaco11 = nil

cdactive = false
init = false
cdmaxwaves = 4
cdcurrentwave = 1
cdwavetime = 21
cdcwavetime = 21
cdwavereduction = 1
ctimer = nil
fighterspawns = {}
bomberspawns = {}
fightersnum = 0
bombernum = 0
IA1 = GROUP:FindByName("Inital Attacker")
IA2 = GROUP:FindByName("Inital Attacker2")
FA1 = GROUP:FindByName("MIG311")
FA2 = GROUP:FindByName("MIG312")

wincrease = nil
wdecrease = nil
tincrease = nil
tdecrease = nil

tdyhealthlast = 0
foresthealthlast = 0
cawacs = nil

function startawacs()
	if cawacs ~= nil then
		cawacs:Stop()
	end
	cawacs = RECOVERYTANKER:New(UNIT:FindByName("TDY"), "Darkstar")
	cawacs:SetAWACS(true,true)
	cawacs:SetCallsign(CALLSIGN.AWACS.Magic,1)
	cawacs:SetRespawnOn()
	cawacs:SetAltitude(26000)
	cawacs:SetRadio(250)
	cawacs:SetTakeoffCold()
	cawacs:SetTACAN(44,"MGK")
	cawacs:SetTakeoffAir()
	cawacs:SetSpeed(330)
	cawacs:Start()
end

Tanker = nil

function starttanker()
	if Tanker ~= nil then
		Tanker:Stop()
	end
	Tanker = RECOVERYTANKER:New(UNIT:FindByName("TDY"), "Shell")
	Tanker:SetCallsign(CALLSIGN.Tanker.Shell,1)
	Tanker:SetRespawnOn()
	Tanker:SetTakeoffAir()
	Tanker:SetSpeed(310)
	Tanker:SetRacetrackDistances(15,10)
	Tanker:SetPatternUpdateDistance(25)
	Tanker:SetRadio(255)
	Tanker:SetModex(911)
	Tanker:SetTACAN(9,"SHL")
	Tanker:Start()
end

function stoptanker()
	if Tanker ~= nil then
		Tanker:Stop()
	end
end

function stopawacs()
	if cawacs ~= nil then
		cawacs:Stop()
	end
end

cvnfleet:Activate()
cspawned = true



function checkcarriers()
	if cdactive == true then

		if Teddy:IsAlive() then
			local currentlife = Teddy:GetLifeRelative()
			if currentlife < tdyhealthlast then
				local clife = currentlife * 100
				MESSAGE:New("Warning, USS Theodore Roosevelt was damaged, if the Carrier is lost the mission will fail, carrier is at ".. clife .. "% health",60)
				hm("*Fleet Defender:* \n >  Warning, USS Theodore Roosevelt was damaged, if the Carrier is lost the mission will fail, carrier is at ".. clife .. "% health")
			end
			tdyhealthlast = currentlife
		else
			MESSAGE:New("Warning USS Theodore Roosevelt is dead, mission has failed",60)
			hm("*Fleet Defender:* \n > Ooops Some one Messed up, USS Theodore Roosevelt is dead, Mission failed")
			CarrierStop()
		end
		if Forrest:IsAlive() then
			local currentlife = Forrest:GetLifeRelative()
			if currentlife < foresthealthlast then
				local clife = currentlife * 100
				MESSAGE:New("Warning, USS Forrestal was damaged, if the Carrier is lost the mission will fail, carrier is at ".. clife .. "% health",60)
				hm("*Fleet Defender:* \n >  Warning, USS Forrestal was damaged, if the Carrier is lost the mission will fail, carrier is at ".. clife .. "% health")
			end
			tdyhealthlast = currentlife
		else
			MESSAGE:New("Warning USS Forrestal is dead, mission has failed",60)
			hm("*Fleet Defender:* \n > Ooops Some one Messed up, USS Forrestal is dead, Mission failed")
			CarrierStop()
		end
	end
end


function spawncarriers()
	
	cvnfleet:Respawn()
	cspawned = true
	cvnfleet:Activate()
	starttanker()
	startawacs()
	BASE:E({"Carrier Fleet, AWACS and Tanker Should all be respawning"})
	hm("*Fleet Defender:* \n > Carrier Fleet, AWACS and Tanker Should all be respawning")
end

function despawncarriers()
	if cdactive == false then
		lockallslots()
	end
	if cdactive == false and cspawned == true then
		cvnfleet:Destroy()
		stopawacs()
		stoptanker()
		BASE:E({"Carrier Fleet, AWACS and Tanker Should all be despawning"})
		hm("*Fleet Defender:* \n > Carrier Fleet, AWACS and Tanker Should all be despawning")
		cspawned = false
	end
end

function resetsqncount()
	turkey = 32
	eagle = 12
	mirage = 12
	tdyhornet = 36
	stnhornet = 36
	tdycat = 12
	stncat = 12
	tankers = 6
	awacs = 2
end




turkey = 32
eagle = 12
mirage = 12
tdyhornet = 36
stnhornet = 36
tdycat = 12
stncat = 12
tankers = 6
awacs = 2
Divider = 4
-- eventhandler

Slothandler = EVENTHANDLER:New() 
Slothandler:HandleEvent(EVENTS.Crash) -- watch for crash, ejection and pilot dead
Slothandler:HandleEvent(EVENTS.Ejection)
Slothandler:HandleEvent(EVENTS.PilotDead)
function hmfleet(msg)
	hm("*Fleet Defender:* > " .. msg .. " ") 
end
function slotlocker(EventData)
	if EventData.IniUnitName == "N CAP Hornet 403" then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
       stnhornet = stnhornet - 1
       if stnhornet < 0 then
        stnhornet = 0
       end
       trigger.action.setUserFlag(EventData.IniUnitName,100)
       MESSAGE:New("Lost Contact with Hornet Unit 403 Slot Locked until Restart Forrestal has " ..stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
	   hmfleet("Lost Contact with Hornet Unit 403 Slot Locked until Restart Forrestal has " ..stnhornet .. " Hornets remaining")
    end
  elseif EventData.IniUnitName == "N CAP Hornet 404" then
     if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Hornet Unit 404 Slot Locked until Restart Forrestal has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with Hornet Unit 404 Slot Locked until Restart Forrestal has " ..stnhornet .. " Hornets remaining")
     end
  elseif EventData.IniUnitName == "N CAP TomCat 303" then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stncat = stncat - 1
        if stncat < 0 then
          stncat = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Cat Unit 303 Slot Locked until Restart Forrestal has " .. stncat .. " Tomcats remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with Hornet Unit 303 Slot Locked until Restart Forrestal has " ..stncat .. " Tomcats remaining")
    end
  elseif EventData.IniUnitName == "N CAP TomCat 304" then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stncat = stncat - 1
        if stncat < 0 then
          stncat = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Cat Unit 304 Slot Locked until Forrestal has " .. stncat .. " Tomcats remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with Cat Unit 304 Slot Locked until Restart Forrestal has " ..stncat .. " Tomcats remaining")
    end
  elseif EventData.IniUnitName == "N ALERT Hornet 101" then
     if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Hornet Unit 101 Slot Locked until Restart Forrestal has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with Hornet Unit 101 Slot Locked until Restart Forrestal has " ..stnhornet .. " Hornets remaining")
     end
  elseif EventData.IniUnitName == "N ALERT Hornet 102" then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Hornet Unit 102 Slot Locked until Restart Forrestal  has ".. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with Hornet Unit 102 Slot Locked until Restart Forrestal has " ..stnhornet .. " Hornets remaining")
    end
  elseif EventData.IniUnitName == "N ALERT TomCat 91" then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stncat = stncat - 1
        if stncat < 0 then
          stncat = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Hornet Unit 91 Slot Locked until Restart Forrestal has ".. stncat .." Tomcats remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with Tom Cat Unit 91 Slot Locked until Restart Forrestal has " ..stncat .. " Tomcats remaining")
    end
  elseif EventData.IniUnitName == "N ALERT TomCat 92" then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stncat = stncat - 1
        if stncat < 0 then
          stncat = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Hornet Unit 304 Slot Locked until Restart Forrestal has ".. stncat .. " Tomcats remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with Hornet Unit 304 Slot Locked until Restart Forrestal has " ..stncat .. " Tomcats remaining")
    end
  elseif EventData.IniUnitName == "SC ALERT Hornet 201" then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Hornet Unit 201 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with Hornet Unit 201 Slot Locked until Restart Teddy has " ..tdyhornet .. " Hornets remaining")
    end
  elseif EventData.IniUnitName == "SC ALERT Hornet 202" then
     if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Hornet Unit 202 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with Hornet Unit 202 Slot Locked until Restart Teddy has " ..tdyhornet .. " Hornets remaining")
    end
  elseif EventData.IniUnitName == "SC ALERT TomCat 81" then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdycat = tdycat - 1
        if tdycat < 0 then
          tdycat = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Cat Unit 081 Slot Locked until Restart Teddy has " .. tdycat .. " Tomcats remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with cat Unit 081 Slot Locked until Restart Teddy has " ..tdycat .. " Cats remaining")
    end  
  elseif EventData.IniUnitName == "SC ALERT TomCat 82" then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdycat = tdycat - 1
        if tdycat < 0 then
          tdycat = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Cat Unit 082 Slot Locked until Restart Teddy has " .. tdycat .. " Tomcats remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with Cat Unit 082 Slot Locked until Restart Teddy has " ..tdycat .. " Cats remaining")
    end
  elseif EventData.IniUnitName == "SC CAP TomCat 301" then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdycat = tdycat - 1
        if tdycat < 0 then
          tdycat = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Cat Unit 301 Slot Locked until Restart Teddy has " .. tdycat .. " Tomcats remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with cat Unit 301 Slot Locked until Restart Teddy has " ..tdycat .. " Cats remaining")
    end
  elseif EventData.IniUnitName == "SC CAP TomCat 302" then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdycat = tdycat - 1
        if tdycat < 0 then
          tdycat = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Cat Unit 302 Slot Locked until Restart Teddy has " .. tdycat .. " Tomcats remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with cat Unit 302 Slot Locked until Restart Teddy has " ..tdycat .. " Cats remaining")
    end
  elseif EventData.IniUnitName == "SC CAP Hornet 401" then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Hornet Unit 401 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with cat Unit 401 Slot Locked until Restart Teddy has " ..tdyhornet .. " hornets remaining")
    end
  elseif EventData.IniUnitName == "SC CAP Hornet 402" then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        MESSAGE:New("Lost Contact with Hornet Unit 402 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
		hmfleet("Lost Contact with Hornet Unit 402 Slot Locked until Restart Teddy has " ..tdyhornet .. " hornet remaining")
    end
   elseif EventData.IniUnitName == "Turkey-16-1" then
		 if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
			trigger.action.setUserFlag(EventData.IniUnitName,100)
			MESSAGE:New("Lost Contact with Viper Unit Turkey 16-1, slot locked for 60 seconds",30):ToAll()
			turkey = turkey - 1
			if turkey > 0 then
				SCHEDULER:New(nil,function()
					MESSAGE:New("Viper Unit Turkey 16-1 is now unlocked, we have ".. turkey .. "F16's remaining",30,"RIPCORD"):ToAll()
					trigger.action.setUserFlag(EventData.IniUnitName,00)
				end,{},60)
			else
					MESSAGE:New("No Turkish Vipers remain! Slot will remain locked.",30,"RIPCORD"):ToAll()
			end
		 end
	elseif EventData.IniUnitName == "Turkey-16-2" then
		 if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
			trigger.action.setUserFlag(EventData.IniUnitName,100)
			MESSAGE:New("Lost Contact with Viper Unit Turkey 16-2, slot locked for 60 seconds",30):ToAll()
			turkey = turkey - 1
			if turkey > 0 then
				SCHEDULER:New(nil,function()
					MESSAGE:New("Viper Unit Turkey 16-2 is now unlocked",30,"RIPCORD"):ToAll()
					trigger.action.setUserFlag(EventData.IniUnitName,00)
				end,{},60)
			else
				MESSAGE:New("No Turkish Vipers remain! Slot will remain locked.",30,"RIPCORD"):ToAll()
			end
		 end
	elseif EventData.IniUnitName == "Turkey-15-1" then
		 if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
			trigger.action.setUserFlag(EventData.IniUnitName,100)
			MESSAGE:New("Lost Contact with Eagle Unit Turkey 15-1, slot locked for 60 seconds",30):ToAll()
			turkey = turkey - 1
			if turkey > 0 then
				SCHEDULER:New(nil,function()
					MESSAGE:New("Eagle Unit Turkey 15-1 is now unlocked",30,"RIPCORD"):ToAll()
					trigger.action.setUserFlag(EventData.IniUnitName,00)
				end,{},60)
			else
				MESSAGE:New("No Turkish Eagles remain! Slot will remain locked.",30,"RIPCORD"):ToAll()
			end
		 end
	elseif EventData.IniUnitName == "Turkey-15-2" then
		 if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
			trigger.action.setUserFlag(EventData.IniUnitName,100)
			MESSAGE:New("Lost Contact with Eagle Unit Turkey 15-2, slot locked for 60 seconds",30):ToAll()
			turkey = turkey - 1
			if turkey > 0 then
				SCHEDULER:New(nil,function()
					MESSAGE:New("Eagle Unit Turkey 15-2 is now unlocked",30,"RIPCORD"):ToAll()
					trigger.action.setUserFlag(EventData.IniUnitName,00)
				end,{},60)
			else
				MESSAGE:New("No Turkish Eagles remain! Slot will remain locked.",30,"RIPCORD"):ToAll()
			end
		 end
	elseif EventData.IniUnitName == "Turkey-m2000-1" then
		 if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
			trigger.action.setUserFlag(EventData.IniUnitName,100)
			MESSAGE:New("Lost Contact with Turkey Unit M2000-1, slot locked for 60 seconds",30):ToAll()
			turkey = turkey - 1
			if turkey > 0 then
				SCHEDULER:New(nil,function()
					MESSAGE:New("Mirage Unit Turkey-m2000-1 is now unlocked",30,"RIPCORD"):ToAll()
					trigger.action.setUserFlag(EventData.IniUnitName,00)
				end,{},60)
			else
				MESSAGE:New("No Turkish Mirages remain! Slot will remain locked.",30,"RIPCORD"):ToAll()			
			end
		 end
	elseif EventData.IniUnitName == "Turkey-m2000-2" then
		 if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
			trigger.action.setUserFlag(EventData.IniUnitName,100)
			MESSAGE:New("Lost Contact with Turkey Unit M2000-2, slot locked for 60 seconds",30):ToAll()
			turkey = turkey - 1
			if turkey > 0 then
				SCHEDULER:New(nil,function()
					MESSAGE:New("Mirage Unit Turkey-m2000-2 is now unlocked",30,"RIPCORD"):ToAll()
					trigger.action.setUserFlag(EventData.IniUnitName,00)
				end,{},60)
			else
				MESSAGE:New("No Turkish Mirages remain! Slot will remain locked.",30,"RIPCORD"):ToAll()
			end
		 end
	elseif EventData.IniUnitName == "Turkey-JF17" then
		 if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
			trigger.action.setUserFlag(EventData.IniUnitName,100)
			MESSAGE:New("Lost Contact with Turkey Unit Turkey-JF17, slot locked for 60 seconds",30):ToAll()
			turkey = turkey - 1
			if turkey > 0 then
				SCHEDULER:New(nil,function()
					MESSAGE:New("JF17 Unit Turkey-JF17 is now unlocked",30,"RIPCORD"):ToAll()
					trigger.action.setUserFlag(EventData.IniUnitName,00)
				end,{},60)
			else
				MESSAGE:New("No Turkish JF17s remain! Slot will remain locked.",30,"RIPCORD"):ToAll()
			end
		 end
	elseif EventData.IniUnitName == "Turkey-JF17-1" then
		 if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
			trigger.action.setUserFlag(EventData.IniUnitName,100)
			MESSAGE:New("Lost Contact with Turkey Unit Turkey-JF17-1, slot locked for 60 seconds",30):ToAll()
			turkey = turkey - 1
			if turkey > 0 then
				SCHEDULER:New(nil,function()
					MESSAGE:New("JF17 Unit Turkey-JF17-1 is now unlocked",30,"RIPCORD"):ToAll()
					trigger.action.setUserFlag(EventData.IniUnitName,00)
				end,{},60)
			else
				MESSAGE:New("No Turkish JF17s remain! Slot will remain locked.",30,"RIPCORD"):ToAll()
			end
		 end
	elseif EventData.IniUnitName == "SC RAMP Hornet 31" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 31 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
		  hmfleet("Lost Contact with Hornet Unit 31 Slot Locked until Restart Teddy has " ..tdyhornet .. " hornets remaining")
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 31 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
		  hmfleet("Lost Contact with Hornet Unit 31 Slot Locked until Restart Teddy has " ..tdyhornet .. " hornets remaining")
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 31 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
      end
     elseif EventData.IniUnitName == "SC RAMP Hornet 32" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 32 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 32 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 32 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
      end
    elseif EventData.IniUnitName == "SC RAMP Hornet 33" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 33 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 33 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 33 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
      end
     elseif EventData.IniUnitName == "SC RAMP Hornet 34" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 34 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 34 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 34 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
      end
    elseif EventData.IniUnitName == "SC RAMP Hornet 41" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 41 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 41 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 41 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end 
   elseif EventData.IniUnitName == "SC RAMP Hornet 42" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 42 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 42 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 42 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},60)
        end
     end 
   elseif EventData.IniUnitName == "SC RAMP Hornet 43" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 43 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 43 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 43 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end 
   elseif EventData.IniUnitName == "SC RAMP Hornet 44" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 44 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 44 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 44 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end 
    elseif EventData.IniUnitName == "SC RAMP Hornet 51" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 51 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 51 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 51 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end 
	 elseif EventData.IniUnitName == "SC RAMP Hornet 52" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 52 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 52 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 52 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end  
	 elseif EventData.IniUnitName == "SC RAMP Hornet 53" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 53 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 53 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 51 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end 
	  elseif EventData.IniUnitName == "SC RAMP Hornet 54" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 54 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 54 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 54 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end 
	  elseif EventData.IniUnitName == "SC RAMP Hornet 55" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 55 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 55 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 55 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end 
	 elseif EventData.IniUnitName == "SC RAMP Hornet 56" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 56 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 56 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 56 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end 
	  elseif EventData.IniUnitName == "SC RAMP Hornet 57" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 57 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 57 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 57 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end 
	 elseif EventData.IniUnitName == "SC RAMP Hornet 58" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdyhornet = tdyhornet - 1
        if tdyhornet < 0 then
          tdyhornet = 0
        end
        if tdyhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 58 Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 58 Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 58 Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end 
   elseif EventData.IniUnitName == "SC RAMP Tomcat 10" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdycat = tdycat - 1
        if tdycat < 0 then
          tdycat = 0
        end
        if tdycat == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 10 Slot Locked until Restart Teddy has " .. tdycat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 10 Slot Locked for 15 seconds Teddy has " .. tdycat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("TomCat Unit 10 Slot UnLocked Teddy has " .. tdycat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end 
   elseif EventData.IniUnitName == "SC RAMP Tomcat 11" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdycat = tdycat - 1
        if tdycat < 0 then
          tdycat = 0
        end
        if tdycat == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 11 Slot Locked until Restart Teddy has " .. tdycat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 11 Slot Locked for 15 seconds Teddy has " .. tdycat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("TomCat Unit 11 Slot UnLocked Teddy has " .. tdycat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end
   elseif EventData.IniUnitName == "SC RAMP Tomcat 12" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdycat = tdycat - 1
        if tdycat < 0 then
          tdycat = 0
        end
        if tdycat == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 12 Slot Locked until Restart Teddy has " .. tdycat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 12 Slot Locked for 15 seconds Teddy has " .. tdycat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("TomCat Unit 12 Slot UnLocked Teddy has " .. tdycat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end
   elseif EventData.IniUnitName == "SC RAMP Tomcat 13" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        tdycat = tdycat - 1
        if tdycat < 0 then
          tdycat = 0
        end
        if tdycat == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 13 Slot Locked until Restart Teddy has " .. tdycat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 13 Slot Locked for 15 seconds Teddy has " .. tdycat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("TomCat Unit 13 Slot UnLocked Teddy has " .. tdycat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end
   elseif EventData.IniUnitName == "N RAMP Hornet 61" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        if stnhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 61 Slot Locked until Restart Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 61 Slot Locked for 15 seconds Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 61 Slot UnLocked Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end
   elseif EventData.IniUnitName == "N RAMP Hornet 62" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        if stnhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 62 Slot Locked until Restart Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 62 Slot Locked for 15 seconds Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 62 Slot UnLocked Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end
   elseif EventData.IniUnitName == "N RAMP Hornet 63" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        if stnhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 63 Slot Locked until Restart Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 63 Slot Locked for 15 seconds Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 63 Slot UnLocked Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end
   elseif EventData.IniUnitName == "N RAMP Hornet 64" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        if stnhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 64 Slot Locked until Restart Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 64 Slot Locked for 15 seconds Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 64 Slot UnLocked Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end
	elseif EventData.IniUnitName == "N RAMP Hornet 65" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        if stnhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 65 Slot Locked until Restart Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 65 Slot Locked for 15 seconds Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 65 Slot UnLocked Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end	 
    elseif EventData.IniUnitName == "N RAMP Hornet 66" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        if stnhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 66 Slot Locked until Restart Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 66 Slot Locked for 15 seconds Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 66 Slot UnLocked Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end
	 elseif EventData.IniUnitName == "N RAMP Hornet 67" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        if stnhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 67 Slot Locked until Restart Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 67 Slot Locked for 15 seconds Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 67 Slot UnLocked Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end 
	 elseif EventData.IniUnitName == "N RAMP Hornet 68" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        if stnhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 68 Slot Locked until Restart Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 68 Slot Locked for 15 seconds Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 68 Slot UnLocked Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end 
	 elseif EventData.IniUnitName == "N RAMP Hornet 69" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        if stnhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 69 Slot Locked until Restart Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 69 Slot Locked for 15 seconds Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 69 Slot UnLocked Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end 
 elseif EventData.IniUnitName == "N RAMP Hornet 70" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        if stnhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 70 Slot Locked until Restart Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 70 Slot Locked for 15 seconds Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 70 Slot UnLocked Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end	 
    elseif EventData.IniUnitName == "N RAMP Hornet 71" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        if stnhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 71 Slot Locked until Restart Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 71 Slot Locked for 15 seconds Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 71 Slot UnLocked Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end
	elseif EventData.IniUnitName == "N RAMP Hornet 72" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stnhornet = stnhornet - 1
        if stnhornet < 0 then
          stnhornet = 0
        end
        if stnhornet == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 72 Slot Locked until Restart Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with Hornet Unit 72 Slot Locked for 15 seconds Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("Hornet Unit 72 Slot UnLocked Stennis has " .. stnhornet .. " Hornets remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end	 
   elseif EventData.IniUnitName == "N RAMP TomCat 21" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stncat = stncat - 1
        if stncat < 0 then
          stncat = 0
        end
        if stncat == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 21 Slot Locked until Restart Stennis has " .. stncat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 21 Slot Locked for 15 seconds Stennis has " .. stncat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("TomCat Unit 21 Slot UnLocked Stennis has " .. stncat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end
   elseif EventData.IniUnitName == "N RAMP TomCat 22" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stncat = stncat - 1
        if stncat < 0 then
          stncat = 0
        end
        if stncat == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 22 Slot Locked until Restart Stennis has " .. stncat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 22 Slot Locked for 15 seconds Stennis has " .. stncat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("TomCat Unit 22 Slot UnLocked Stennis has " .. stncat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end
   elseif EventData.IniUnitName == "N RAMP TomCat 23" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stncat = stncat - 1
        if stncat < 0 then
          stncat = 0
        end
        if stncat == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 23 Slot Locked until Restart Stennis has " .. stncat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 23 Slot Locked for 15 seconds Stennis has " .. stncat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("TomCat Unit 23 Slot UnLocked Stennis has " .. stncat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end
   elseif EventData.IniUnitName == "N RAMP TomCat 24" then
      if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
        stncat = stncat - 1
        if stncat < 0 then
          stncat = 0
        end
        if stncat == 0 then
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 24 Slot Locked until Restart Stennis has " .. stncat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
        else
          trigger.action.setUserFlag(EventData.IniUnitName,100)
          MESSAGE:New("Lost Contact with TomCat Unit 24 Slot Locked for 15 seconds Stennis has " .. stncat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
          SCHEDULER:New(nil,function() 
            MESSAGE:New("TomCat Unit 24 Slot UnLocked Stennis has " .. stncat .. " TomCats remaining",30,"RIPCORD",true):ToAll()
            trigger.action.setUserFlag(EventData.IniUnitName,00)
          end,{},15)
        end
     end
   end 
end


function Slothandler:OnEventPilotDead(EventData)
  BASE:E({EventData})
  -- Lock that unit out so it can no longer be used.
  BASE:E({EventData.IniUnitName,"Pilot Dead"})
  slotlocker(EventData)
end

function Slothandler:OnEventCrash(EventData)
  BASE:E({EventData})
  -- Lock that unit out so it can no longer be used.
  BASE:E({EventData.IniUnitName,"Crash"})
  slotlocker(EventData)
 end

function Slothandler:OnEventEjection(EventData)
  BASE:E({EventData})
  -- Lock that unit out so it can no longer be used.
  BASE:E({EventData.IniUnitName,"Ejection"})
  slotlocker(EventData)
end



function CarrierStart()
  if texaco11 ~= nil then
    texaco11:Destroy()
  end
  spawncarriers()
  texaco11 = texaco11spawn:Spawn()
  fightersnum = 0
  bombernum = 0
  resetsqncount()
  cdcwavetime = cdwavetime
  mmenu1a:Remove()
  mmenu1a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Stop",mmenu,CarrierStart,{})  
  MESSAGE:New("WARNING! Carrier Defence Mission will begin in 2 MINUTES, CAP & Turkey Slots Unlocked \n Alert & Non Alert Slots Unlock in 2 minutes",60,"RipCord"):ToAll()
  hmfleet("Carrier Defence Mission will begin in 2 minutes, CAP slots unlocked. \n Alert and Non Alert Slots Unlock in 2 minutes")
  MESSAGE:New("Carrier Air Wing Status \n CVN 71 Theodore Roosevelt \n Hornet: ".. tdyhornet .." Airframes \n TomCat: "..tdycat.." \n USS Forrestal \n Hornet: ".. stnhornet .." Airframes \n TomCat: "..stncat.."",60,"RipCord"):ToAll()
  hmfleet("Carrier Air Wing Status \n CVN 71 Theodore Roosevelt \n Hornet: ".. tdyhornet .." Airframes \n TomCat: "..tdycat.." \n USS Forrestal \n Hornet: ".. stnhornet .." Airframes \n TomCat: "..stncat.."")
  
  MESSAGE:New("Destruction of Airframes will result in loses, if you have 0 left then you will no longer be able to spawn",60,"RipCord"):ToAll()
  hmfleet("Destruction of Airframes will result in loses, if you have 0 left you will no longer be able to spawn")
  
  IA1:Activate()
  IA2:Activate()
  FA1:Activate()
  FA2:Activate()
  BASE:E({"Unlocking Cap Slots"})
  trigger.action.setUserFlag("N CAP Hornet 403",00)
  trigger.action.setUserFlag("N CAP Hornet 404",00)
  trigger.action.setUserFlag("N CAP TomCat 303",00)
  trigger.action.setUserFlag("N CAP TomCat 304",00)
  trigger.action.setUserFlag("SC CAP Hornet 401",00)
  trigger.action.setUserFlag("SC CAP Hornet 402",00)
  trigger.action.setUserFlag("SC CAP TomCat 301",00)
  trigger.action.setUserFlag("SC CAP TomCat 302",00)
  trigger.action.setUserFlag("Turkey-16-1",00)
  trigger.action.setUserFlag("Turkey-16-2",00)
  trigger.action.setUserFlag("Turkey-15-1",00)
  trigger.action.setUserFlag("Turkey-15-2",00)
  trigger.action.setUserFlag("Turkey-m2000-1",00)
  trigger.action.setUserFlag("Turkey-m2000-2",00)
  BASE:E({"locking Alert Slots"})
  trigger.action.setUserFlag("N ALERT Hornet 101",100)
  trigger.action.setUserFlag("N ALERT Hornet 102",100)
  trigger.action.setUserFlag("N ALERT TomCat 91",100)
  trigger.action.setUserFlag("N ALERT TomCat 92",100)
  trigger.action.setUserFlag("SC ALERT Hornet 201",100)
  trigger.action.setUserFlag("SC ALERT Hornet 202",100)
  trigger.action.setUserFlag("SC ALERT TomCat 81",100)
  trigger.action.setUserFlag("SC ALERT TomCat 82",100)
  BASE:E({"Locking Other Slots"})
  trigger.action.setUserFlag("N RAMP Hornet 61",100)
  trigger.action.setUserFlag("N RAMP Hornet 62",100)
  trigger.action.setUserFlag("N RAMP Hornet 63",100)
  trigger.action.setUserFlag("N RAMP Hornet 64",100)
  trigger.action.setUserFlag("N RAMP TomCat 21",100)
  trigger.action.setUserFlag("N RAMP TomCat 22",100)
  trigger.action.setUserFlag("N RAMP TomCat 23",100)
  trigger.action.setUserFlag("N RAMP TomCat 24",100)
  trigger.action.setUserFlag("SC RAMP Hornet 31",100)
  trigger.action.setUserFlag("SC RAMP Hornet 32",100)
  trigger.action.setUserFlag("SC RAMP Hornet 33",100)
  trigger.action.setUserFlag("SC RAMP Hornet 34",100)
  trigger.action.setUserFlag("SC RAMP Hornet 41",100)
  trigger.action.setUserFlag("SC RAMP Hornet 42",100)
  trigger.action.setUserFlag("SC RAMP Hornet 43",100)
  trigger.action.setUserFlag("SC RAMP Hornet 44",100)
  trigger.action.setUserFlag("SC RAMP Hornet 51",100)
	trigger.action.setUserFlag("SC RAMP Hornet 52",100)
	trigger.action.setUserFlag("SC RAMP Hornet 53",100)
	trigger.action.setUserFlag("SC RAMP Hornet 54",100)
	trigger.action.setUserFlag("SC RAMP Hornet 55",100)
	trigger.action.setUserFlag("SC RAMP Hornet 56",100)
	trigger.action.setUserFlag("SC RAMP Hornet 57",100)
	trigger.action.setUserFlag("SC RAMP Hornet 58",100)
	trigger.action.setUserFlag("SC RAMP TomCat 10",100)
	trigger.action.setUserFlag("SC RAMP TomCat 11",100)
	trigger.action.setUserFlag("SC RAMP TomCat 12",100)
	trigger.action.setUserFlag("SC RAMP TomCat 13",100)
  trigger.action.setUserFlag("SC RAMP TomCat 10",100)
  trigger.action.setUserFlag("SC RAMP TomCat 11",100)
  trigger.action.setUserFlag("SC RAMP TomCat 12",100)
  trigger.action.setUserFlag("SC RAMP TomCat 13",100)
  mtimer = SCHEDULER:New(nil,function()
	trigger.action.setUserFlag("N ALERT Hornet 101",00)
    trigger.action.setUserFlag("N ALERT Hornet 102",00)
    trigger.action.setUserFlag("N ALERT TomCat 91",00)
    trigger.action.setUserFlag("N ALERT TomCat 92",00)
    trigger.action.setUserFlag("SC ALERT Hornet 201",00)
    trigger.action.setUserFlag("SC ALERT Hornet 202",00)
    trigger.action.setUserFlag("SC ALERT TomCat 81",00)
    trigger.action.setUserFlag("SC ALERT TomCat 82",00)
    MESSAGE:New("Alert Slots Are now active",30)
	hmfleet("Alert Slots are now active")
  end,{},60)
  ctimer = SCHEDULER:New(nil,function() 
    BASE:E({"Unlocking Alert Slots"})
    BASE:E({"Unlocking Other Slots Slots"})
    trigger.action.setUserFlag("N RAMP Hornet 61",00)
    trigger.action.setUserFlag("N RAMP Hornet 62",00)
    trigger.action.setUserFlag("N RAMP Hornet 63",00)
    trigger.action.setUserFlag("N RAMP Hornet 64",00)
	trigger.action.setUserFlag("N RAMP Hornet 65",00)
	trigger.action.setUserFlag("N RAMP Hornet 66",00)
	trigger.action.setUserFlag("N RAMP Hornet 67",00)
	trigger.action.setUserFlag("N RAMP Hornet 68",00)
	trigger.action.setUserFlag("N RAMP Hornet 69",00)
	trigger.action.setUserFlag("N RAMP Hornet 70",00)
	trigger.action.setUserFlag("N RAMP Hornet 71",00)
	trigger.action.setUserFlag("N RAMP Hornet 72",00)
    trigger.action.setUserFlag("N RAMP TomCat 21",00)
    trigger.action.setUserFlag("N RAMP TomCat 22",00)
    trigger.action.setUserFlag("N RAMP TomCat 23",00)
    trigger.action.setUserFlag("N RAMP TomCat 24",00)
    trigger.action.setUserFlag("SC RAMP Hornet 31",00)
    trigger.action.setUserFlag("SC RAMP Hornet 32",00)
    trigger.action.setUserFlag("SC RAMP Hornet 33",00)
    trigger.action.setUserFlag("SC RAMP Hornet 34",00)
    trigger.action.setUserFlag("SC RAMP Hornet 41",00)
    trigger.action.setUserFlag("SC RAMP Hornet 42",00)
    trigger.action.setUserFlag("SC RAMP Hornet 43",00)
    trigger.action.setUserFlag("SC RAMP Hornet 44",00)
	trigger.action.setUserFlag("SC RAMP Hornet 51",00)
	trigger.action.setUserFlag("SC RAMP Hornet 52",00)
	trigger.action.setUserFlag("SC RAMP Hornet 53",00)
	trigger.action.setUserFlag("SC RAMP Hornet 54",00)
	trigger.action.setUserFlag("SC RAMP Hornet 55",00)
	trigger.action.setUserFlag("SC RAMP Hornet 56",00)
	trigger.action.setUserFlag("SC RAMP Hornet 57",00)
	trigger.action.setUserFlag("SC RAMP Hornet 58",00)
	trigger.action.setUserFlag("SC RAMP TomCat 10",100)
	trigger.action.setUserFlag("SC RAMP TomCat 11",100)
	trigger.action.setUserFlag("SC RAMP TomCat 12",100)
	trigger.action.setUserFlag("SC RAMP TomCat 13",100)
    trigger.action.setUserFlag("SC RAMP TomCat 10",00)
    trigger.action.setUserFlag("SC RAMP TomCat 11",00)
    trigger.action.setUserFlag("SC RAMP TomCat 12",00)
    trigger.action.setUserFlag("SC RAMP TomCat 13",00)
    MESSAGE:New("Non-Alert Slots Are now active",30):ToAll()
	hmfleet("Non-Alert Slots are now active")
    BASE:E({"Slots Unlocked Starting Mission"})
    cdactive = true
    for i = 1, 6, 1
    do
      local s = math.random(1,2)
      if s == 1 then
        spawnrandombomber()
      else
        spawnrandomfighter()
      end
    end
    BASE:E({bombernum,fightersnum})
    init = true
    cdcurrentwave = cdcurrentwave + 1
    mmenu1a:Remove()
    mmenu1a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Stop",mmenu,CarrierStop,{})
    if cdcurrentwave > cdmaxwaves then
      MESSAGE:New("Max Waves of " .. cdmaxwaves .. " Reached Stopping Mission",30):ToAll()
	  hmfleet("Max Waves of " .. cdmaxwaves .. " Reached Stopping Mission")
      CarrierStop()
    else
      MESSAGE:New("next Wave " .. cdcurrentwave .. " of " .. cdmaxwaves .." will start in " .. cdwavetime .. " minutes",30):ToAll()
      ctimer = SCHEDULER:New(nil,nwave,{},(cdcwavetime*60))
    end
  end,{},(60*2))
end
function lockallslots()
 if cdactive == false then
	trigger.action.setUserFlag("N CAP Hornet 403",100)
	trigger.action.setUserFlag("N CAP Hornet 404",100)
	trigger.action.setUserFlag("N CAP TomCat 303",100)
	trigger.action.setUserFlag("N CAP TomCat 304",100)
	trigger.action.setUserFlag("SC CAP Hornet 401",100)
	trigger.action.setUserFlag("SC CAP Hornet 402",100)
	trigger.action.setUserFlag("SC CAP TomCat 301",100)
	trigger.action.setUserFlag("SC CAP TomCat 302",100)
	BASE:E({"locking Alert Slots"})
	trigger.action.setUserFlag("N ALERT Hornet 101",100)
	trigger.action.setUserFlag("N ALERT Hornet 102",100)
	trigger.action.setUserFlag("N ALERT TomCat 91",100)
	trigger.action.setUserFlag("N ALERT TomCat 92",100)
	trigger.action.setUserFlag("SC ALERT Hornet 201",100)
	trigger.action.setUserFlag("SC ALERT Hornet 202",100)
	trigger.action.setUserFlag("SC ALERT TomCat 81",100)
	trigger.action.setUserFlag("SC ALERT TomCat 82",100)
	BASE:E({"Locking Other Slots"})
	trigger.action.setUserFlag("N RAMP Hornet 61",100)
	trigger.action.setUserFlag("N RAMP Hornet 62",100)
	trigger.action.setUserFlag("N RAMP Hornet 63",100)
	trigger.action.setUserFlag("N RAMP Hornet 64",100)
	trigger.action.setUserFlag("N RAMP Hornet 65",100)
	trigger.action.setUserFlag("N RAMP Hornet 66",100)
	trigger.action.setUserFlag("N RAMP Hornet 67",100)
	trigger.action.setUserFlag("N RAMP Hornet 68",100)
	trigger.action.setUserFlag("N RAMP Hornet 69",100)
	trigger.action.setUserFlag("N RAMP Hornet 70",100)
	trigger.action.setUserFlag("N RAMP Hornet 71",100)
	trigger.action.setUserFlag("N RAMP Hornet 72",100)
	trigger.action.setUserFlag("N RAMP TomCat 21",100)
	trigger.action.setUserFlag("N RAMP TomCat 22",100)
	trigger.action.setUserFlag("N RAMP TomCat 23",100)
	trigger.action.setUserFlag("N RAMP TomCat 24",100)
	trigger.action.setUserFlag("SC RAMP Hornet 31",100)
	trigger.action.setUserFlag("SC RAMP Hornet 32",100)
	trigger.action.setUserFlag("SC RAMP Hornet 33",100)
	trigger.action.setUserFlag("SC RAMP Hornet 34",100)
	trigger.action.setUserFlag("SC RAMP Hornet 41",100)
	trigger.action.setUserFlag("SC RAMP Hornet 42",100)
	trigger.action.setUserFlag("SC RAMP Hornet 43",100)
	trigger.action.setUserFlag("SC RAMP Hornet 44",100)
	trigger.action.setUserFlag("SC RAMP Hornet 51",100)
	trigger.action.setUserFlag("SC RAMP Hornet 52",100)
	trigger.action.setUserFlag("SC RAMP Hornet 53",100)
	trigger.action.setUserFlag("SC RAMP Hornet 54",100)
	trigger.action.setUserFlag("SC RAMP Hornet 55",100)
	trigger.action.setUserFlag("SC RAMP Hornet 56",100)
	trigger.action.setUserFlag("SC RAMP Hornet 57",100)
	trigger.action.setUserFlag("SC RAMP Hornet 58",100)
	trigger.action.setUserFlag("SC RAMP TomCat 10",100)
	trigger.action.setUserFlag("SC RAMP TomCat 11",100)
	trigger.action.setUserFlag("SC RAMP TomCat 12",100)
	trigger.action.setUserFlag("SC RAMP TomCat 13",100)
	trigger.action.setUserFlag("Turkey-16-1",100)
	trigger.action.setUserFlag("Turkey-16-2",100)
	trigger.action.setUserFlag("Turkey-15-1",100)
	trigger.action.setUserFlag("Turkey-15-2",100)
	trigger.action.setUserFlag("Turkey-m2000-1",100)
	trigger.action.setUserFlag("Turkey-m2000-2",100)
	BASE:E({"ALL SLOTS SHOULD BE LOCKED"})
	MESSAGE:New("All Non Set up Slots are Locked",30):ToAll()
	hmfleet("All non set up Slots should now be locked out")
	else
		BASE:E({"Lock Out was scheduled but we are active, not locking out"})
	end
end
function CarrierStop()
  BASE:E({"Carrier Stop Called"})
  MESSAGE:New("Stopping Carrier Defence Mission At this time, Removing all Spawns \n Carrier will despawn in 15 minutes & All Slots will lock unless a new round is started.",30):ToAll()
  hmfleet("Stopping Defence Mission at this time, removing all spawns")
  hmfleet("Carrier will despawn in 15 minutes unless a new round is started")
  if texaco11 ~= nil then
     BASE:E({"Texaco Destroyed"})
	texaco11:Destroy()
  end
  ctimer:Stop()
  SCHEDULER:New(nil,despawncarriers,{},(60*15))
  BASE:E({"SCHEDULERS SHOULD BE STOPPED"})
  init = false
  cdactive = false
  cdcwavetime = cdwavetime
  cdcurrentwave = 1
  IA1:Destroy()
  IA2:Destroy()
  FA1:Destroy()
  FA2:Destroy()
  for k,v in pairs (fighterspawns) do
      if v:IsAlive() == true then
        v:Destroy()
      end
  end
  fighterspawns = {}
  for k,v in pairs (bomberspawns) do
    if v:IsAlive() == true then
      v:Destroy()
    end
  end
  BASE:E({"ALL SPAWNS SHOULD BE DEAD"})
  MESSAGE:New("All Spawns Should Be destroyed, Now Locking Slots",30):ToAll()
  hmfleet("All Wave Spawns Should now be destroyed")
  
  mmenu1a:Remove()
  mmenu1a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Start",mmenu,CarrierStart,{})
  BASE:E({"START MENU SHOULD BE BACK, STOP COMPLETED"})
end

function nwave()
  BASE:E({"nextwave called"})
  nextwave()
end

function nextwave()
  BASE:E({"Inside Nextwave"})
  cdcurrentwave = cdcurrentwave + 1
  cdcwavetime = cdcwavetime - cdwavereduction
  if cdcwavetime < 5 then
    cdcwavetime = 5
  end
    BASE:E({"Updating Fighter list",fightersnum})
    local ftemp = {}
    for k,v in pairs (fighterspawns) do
      if v:IsAlive() ~= true then
        BASE:E("fighter was not alive removing from the list")
        fightersnum = fightersnum - 1
        if fightersnum < 0 then 
          fightersnum = 0
        end
      else
        if v:AllOnGround() == true then
          v:Destroy()
          BASE:E("fighters were on the ground")
          fightersnum = fightersnum - 1
          if fightersnum < 0 then 
            fightersnum = 0
          end
        else
          BASE:E("fighter was alive moving to the temp list")
          table.insert(ftemp,v)
        end
      end
    end
    BASE:E({"fighters are all done updating fighter spawn list with temp list",fightersnum})
    fighterspawns = ftemp
    BASE:E({"Updating Bomber list",bombernum})
    local btemp = {}
    for k,v in pairs (bomberspawns) do
      if v:IsAlive() ~= true then
        BASE:E("bomber was not alive removing from the list")
        bombernum = bombernum - 1
        if bombernum < 0 then 
          bombernum = 0
        end
      else
        if v:AllOnGround() == true then
          v:Destroy()
          BASE:E("fighters were on the ground")
          fightersnum = fightersnum - 1
          if fightersnum < 0 then 
            fightersnum = 0
          end
        else
          BASE:E("bomber was alive moving to the temp list")
          table.insert(btemp,v)
        end
      end
    end
    BASE:E({"Bombers list done, updating spawn list with new data",bombernum})
    bomberspawns = btemp
    BASE:E({"Spawning New Fighters balive is:",balive})
    local snumber = (balive + cdcurrentwave)
    snumber = snumber / Divider
    snumber = math.floor(snumber)
    if snumber < cdcurrentwave then 
      snumber = cdcurrentwave
    end
    local temp = 1
    if balive < 0 then
      temp = 1
    else
      temp = balive / Divider
    end
    temp = math.floor(temp)
    if temp < 1 then
      temp = 1
    end
    snumber = math.random(temp,snumber)
    BASE:E({"Fighter SpawnTime snumber is:",snumber})
    for i = 1, snumber, 1 do
     spawnrandomfighter()
    end
	
	-- BOMBER SPAWNS
    local snumber = (balive + cdcurrentwave)
    snumber = snumber / Divider
    snumber = math.floor(snumber)
    if snumber < cdcurrentwave then 
      snumber = cdcurrentwave
    end
    local temp = 1
    if balive < 0 then
      temp = 1
    else
      temp = (balive / Divider)
    end
    temp = math.floor(temp)
    if temp < 1 then
      temp = 1
    end
    snumber = math.random(temp,snumber)
    BASE:E({"Bomber SpawnTime snumber is:",snumber})
    for i = 1, snumber, 1 do
     spawnrandombomber()
    end
    if cdcurrentwave >= cdmaxwaves then
      MESSAGE:New("Max Waves of " .. cdmaxwaves .. " Reached Stopping Defence Mission in 60 minutes",30):ToAll()
	  hmfleet("Max Waves of " .. cdmaxwaves .. " Reached Stopping Defence Mission in 60 minutes")
      ctimer = SCHEDULER:New(nil,CarrierStop,{},(60*60))
    else
      MESSAGE:New("next Wave " .. cdcurrentwave .. " of " .. cdmaxwaves .." will start in " .. cdwavetime .. " minutes",30):ToAll()
	  hmfleet("next Wave " .. cdcurrentwave .. " of " .. cdmaxwaves .." will start in " .. cdwavetime .. " minutes")
      ctimer = SCHEDULER:New(nil,nwave,{},(cdcwavetime*60))
    end
end


function dincrease()
  if cdactive == false then
  mmenu2c:Remove()
  Divider = Divider + 1
  MESSAGE:New("Difficulty Divider Increased by 1 to ".. Divider .." Remember Higher = less difficult",15):ToAll()
  hmfleet("Difficulty Divider Increased by 1 to ".. Divider .." Remember Higher = less difficult")
  mmenu2c = MENU_COALITION:New(coalition.side.BLUE,"Difficulty Divider:" .. Divider .. "",mmenu1)
  else
    MESSAGE:New("Unable, Mission is Active at the current time",15):ToAll()
  end
end

function ddecrease()
  if cdactive == false then
  mmenu2c:Remove()
  Divider = Divider - 1
  if Divider == 0 then
	Divider = 1
  end
  MESSAGE:New("Difficulty Divider Decreased by 1 to ".. Divider .." Remember Higher = less difficult",15):ToAll()
  hmfleet("Difficulty Divider Decreased by 1 to ".. Divider .." Remember Higher = less difficult")
  mmenu2c = MENU_COALITION:New(coalition.side.BLUE,"Difficulty Divider:" .. Divider .. "",mmenu1)
  else
    MESSAGE:New("Unable, Mission is Active at the current time",15):ToAll()
  end
end

function wincrease()
  if cdactive == false then
  mmenu2:Remove()
  cdmaxwaves = cdmaxwaves + 1
  MESSAGE:New("Max Waves Increased by 1 to ".. cdmaxwaves .."",15):ToAll()
  hmfleet("Max Waves Increased by 1 to ".. cdmaxwaves .."")
  mmenu2 = MENU_COALITION:New(coalition.side.BLUE,"Max Waves:" .. cdmaxwaves,mmenu1)
  else
    MESSAGE:New("Unable, Mission is Active at the current time",15):ToAll()
  end
end

function wdecrease()
  if cdactive == false then
  mmenu2:Remove()
  cdmaxwaves = cdmaxwaves - 1
  
  if cdmaxwaves < 1 then
    cdmaxwaves = 1
    MESSAGE:New("Unable to reduce waves below 1",15):ToAll()
  end
  MESSAGE:New("Max Waves decreased by 1 to " ..cdmaxwaves):ToAll()
  hmfleet("Max Waves decreased by 1 to " ..cdmaxwaves .. "")
  mmenu2 = MENU_COALITION:New(coalition.side.BLUE,"Max Waves:" .. cdmaxwaves,mmenu1)
  else
    MESSAGE:New("Unable, Mission is Active at the current time",15):ToAll()
  end
end

function tincrease()
  if cdactive == false then
    mmenu2c:Remove()
    cdwavetime = cdwavetime + 1
    MESSAGE:New("Wave Time Increased by 1 minute to ".. cdwavetime .. "",15):ToAll()
	hmfleet("Wave Time Increased by 1 minute to ".. cdwavetime .. "") 
    mmenu2c = MENU_COALITION:New(coalition.side.BLUE,"Wave Time:" .. cdwavetime,mmenu1)
  else
    MESSAGE:New("Unable, Mission is Active at the current time",15):ToAll()
  end
end


function tdecrease()
  if cdactive == false then
  mmenu2c:Remove()
  cdwavetime = cdwavetime - 1
  if cdwavetime < 5 then
    cdwavetime = 5
    MESSAGE:New("Wave time can not be reduced below 5 minutes",15):ToAll()
  end
  MESSAGE:New("Wave Time Decreased by 1 minute to ".. cdwavetime .. "",15):ToAll()
  hmfleet("Wave Time Decreased by 1 minute to ".. cdwavetime)
  mmenu2c = MENU_COALITION:New(coalition.side.BLUE,"Wave Time:" .. cdwavetime,mmenu1)
  else
    MESSAGE:New("Unable, Mission is Active at the current time",15):ToAll()
  end
end

function spawnrandomfighter()
  BASE:E({"Spawn Random Fighter"})
  fightersnum = fightersnum + 1
  local rnd = math.random(1,3)
  local spawner = SPAWN:NewWithAlias("Fighter_Spawn1","Fighter" .. fightersnum)
      :InitRandomizeTemplate(fighters)
      :InitRandomizePosition(true,30000,1000)
      :InitRandomizeRoute(1,4,math.random(100,5000),math.random(0,1000))
  if rnd == 1 then
    BASE:E({"Fighter Spawn 1"})
    spawner = SPAWN:NewWithAlias("Fighter_Spawn1","Fighter" .. fightersnum)
      :InitRandomizeTemplate(fighters)
      :InitRandomizePosition(true,30000,1000)
      :InitRandomizeRoute(1,4,math.random(100,5000),math.random(0,1000))
  elseif rnd == 2 then
    BASE:E({"Fighter Spawn 2"})
    spawner = SPAWN:NewWithAlias("FIGHTER_SPAWN2","Fighter" .. fightersnum)
      :InitRandomizeTemplate(fighters)
      :InitRandomizePosition(true,30000,1000)
      :InitRandomizeRoute(1,4,15000,1000)
  elseif rnd == 3 then
    BASE:E({"Fighter Spawn 3"})
    spawner = SPAWN:NewWithAlias("FIGHTER_SPAWN3","Fighter" .. fightersnum)
      :InitRandomizeTemplate(fighters)
      :InitRandomizePosition(true,30000,1000)
      :InitRandomizeRoute(1,4,math.random(100,5000),math.random(0,1000))
  else 
    BASE:E({"Fighter Spawn other"})
    spawner = SPAWN:NewWithAlias("Fighter_Spawn1","Fighter" .. fightersnum)
      :InitRandomizeTemplate(fighters)
      :InitRandomizePosition(true,30000,1000)
      :InitRandomizeRoute(1,4,math.random(100,5000),math.random(0,1000))
  end
  BASE:E({"Fighter Spawn Spawning"})
  local spawned = spawner:Spawn()
  table.insert(fighterspawns,spawned)
end

function spawnrandombomber()
  bombernum = bombernum + 1
  local rnd = math.random(1,3)
  local spawner = SPAWN:NewWithAlias("Bear_SP1","Bomber" .. bombernum)
      :InitRandomizeTemplate(bombers)
      :InitRandomizePosition(true,30000,1000)
      :InitRandomizeRoute(1,4,math.random(100,2000),math.random(0,1000))
  if rnd == 1 then
    spawner = SPAWN:NewWithAlias("Bear_SP1","Bomber" .. bombernum)
      :InitRandomizeTemplate(bombers)
      :InitRandomizePosition(true,30000,1000)
      :InitRandomizeRoute(1,4,math.random(100,2000),math.random(0,1000))
  elseif rnd == 2 then
    spawner = SPAWN:NewWithAlias("Bear_SP2","Bomber" .. bombernum)
      :InitRandomizeTemplate(bombers)
      :InitRandomizePosition(true,30000,2000)
      :InitRandomizeRoute(1,4,25000,1000)
  elseif rnd == 3 then
    spawner = SPAWN:NewWithAlias("Bear_SP3","Bomber" .. bombernum)
      :InitRandomizeTemplate(bombers)
      :InitRandomizePosition(true,35000,2000)
      :InitRandomizeRoute(1,4,math.random(100,5000),math.random(0,1000))
  else 
    spawner = SPAWN:NewWithAlias("Bear_SP1","Bomber" .. bombernum)
      :InitRandomizeTemplate(bombers)
      :InitRandomizePosition(true,35000,1000)
      :InitRandomizeRoute(1,4,math.random(100,5000),math.random(0,1000))
  end
  
  local spawned = spawner:Spawn()
  table.insert(bomberspawns,spawned)
end

  trigger.action.setUserFlag("N CAP Hornet 403",100)
  trigger.action.setUserFlag("N CAP Hornet 404",100)
  trigger.action.setUserFlag("N CAP TomCat 303",100)
  trigger.action.setUserFlag("N CAP TomCat 304",100)
  trigger.action.setUserFlag("SC CAP Hornet 401",100)
  trigger.action.setUserFlag("SC CAP Hornet 402",100)
  trigger.action.setUserFlag("SC CAP TomCat 301",100)
  trigger.action.setUserFlag("SC CAP TomCat 302",100)
  trigger.action.setUserFlag("Turkey-16-1",100)
  trigger.action.setUserFlag("Turkey-16-2",100)
  trigger.action.setUserFlag("Turkey-15-1",100)
  trigger.action.setUserFlag("Turkey-15-2",100)
  trigger.action.setUserFlag("Turkey-m2000-1",100)
  trigger.action.setUserFlag("Turkey-m2000-2",100)
  BASE:E({"locking Alert Slots"})
  trigger.action.setUserFlag("N ALERT Hornet 101",100)
  trigger.action.setUserFlag("N ALERT Hornet 102",100)
  trigger.action.setUserFlag("N ALERT TomCat 91",100)
  trigger.action.setUserFlag("N ALERT TomCat 92",100)
  trigger.action.setUserFlag("SC ALERT Hornet 201",100)
  trigger.action.setUserFlag("SC ALERT Hornet 202",100)
  trigger.action.setUserFlag("SC ALERT TomCat 81",100)
  trigger.action.setUserFlag("SC ALERT TomCat 82",100)
  BASE:E({"Locking Other Slots"})
  trigger.action.setUserFlag("N RAMP Hornet 61",100)
  trigger.action.setUserFlag("N RAMP Hornet 62",100)
  trigger.action.setUserFlag("N RAMP Hornet 63",100)
  trigger.action.setUserFlag("N RAMP Hornet 64",100)
  trigger.action.setUserFlag("N RAMP Hornet 65",100)
  trigger.action.setUserFlag("N RAMP Hornet 66",100)
  trigger.action.setUserFlag("N RAMP Hornet 67",100)
  trigger.action.setUserFlag("N RAMP Hornet 68",100)
  trigger.action.setUserFlag("N RAMP Hornet 69",100)
  trigger.action.setUserFlag("N RAMP Hornet 70",100)
  trigger.action.setUserFlag("N RAMP Hornet 71",100)
  trigger.action.setUserFlag("N RAMP Hornet 72",100)
  trigger.action.setUserFlag("N RAMP TomCat 21",100)
  trigger.action.setUserFlag("N RAMP TomCat 22",100)
  trigger.action.setUserFlag("N RAMP TomCat 23",100)
  trigger.action.setUserFlag("N RAMP TomCat 24",100)
  trigger.action.setUserFlag("SC RAMP Hornet 31",100)
  trigger.action.setUserFlag("SC RAMP Hornet 32",100)
  trigger.action.setUserFlag("SC RAMP Hornet 33",100)
  trigger.action.setUserFlag("SC RAMP Hornet 34",100)
  trigger.action.setUserFlag("SC RAMP Hornet 41",100)
  trigger.action.setUserFlag("SC RAMP Hornet 42",100)
  trigger.action.setUserFlag("SC RAMP Hornet 43",100)
  trigger.action.setUserFlag("SC RAMP Hornet 44",100)
  trigger.action.setUserFlag("SC RAMP Hornet 51",100)
  trigger.action.setUserFlag("SC RAMP Hornet 52",100)
  trigger.action.setUserFlag("SC RAMP Hornet 53",100)
  trigger.action.setUserFlag("SC RAMP Hornet 54",100)
	trigger.action.setUserFlag("SC RAMP Hornet 55",100)
	trigger.action.setUserFlag("SC RAMP Hornet 56",100)
	trigger.action.setUserFlag("SC RAMP Hornet 57",100)
	trigger.action.setUserFlag("SC RAMP Hornet 58",100)
	trigger.action.setUserFlag("SC RAMP TomCat 10",100)
	trigger.action.setUserFlag("SC RAMP TomCat 11",100)
	trigger.action.setUserFlag("SC RAMP TomCat 12",100)
	trigger.action.setUserFlag("SC RAMP TomCat 13",100)
  trigger.action.setUserFlag("SC RAMP TomCat 10",100)
  trigger.action.setUserFlag("SC RAMP TomCat 11",100)
  trigger.action.setUserFlag("SC RAMP TomCat 12",100)
  trigger.action.setUserFlag("SC RAMP TomCat 13",100)
  

function getwingstate()
   MESSAGE:New("Carrier Air Wing Status \n CVN 71 Theodore Roosevelt \n Hornet: ".. tdyhornet .." Airframes \n TomCat: "..tdycat.." \n USS Forrestal \n Hornet: ".. stnhornet .." Airframes \n TomCat: "..stncat.."",60,"RipCord"):ToAll()
   hmfleet("Carrier Air Wing Status \n CVN 71 Theodore Roosevelt \n Hornet: ".. tdyhornet .." Airframes \n TomCat: "..tdycat.." \n USS Forrestal \n Hornet: ".. stnhornet .." Airframes \n TomCat: "..stncat.."")
end

function getdifficulty()
    local snumber = (balive + cdcurrentwave)
    snumber = snumber / Divider
    snumber = math.floor(snumber)
    if snumber < cdcurrentwave then 
      snumber = cdcurrentwave
    end
    local temp = 1
    if balive < 0 then
      temp = 1
    else
      temp = balive / Divider
    end
    temp = math.floor(temp)
    if temp < 1 then
      temp = 1
    end
	fighterinfo = "Fighter Min Spawn: " .. temp .. " , Max Spawn: " .. snumber .. " "
	snumber = (balive + cdcurrentwave)
    snumber = snumber / Divider
    snumber = math.floor(snumber)
    if snumber < cdcurrentwave then 
      snumber = cdcurrentwave
    end
    temp = 1
    if balive < 0 then
      temp = 1
    else
      temp = balive / Divider
    end
    temp = math.floor(temp)
    if temp < 1 then
      temp = 1
    end
    snumber = math.random(temp,snumber)
	bomberinfo = "Bomber Min Spawn: " .. temp .. ", Max Spawn: ".. snumber .. " "
	MESSAGE:New("Current Difficulty is as follows \n " .. fighterinfo .. "\n" .. bomberinfo .. "\n Mission is on Wave: " .. cdcurrentwave .. " of " .. cdmaxwaves .. "\n Current time between waves is:" ..cdcwavetime.. " minutes",15):ToAll()
	hmfleet("Current Difficulty is as follows \n " .. fighterinfo .. "\n" .. bomberinfo .. "\n Mission is on Wave: " .. cdcurrentwave .. " of " .. cdmaxwaves .. "\n Current time between waves is:" ..cdcwavetime.. " minutes")
	getwingstate()
end
  
mmenu = MENU_COALITION:New(coalition.side.BLUE,"Carrier Defence")
mmenu1 = MENU_COALITION:New(coalition.side.BLUE,"Setup",mmenu)
mmenu2 = MENU_COALITION:New(coalition.side.BLUE,"Max Waves:" .. cdmaxwaves,mmenu1z)
mmenu2c = MENU_COALITION:New(coalition.side.BLUE,"Wave Time:" .. cdwavetime .. " Minutes",mmenu1)
mmenu2c = MENU_COALITION:New(coalition.side.BLUE,"Difficulty Divider:" .. Divider .. "",mmenu1)
mmenu1z = MENU_COALITION:New(coalition.side.BLUE,"Adjust Waves",mmenu1)
mmenu1y = MENU_COALITION:New(coalition.side.BLUE,"Adjust Difficulty",mmenu1)
mmenu3a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Increase Divider",mmenu1y,dincrease)
mmenu3b = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Decrease Divider",mmenu1y,ddecrease)
mmenu1a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Start",mmenu,CarrierStart,{})
mmenu1f = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Get Mission Update",mmenu,getdifficulty,{})
mmenu1b = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Get CV Wing Update",mmenu,getwingstate,{})
mmenu2a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Increase Max Waves",mmenu1z,wincrease)
mmenu2b = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Decrease Max Waves",mmenu1z,wdecrease)
mmenu2e = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Increase Wave Time",mmenu1z,tincrease)
mmenu2f = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Decrease Wave Time",mmenu1z,tdecrease)
