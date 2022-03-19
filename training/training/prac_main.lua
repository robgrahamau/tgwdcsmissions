 BASE:E({"TRAINING MISSION START"})
PlayerBMap = {}
clients = SET_CLIENT:New():FilterActive(true):FilterStart() -- look at clients
arco = GROUP:FindByName("ARC")
arco = SPAWN:New("ARC"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
tex = GROUP:FindByName("TEX")
tex = SPAWN:New("TEX"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
shell = GROUP:FindByName("SHELL")
shell = SPAWN:New("SHELL"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
overlord = GROUP:FindByName("Overlord")
overlord = SPAWN:New("Overlord"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
attacker = GROUP:FindByName("Attacker")
attacker2 = GROUP:FindByName("Attacker2")
attacker3 = GROUP:FindByName("Attacker3")
livefire = GROUP:FindByName("ActiveFire")
moving = GROUP:FindByName("Ground-1")
SPAWNZONE = ZONE_POLYGON:New("Spawn",GROUP:FindByName("SpawnArea"))
SPAWNZONE2 = ZONE:New("SpawnZone2")
staticdef1 = GROUP:FindByName("Static_Def")
staticdef2 = GROUP:FindByName("Static_Def_2")
target1 = STATIC:FindByName("target1",false)
target2 = STATIC:FindByName("target2",false)
AFAC = GROUP:FindByName("AFAC")
BIC = GROUP:FindByName("InContact2")
RIC = GROUP:FindByName("InContact")
Ehandler = EVENTHANDLER:New()
Ehandler:HandleEvent(EVENTS.Dead)
bgroundd15 = nil
bground15 = nil
bground10 = nil
bgroundd10 = nil
blive = nil
blive1 = nil
blived = nil
incontact = nil
afac = true
afacspawn = nil
bairspawn = nil
bairspawn2 = nil
bairspawn3 = nil
blivespawn = nil
bairdestroy = nil
bairdestroy2 = nil
bairdestroy3 = nil
blivedestroy = nil
attackerspawn = false
attackerspawn2 = false
attackerspawn3 = false
sa10spawn = false
sa15spawn = false
carrierspawn = false
livespawn = false
incontacspawn = false
SupportHandler = EVENTHANDLER:New()
SupportHandler:HandleEvent(EVENTS.LandingQualityMark)
cruisergroup = GROUP:FindByName("Crusier")
sg1 = GROUP:FindByName("ShipGroup1")
sg2 = GROUP:FindByName("ShipGroup2")
sg3 = GROUP:FindByName("ShipGroup3")
scud1 = GROUP:FindByName("SCUD1")
scud2 = GROUP:FindByName("SCUD2")
scud3 = GROUP:FindByName("SCUD3")
scud4 = GROUP:FindByName("SCUD4")
scud5 = GROUP:FindByName("SCUD5")
scud6 = GROUP:FindByName("SCUD6")
scuds = nil
scudm = nil
scudmenu = nil
removescud = nil
function spawnrandomscud()
  local i = math.random(1,6)
  u = "SCUD" .. i
  if scuds ~= nil then
    if scudm ~= nil then
      COORDINATE:RemoveMark(scudm)
    end
    scuds:Destroy()
  end
  scuds = SPAWN:New(u):Spawn()
  local coord = scuds:GetCoordinate()
  local zg = ZONE_GROUP:New("SCUD",scuds,20000)
  local nc = zg:GetRandomCoordinate(1000,20000)
  scudm = nc:MarkToAll("Possible Scud Location Search the area",true)
  MESSAGE:New("Possible SCUD located at this point " .. nc:ToStringLLDMS() .. " \n " .. nc:ToStringLLDDM() .. " \n" .. nc:ToStringMGRS() .. "\n ",30):ToAll()
  scudmenu:Remove()
  scudmenu = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"ReMove Scuds",b_menu,removescud,{})
end

function removescud()
  if scuds ~= nil then
    scuds:Destroy()
    if scudm ~= nil then
      COORDINATE:RemoveMark(scudm)
    end
  end
  scudmenu = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn Scuds",b_menu,spawnrandomscud,{})
end

function _randommessage(unit)
  message = "" .. unit .. "Despawned"
  randommessage = math.random(1,21)
  if randommessage == 1 then
    message = "" .. unit .. " Threat Should be gone, we didn't use a disintegrator honest!"
  elseif randommessage == 2 then
    message = "" .. unit .. " that were spawned just vanished, no one saw the portal gun right?"
  elseif randommessage == 3 then
    message = "" .. unit .. " Threat has been TERMINATED, they really should have preflighted"
  elseif randommessage == 4 then
    message = "Ah Scotty are those " .. unit .. " meant to come through the transporter looking like that?"
  elseif randommessage == 5 then
    message = "Man who'd have thought that vibrating those " .. unit .. " at that frequency would do that!"
  elseif randommessage == 6 then
    message = "Ah did those " .. unit .. " just shoot...Ok Who put Boozer in charge of their training?"
  elseif randommessage == 7 then
    message = "Well we did tell " .. unit .. " Don't touch the Red Button"
  elseif randommessage == 7 then
    message = "" .. unit .. " Threat has been... Sanatized"
  elseif randommessage == 8 then  
    message = "Hey boss those ".. unit .. " we had out on a Fam flight? They just vanished, were not in Bamuta right?"
  elseif randommessage == 9 then 
   message = "Those ".. unit .." just vanished boss, their last communication reported a strange black Rectangle then 'My God.. It's full of stars"
  elseif randommessage == 10 then
    message = "" .. unit .. "last transmission: 'The Sleeper Must Awaken"
  elseif randommessage == 11 then
    message = "Ah those " ..unit.." just vanished into a bright blue glow... reports of a Flying British Police Phone Box, Nah they must be drunk"
  elseif randommessage == 12 then
    message = "" ..unit .. ": have reported for Heresy against the Emperor..\n Inquisitional ruling Exterminatus..\n Ruling Executed"
  elseif randommessage == 13 then
    message = "" ..unit .. ": We Lived for the One, We Die For the One.. Entil'Zha\n"
  elseif randommessage == 14 then
    message = "" ..unit .. ": 'We are all Kosh' ... what the hell does that mean?"
  elseif randommessage == 15 then
    message = "" ..unit .. " just self terminated, last transmission 'Does this unit.. have a soul Tali'Vas'Normandy?"
  elseif randommessage == 16 then
    message = ""..unit .. ": No one would have believed that in the last years of the 19th century that human affairs where being watched from the timeless worlds of space"
  elseif randommessage == 17 then
    message = ""..unit .. ": You have control Lt. Fuki"
  elseif randommessage == 18 then
    message = ""..unit .. ": last transmission 'Oli, Oli, Oxen Free"
  elseif randommessage == 19 then
    message = ""..unit .. ": Just Ctrl.. Alt.. Deleted"
  elseif randommessage == 20 then
    message = ""..unit .. ": Game Over man.. Game Over!"
  elseif randommessage == 21 then
    message = ""..unit .. ": Alt-F4 to bring up the map ? ...ok ....Alt...and F.........\n User " ..unit.. " has left the channel"
  end
  return message
end

---@param self
--@param Core.Event#EVENTDATA EventData
function Ehandler:OnEventDead(EventData)
  BASE:E({EventData.IniGroupName})
  if EventData.IniGroupName == cruisergroup:GetName() then
    MESSAGE:New("Cruiser Group was destroyed, New Cruiser in 15 minutes",30,"Training Command"):ToAll()
    SCHEDULER:New(nil,function() 
        cruisergroup = SPAWN:New("Crusier"):Spawn()
        MESSAGE:New("New Cruiser is Active",30,"Training Command"):ToAll()
      end,{},(60*15))  
  end 
  if EventData.IniGroupName == sg1:GetName() then
    MESSAGE:New("Oil Tanker was destroyed, New tanker in 15 minutes",30,"Training Command"):ToAll()
    SCHEDULER:New(nil,function() 
        sg1 = SPAWN:New("ShipGroup1"):Spawn()
        MESSAGE:New("New Tanker Group is Active",30,"Training Command"):ToAll()
      end,{},(60*15))  
  end
  if EventData.IniGroupName == attacker:GetName() then
    MESSAGE:New("Registed a Kill on Attacker 1",30,"Training Command"):ToAll()
  end
  if EventData.IniGroupName == attacker2:GetName() then
    MESSAGE:New("Registed a Kill on Attacker 2",30,"Training Command"):ToAll()
  end
    if EventData.IniGroupName == attacker3:GetName() then
    MESSAGE:New("Registed a Kill on Attacker 3",30,"Training Command"):ToAll()
  end
  if EventData.IniGroupName == sg2:GetName() then
    MESSAGE:New("Oil Tanker was destroyed, New tanker in 15 minutes",30,"Training Command"):ToAll()
    SCHEDULER:New(nil,function() 
        sg2 = SPAWN:New("ShipGroup2"):Spawn()
        MESSAGE:New("New Tanker Group is Active",30,"Training Command"):ToAll()
      end,{},(60*15))  
  end
  if EventData.IniGroupName == sg3:GetName() then
    MESSAGE:New("Oil Tanker was destroyed, New tanker in 15 minutes",30,"Training Command"):ToAll()
    SCHEDULER:New(nil,function() 
        sg3 = SPAWN:New("ShipGroup3"):Spawn()
        MESSAGE:New("New Tanker Group is Active",30,"Training Command"):ToAll()
      end,{},(60*15))  
  end
  if EventData.IniGroupName == arco:GetName() then
    MESSAGE:New("ARCO was destroyed, New tanker in 1 minute",30,"Training Command"):ToAll()
    SCHEDULER:New(nil,function() 
        arco = SPAWN:New("ARC"):Spawn()
        MESSAGE:New("New ARCO is Active",30,"Training Command"):ToAll()
      end,{},(60*1))  
  end  
  if EventData.IniGroupName == tex:GetName() then
    MESSAGE:New("TEXACO was destroyed, New tanker in 1 minute",30,"Training Command"):ToAll()
    SCHEDULER:New(nil,function() 
        tex = SPAWN:New("TEX"):Spawn()
        MESSAGE:New("New TEXACO is Active",30,"Training Command"):ToAll()
      end,{},(60*1))  
  end  
  if EventData.IniGroupName == shell:GetName() then
    MESSAGE:New("TEXACO was destroyed, New tanker in 1 minute",30,"Training Command"):ToAll()
    SCHEDULER:New(nil,function() 
        shell = SPAWN:New("SHELL"):Spawn()
        MESSAGE:New("New SHELL is Active",30,"Training Command"):ToAll()
      end,{},(60*1))  
  end  
end
-- handle our ejection

function respawntanker()
  arco:Destroy()
  arco = SPAWN:New("ARC"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
  tex:Destroy()
  tex = SPAWN:New("TEX"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
  shell:Destroy()
  shell = SPAWN:New("SHELL"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
  MESSAGE:New("Tankers should be respawned",15,"Training Command"):ToAll()
end

function spawnafac()
  if afac == true then
    AFAC:Destroy()
  end
    afac = true
    AFAC = SPAWN:New("AFAC"):Spawn()
    MESSAGE:New("Airborn FAC is now active on 123.50, CHEVY 9 \nIt will orbit in the area of the Live fire Zone.",60,"Training Command"):ToAll()
end

function spawnincontact()
  if incontactspawn == true then
    BIC:Destroy()
    RIC:Destroy()
  end
  incontactspawn = true
  BIC = SPAWN:New("InContact2"):Spawn()
  RIC = SPAWN:New("InContact"):Spawn()
  bco = BIC:GetCoordinate()
  rco = RIC:GetCoordinate()
  bddm = bco:ToStringLLDDM()
  bdms = bco:ToStringLLDMS()
  bmgrs = bco:ToStringMGRS()
  bposmessage = "Friendly infantry are in contact at the following position:\n LLDDM: " .. bddm .. "\n LLDMS: " ..bdms .. "\n MGRS:" ..bmgrs .. "\n Friendly Position is now marked with Red Smoke, Hostile Position is Marked With Green Smoke" 
  MESSAGE:New(bposmessage,60,"Training Control"):ToAll()
  rco:SmokeGreen()
  bco:SmokeRed()
  incontact:Remove()
  incontact = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Despawn Troops In Contact",b_menu2,despawnincontact)
end

function despawnincontact()
  if incontactspawn == true then
    BIC:Destroy()
    RIC:Destroy()
    incontactspawn = false
  end
  bposmessage = _randommessage("Troops in contact")
  MESSAGE:New(bposmessage,60,"Training Control"):ToAll()
  incontact:Remove()
  incontact = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn Troops In Contact",b_menu2,spawnincontact)
end



function despawnlive()
  livefire:Destroy()
  livespawn = false
  MESSAGE:New("Live Fire Hostile Ground units should now be terminated please ignore the bodies, blood and oh we used te disintegrator on the live ones? ah.. you dind't hear that!",30,"Training Command"):ToAll()
  blived:Remove()
  blive1:Remove()
  blive = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn Livefire Units",b_menu2,livefirespawn)  
end

function liveposinfo()
  if livespawn == true then
      if livefire:IsAlive() ~= false then
        livepos = livefire:GetCoordinate()
        liveposllddm = livepos:ToStringLLDDM()
        liveposdms = livepos:ToStringLLDMS()
        livemgrs = livepos:ToStringMGRS()
        livepos:SmokeBlue()
        liveposmessage = "Live Fire Group are in and around the following position:\n LLDDM: " .. liveposllddm .. "\n LLDMS: " ..liveposdms .. "\n MGRS:" ..livemgrs .. " Now Marked With Blue Smoke" 
        MESSAGE:New(liveposmessage,60,"Training Control"):ToAll()
      else
        liveposmessage = "Live Fire Group are showing as destroyed, Ignore the bodies there just simulations honest." 
        MESSAGE:New(liveposmessage,60,"Training Control"):ToAll()
      end
  end
end

function livefirespawn()
  if livespawn == false then
    livefire:Destroy()
    livefire = SPAWN:New("ActiveFire"):InitRandomizeZones({SPAWNZONE,SPAWNZONE2}):InitRandomizeUnits(true,150,500):Spawn()
    livepos = livefire:GetCoordinate()
    liveposllddm = livepos:ToStringLLDDM()
    liveposdms = livepos:ToStringLLDMS()
    livemgrs = livepos:ToStringMGRS()
    livepos:SmokeRed()
    liveposmessage = "Live Fire Group are in and around the following position:\n LLDDM: " .. liveposllddm .. "\n LLDMS: " ..liveposdms .. "\n MGRS:" ..livemgrs .. " Now Marked With Red Smoke" 
    MESSAGE:New(liveposmessage,60,"Training Control"):ToAll()
    livespawn = true
    blive1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Request Lifefire Info",b_menu2,liveposinfo)
    blive:Remove()
    blived = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Destroy livefire",b_menu2,despawnlive)
  else
    liveposmessage = "Live Fire Group are Reporting already spawned you shouldn't be able to respawn them until there dead, Ah.. the Holodecks glitching report to Rob!" 
    MESSAGE:New(liveposmessage,60,"Training Control"):ToAll()  
  end
end

function respawnoverlord()
  overlord:Destroy()
  overlord = SPAWN:New("Overlord"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
  MESSAGE:New("Overlord should be respawned",15,"Training Control"):ToAll() 
end
group1 = GROUP:FindByName("group1")
group2 = GROUP:FindByName("group2")
group3 = GROUP:FindByName("group3")
sa15 = GROUP:FindByName("SA15")
sa10 = GROUP:FindByName("SA10")
function respawnground()
  group1:Destroy()
  group1 = SPAWN:New("group1"):Spawn()
  group2:Destroy()
  group2 = SPAWN:New("group2"):Spawn()
  group3:Destroy()
  group3 = SPAWN:New("group3"):Spawn()
  MESSAGE:New("Static Ground Units should be respawned",15,"Training Control"):ToAll()
end

function spawn10()
  sa10:Destroy()
  sa10spawn = true
  sa10 = SPAWN:New("SA10"):Spawn()
  MESSAGE:New("SA10 Spawned at Sukhumi",15,"Training Control"):ToAll()
  bground10:Remove()
  bgroundd10 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Destroy SA10",b_menu2,despawn10)
end
function despawn10()
  sa10:Destroy()
  sa10spawn = false
  MESSAGE:New("SA 10 should be dead",15,"Training Control"):ToAll()
  bgroundd10:Remove()
  bground10 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn SA10",b_menu2,spawn10)
end

function spawn15()
  sa15:Destroy()
  sa15 = SPAWN:New("SA15"):Spawn()
  sa15spawn = true
  MESSAGE:New("SA 10 should be spawned at Sukhumi",15,"Training Control"):ToAll()
  bground15:Remove()
  bgroundd15 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Destroy SA15",b_menu2,despawn15)
  
end
function despawn15()
  sa15:Destroy()
  sa15spawn = false
  bgroundd15:Remove()
  MESSAGE:New("SA 15 should be dead",15,"Training Control"):ToAll()
  bground15 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn SA15",b_menu2,spawn15)
end

function spawnair()
  attacker:Destroy()
  attacker = SPAWN:New("Attacker"):InitRandomizePosition(true,10000,0):InitRandomizeRoute(1,3,10000,1000):InitCleanUp(120):Spawn()
  MESSAGE:New("SU27 x 2 Spawned Near Sochi Heading South along the coast",15,"Training Control"):ToAll()
  bairspawn:Remove()
  attackerspawn = true
  bairdestroy = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Destroy Su27 Air threat",b_menu2,despawnair)
end

function spawnair2()
  attacker2:Destroy()
  attacker2 = SPAWN:New("Attacker2"):InitRandomizePosition(true,10000,0):InitRandomizeRoute(1,3,10000,1000):InitCleanUp(120):Spawn()
  MESSAGE:New("MIG29 x 2 Spawned Near Sochi Heading South along the coast",15,"Training Control"):ToAll()
  bairspawn2:Remove()
  attackerspawn = true
  bairdestroy2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Destroy Mig29 Air threat",b_menu2,despawnair2)
end

function spawnair3()
  attacker3:Destroy()
  attacker3 = SPAWN:New("Attacker3"):InitRandomizePosition(true,10000,0):InitRandomizeRoute(1,3,10000,1000):InitCleanUp(120):Spawn()
  MESSAGE:New("Mig 21 x 4 Spawned Near Sochi Heading South along the coast",15,"Training Control"):ToAll()
  bairspawn3:Remove()
  attackerspawn3 = true
  bairdestroy3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Destroy MIG21 Air threat",b_menu2,despawnair3)
end

function despawnair()
  attacker:Destroy()
  bairdestroy:Remove()
  attackerspawn = false
  message = _randommessage("Su27's")  
  MESSAGE:New(message,15,"Training Control, SU27's"):ToAll()
  bairspawn = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn 2x SU27",b_menu2,spawnair)
end
function despawnair2()
  attacker2:Destroy()
  bairdestroy2:Remove()
  attackerspawn2 = false
  message = _randommessage("MiG-29's")
  MESSAGE:New(message,15,"Training Control MIG29's"):ToAll()
  bairspawn2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn 2x MIG29",b_menu2,spawnair2)
end
function despawnair3()
  attacker3:Destroy()
  bairdestroy3:Remove()
  attackerspawn3 = false
  message = _randommessage("MiG-21's") 
  MESSAGE:New(message,15,"Training Control, MIG21's"):ToAll()
  bairspawn3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn 4x MIG21",b_menu2,spawnair3)
end

movingspawned = false
function spawnmoving()
	if movingspawned == false then
		moving:Respawn()
		moving:Activate()
		MESSAGE:New("Moving Group Spawned heading south along the roads from Sukhumi",60):ToAll()
		movingspawned = true
	else
		if moving:IsAlive() ~= true then
			moving:Respawn()
			moving:Activate()
			MESSAGE:New("Moving Group has been respawned heading south along the roads from Sukhumi",60):ToAll()
		else
			MESSAGE:New("Unable to spawn new moving group, old group still alive, check along the roads from Sukhumi to Zugdidi",60):ToAll()
		end
	end
end

b_menu = MENU_COALITION:New(coalition.side.BLUE,"Spawning Controls")
b_menu2 = MENU_COALITION:New(coalition.side.BLUE,"Live Fire Spawning Controls")
barco = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Respawn Tankers",b_menu,respawntanker)
bover = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Respawn Overlord",b_menu,respawnoverlord)
bground = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Respawn Ground Targets",b_menu,respawnground)
bafac = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn AFAC",b_menu,spawnafac)
bground10 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn SA10",b_menu2,spawn10)
bground15 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn SA15",b_menu2,spawn15)
bairspawn = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn 2x SU27",b_menu2,spawnair)
bairspawn2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn 2x MIG29",b_menu2,spawnair2)
bairspawn3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn 4x MIG21",b_menu2,spawnair3)
blive = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn Livefire Units",b_menu2,livefirespawn)
incontact = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn Troops In Contact",b_menu2,spawnincontact)
scudmenu = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn Scuds",b_menu,spawnrandomscud,{})
mmoving = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn Moving Ground Units",b_menu2,spawnmoving)
  RescueheloStennis = RESCUEHELO:New(UNIT:FindByName("TeddyR"), "Rescue")
  RescueheloStennis:SetHomeBase(AIRBASE:FindByName("Burke"))
  RescueheloStennis:SetTakeoffHot()
  RescueheloStennis:SetRescueOn()
  RescueheloStennis:SetRespawnOn()
  RescueheloStennis:SetTakeoffCold()
  RescueheloStennis:SetRescueHoverSpeed(1)
  RescueheloStennis:Start()
  
  awacsStennis = RECOVERYTANKER:New(UNIT:FindByName("Stennis"), "Magic")
  awacsStennis:SetAWACS(true,true)
  awacsStennis:SetCallsign(CALLSIGN.AWACS.Magic,1)
  awacsStennis:SetTakeoffAir()
  awacsStennis:SetAltitude(20000)
  awacsStennis:SetRadio(262)
  awacsStennis:SetTACAN(4,"MGK")
  awacsStennis:Start()
  
  BASE:E("Stennis Tanker")
  ShellStennis = RECOVERYTANKER:New(UNIT:FindByName("Stennis"), "arco2")
  ShellStennis:SetCallsign(CALLSIGN.Tanker.Arco,2)
  ShellStennis:SetRespawnOn()
  ShellStennis:SetRespawnInAir()
  ShellStennis:SetSpeed(310)
  ShellStennis:SetCallsign(CALLSIGN.Tanker.Shell,1)
  ShellStennis:SetRacetrackDistances(15,10)
  ShellStennis:SetPatternUpdateDistance(10)
  ShellStennis:SetRadio(255)
  ShellStennis:SetModex(911)
  ShellStennis:SetTACAN(9,"SHL")

AirbossTeddy = AIRBOSS:New("TeddyR","Teddy")
AirbossTeddy:SetLSORadio(119.30)
AirbossTeddy:SetMarshalRadio(304)
AirbossTeddy:SetTACAN(65,"X","TDY")
AirbossTeddy:SetICLS(5,"TDY")
AirbossTeddy:SetAirbossNiceGuy(true)
AirbossTeddy:SetMenuRecovery(30,25,false,0)
AirbossTeddy:SetHoldingOffsetAngle(0)
AirbossTeddy:SetDespawnOnEngineShutdown(true)
AirbossTeddy:SetMaxSectionSize(4)
AirbossTeddy:SetPatrolAdInfinitum(true)
AirbossTeddy:SetRefuelAI(30)
AirbossTeddy:SetSoundfilesFolder("Airboss Soundfiles/")
AirbossTeddy:SetRecoveryTurnTime(300)
AirbossTeddy:SetRecoveryTanker(ShellStennis)
AirbossTeddy:SetDefaultPlayerSkill("TOPGUN Graduate")
AirbossTeddy:SetHandleAIOFF()
AirbossTeddy:SetWelcomePlayers(false)
AirbossTeddy:SetDefaultMessageDuration(5)
AirbossTeddy:Load("C:\\Users\\root\\Saved Games\\lsogrades\\")
AirbossTeddy:SetAutoSave("C:\\Users\\root\\Saved Games\\lsogrades\\")
AirbossTeddy:SetTrapSheet("C:\\Users\\root\\Saved Games\\lsogrades\\")
function AirbossTeddy:OnAfterStart(From,Event,To)
  self:DeleteAllRecoveryWindows()
end
function AirbossTeddy:OnAfterLSOGrade(From, Event, To, playerData, myGrade)
		myGrade.messageType = 2
		myGrade.name = playerData.name
		HypeMan.sendBotTable(myGrade)
end
AirbossTeddy:Start()

AirbossStennis = AIRBOSS:New("Stennis","Stennis")
-- Delete auto recovery window.
function AirbossStennis:OnAfterStart(From,Event,To)
  self:DeleteAllRecoveryWindows()
end
AirbossStennis:SetMarshalRadio(305)
AirbossStennis:SetLSORadio(118.30)
AirbossStennis:SetTACAN(55,"X","STN")
AirbossStennis:SetSoundfilesFolder("Airboss Soundfiles/")
AirbossStennis:SetAirbossNiceGuy(true)
AirbossStennis:SetDespawnOnEngineShutdown(true)
AirbossStennis:SetRefuelAI(20)
AirbossStennis:SetMenuRecovery(30,25,false,0)
AirbossStennis:SetHoldingOffsetAngle(0)
AirbossStennis:SetRecoveryTanker(ShellStennis)
AirbossStennis:SetRecoveryTurnTime(300)
AirbossStennis:SetPatrolAdInfinitum(true)
AirbossStennis:Load("C:\\Users\\root\\Saved Games\\lsogrades\\")
AirbossStennis:SetAutoSave("C:\\Users\\root\\Saved Games\\lsogrades\\")
AirbossStennis:SetTrapSheet("C:\\Users\\root\\Saved Games\\lsogrades\\")
AirbossStennis:Start()
function AirbossStennis:OnAfterLSOGrade(From, Event, To, playerData, myGrade)
		myGrade.messageType = 2
		myGrade.name = playerData.name
		HypeMan.sendBotTable(myGrade)
	end
 SCHEDULER:New(nil,function()
  if livespawn == true then
    if livefire:IsAlive() ~= true then  
      livefire:Destroy()
      livespawn = false
      liveposmessage = "Live Fire Group are showing as destroyed, Ignore the bodies there just simulations that's not real blood we swear!\nThe Holodeck's just THAT good.. Why are you looking at us like that?\nStop it.. we have gag's and zip ties and other tanks that need... Simulated crews you know" 
      MESSAGE:New(liveposmessage,60,"Training Control"):ToAll()
      blived:Remove()
      blive1:Remove()
      blive = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn Livefire Units",b_menu2,livefirespawn)
    end
  end
  if attackerspawn == true then
    if attacker:IsAlive() ~= true then
      attacker:Destroy()
      if bairdestroy ~= nil then
		bairdestroy:Remove()
	  end
      attackerspawn = false
      MESSAGE:New("SU27 x 2 have been destroyed",30,"Training Control"):ToAll()
      bairspawn = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn 2x SU27",b_menu2,spawnair)
    end
  end
  if attackerspawn2 == true then
    if attacker2:IsAlive() ~= true then
      attacker2:Destroy()
      if bairdestroy2 ~= nil then
		bairdestroy2:Remove()
	  end
      attackerspawn2 = false
      MESSAGE:New("MIG29 x 2 have been destroyed",30,"Training Control"):ToAll()
      bairspawn2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn 2x MIG29",b_menu2,spawnair2)
    end
  end
  if attackerspawn3 == true then
    if attacker3:IsAlive() ~= true then
      attacker3:Destroy()
      if bairdestroy3 ~= nil then
		bairdestroy3:Remove()
	  end
      attackerspawn3 = false
      MESSAGE:New("MIG21 x 4 have been destroyed",30,"Training Control"):ToAll()
      bairspawn3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn 4x MIG21",b_menu2,spawnair3)
    end
  end
  
  if sa10spawn == true then
    if sa10:IsAlive() ~= true then
      sa10:Destroy()
      sa10spawn = false
      MESSAGE:New("SA 10 is reporting dead, Respawn Avalible",15,"Training Control"):ToAll()
      bgroundd10:Remove()
      bground10 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn SA10",b_menu2,spawn10)
    end
  end
  if sa15spawn == true then
    if sa15:IsAlive() ~= true then
      sa15:Destroy()
      sa15spawn = false
      bgroundd15:Remove()
      MESSAGE:New("SA 15 should be dead, Respawn Avalible",15,"Training Control"):ToAll()
      bground15 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn SA15",b_menu2,spawn15)
    end
  end
  if staticdef1:IsAlive() ~= true then
    MESSAGE:New("Defenses around Target 1 have been destroyed, Respawning in 30 Minutes",15,"Training Control"):ToAll()
    SCHEDULER:New(nil,function()
    staticdef1 = SPAWN:New("Static_Def"):Spawn()
    MESSAGE:New("Defenses around Target 1 have been Regenerated.",15,"Training Control"):ToAll()
    end,{},1800)
  end
  if target1:IsAlive() ~= true then
    target1:Destroy()
    MESSAGE:New("Target 1 has been destroyed, Respawning in 30 Minutes",15,"Training Control"):ToAll()
    SCHEDULER:New(nil,function()
    target1 = SPAWNSTATIC:NewFromStatic("target1",country.id.RUSSIA,coalition.side.RED):Spawn(0)
    MESSAGE:New("Target 1 should have Regenerated.",15,"Training Control"):ToAll()
    end,{},1800)
  end
  if staticdef2:IsAlive() ~= true then
    MESSAGE:New("Defenses around Target 2 have been destroyed, Respawning in 30 Minutes",15,"Training Control"):ToAll()
    SCHEDULER:New(nil,function()
    staticdef2 = SPAWN:New("Static_Def_2"):Spawn()
    MESSAGE:New("Defenses around Target 2 have been Regenerated.",15,"Training Control"):ToAll()
    end,{},1800)
  end
  if target2:IsAlive() ~= true then
    target2:Destroy()
    MESSAGE:New("Target 2 has been destroyed, Respawning in 30 Minutes",15,"Training Control"):ToAll()
    SCHEDULER:New(nil,function()
    target2 = SPAWNSTATIC:NewFromStatic("target2",country.id.RUSSIA,coalition.side.RED):Spawn(343)
    MESSAGE:New("Target 2 should have Regenerated.",15,"Training Control"):ToAll()
    end,{},1800)
  end
 end,{},5,5)

hrmsg = false
_reset = restart
frun = false
_t1 = false
 function playercheck()
	
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
	currenttime = "H" .. nowHour .. ":" .. nowminute
	
	frun = true
   clients:ForEachClient(function(PlayerClient) 
      local PlayerID = PlayerClient.ObjectName
        --PlayerClient:AddBriefing("Welcome to Red Iberia Rob Graham Version: "..version.." \n Last updated:".. lastupdate .." \n POWERED BY MOOSE \n Current Server time is: ".. nowHour .. ":" .. nowminute .."\n Mission Restart time:".. restarttime .. "\n No Blue on Blue is Allowed \n Your current objective is to ".. blueobject .."\n" ..bcomms .. "\n Remember Stores and Aircraft are limited and take time to resupply")
        if PlayerClient:GetGroup() ~= nil then
          local group = PlayerClient:GetGroup()
        end
         if PlayerClient:IsAlive() then
           if PlayerBMap[PlayerID] ~= true then
                PlayerBMap[PlayerID] = true
                MESSAGE:New("Welcome to TGW Training Server By Rob Graham \n • Last updated:".. lastupdate .." | Server Restart at: " .. restarttime .. " daily and every 6 Hours \n POWERED BY MOOSE & MIST\n Please Be Aware You need to be on Discord and SRS if possible \n See the BRIEF ALT+B for more information!\nIf Rob,Goose or another TGW admin says something pay attention. \n • consensual PVP and Blue on Blue is allowed for training purposes, Non-consensual (ie you didn't get permission) PVP is NOT allowed. \n • Ask before Engaging in CHAT and VOICE or you will be banned. \n • Please use UNICOM 122.80 when Taking off and Landing \n Remember 'Who I am Addressing, Who I am, Where I am, What I am doing' \n • your not to use Taxiways as Runways \n This server is Funded by the TGW Core members see https://www.taskgroupwarrior.info or the discord for more info!. \n If you want your LSO Data to show in discord you need to use the F10 comms Airboss, use Declare emergency for the Teddy. \n Fox missile trainer is active, use the Radio F10 Menu Option to adjust your controls.",30):ToClient(PlayerClient)
           end    
         else
          if PlayerBMap[PlayerID] ~= false then
                PlayerBMap[PlayerID] = false
          end
       end
    end)
	
	if nowminute == 0 then
		if hrmsg == false then
			if frun == false then
				_reset = _reset - 1
			
			end
			MESSAGE:New("It is now " .. currenttime .. " this server restarts every 6 hrs, 1200,1800,0000,0600 next restart is in " .. _reset .. " Hrs",30):ToAll()
			hrmsg = true
			
		end
	end
	
	if nowminute == 1 then
		if hrmsg == true then
			hrmsg = false
		end
	
	end
	
	if nowminute == 30 and _reset == 1 then
		if _t1 == false then
			MESSAGE:New("This server will restart in aprox 30 minutes",30):ToAll()
			_t1 = true
		end
	end
	
	if nowminute == 31 and _reset == 1 and _t1 == true then
		_t1 = false
	end
		if nowminute == 50 and _reset == 1 then
		if _t1 == false then
			MESSAGE:New("This server will restart in aprox 10 minutes",30):ToAll()
			_t1 = true
		end
	end
	if nowminute == 51 and _reset == 1 and _t1 == true then
		_t1 = false
	end
		if nowminute == 55 and _reset == 1 then
		if _t1 == false then
			MESSAGE:New("This server will restart in aprox 5 minutes",30):ToAll()
			_t1 = true
		end
	end
	if nowminute == 56 and _reset == 1 and _t1 == true then
		_t1 = false
	end
	
 end

 SCHEDULER:New(nil,playercheck,{},1,10)
 
 
 
local function handleWeatherRequest(text, coord, red)
    local currentPressure = coord:GetPressure(0)
    local currentTemperature = coord:GetTemperature()
    local currentWindDirection, currentWindStrengh = coord:GetWind()
    local currentWindDirection1, currentWindStrength1 = coord:GetWind(UTILS.FeetToMeters(1000))
    local currentWindDirection2, currentWindStrength2 = coord:GetWind(UTILS.FeetToMeters(2000))
    local currentWindDirection5, currentWindStrength5 = coord:GetWind(UTILS.FeetToMeters(5000))
    local currentWindDirection10, currentWindStrength10 = coord:GetWind(UTILS.FeetToMeters(10000))
    local weatherString = string.format("Requested weather: Wind from %d@%.1fkts, QNH %.2f, Temperature %d", currentWindDirection, UTILS.MpsToKnots(currentWindStrengh), currentPressure * 0.0295299830714, currentTemperature)
    local weatherString1 = string.format("Wind 1,000ft: Wind from%d@%.1fkts",currentWindDirection1, UTILS.MpsToKnots(currentWindStrength1))
    local weatherString2 = string.format("Wind 2,000ft: Wind from%d@%.1fkts",currentWindDirection2, UTILS.MpsToKnots(currentWindStrength2))
    local weatherString5 = string.format("Wind 5,000ft: Wind from%d@%.1fkts",currentWindDirection5, UTILS.MpsToKnots(currentWindStrength5))
    local weatherString10 = string.format("Wind 10,000ft: Wind from%d@%.1fkts",currentWindDirection10, UTILS.MpsToKnots(currentWindStrength10))
    MESSAGE:New(weatherString, 30, MESSAGE.Type.Information):ToAll()
    MESSAGE:New(weatherString1, 30, MESSAGE.Type.Information):ToAll()
    MESSAGE:New(weatherString2, 30, MESSAGE.Type.Information):ToAll()
    MESSAGE:New(weatherString5, 30, MESSAGE.Type.Information):ToAll()
    MESSAGE:New(weatherString10, 30, MESSAGE.Type.Information):ToAll()
end

------------------------


function SupportHandler:OnEventLandingQualityMark(EventData) 
  BASE:E({"Landing Quality Mark - Traing Server",EventData})
  local comment = EventData.comment
  local who = EventData.IniPlayerName
  if who == nil then
	who = EventData.IniUnitName
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
 lsomsg = "**Training Server - Super Carrier LSO** \n > **" .. where .. "** \n > **Landing Grade for  " .. who .. " \n > **Aircraft Type:** " .. t .. " \n > **Grade:** " .. comment .. "."
  hm(lsomsg )
  hmlso(lsomsg)
end

world.addEventHandler(SupportHandler)
 
 
 do
    nowTable = os.date('*t')
    nowYear = nowTable.year
    nowMonth = nowTable.month
    nowDay = nowTable.day
    nowHour = nowTable.hour
    nowminute = nowTable.min
end

fox3 = FOX:New()
fox3:Start()

BASE:E({"TRAINING MISSION END"})