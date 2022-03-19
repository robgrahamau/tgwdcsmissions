function _split(str, sep)
  BASE:E({str=str, sep=sep})  
  local result = {}
  local regex = ("([^%s]+)"):format(sep)
  for each in str:gmatch(regex) do
    table.insert(result, each)
  end
  return result
end

admin = false
password = "training"
ADMINPASSWORD2 = "tgw"
adminspawned = {} 
newlandingmark = true
-- SupportHandler = EVENTHANDLER:New()

hevent = {
ClassName = "Handle_Events",}

function hevent:New()
  local self = BASE:Inherit(self,BASE:New())
  self:E("Initalising Handle Events")
  self:HandleEvent(EVENTS.MarkRemoved)
  if newlandingmark ~= false then
	self:HandleEvent(EVENTS.LandingQualityMark)
  end
  return self
end


function hevent:OnEventLandingQualityMark(EventData) 
  BASE:E({"Landing Quality Mark",EventData})
  local comment = EventData.comment
  local who = EventData.IniPlayerName
  if who == nil then
	who = EventData.IniUnitName
	BASE:E({"NPC Landed",who})
	return
  end
  if who == nil then
	who = "Unknown"
  end
  local t = EventData.IniTypeName
  if t == nil then
	t = "Unknown"
  end
  local where = EventData.PlaceName
  BASE:E({comment,who,where,t})
  lsomsg = 
  hm("**Super Carrier LSO** \n> ** " .. where .. "** \n> **Landing Grade for  " .. who .. " **Aircraft Type:** " .. t .. " \n> **Grade:** " .. comment .. "." )
  hmlso( "**Super Carrier LSO** \n> ** " .. where .. "** \n> **Landing Grade for  " .. who .. " **Aircraft Type:** " .. t .. " \n> **Grade:** " .. comment .. "."  )
end

function hevent:handlehelp(coalition)
	local msgtext = "Map Command Help Requested. The Following are valid commands for markers any with a - at the start require you to delete the marker. \n -help (this command) \n -smokered,-smokegreen,-smokeblue (Spawn a random smoke near the location) \n -flare (fire flares from the location) \n -weather (request a GRIBS weather report from the location of the marker) \n -tanker (more information soon) \n arty (arty command valid methods include: arty engage,battery \"<name>\",shots #,type gun/missile or arty request, battery <name>,ammo \n valid Battery Names are: Carrier Group 5, Carrier Group 6, Carrier Group 6a & Red Alias \"Kuz\" (replace battery with Alias). \n%d"
	if coalition == 1 then
		MESSAGE:New(msgtext,15):ToRed()
	else
		MESSAGE:New(msgtext,15):ToBlue()
	end
end

function hevent:OnEventMarkRemoved(EventData)
    if EventData.text~=nil and EventData.text:lower():find("-") then 
        local text = EventData.text:lower()
        local text2 = EventData.text
        local vec3={y=EventData.pos.y, x=EventData.pos.x, z=EventData.pos.z}
        local coord = COORDINATE:NewFromVec3(vec3)
		local coalition = EventData.coalition
		local red = false
		if coalition == 1 then
			red = true
		end
        coord.y = coord:GetLandHeight()
        if EventData.text:lower():find("-weather") then
              handleWeatherRequest(text,coord,red)
        elseif EventData.text:lower():find("-tanker") then
           if red == false then
            handleBlueTankerRequest(text,coord)        
           else
            handleRedTankerRequest(text,coord)
           end
		elseif EventData.text:lower():find("-help") then
			self:handlehelp(red)
        elseif EventData.text:lower():find("-smokered") then
          local nc = coord:GetRandomCoordinateInRadius(200,50)
		  nc:SmokeRed()
        elseif EventData.text:lower():find("-smokeblue") then
          local nc = coord:GetRandomCoordinateInRadius(200,50)
		  nc:SmokeBlue()
        elseif EventData.text:lower():find("-smokegreen") then
          local nc = coord:GetRandomCoordinateInRadius(200,50)
		  nc:SmokeGreen()
        elseif EventData.text:lower():find("-smokeorange") then
          local nc = coord:GetRandomCoordinateInRadius(200,50)
		  nc:SmokeOrange()
        elseif EventData.text:lower():find("-smoke") then
          self:handleSmoke(text,coord,coalition)
        elseif EventData.text:lower():find("-flare") then
          coord:FlareRed(math.random(0,360))
          SCHEDULER:New(nil,function() 
            coord:FlareRed(math.random(0,20))
          end,{},30)
        elseif EventData.text:lower():find("-light") then
      coord.y = coord.y + 1500
          coord:IlluminationBomb(1000)
      elseif EventData.text:lower():find("-lightbright") then
      coord.y = coord.y + 2000
          coord:IlluminationBomb(10000)
    elseif EventData.text:lower():find("-ctldfob") then
          -- ctld drop.
      if admin == true then
      BASE:E({"attempting to spawn a fob"})
      MESSAGE:New("Attempting to spawn a fob lets see if it breaks",30):ToAll()
      local _unitId = ctld.getNextUnitId()
      local _name = "ctld Deployed FOB #" .. _unitId
      local _fob = nil
      BASE:E({"ctld",text})
      local keywords=_split(text,"|")
      local s = keywords[2]
      if (s == "blue") then
        _fob = ctld.spawnFOB(2, 211, vec3, _name)
      elseif (s == "red") then
        _fob = ctld.spawnFOB(34, 211, vec3, _name)
      else
        _fob = ctld.spawnFOB(2, 211, vec3, _name)
      end
      table.insert(ctld.logisticUnits, _fob:getName())
		if ctld.troopPickupAtFOB == true then
			table.insert(ctld.builtFOBS, _fob:getName())
		end
      end
     elseif EventData.text:lower():find("-explode") then
			if admin == true then
				self:handleExplosion(text,coord)
			else
				MESSAGE:New("Unable, Admin Commands need to be active to use that command",15):ToAll()
			end
        elseif EventData.text:lower():find("-admin") then
          handleeadmin(text)
    elseif EventData.text:lower():find("-radmin") then
          rhandleeadmin(text)
        elseif EventData.text:lower():find("-spawn") then
          if admin == true then
            newhandlespawn(text2,coord)
          else
            MESSAGE:New("Admin Commands need to be active to spawn new units",15):ToAll()
          end
    elseif EventData.text:lower():find("-rs") then
          if admin == true then
            newhandlespawn(text2,coord)
          else
            MESSAGE:New("Admin Commands need to be active to spawn new units",15):ToAll()
          end
    elseif EventData.text:lower():find("-load") then
          if admin == true then
            dofile(lfs.writedir() .."fleetdefence\\input.lua")
          else
            MESSAGE:New("Admin Commands need to be active to input a file",15):ToAll()
          end
       elseif EventData.text:lower():find("-despawn") then
          if admin == true then
            handledespawn(text2)
          else
            MESSAGE:New("Admin Commands need to be active to despawn units",15):ToAll()
          end
	elseif EventData.text:lower():find("-runscript") then
        hm("Wow ok, some ones attempting to run a script.. hope they know the magic words")
        self:handleScript(text2)
    elseif EventData.text:lower():find("-msgall") then
          if admin == true then
            msgtoall(text2)
          else
            MESSAGE:New("Admin Commands need to be active to despawn units",15):ToAll()
          end
        end
    end
end

function hevent:handleSmoke(text,coord,col)
	local keywords=UTILS.Split(text, ",")
	BASE:E({keywords})
	local keyphrase = keywords[2]
	if col == nil then
		col = 2
		hm("***WARNING ERROR HAPPENED IN SMOKE COL WAS NIL**")
	elseif col ~= 1 then
		col = 2
	end
	ourset = SET_GROUP:New()
	if col == 1 then 
		ourset = SET_GROUP:New():FilterCoalitions("red"):FilterActive(true):FilterCategoryGround():FilterOnce()
		MESSAGE:New("Firehawk, this is breaker Nine nine requesting smoke at the supplied coordinates.",15):ToRed()
		hm("Firehawk, this is breaker Nine nine requesting smoke at the following coordinates.")
	else
		abg = SET_GROUP:New():FilterCoalitions("blue"):FilterActive(true):FilterCategoryGround():FilterOnce()
		MESSAGE:New("Firehawk, this is breaker Nine nine requesting smoke at the supplied coordinates.",15):ToBlue()
		hm("Firehawk, this is breaker Nine nine requesting smoke at the following coordinates.")
	end
	uiz = false 
	gunits:ForEach(function(g)  
		if g:IsAlive() == true then
			local _group = GROUP:FindByName(g:GetName())
			gc = _group:GetCoordinate()
			if gc == nil then
				BASE:E({"Could not get Coord for group:",g:GetName(),g:GetCoordinate(),gc})
			else
				local d = gc:Get2DDistance(coord)
				if d < 25000 then
					uiz = true
				end
			end
		end
	end)
	if uiz == true then
		if keyphrase:lower():find("red") then
			local nc = coord:GetRandomCoordinateInRadius(200,50)
			nc:SmokeRed() 
			return           
		elseif keyphrase:lower():find("blue") then
			local nc = coord:GetRandomCoordinateInRadius(200,50)
			nc:SmokeBlue()
			return
		elseif keyphrase:lower():find("green") then
			local nc = coord:GetRandomCoordinateInRadius(200,50)
			nc:SmokeGreen()
			return
		elseif keyphrase:lower():find("orange") then
			local nc = coord:GetRandomCoordinateInRadius(200,50)
			nc:SmokeOrange()
			return
		else
			local nc = coord:GetRandomCoordinateInRadius(200,500)
			nc:SmokeWhite()
			return
		end
	else	
		local msg = MESSAGE:New("Negative, Unable to launch smoke, no friendly units close enough for to launch rounds for marking, all units outside 25KM",15)	 
		if col == 1 then
			msg:ToRed()
		else
			msg:ToBlue()
		end
	end
end




function hevent:handleScript(text)
  local keywords = UTILS.Split(text,";")
  local doublecheck = keywords[2]
  local script = keywords[3]
  if (admin == true) and (doublecheck == ADMINPASSWORD2) then
    BASE:E({"attempting to run script"})
    hm("Some one knew both the magic words Now do they know how to code?")
    assert(loadstring(script))()
    MESSAGE:New("Admin Script was successful")
    hm("Some one knew both the magic words and their script was correct!")
  else
    MESSAGE:New("Uh, uh, uh.. You didn't say the magic word.")
    hm("***Ohhh, some ones being Naughty***, \n `Uh, uh, uh.. you didn't say the magic word` \n https://tenor.com/view/jurassic-park-nedry-dennis-no-no-nah-you-didnt-say-the-magic-word-gif-16617306 ")
  end
end



function hevent:handleExplosion(text,coord)
  local keywords=UTILS.Split(text, ",")
  local yeild = keywords[2]
  yeild = tonumber(yeild)
  if yeild == nil then
    yeild = 250
    hm("Ok, who let sock near the armory? were the hell has 250pounds of TnT gone?")
  end
  if admin == true then
    coord:Explosion(yeild)
    hm("Oh shit... I swore there was " .. yeild .. " more of this shit arou.... Ohhh there it is")
  end
end

function tankerCooldownHelp(tankername)
  MESSAGE:New(string.format("Tanker routing is now available again for %s. Use the following marker commands:\n-tanker route %s \n-tanker route %s ,h <0-360>,d <5-100>,a <10-30,000>,s <250-400> \nFor more control",tankername,tankername,tankername), MESSAGE.Type.Information):ToBlue()
end

function handleBlueTankerRequest(text,coord)
  local currentTime = os.time()
  if text:find("route") then
        local keywords=_split(text, ",")
        local heading = nil
        local distance = nil
        local endcoord = nil
        local endpoint = false
        local altitude = nil
        local altft = nil
        local spknt = nil
        local speed = nil
        local tankername = ""
        BASE:E({keywords=keywords})
        for _,keyphrase in pairs(keywords) do
          local str=_split(keyphrase, " ")
          local key=str[1]
          local val=str[2]
          -- BASE:E(string.format("%s, keyphrase = %s, key = %s, val = %s", "route", tostring(keyphrase), tostring(key), tostring(val)))
          if key:lower():find("h") then
            heading = tonumber(val)
            -- BASE:E({"Tanker Movement we have heading",heading})
          end
          if key:lower():find("d") then
            distance = tonumber(val)
            -- BASE:E({"Tanker Movement we have distance",distance})
          end
          if key:lower():find("a") then
            altitude = tonumber(val)
            -- BASE:E({"Tanker Movement we have altitude ",altitude})
          end
          if key:lower():find("s") then
            speed = tonumber(val)
            -- BASE:E({"Tanker Movement we have speed",speed})
          end
        end
        local tanker = nil
        -- find our tanker
        if text:find("arco11") or text:find("arc11") then
            local tankername = "ARCO"
            local cooldown = currentTime - ARC_Timer
              if cooldown < TANKER_COOLDOWN then 
                MESSAGE:New(string.format("ARCO Tanker Requests are not available at this time.\nRequests will be available again in %d minutes", (TANKER_COOLDOWN - cooldown) / 60),30, MESSAGE.Type.Information):ToBlue()
              return
            end
            tanker = Arco11
            if tanker:IsAlive() ~= true then
              MESSAGE:New("ARCO is currently not avalible for tasking, it's M.I.A",30,MESSAGE.Type.Information):ToBlue()
              return
            end
            ARC_Timer = currentTime
         elseif text:find("texaco11") or text:find("tex11") then
            local tankername = "TEXACO11"
            tanker = Texaco11
            local cooldown = currentTime - TEX_Timer
              if cooldown < TANKER_COOLDOWN then 
                MESSAGE:New(string.format("TEXACO11 Tanker Requests are not available at this time.\nRequests will be available again in %d minutes", (TANKER_COOLDOWN - cooldown) / 60),30, MESSAGE.Type.Information):ToBlue()
              return
            end
            if tanker:IsAlive() ~= true then
              MESSAGE:New("TEXACO11 is currently not avalible for tasking it's M.I.A",30,MESSAGE.Type.Information):ToBlue()
              return
            end
            TEX_Timer = currentTime
          elseif text:find("texaco21") or text:find("tex21") then
            local tankername = "TEXACO21"
            tanker = Texaco21
            local cooldown = currentTime - TEX2_Timer
              if cooldown < TANKER_COOLDOWN then 
                MESSAGE:New(string.format("TEXACO21 Tanker Requests are not available at this time.\nRequests will be available again in %d minutes", (TANKER_COOLDOWN - cooldown) / 60),30, MESSAGE.Type.Information):ToBlue()
              return
            end
            if tanker:IsAlive() ~= true then
              MESSAGE:New("TEXACO21 is currently not avalible for tasking it's M.I.A",30,MESSAGE.Type.Information):ToBlue()
              return
            end
            TEX2_Timer = currentTime
          else
          MESSAGE:New("No known Tanker was included in the Tanker Route Command, please select ARCO21 or TEXACO21",30,MESSAGE.Type.Information):ToBlue()
          return
        end
        if altitude == nil then
           altft = 19000
           altitude = UTILS.FeetToMeters(19000)
        else
           if altitude > 30000 then
             altitude = 30000
           elseif altitude < 10000 then
             altitude = 10000
           end
           altft = altitude
           altitude = UTILS.FeetToMeters(altitude)
         end
         if speed == nil then
            spknt = 370
            speed = UTILS.KnotsToMps(370)
         else
            if speed > 450 then
              speed = 450
            elseif speed < 250 then
              speed = 250
            end
            spknt = speed
            speed = UTILS.KnotsToMps(speed)
         end  
        if heading ~= nil then 
          if heading < 0 then
            heading = 0
          elseif heading > 360 then
            heading = 360
          end
          if distance ~= nil then
            if distance > 100 then
              distance = 100
            end
            if distance < 5 then
              distance = 5
            end
            endcoord = coord:Translate(UTILS.NMToMeters(distance),heading)
          else
            endcoord = coord:Translate(UTILS.NMToMeters(25),heading)
            distance = 25
          end
        else
          heading = math.random(0,360)
          endcoord = coord:Translate(UTILS.NMToMeters(25),heading)
          distance = 25
        end
        tanker:ClearTasks()
        local routeTask = tanker:TaskOrbit( coord, altitude,  speed, endcoord )
        tanker:SetTask(routeTask, 2)
        local tankerTask = tanker:EnRouteTaskTanker()
        tanker:PushTask(tankerTask, 4)
        MESSAGE:New( string.format("%s Tanker is re-routed to the player requested destination.\nIt will orbit on a heading of %d for %d nm, Alt: %d Gnd Speed %d.\n%d minutes cooldown starting now", tanker:GetName(),heading,distance,altft,spknt, TANKER_COOLDOWN / 60),20, MESSAGE.Type.Information ):ToBlue()      
        SCHEDULER:New(nil, tankerCooldownHelp, {tankername}, TANKER_COOLDOWN)
    end
end
function handleRedTankerRequest(text,coord)
  MESSAGE:New("Tanker Routing Commands are Currently Not Supported",30,"Info"):ToRed()
end






 function handleWeatherRequest(text, coord, red)
    local currentPressure = coord:GetPressure(0)
    local currentTemperature = coord:GetTemperature()
    local currentWindDirection, currentWindStrengh = coord:GetWind()
  local currentWindDirection1a, currentWindStrength1a = coord:GetWind(UTILS.FeetToMeters(500))
    local currentWindDirection1, currentWindStrength1 = coord:GetWind(UTILS.FeetToMeters(1000))
    local currentWindDirection2, currentWindStrength2 = coord:GetWind(UTILS.FeetToMeters(2000))
    local currentWindDirection5, currentWindStrength5 = coord:GetWind(UTILS.FeetToMeters(5000))
    local currentWindDirection10, currentWindStrength10 = coord:GetWind(UTILS.FeetToMeters(10000))
    local weatherString = string.format("Requested weather: Wind from %d@%.1fkts, QNH %.2f, Temperature %d", currentWindDirection, UTILS.MpsToKnots(currentWindStrengh), currentPressure * 0.0295299830714, currentTemperature)
    local weatherString1 = string.format("Wind 500ft MSL: Wind from%d@%.1fkts",currentWindDirection1, UTILS.MpsToKnots(currentWindStrength1a))
    local weatherString2a = string.format("Wind 1,000ft MSL: Wind from%d@%.1fkts",currentWindDirection2, UTILS.MpsToKnots(currentWindStrength1))
  local weatherString2 = string.format("Wind 2,000ft MSL: Wind from%d@%.1fkts",currentWindDirection2, UTILS.MpsToKnots(currentWindStrength2))
    local weatherString5 = string.format("Wind 5,000ft MSL: Wind from%d@%.1fkts",currentWindDirection5, UTILS.MpsToKnots(currentWindStrength5))
    local weatherString10 = string.format("Wind 10,000ft MSL: Wind from%d@%.1fkts",currentWindDirection10, UTILS.MpsToKnots(currentWindStrength10))
    if red == false then
    MESSAGE:New(weatherString, 30, MESSAGE.Type.Information):ToBlue()
  MESSAGE:New(weatherString2a, 30, MESSAGE.Type.Information):ToBlue()
    MESSAGE:New(weatherString1, 30, MESSAGE.Type.Information):ToBlue()
    MESSAGE:New(weatherString2, 30, MESSAGE.Type.Information):ToBlue()
    MESSAGE:New(weatherString5, 30, MESSAGE.Type.Information):ToBlue()
    MESSAGE:New(weatherString10, 30, MESSAGE.Type.Information):ToBlue()
  HypeMan.sendBotMessage('$SERVERNAME - Weather Requested \n ' .. weatherString .. '\n' .. weatherString1 .. '\n' .. weatherString2 .. '\n' .. weatherString5 .. '\n' .. weatherString10 .. '\n')
    else
    MESSAGE:New(weatherString, 30, MESSAGE.Type.Information):ToRed()
    MESSAGE:New(weatherString1, 30, MESSAGE.Type.Information):ToRed()
  MESSAGE:New(weatherString2a, 30, MESSAGE.Type.Information):ToRed()
    MESSAGE:New(weatherString2, 30, MESSAGE.Type.Information):ToRed()
    MESSAGE:New(weatherString5, 30, MESSAGE.Type.Information):ToRed()
    MESSAGE:New(weatherString10, 30, MESSAGE.Type.Information):ToRed()
  HypeMan.sendBotMessage('$SERVERNAME - Weather Requested \n ' .. weatherString .. '\n' .. weatherString1 .. '\n' .. weatherString2 .. '\n' .. weatherString5 .. '\n' .. weatherString10 .. '\n')
    end
end

function handleeadmin(text)
  local keywords=_split(text, ",")
   BASE:E({keywords=keywords})
   for _,keyphrase in pairs(keywords) do
    if keyphrase == password then
      if admin == false then
        admin = true
      else
        admin = false
      end
    end
   end
   if admin == true then
     MESSAGE:New("Admin Commands are Now Enabled",15):ToAll()
   else
     MESSAGE:New("Admin Commands are Disabled",15):ToAll()
   end
end


function rhandleeadmin(text)
  local keywords=_split(text, ",")
   BASE:E({keywords=keywords})
   for _,keyphrase in pairs(keywords) do
    if keyphrase == password then
      if admin == false then
        admin = true
      else
        admin = false
      end
    end
   end
   if admin == true then
     BASE:E({"ADMIN ENABLED"})
   --MESSAGE:New("Admin Commands are Now Enabled",15):ToAll()
   else
  BASE:E({"ADMIN DISABLED"})
     --MESSAGE:New("Admin Commands are Disabled",15):ToAll()
   end
end
function newhandlespawn(text,coord)
  BASE:E({"Spawn Request",text,coord})
  local keywords=_split(text, ",")
  local unit = nil
  local name = nil
  local heading = nil
  local uheading = nil
  local side = 1
  local ran = false
  for _,keyphrase in pairs(keywords) do
   local str=_split(keyphrase, " ")
	local key=str[1]
    local val=str[2]
  if key:lower():find("u") then
    unit = val
  elseif key:lower():find("n") then
    name = val
  elseif key:lower():find("h") then
    heading = tonumber(val)
   elseif key:lower():find("uh") then
    uheading = tonumber(val)
  elseif key:lower():find("r") then
    if val:lower() == "true" then
      ran = true 
    else
      ran = false
    end
  elseif key:lower():find("s") then
    if val:lower()  == "blue" then
      side = 2
    else
      side = 1
    end
   end
  end
  local sp = nil
  if (name ~= nil) and (unit ~= nil) then
    local tempgroup = GROUP:FindByName(unit)
    if tempgroup ~= nil then
      if side == 1 then
        sp = SPAWN:NewWithAlias(unit,"IAA " .. name):InitCountry(34)
      else
        sp = SPAWN:NewWithAlias(unit,"GM_USAA " .. name):InitCountry(2)
      end
      if ran == true then
        sp:InitRandomizeUnits(true,150,400)
      end
      if heading ~= nil then
        BASE:E({"HEADING ACTUALLY WAS NOT NIL WAS",heading})
        sp:InitGroupHeading(heading)
      else
        BASE:E({"HEADING ACTUALLY WAS NIL WAS",heading})
      end
	  if uheading ~= nil then
        BASE:E({"UNIT HEADING ACTUALLY WAS NOT NIL WAS",heading})
        sp:InitHeading(heading)
      else
        BASE:E({"UNIT HEADING ACTUALLY WAS NIL WAS",heading})
      end
      BASE:E({"Spawning:",u,side,ran,heading})
      sp = sp:SpawnFromCoordinate(coord)
      table.insert(adminspawned,sp)
    else
      MESSAGE:New("Unable to spawn requested group, template group does not exist",15):ToAll()
      BASE:E({"Unable to spawn group:",unit})
    end
  else
    BASE:E({"Name was Nil! or unit was nil",unit,name})
    MESSAGE:New("unable to spawn requested group as you left out information",15):ToAll()
  end
end





function handledespawn(text)
  BASE:E({"DeSpawn Request",text})
  local keywords=_split(text, ",")
  local unit = nil
  BASE:E({"DESPAWN", keywords=keywords})
  unit = keywords[2]
  local mgroup = nil
  mgroup = GROUP:FindByName(unit)
  if mgroup == nil then
    BASE:E({"Despawn error no group found"})
    MESSAGE:New("Admin Command Error, group not found.")
  else
    if mgroup:IsAlive() == true then
      mgroup:Destroy()
    end
    BASE:E({"Despawning Unit",unit})
    MESSAGE:New("And with a finger snap " .. unit .. " has become dust in the wind",10):ToAll()
  end
end

function msgtoall(text)
  BASE:E({"Msg to all",text})
  local keywords=_split(text,"|")
  msg = keywords[2]
  if msg ~= nil then
    MESSAGE:New(msg,15):ToAll()
  end
end

myevents = hevent:New()