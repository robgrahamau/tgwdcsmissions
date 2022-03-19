


  hm("Airboss is active, Starting Up Scripts")
 
	SHELL = RECOVERYTANKER:New(UNIT:FindByName("ABE"), "Texaco")
	SHELL:SetTakeoffCold()
	SHELL:SetRecoveryAirboss(false)
	SHELL:SetCallsign(CALLSIGN.Tanker.Shell,1)
	SHELL:SetSpeed(290)
	SHELL:SetAltitude(6000)
	SHELL:SetRadio(265)
	SHELL:SetTACAN(47,"SHL")
	SHELL:SetLowFuelThreshold(0.3)
	SHELL:Start()
	hm("Abe's Recovery Tanker has been activated. \n > SHELL11 is Now online \n > TACAN 47 > Speed 290 > Altitude 6000 > Radio 265")

  
  ABABE = AIRBOSS:New("ABE","Abraham Lincoln")
  ABABE:SetTACAN(67,"X","ABE")
  ABABE:SetICLS(2,"LIN")
  ABABE:SetAirbossNiceGuy(true)
  ABABE:SetMarshalRadio(309)
  ABABE:SetLSORadio(118.750)
  ABABE:SetBeaconRefresh(1200)
  ABABE:SetPatrolAdInfinitum(true)
  ABABE:SetDefaultMessageDuration(1)
  ABABE:Load("C:\\Users\\root\\Saved Games\\lsogrades\\")
  ABABE:SetAutoSave("C:\\Users\\root\\Saved Games\\lsogrades\\")
  ABABE:SetTrapSheet("C:\\Users\\root\\Saved Games\\lsogrades\\")
  ABABE:SetSoundfilesFolder("Airboss Soundfiles/")
  ABABE:SetEmergencyLandings(true)
  ABABE:SetWelcomePlayers(false)
  ABABE:SetMenuRecovery(30,27,false,0)
  ABABE:SetMenuSingleCarrier(false)
  ABABE:Start()
  hm("Abe's Airboss has been activated. \n > LSO is Now online \n > • TACAN 67 > • ICLS 2 > • RECOVERY PERIOD: 30 Minutes > • Recovery Speed: 27 Knots")  

  hm("Airboss was not active, No scripts loaded.")


function ABABE:OnAfterLSOGrade(From, Event, To, playerData, myGrade)
		myGrade.messageType = 2
		myGrade.name = playerData.name
		HypeMan.sendBotTable(myGrade)
end


  
  ABFOR = AIRBOSS:New("FOR","USS FORRESTAL")
  ABFOR:SetTACAN(72,"X","FOR")
  ABFOR:SetICLS(4,"TAL")
  ABFOR:SetAirbossNiceGuy(true)
  ABFOR:SetBeaconRefresh(1200)
  ABABE:SetMarshalRadio(305)
  ABABE:SetLSORadio(118.250)
  ABFOR:SetPatrolAdInfinitum(true)
  ABFOR:SetDefaultMessageDuration(1)
  ABFOR:Load("C:\\Users\\root\\Saved Games\\lsogrades\\")
  ABFOR:SetAutoSave("C:\\Users\\root\\Saved Games\\lsogrades\\")
  ABFOR:SetTrapSheet("C:\\Users\\root\\Saved Games\\lsogrades\\")
  ABFOR:SetSoundfilesFolder("Airboss Soundfiles/")
  ABFOR:SetEmergencyLandings(true)
  ABFOR:SetWelcomePlayers(false)
  ABFOR:SetMenuRecovery(30,27,false,0)
  ABFOR:SetMenuSingleCarrier(false)
  ABFOR:Start()
  hm("Forrestal Airboss has been activated. \n > LSO is Now online \n > • TACAN 72 > • ICLS 4 > • RECOVERY PERIOD: 30 Minutes > • Recovery Speed: 27 Knots")  


function ABFOR:OnAfterLSOGrade(From, Event, To, playerData, myGrade)
		myGrade.messageType = 2
		myGrade.name = playerData.name
		HypeMan.sendBotTable(myGrade)
end




	TEX = RECOVERYTANKER:New(UNIT:FindByName("FOR"), "Texaco-1")
	TEX:SetTakeoffCold()
	TEX:SetRecoveryAirboss(false)
	TEX:SetCallsign(CALLSIGN.Tanker.Texaco,1)
	TEX:SetSpeed(290)
	TEX:SetAltitude(6000)
	TEX:SetRadio(262)
	TEX:SetTACAN(43,"TEX")
	TEX:SetLowFuelThreshold(0.3)
	TEX:Start()
	hm("FORRESTALL Recovery Tanker has been activated. \n > TEXACO11 is Now online \n > TACAN 43 > Speed 290 > Altitude 6000 > Radio 262")
	
	TEX21 = RECOVERYTANKER:New(UNIT:FindByName("TED"), "Texaco-2")
	TEX21:SetTakeoffCold()
	TEX21:SetRecoveryAirboss(false)
	TEX21:SetCallsign(CALLSIGN.Tanker.Texaco,2)
	TEX21:SetSpeed(290)
	TEX21:SetAltitude(6000)
	TEX21:SetRadio(261)
	TEX21:SetTACAN(45,"TE2")
	TEX21:SetLowFuelThreshold(0.3)
	TEX21:Start()
	hm("TEDDY Recovery Tanker has been activated. \n > TEXACO21 is Now online \n > TACAN 45 > Speed 290 > Altitude 6000 > Radio 261")
	
	TEX31 = RECOVERYTANKER:New(UNIT:FindByName("STN"), "Texaco-3")
	TEX31:SetTakeoffCold()
	TEX31:SetRecoveryAirboss(false)
	TEX31:SetCallsign(CALLSIGN.Tanker.Texaco,3)
	TEX31:SetSpeed(290)
	TEX31:SetAltitude(6000)
	TEX31:SetRadio(263)
	TEX31:SetTACAN(46,"TE3")
	TEX31:SetLowFuelThreshold(0.3)
	TEX31:Start()
	hm("STN Recovery Tanker has been activated. \n > TEXACO31 is Now online \n > TACAN 46 > Speed 290 > Altitude 6000 > Radio 263")

  bombtargets = {"Ground-3-1","Ground-2-1","Ground-1-1","Ground-3-2","Ground-3-3","Ground-3-4","Ground-3-5"}
  FaralonRange = RANGE:New("Faralon Range")
  FaralonRange:AddBombingTargets(bombtargets,25)
  FaralonRange:SetRangeControl(262,"range")
  FaralonRange:SetRangeZone(ZONE:FindByName("rangezone"))
  FaralonRange:Start()
  
  

  SH51 = GROUP:FindByName("SHL51")
  SH51:HandleEvent(EVENTS.Land)
  SH51:HandleEvent(EVENTS.Crash)
  function SH51:OnEventLand(EventData)
    SH51:Respawn()
  end
  function SH51:OnEventCrash(EventData)
    SH51:Respawn()
  end
  AR61 = GROUP:FindByName("ARCO61")
  AR61:HandleEvent(EVENTS.Land)
  AR61:HandleEvent(EVENTS.Crash)
  function AR61:OnEventLand(EventData)
    AR61:Respawn()
  end
  function AR61:OnEventCrash(EventData)
    AR61:Respawn()
  end
  AR81 = GROUP:FindByName("ARCO8-1")
  AR81:HandleEvent(EVENTS.Land)
  AR81:HandleEvent(EVENTS.Crash)
  function AR61:OnEventLand(EventData)
    AR81:Respawn()
  end
  function AR61:OnEventCrash(EventData)
    AR81:Respawn()
  end
  TX91 = GROUP:FindByName("TEX91")
  TX91:HandleEvent(EVENTS.Land)
  TX91:HandleEvent(EVENTS.Crash)
  function TX91:OnEventLand(EventData)
    TX91:Respawn()
   end
   function TX91:OnEventCrash(EventData)
    TX91:Respawn()
   end
  
  fox = FOX:New()
  fox:AddProtectedGroup(GROUP:FindByName("SHL51"))
  fox:AddProtectedGroup(GROUP:FindByName("ARCO61"))
  fox:AddProtectedGroup(GROUP:FindByName("ARCO8-1"))
  fox:AddProtectedGroup(GROUP:FindByName("TEX91"))
  fox:AddSafeZone(ZONE:FindByName("AirtoAir"))
  fox:AddSafeZone(ZONE:FindByName("longrad"))
  fox:Start()
  
  
atis1 = ATIS:New(AIRBASE.MarianaIslands.Andersen_AFB,118.17)
atis1:SetRadioRelayUnitName("Overlord-1")
atis1:SetTowerFrequencies({"126.2"})
atis1:SetTACAN(54)
atis1:AddILS(109.35,"24R")
atis1:AddILS(110.15,"24L")
--atis1:Start()

atis2 = ATIS:New(AIRBASE.MarianaIslands.Antonio_B_Won_Pat_Intl,119.00)
atis2:SetRadioRelayUnitName("B1-1")
--atis2:Start()