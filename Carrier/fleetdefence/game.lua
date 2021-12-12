-- templates
fighters = {"MIG25_T","MIG25_2","MIG31_T","MIG31_2","MIG23_T","MIG23_2","MIG21_T","MIG21_2","SU27_T","SU27_2","MIG29F"}
bombers = {"TU-22m3", "MIG27", "Bear","TU-22m3_2", "MIG27_2", "Bear_2","JF17","J11","MIG29AS","SU33-1"}

if slmod ~= nil then
  hasslmod = true
else
  hasslmod = false
end

-- spawn zones (not currently used)

NSpawn = ZONE_POLYGON:New("NZone",GROUP:FindByName("NorthSpawnZone"))
CSpawn = ZONE_POLYGON:New("CZone",GROUP:FindByName("NorthSpawnZone2"))
ESpawn = ZONE_POLYGON:New("NZone",GROUP:FindByName("NorthSpawnZone3"))
Teddy = UNIT:FindByName("TDY")
Forrest = UNIT:FindByName("CVN74")
cvnfleet = GROUP:FindByName("CVN71")
texaco11spawn = SPAWN:New("Texaco11")
texaco11 = nil
despawncarriertimer = nil
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

tdyhealthlast = 0
foresthealthlast = 0
cawacs = nil
hmdebug = false
useslmod = false
function hmfleet(msg)
  hm("*Fleet Defender:* > " .. msg .. " ") 
end
function rlog(msg)
  BASE:E(msg)
  if hmdebug == true then
    hm(string.format( "%1s:(%s)" , "Carrier Defence Logger",routines.utils.oneLineSerialize( msg ) ) )
  end
end

function sendmsg(msg,dur,clear)
  if clear == nil then
    clear = false
  elseif clear ~= true then
    clear = false
  end
  
  if hasslmod == true and useslmod == true then
    slmod.msg_out(msg,dur,'chat')
  end
  MESSAGE:New(msg,dur,"MOTHER",clear):ToAll()
  hmfleet(msg)
  BASE:E({"SendMSG",msg})
end

function startawacs()
  rlog("Start AWACS")
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
  rlog("Start Tankers")
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
  
  if texaco11 ~= nil then
    texaco11:Destroy()
  end
  texaco11 = texaco11spawn:Spawn()
  
end

function stoptanker()
  rlog("Stop Tanker")
  if Tanker ~= nil then
    Tanker:Stop()
  end
  if texaco11 ~= nil then
    texaco11:Destroy()
  end
end

function stopawacs()
  rlog("Stop AWACS")
  if cawacs ~= nil then
    cawacs:Stop()
  end
end

-- checks the carriers
function checkcarriers()
  rlog("Check Carriers")
  if cdactive == true then
    if Teddy:IsAlive() then
      local currentlife = Teddy:GetLifeRelative()
      if currentlife < tdyhealthlast then
        local clife = currentlife * 100
        sendmsg("Warning, USS Theodore Roosevelt was damaged, if the Carrier is lost the mission will fail, carrier is at ".. clife .. "% health",60)
      end
      tdyhealthlast = currentlife
    else
      sendmsg("Warning USS Theodore Roosevelt is dead, mission has failed",60,true)
      CarrierStop()
    end
    if Forrest:IsAlive() then
      local currentlife = Forrest:GetLifeRelative()
      if currentlife < foresthealthlast then
        local clife = currentlife * 100
        sendmsg("Warning, USS Forrestal was damaged, if the Carrier is lost the mission will fail, carrier is at ".. clife .. "% health",60)
      end
      foresthealthlast = currentlife
    else
      sendmsg("Warning USS Forrestal is dead, mission has failed",60,true)
      CarrierStop()
    end
  else
    tdyhealthlast = 0
    foresthealthlast = 0
  end
end

-- spawns in the carriers.
function spawncarriers()
  cvnfleet:Respawn()
  cspawned = true
  if despawncarriertimer ~= nil then
    despawncarriertimer:Stop()
  end
  cvnfleet:Activate()
  starttanker()
  startawacs()
  local currentlife = Teddy:GetLifeRelative()
  tdyhealthlast = currentlife
  currentlife = Forrest:GetLifeRelative()
  foresthealthlast = currentlife
  BASE:E({"Carrier Fleet, AWACS and Tanker Should all be respawning"})
  sendmsg("Carrier Fleet, AWACS and Tanker should now all be active",15)
end

-- despawns the carriers and stops everything.
function despawncarriers()
  rlog({"Despawn Carriers Called",cdactive,cspawned})
  if cdactive == false then
    lockallslots()
  end
  if cdactive == false and cspawned == true then
    cvnfleet:Destroy()
    stopawacs()
    stoptanker()
    tdyhealthlast = 0
    foresthealthlast = 0
    sendmsg("Carrier Fleet, AWACS, and Tanker are now Despawning",15)
    lockallslots()
    cspawned = false
  end
end

-- resets values.
function resetsqncount()
  rlog("resetsqncount called")
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

-- eventhandler
Slothandler = EVENTHANDLER:New() 
Slothandler:HandleEvent(EVENTS.Crash) -- watch for crash, ejection and pilot dead
Slothandler:HandleEvent(EVENTS.Ejection)
Slothandler:HandleEvent(EVENTS.PilotDead)
Slothandler:HandleEvent(EVENTS.Dead)


function unlockcapslots()
  rlog({"Cap Slots Unlocked"})
  sendmsg("All CAP and Turkey slots are now open",30,false)
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
end

function lockcapslots()
  rlog({"Cap Slots Unlocked"})
  sendmsg("All CAP and Turkey slots are now locked",30,false)
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
end

function lockalertslots()
  rlog({"Locking Alert Slots"})
  sendmsg("All ALERT slots are now locked",30,false)
  trigger.action.setUserFlag("N ALERT Hornet 101",100)
  trigger.action.setUserFlag("N ALERT Hornet 102",100)
  trigger.action.setUserFlag("N ALERT TomCat 91",100)
  trigger.action.setUserFlag("N ALERT TomCat 92",100)
  trigger.action.setUserFlag("SC ALERT Hornet 201",100)
  trigger.action.setUserFlag("SC ALERT Hornet 202",100)
  trigger.action.setUserFlag("SC ALERT TomCat 81",100)
  trigger.action.setUserFlag("SC ALERT TomCat 82",100)
end

function unlockalertslots()
  rlog("Unlocking Alert slots")
  sendmsg("All Alert slots are now open",30,false)
  trigger.action.setUserFlag("N ALERT Hornet 101",00)
  trigger.action.setUserFlag("N ALERT Hornet 102",00)
  trigger.action.setUserFlag("N ALERT TomCat 91",00)
  trigger.action.setUserFlag("N ALERT TomCat 92",00)
  trigger.action.setUserFlag("SC ALERT Hornet 201",00)
  trigger.action.setUserFlag("SC ALERT Hornet 202",00)
  trigger.action.setUserFlag("SC ALERT TomCat 81",00)
  trigger.action.setUserFlag("SC ALERT TomCat 82",00)
end

function lockrampslots()
  rlog({"Locking all ramp slots"})
  sendmsg("All RAMP slots are now locked",30,false)
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
  
end

function unlockrampslots()
  rlog({"unlocking all ramp slots"})
  sendmsg("All RAMP slots are now open",30,false)
  trigger.action.setUserFlag("N RAMP Hornet 61",00)
  trigger.action.setUserFlag("N RAMP Hornet 62",00)
  trigger.action.setUserFlag("N RAMP Hornet 63",00)
  trigger.action.setUserFlag("N RAMP Hornet 64",00)
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
  trigger.action.setUserFlag("SC RAMP TomCat 10",00)
  trigger.action.setUserFlag("SC RAMP TomCat 11",00)
  trigger.action.setUserFlag("SC RAMP TomCat 12",00)
  trigger.action.setUserFlag("SC RAMP TomCat 13",00)
  trigger.action.setUserFlag("SC RAMP TomCat 10",00)
  trigger.action.setUserFlag("SC RAMP TomCat 11",00)
  trigger.action.setUserFlag("SC RAMP TomCat 12",00)
  trigger.action.setUserFlag("SC RAMP TomCat 13",00)
  
end

-- handles locking the slots when game is in play.
function slotlocker(EventData)
  local unitname = EventData.IniUnitName
  rlog({"SlotLocker",unitname,EventData})
  if unitname.text:lower():find("N CAP Hornet") then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
      stnhornet = stnhornet - 1
      if stnhornet < 0 then
        stnhornet = 0
      end
      trigger.action.setUserFlag(EventData.IniUnitName,100)
      sendmsg("Lost Contact with Hornet " .. unitname .. " Slot Locked until Restart Forrestal has " ..stnhornet .. " Hornets remaining",30)
    end
  elseif unitname.text:lower():find("N CAP TomCat") then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
      stncat = stncat - 1
      if stncat < 0 then
        stncat = 0
      end
      trigger.action.setUserFlag(EventData.IniUnitName,100)
      sendmsg("Lost Contact with Cat " .. unitname .. " Slot Locked until Restart Forrestal has " .. stncat .. " Tomcats remaining",30)
    end
  elseif unitname.text:lower():find("SC CAP TomCat") then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
      tdycat = tdycat - 1
      if tdycat < 0 then
        tdycat = 0
      end
      trigger.action.setUserFlag(EventData.IniUnitName,100)
      sendmsg("Lost Contact with Cat " .. unitname .. " Slot Locked until Restart Teddy has " .. tdycat .. " Tomcats remaining",30)
    end
  elseif unitname.text:lower():find("SC CAP Hornet") then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
      tdyhornet = tdyhornet - 1
      if tdyhornet < 0 then
        tdyhornet = 0
      end
      trigger.action.setUserFlag(EventData.IniUnitName,100)
      sendmsg("Lost Contact with Hornet " .. unitname .. "  Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30)
    end
  elseif unitname.text:lower():find("N ALERT Hornet") then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
      stnhornet = stnhornet - 1
      if stnhornet < 0 then
        stnhornet = 0
      end
      trigger.action.setUserFlag(EventData.IniUnitName,100)
      sendmsg("Lost Contact with Hornet " .. unitname .. " Slot Locked until Restart Forrestal has " ..stnhornet .. " Hornets remaining",30)
    end
  elseif unitname.text:lower():find("N ALERT TomCat") then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
      stncat = stncat - 1
      if stncat < 0 then
        stncat = 0
      end
      trigger.action.setUserFlag(EventData.IniUnitName,100)
      sendmsg("Lost Contact with Cat " .. unitname .. " Slot Locked until Restart Forrestal has " .. stncat .. " Tomcats remaining",30)
        end
  elseif unitname.text:lower():find("SC ALERT Hornet") then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
      tdyhornet = tdyhornet - 1
      if tdyhornet < 0 then
        tdyhornet = 0
      end
      trigger.action.setUserFlag(EventData.IniUnitName,100)
      sendmsg("Lost Contact with Hornet " .. unitname .. " Slot Locked until Restart Forrestal has " ..tdyhornet .. " Hornets remaining",30)
    end
  elseif unitname.text:lower():find("SC ALERT TomCat") then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
      tdycat = tdycat - 1
      if tdycat < 0 then
        tdycat = 0
      end
      trigger.action.setUserFlag(EventData.IniUnitName,100)
      sendmsg("Lost Contact with Cat " ..unitname .. " Slot Locked until Restart Teddy has " .. tdycat .. " Tomcats remaining",30)
    end  
  elseif unitname.text:lower():find("SC RAMP Hornet") then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
      tdyhornet = tdyhornet - 1
      if tdyhornet < 0 then
        tdyhornet = 0
      end
      if tdyhornet == 0 then
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        sendmsg("Lost Contact with Hornet " ..unitname .. "  Slot Locked until Restart Teddy has " .. tdyhornet .. " Hornets remaining",30)
      else
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        sendmsg("Lost Contact with Hornet " ..unitname .. "  Slot Locked for 15 seconds Teddy has " .. tdyhornet .. " Hornets remaining",30)
        SCHEDULER:New(nil,function() 
          sendmsg("Hornet " ..unitname .. "   Slot UnLocked Teddy has " .. tdyhornet .. " Hornets remaining",30)
          trigger.action.setUserFlag(EventData.IniUnitName,00)
        end,{},15)
      end
    end
  elseif unitname.text:lower():find("SC RAMP Tomcat") then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
      tdycat = tdycat - 1
      if tdycat < 0 then
        tdycat = 0
      end
      if tdycat == 0 then
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        sendmsg("Lost Contact with TomCat " ..unitname .. " Slot Locked until Restart Teddy has " .. tdycat .. " TomCats remaining",30)
      else
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        sendmsg("Lost Contact with TomCat " ..unitname .. " Slot Locked for 15 seconds Teddy has " .. tdycat .. " TomCats remaining",30)
        SCHEDULER:New(nil,function() 
          sendmsg("TomCat " ..unitname .. " Slot UnLocked Teddy has " .. tdycat .. " TomCats remaining",30)
          trigger.action.setUserFlag(EventData.IniUnitName,00)
        end,{},15)
      end
    end
  elseif unitname.text:lower():find("N RAMP Hornet") then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
      stnhornet = stnhornet - 1
      if stnhornet < 0 then
        stnhornet = 0
      end
      if stnhornet == 0 then
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        sendmsg("Lost Contact with Hornet " ..unitname .. " Slot Locked until Restart Stennis has " .. stnhornet .. " Hornets remaining",30)
      else
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        sendmsg("Lost Contact with Hornet " ..unitname .. " Slot Locked for 15 seconds Stennis has " .. stnhornet .. " Hornets remaining",30)
        SCHEDULER:New(nil,function() 
          sendmsg("Hornet " ..unitname .. " Slot UnLocked Stennis has " .. stnhornet .. " Hornets remaining",30)
          trigger.action.setUserFlag(EventData.IniUnitName,00)
        end,{},15)
      end
    end
  elseif unitname.text:lower():find("N RAMP TomCat") then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
      stncat = stncat - 1
      if stncat < 0 then
        stncat = 0
      end
      if stncat == 0 then
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        sendmsg("Lost Contact with TomCat " ..unitname .. " Slot Locked until Restart Stennis has " .. stncat .. " TomCats remaining",30)
      else
        trigger.action.setUserFlag(EventData.IniUnitName,100)
        sendmsg("Lost Contact with TomCat " ..unitname .. " Slot Locked for 15 seconds Stennis has " .. stncat .. " TomCats remaining",30)
        SCHEDULER:New(nil,function() 
          sendmsg("TomCat " ..unitname .. " Slot UnLocked Stennis has " .. stncat .. " TomCats remaining",30)
          trigger.action.setUserFlag(EventData.IniUnitName,00)
        end,{},15)
      end
    end
  elseif unitname.text:lower():find("Turkey") then
    if  trigger.misc.getUserFlag(EventData.IniUnitName) ~= 100 then
      trigger.action.setUserFlag(EventData.IniUnitName,100)
      sendmsg("Lost Contact with Turkey unit " ..unitname .. ", slot locked for 60 seconds",30)
      turkey = turkey - 1
      if turkey > 0 then
        SCHEDULER:New(nil,function()
          sendmsg("Turkey unit " ..unitname .. " is now unlocked, we have ".. turkey .. "F16's remaining",30)
          trigger.action.setUserFlag(EventData.IniUnitName,00)
        end,{},60)
      else
        sendmsg("No Turkish units remain! Slot will remain locked.",30)
      end
    end
  end
end


function Slothandler:OnEventPilotDead(EventData)
  rlog({EventData})
  -- Lock that unit out so it can no longer be used.
  rlog({EventData.IniUnitName,"Pilot Dead"})
  slotlocker(EventData)
end

function Slothandler:OnEventCrash(EventData)
  rlog({EventData})
  -- Lock that unit out so it can no longer be used.
  rlog({EventData.IniUnitName,"Crash"})
  slotlocker(EventData)
 end

function Slothandler:OnEventEjection(EventData)
  rlog({EventData})
  -- Lock that unit out so it can no longer be used.
  rlog({EventData.IniUnitName,"Ejection"})
  slotlocker(EventData)
end

function Slothandler:OnEventDead(EventData)
  rlog({EventData})
  -- Lock that unit out so it can no longer be used.
  rlog({EventData.IniUnitName,"Dead"})
  slotlocker(EventData)
end


function startinitattack()
  rlog({"Start Initial Attack"})
  IA1:Respawn()
  IA1:Activate()
  IA2:Respawn()
  IA2:Activate()
  FA1:Respawn()
  FA1:Activate()
  FA2:Respawn()
  FA2:Activate()
end

-- Start up the Mission.
function CarrierStart()
  rlog({"Carrier Start Called"})
  -- reset the sqn count.
  resetsqncount()
  -- set the wave time to match.
  cdcwavetime = cdwavetime
  -- reset fighters and bombers.

  fightersnum = 0
  bombernum = 0
  spawncarriers()
  
  buildstartedmenu()
  
  sendmsg("WARNING! Carrier Defence Mission will begin in 2 MINUTES, CAP & Turkey Slots Unlocked \n Alert & Non Alert Slots Unlock in 2 minutes",60)
  sendmsg("Carrier Air Wing Status \n CVN 71 Theodore Roosevelt \n Hornet: ".. tdyhornet .." Airframes \n TomCat: "..tdycat.." \n USS Forrestal \n Hornet: ".. stnhornet .." Airframes \n TomCat: "..stncat.."",60)
  sendmsg("Destruction of Airframes will result in loses, if you have 0 left then you will no longer be able to spawn",60)
  -- start initail attackers
  startinitattack()
  unlockcapslots()
    lockalertslots()
    lockrampslots()
  -- set mission as active
  cdactive = true
  -- start the timer to unlock the alert slots
  mtimer = SCHEDULER:New(nil,function()
    unlockalertslots()
    rlog("Alert Slots Are now active")
  end,{},60)
  -- Start the timer for the ramp slots
  ctimer = SCHEDULER:New(nil,function() 
    unlockrampslots()
        rlog({"Slots Unlocked Starting Mission"})
        for i = 1, 6, 1 do
      local s = math.random(1,2)
      if s == 1 then
        spawnrandombomber()
      else
        spawnrandomfighter()
      end
    end
    BASE:E({bombernum,fightersnum})
    init = true
    sendmsg("next Wave " .. cdcurrentwave .. " of " .. cdmaxwaves .." will start in " .. cdwavetime .. " minutes",30)
    ctimer = SCHEDULER:New(nil,nwave,{},(cdcwavetime*60))
  end,{},(60*2))
end

function lockallslots()
  if cdactive == false then
    lockalertslots()
    lockcapslots()
    lockrampslots()   
    rlog({"ALL SLOTS SHOULD BE LOCKED"})
    sendmsg("All Non Set up Slots are Locked",30)
  else
    rlog({"Lock Out was scheduled but we are active, not locking out"})
  end
end

function destroyallai()
  rlog("Destroy all AI called")
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

end

function CarrierStop()
  rlog({"Carrier Stop Called"})
  sendmsg("Stopping Carrier Defence Mission At this time, Removing all Spawns \n Carrier will despawn in 15 minutes & All Slots will lock unless a new round is started.",30)
  ctimer:Stop()
  destroyallai()
  despawncarriertimer = SCHEDULER:New(nil,despawncarriers,{},(60*15))
  BASE:E({"SCHEDULERS SHOULD BE STOPPED"})
  init = false
  cdactive = false
  cdcwavetime = cdwavetime  
  cdcurrentwave = 1
  sendmsg("All Wave Spawns Should now be destroyed",30)
  buildrestoppedmenu()
  rlog({"START MENU SHOULD BE BACK, STOP COMPLETED"})
end

function checkfighters()
  rlog({"Updating Fighter list",fightersnum})
  local ftemp = {}
  for k,v in pairs (fighterspawns) do
    if v:IsAlive() ~= true then
      rlog("fighter was not alive removing from the list")
      fightersnum = fightersnum - 1
      if fightersnum < 0 then 
        fightersnum = 0
      end
    else
      if v:AllOnGround() == true then
        v:Destroy()
        rlog("fighters were on the ground")
        fightersnum = fightersnum - 1
        if fightersnum < 0 then 
          fightersnum = 0
        end
      else
        rlog("fighter was alive moving to the temp list")
        table.insert(ftemp,v)
      end
    end
  end
    rlog({"fighters are all done updating fighter spawn list with temp list",fightersnum})
  fighterspawns = ftemp
end
function checkbombers()
  rlog({"Updating Bomber list",bombernum})
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
          rlog("cinbers were on the ground")
          bombernum = bombernum - 1
          if bombersnum < 0 then 
            bombernum = 0
          end
        else
          BASE:E("bomber was alive moving to the temp list")
          table.insert(btemp,v)
        end
      end
    end
    rlog({"Bombers list done, updating spawn list with new data",bombernum})
  bomberspawns = btemp
end

function nwave()
  rlog({"nextwave called"})
  nextwave()
end

function nextwave()
  rlog({"Inside Nextwave"})
  cdcurrentwave = cdcurrentwave + 1
  cdcwavetime = cdcwavetime - cdwavereduction
  if cdcwavetime < 5 then
    cdcwavetime = 5
  end
  
  checkfighters()
    checkbombers()

    rlog({"Spawning New Fighters balive is:",balive})
    -- fighter spawns
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
    rlog({"Fighter SpawnTime snumber is:",snumber})
    for i = 1, snumber, 1 do
     spawnrandomfighter()
    end
  
  -- BOMBER SPAWNS
  rlog({"Spawning New Bombers balive is:",balive})
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
    rlog({"Bomber SpawnTime snumber is:",snumber})
  
    for i = 1, snumber, 1 do
     spawnrandombomber()
    end
  
  rlog("Wave check")
    if cdcurrentwave >= cdmaxwaves then
      sendmsg("Max Waves of " .. cdmaxwaves .. " Reached Stopping Mission in 120 minutes",30)
      ctimer = SCHEDULER:New(nil,CarrierStop,{},(120*60))
    else
      sendmsg("next Wave " .. cdcurrentwave .. " of " .. cdmaxwaves .." will start in " .. cdwavetime .. " minutes",30)
      ctimer = SCHEDULER:New(nil,nwave,{},(cdcwavetime*60))
    end
end


-- Main Menu Command set.


function dincrease()
  if cdactive == false then
    Divider = Divider + 1
    sendmsg("Difficulty Divider Increased by 1 to ".. Divider .." Remember Higher = less difficult",15)
    buildstoppedmenu()
  else
    sendmsg("Unable, Mission is Active at the current time",15)
  end
end

function ddecrease()
  if cdactive == false then
    Divider = Divider - 1
    if Divider == 0 then
      Divider = 1
    end
    sendmsg("Difficulty Divider Decreased by 1 to ".. Divider .." Remember Higher = less difficult",15)
    buildstoppedmenu()
  else
    sendmsg("Unable, Mission is Active at the current time",15)
  end
end

function wincrease()
  if cdactive == false then
    cdmaxwaves = cdmaxwaves + 1
    sendmsg("Max Waves Increased by 1 to ".. cdmaxwaves .."",15)
    buildstoppedmenu()
  else
    sendmsg("Unable, Mission is Active at the current time",15)
  end
end

function wdecrease()
  if cdactive == false then
    cdmaxwaves = cdmaxwaves - 1
    if cdmaxwaves < 1 then
      cdmaxwaves = 1
      sendmsg("Unable to reduce waves below 1",15)
    else
      sendmsg("Max Waves decreased by 1 to " ..cdmaxwaves .. "",15)
    end
    buildstoppedmenu()
  else
    sendmsg("Unable, Mission is Active at the current time",15)
  end
end

function tincrease()
  if cdactive == false then
    cdwavetime = cdwavetime + 1
    sendmsg("Wave Time Increased by 1 minute to ".. cdwavetime .. "",15)
    buildstoppedmenu()
  else
    sendmsg("Unable, Mission is Active at the current time",15)
  end
end

function tdecrease()
  if cdactive == false then
    cdwavetime = cdwavetime - 1
    if cdwavetime < 5 then
      cdwavetime = 5
      sendmsg("Wave time can not be reduced below 5 minutes",15)
    end
    sendmsg("Wave Time Decreased by 1 minute to ".. cdwavetime .. "",15)
    buildstoppedmenu()
  else
    sendmsg("Unable, Mission is Active at the current time",15)
  end
end

-- Spawning Random Fighters 
function spawnrandomfighter()
  rlog({"Spawn Random Fighter"})
  fightersnum = fightersnum + 1
  local rnd = math.random(1,3)
  local spawner = SPAWN:NewWithAlias("Fighter_Spawn1","Fighter" .. fightersnum)
      :InitRandomizeTemplate(fighters)
      :InitRandomizePosition(true,30000,1000)
      :InitRandomizeRoute(1,4,math.random(100,5000),math.random(0,1000))
  if rnd == 1 then
    rlog({"Fighter Spawn 1"})
    spawner = SPAWN:NewWithAlias("Fighter_Spawn1","Fighter" .. fightersnum)
    :InitRandomizeTemplate(fighters)
    :InitRandomizePosition(true,30000,1000)
    :InitRandomizeRoute(1,4,math.random(100,5000),math.random(0,1000))
  elseif rnd == 2 then
    rlog({"Fighter Spawn 2"})
    spawner = SPAWN:NewWithAlias("FIGHTER_SPAWN2","Fighter" .. fightersnum)
    :InitRandomizeTemplate(fighters)
    :InitRandomizePosition(true,30000,1000)
    :InitRandomizeRoute(1,4,15000,1000)
  elseif rnd == 3 then
    rlog({"Fighter Spawn 3"})
    spawner = SPAWN:NewWithAlias("FIGHTER_SPAWN3","Fighter" .. fightersnum)
    :InitRandomizeTemplate(fighters)
    :InitRandomizePosition(true,30000,1000)
    :InitRandomizeRoute(1,4,math.random(100,5000),math.random(0,1000))
  else 
    rlog({"Fighter Spawn other"})
    spawner = SPAWN:NewWithAlias("Fighter_Spawn1","Fighter" .. fightersnum)
    :InitRandomizeTemplate(fighters)
    :InitRandomizePosition(true,30000,1000)
    :InitRandomizeRoute(1,4,math.random(100,5000),math.random(0,1000))
  end
  rlog({"Fighter Spawn Spawning"})
  local spawned = spawner:Spawn()
  table.insert(fighterspawns,spawned)
end

-- Spawn Random Bomber.
function spawnrandombomber()
  rlog({"Bomber Spawn"})
  bombernum = bombernum + 1
  local rnd = math.random(1,3)
  local spawner = SPAWN:NewWithAlias("Bear_SP1","Bomber" .. bombernum)
      :InitRandomizeTemplate(bombers)
      :InitRandomizePosition(true,30000,1000)
      :InitRandomizeRoute(1,4,math.random(100,2000),math.random(0,1000))
  if rnd == 1 then
    rlog({"Bomber Spawn 1"})
    spawner = SPAWN:NewWithAlias("Bear_SP1","Bomber" .. bombernum)
    :InitRandomizeTemplate(bombers)
    :InitRandomizePosition(true,30000,1000)
    :InitRandomizeRoute(1,4,math.random(100,2000),math.random(0,1000))
  elseif rnd == 2 then
    rlog({"Bomber Spawn 2"})
    spawner = SPAWN:NewWithAlias("Bear_SP2","Bomber" .. bombernum)
    :InitRandomizeTemplate(bombers)
    :InitRandomizePosition(true,30000,2000)
    :InitRandomizeRoute(1,4,25000,1000)
  elseif rnd == 3 then
    rlog({"Bomber Spawn 3"})
    spawner = SPAWN:NewWithAlias("Bear_SP3","Bomber" .. bombernum)
    :InitRandomizeTemplate(bombers)
    :InitRandomizePosition(true,35000,2000)
    :InitRandomizeRoute(1,4,math.random(100,5000),math.random(0,1000))
  else 
    rlog({"Bomber Spawn other"})
    spawner = SPAWN:NewWithAlias("Bear_SP1","Bomber" .. bombernum)
    :InitRandomizeTemplate(bombers)
    :InitRandomizePosition(true,35000,1000)
    :InitRandomizeRoute(1,4,math.random(100,5000),math.random(0,1000))
  end
    local spawned = spawner:Spawn()
  table.insert(bomberspawns,spawned)
end

-- returns the current State of the Air Wings.
function getwingstate()
  local msg = "Carrier Air Wing Status \n CVN 71 Theodore Roosevelt \n Hornet: ".. tdyhornet .." Airframes \n TomCat: "..tdycat.." \n USS Forrestal \n Hornet: ".. stnhornet .." Airframes \n TomCat: "..stncat.." \n Turkey has " .. Turkey .. " Fighters remaining"
  sendmsg(msg,60)
end

-- Returns difficulty Information.
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
  sendmsg("Current Difficulty is as follows \n " .. fighterinfo .. "\n" .. bomberinfo .. "\n Mission is on Wave: " .. cdcurrentwave .. " of " .. cdmaxwaves .. "\n Current time between waves is:" ..cdcwavetime.. " minutes",15)
  getwingstate()
end
  
  
-- Menu should look like this
-- - Carrier Defence
-- | - Setup*
-- | | - Wave Time: ## Minutes
-- | | - Number of Waves: #
-- | | - Difficulty Divider: #
-- | | - Adjust Waves
-- | | | - Increase Max Waves
-- | | | - Decrease Max Waves
-- | | | - Increase Waves Time
-- | | | - Decrease Waves Time
-- | | - Adjust Difficulty
-- | | | - Increase Divider
-- | | | - Decrease Divider
-- | - Get Mission Update
-- | - Get CV Wing Update
-- | - Start/Stop
--
-- Set up should be removed when mission is started.

function buildmainmenu()
  rlog({"Building Menu for the first time"})
  mmenu = MENU_COALITION:New(coalition.side.BLUE,"Carrier Defence")
  -- |
    mmenu1 = MENU_COALITION:New(coalition.side.BLUE,"Setup",mmenu)
    -- |
      mmenu2 = MENU_COALITION:New(coalition.side.BLUE,"Wave Time:" .. cdwavetime .. " Minutes",mmenu1)
      mmenu2a = MENU_COALITION:New(coalition.side.BLUE,"Number of Waves:" .. cdmaxwaves,mmenu1)
      mmenu2b = MENU_COALITION:New(coalition.side.BLUE,"Difficulty Divider:" .. Divider .. "",mmenu1)
      mmenu2c = MENU_COALITION:New(coalition.side.BLUE,"Adjust Waves",mmenu1)
      -- |
        mmenu3a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Increase Max Waves",mmenu2c,wincrease)
        mmenu3b = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Decrease Max Waves",mmenu2c,wdecrease)
        mmenu3c = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Increase Wave Time",mmenu2c,tincrease)
        mmenu3d = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Decrease Wave Time",mmenu2c,tdecrease)
      mmenu2e = MENU_COALITION:New(coalition.side.BLUE,"Adjust Difficulty",mmenu1)
      -- |
        mmenu4a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Increase Divider",mmenu2e,dincrease)
        mmenu4b = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Decrease Divider",mmenu2e,ddecrease)
    mmenu1a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Get Mission Update",mmenu,getdifficulty,{})
    mmenu1b = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Get CV Wing Update",mmenu,getwingstate,{})
    mmenu1c = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Start",mmenu,CarrierStart,{})
end

function buildstoppedmenu()
  rlog({"Building stopped menu"})
  -- Remove all existing menus.
  if mmenu4a ~= nil then
    mmenu4a:Remove()
  end
  if mmenu4b ~= nil then
    mmenu4b:Remove()
  end
  if mmenu3a ~= nil then
    mmenu3a:Remove()
  end
  if mmenu3b ~= nil then
    mmenu3b:Remove()
  end
  if mmenu3c ~= nil then
    mmenu3c:Remove()
  end
  if mmenu3d ~= nil then
    mmenu3d:Remove()
  end
  if mmenu2 ~= nil then
    mmenu2:Remove()
  end
  if mmenu2a ~= nil then
    mmenu2a:Remove()
  end
  if mmenu2b ~= nil then
    mmenu2b:Remove()
  end
  if mmenu2c ~= nil then
    mmenu2c:Remove()
  end
  if mmenu2d ~= nil then
    mmenu2d:Remove()
  end
  if mmenu2e ~= nil then
    mmenu2e:Remove()
  end
  if mmenu1 ~= nil then
    mmenu1:Remove()
  end
  if mmenu1a ~= nil then
    mmenu1a:Remove()
  end
  if mmenu1b ~= nil then
    mmenu1b:Remove()
  end
  if mmenu1c ~= nil then
    mmenu1c:Remove()
  end
  -- build the menu.
  mmenu1 = MENU_COALITION:New(coalition.side.BLUE,"Setup",mmenu)
    -- |
      mmenu2 = MENU_COALITION:New(coalition.side.BLUE,"Wave Time:" .. cdwavetime .. " Minutes",mmenu1)
      mmenu2a = MENU_COALITION:New(coalition.side.BLUE,"Number of Waves:" .. cdmaxwaves,mmenu1)
      mmenu2b = MENU_COALITION:New(coalition.side.BLUE,"Difficulty Divider:" .. Divider .. "",mmenu1)
      mmenu2c = MENU_COALITION:New(coalition.side.BLUE,"Adjust Waves",mmenu1)
      -- |
        mmenu3a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Increase Max Waves",mmenu2c,wincrease)
        mmenu3b = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Decrease Max Waves",mmenu2c,wdecrease)
        mmenu3c = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Increase Wave Time",mmenu2c,tincrease)
        mmenu3d = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Decrease Wave Time",mmenu2c,tdecrease)
      mmenu2e = MENU_COALITION:New(coalition.side.BLUE,"Adjust Difficulty",mmenu1)
      -- |
        mmenu4a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Increase Divider",mmenu2e,dincrease)
        mmenu4b = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Decrease Divider",mmenu2e,ddecrease)
  mmenu1a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Get Mission Update",mmenu,getdifficulty,{})
  mmenu1b = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Get CV Wing Update",mmenu,getwingstate,{})
  mmenu1c = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Start",mmenu,CarrierStart,{})
end

function buildrestoppedmenu()
  rlog({"Building stopped menu"})
  -- Remove all existing menus.
  if mmenu1a ~= nil then
    mmenu1a:Remove()
  end
  if mmenu1b ~= nil then
    mmenu1b:Remove()
  end
  if mmenu1c ~= nil then
    mmenu1c:Remove()
  end
  -- build the menu.
  mmenu1 = MENU_COALITION:New(coalition.side.BLUE,"Setup",mmenu)
    -- |
      mmenu2 = MENU_COALITION:New(coalition.side.BLUE,"Wave Time:" .. cdwavetime .. " Minutes",mmenu1)
      mmenu2a = MENU_COALITION:New(coalition.side.BLUE,"Number of Waves:" .. cdmaxwaves,mmenu1)
      mmenu2b = MENU_COALITION:New(coalition.side.BLUE,"Difficulty Divider:" .. Divider .. "",mmenu1)
      mmenu2c = MENU_COALITION:New(coalition.side.BLUE,"Adjust Waves",mmenu1)
      -- |
        mmenu3a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Increase Max Waves",mmenu2c,wincrease)
        mmenu3b = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Decrease Max Waves",mmenu2c,wdecrease)
        mmenu3c = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Increase Wave Time",mmenu2c,tincrease)
        mmenu3d = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Decrease Wave Time",mmenu2c,tdecrease)
      mmenu2e = MENU_COALITION:New(coalition.side.BLUE,"Adjust Difficulty",mmenu1)
      -- |
        mmenu4a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Increase Divider",mmenu2e,dincrease)
        mmenu4b = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Decrease Divider",mmenu2e,ddecrease)
  mmenu1a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Get Mission Update",mmenu,getdifficulty,{})
  mmenu1b = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Get CV Wing Update",mmenu,getwingstate,{})
  mmenu1c = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Start",mmenu,CarrierStart,{})
end

function buildstartedmenu()
  rlog("Building startedmenu")
    -- Remove all existing menus.
  if mmenu4a ~= nil then
    mmenu4a:Remove()
  end
  if mmenu4b ~= nil then
    mmenu4b:Remove()
  end
  if mmenu3a ~= nil then
    mmenu3a:Remove()
  end
  if mmenu3b ~= nil then
    mmenu3b:Remove()
  end
  if mmenu3c ~= nil then
    mmenu3c:Remove()
  end
  if mmenu3d ~= nil then
    mmenu3d:Remove()
  end
  if mmenu2 ~= nil then
    mmenu2:Remove()
  end
  if mmenu2a ~= nil then
    mmenu2a:Remove()
  end
  if mmenu2b ~= nil then
    mmenu2b:Remove()
  end
  if mmenu2c ~= nil then
    mmenu2c:Remove()
  end
  if mmenu2d ~= nil then
    mmenu2d:Remove()
  end
  if mmenu2e ~= nil then
    mmenu2e:Remove()
  end
  if mmenu1 ~= nil then
    mmenu1:Remove()
  end
  if mmenu1a ~= nil then
    mmenu1a:Remove()
  end
  if mmenu1b ~= nil then
    mmenu1b:Remove()
  end
  if mmenu1c ~= nil then
    mmenu1c:Remove()
  end
  mmenu1a = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Get Mission Update",mmenu,getdifficulty,{})
  mmenu1b = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Get CV Wing Update",mmenu,getwingstate,{})
  mmenu1c = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Stop",mmenu,CarrierStop,{})
end


-- inital Game Start Stuff.

lockallslots()
buildmainmenu()
spawncarriers()

rlog("Game LUA loaded")