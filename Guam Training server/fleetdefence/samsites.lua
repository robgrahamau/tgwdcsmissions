RangeTopMenu = MENU_COALITION:New(2,"Guam Training Control")
hm("Loading Sam Scripts")

longradzone = ZONE:FindByName("longrad")
navalzone = ZONE:FindByName("naval")

SA2 = GROUP:FindByName("SA2")
SA3 = GROUP:FindByName("SA3")
SA5 = nil
SA6 = GROUP:FindByName("SA6")
SA8 = GROUP:FindByName("SA8")
SA10 = GROUP:FindByName("SA10")
SA11 = GROUP:FindByName("SA11")
SA15 = GROUP:FindByName("SA15")
SA19 = GROUP:FindByName("SA19")
samlive = false
function activatesam(sitetype)
	if sitetype ~= nil then
		samlive = true
		if sitetype:IsAlive() == true then
			sitetype:Destroy()
		end
			sitetype:Respawn()
			sitetype:Activate()
			hm("Warning Sam Site of type ".. sitetype:GetName() .. " Restricted Airspace activated \n Remain within Zone or Site will deactivate")
			MESSAGE:New("Warning Sam Site of type ".. sitetype:GetName() .. " Restricted Airspace activated \n Remain within Zone or Site will deactivate",60,"Range Master"):ToAll()
			sammenu("active",sitetype)
	else
			hm("error in activatesam") 
	end
end

function deactivatesam(sitetype)
	if sitetype ~= nil then
		samlive = false
		if sitetype:IsAlive() == true then
			sitetype:Destroy()
			hm("deactivating Sam Site of type ".. sitetype:GetName() .. " Restricted Airspace dactivated")
			MESSAGE:New("deactivating Sam Site of type ".. sitetype:GetName() .. " Restricted Airspace deactivated",60,"Range Master"):ToAll()
			sammenu("inactive",nil)
		end
	end
end

function sammenu(state,samtype)
  if state == "init" then
    sammenutop = MENU_COALITION:New(2,"SAM TRAINING RANGE",RangeTopMenu)
    sammenu1 = MENU_COALITION_COMMAND:New(2,"Activate SA2",sammenutop,activatesam,SA2)
    sammenu2 = MENU_COALITION_COMMAND:New(2,"Activate SA3",sammenutop,activatesam,SA3)
    sammenu3 = MENU_COALITION_COMMAND:New(2,"Activate SA6",sammenutop,activatesam,SA6)
    sammenu4 = MENU_COALITION_COMMAND:New(2,"Activate SA8",sammenutop,activatesam,SA8)
    sammenu5 = MENU_COALITION_COMMAND:New(2,"Activate SA10",sammenutop,activatesam,SA10)
    sammenu6 = MENU_COALITION_COMMAND:New(2,"Activate SA11",sammenutop,activatesam,SA11)
    sammenu7 = MENU_COALITION_COMMAND:New(2,"Activate SA15",sammenutop,activatesam,SA15)
    sammenu8 = MENU_COALITION_COMMAND:New(2,"Activate SA19",sammenutop,activatesam,SA19)
  elseif state == "inactive" then
    sammenu1:Remove()
    sammenu1 = MENU_COALITION_COMMAND:New(2,"Activate SA2",sammenutop,activatesam,SA2)
    sammenu2 = MENU_COALITION_COMMAND:New(2,"Activate SA3",sammenutop,activatesam,SA3)
    sammenu3 = MENU_COALITION_COMMAND:New(2,"Activate SA6",sammenutop,activatesam,SA6)
    sammenu4 = MENU_COALITION_COMMAND:New(2,"Activate SA8",sammenutop,activatesam,SA8)
    sammenu5 = MENU_COALITION_COMMAND:New(2,"Activate SA10",sammenutop,activatesam,SA10)
    sammenu6 = MENU_COALITION_COMMAND:New(2,"Activate SA11",sammenutop,activatesam,SA11)
    sammenu7 = MENU_COALITION_COMMAND:New(2,"Activate SA15",sammenutop,activatesam,SA15)
    sammenu8 = MENU_COALITION_COMMAND:New(2,"Activate SA19",sammenutop,activatesam,SA19)
  elseif state == "active" then
    sammenu1:Remove()
    sammenu2:Remove()
    sammenu3:Remove()
    sammenu4:Remove()
    sammenu5:Remove()
    sammenu6:Remove()
    sammenu7:Remove()
    sammenu8:Remove()
    sammenu1 = MENU_COALITION_COMMAND:New(2,"Deactivate Sam",sammenutop,deactivatesam,samtype)
  
  else
  
  
  end
end

sammenu("init",nil)



-----
env.info("Loading Air units")

a2aguns = GROUP:FindByName("a2a_guns")
a2aguns:HandleEvent(EVENTS.Dead,deactivateair,a2aguns)
a2afox1 = GROUP:FindByName("a2a_fox1")
a2afox1:HandleEvent(EVENTS.Dead,deactivateair,a2afox1)
a2afox2 = GROUP:FindByName("a2a_heat")
a2afox2:HandleEvent(EVENTS.Dead,deactivateair,a2afox2)
a2afox3 = GROUP:FindByName("a2a_fox3")
a2afox3:HandleEvent(EVENTS.Dead,deactivateair,a2afox3)
airlive = false
airtype = nil

function activateair(airtype)
  if airtype ~= nil then
    airlive = true
    if airtype:IsAlive() == true then
      airtype:Destroy()
    end
      airtype:Respawn()
      airtype:Activate()
      hm("Warning AI Air of type ".. airtype:GetName() .. " has been Activated, Restricted Airspace now active \n Remain within Zone or Air Unit will deactivate")
      MESSAGE:New("Warning AI Air of type ".. airtype:GetName() .. " has been Activated, Restricted Airspace now active \n Remain within Zone or Airunit will deactivate",60,"Range Master"):ToAll()
      airmenu("active",airtype)
  else
      hm("error in activateair") 
  end
end

function deactivateair(airtype)
  if airtype ~= nil then
    airlive = false
    if airtype:IsAlive() == true then
      airtype:Destroy()
      hm("deactivating air unit of type ".. airtype:GetName() .. " Restricted Airspace dactivated")
      MESSAGE:New("deactivating air unit of type ".. airtype:GetName() .. " Restricted Airspace deactivated",60,"Range Master"):ToAll()
      airmenu("inactive",nil)
    end
  end
end



function airmenu(state,airtype)
  if state == "init" then
    Airtraining = MENU_COALITION:New(2,"AIR TRAINING RANGE",RangeTopMenu)
    amenu1 = MENU_COALITION_COMMAND:New(2,"Activate Guns",Airtraining,activateair,a2aguns)
    amenu2 = MENU_COALITION_COMMAND:New(2,"Activate Fox-1",Airtraining,activateair,a2afox1)
    amenu3 = MENU_COALITION_COMMAND:New(2,"Activate Fox-2",Airtraining,activateair,a2afox2)
    amenu4 = MENU_COALITION_COMMAND:New(2,"Activate Fox-3",Airtraining,activateair,a2afox3)
  elseif state == "inactive" then
    amenu1:Remove()
    amenu1 = MENU_COALITION_COMMAND:New(2,"Activate Guns",Airtraining,activateair,a2aguns)
    amenu2 = MENU_COALITION_COMMAND:New(2,"Activate Fox-1",Airtraining,activateair,a2afox1)
    amenu3 = MENU_COALITION_COMMAND:New(2,"Activate Fox-2",Airtraining,activateair,a2afox2)
    amenu4 = MENU_COALITION_COMMAND:New(2,"Activate Fox-3",Airtraining,activateair,a2afox3)
  elseif state == "active" then
    amenu1:Remove()
    amenu2:Remove()
    amenu3:Remove()
    amenu4:Remove()
    amenu1 = MENU_COALITION_COMMAND:New(2,"Deactivate AI Air Unit",Airtraining,deactivateair,airtype)
  
  else
  
  
  end
end
airmenu("init")

navy1 = GROUP:FindByName("navy1")
navy2 = GROUP:FindByName("navy2")
navy3 = GROUP:FindByName("navy3")

function activatenavy(navytype)
  if navytype ~= nil then
    navylive = true
    if navytype:IsAlive() == true then
      navytype:Destroy()
    end
      navytype:Respawn()
      navytype:Activate()
      hm("Warning AI Naval Units of type ".. navytype:GetName() .. " has been Activated, Restricted Airspace now active \n Remain within Zone or Air Unit will deactivate")
      MESSAGE:New("Warning AI Naval Units of type ".. navytype:GetName()  .. " has been Activated, Restricted Airspace now active \n Remain within Zone or Airunit will deactivate",60,"Range Master"):ToAll()
      navymenu("active",airtype)
  else
      hm("error in activatenavy") 
  end
end

function deactivatenavy(navytype)
  if navytype ~= nil then
    navylive = false
    if navytype:IsAlive() == true then
      navytype:Destroy()
      hm("deactivating Naval unit of type ".. navytype:GetName() .. " Restricted Airspace dactivated")
      MESSAGE:New("deactivating naval unit of type ".. navytype:GetName() .. " Restricted Airspace deactivated",60,"Range Master"):ToAll()
      navymenu("inactive",nil)
    end
  end
end



function navymenu(state,navytype)
	if state == "init" then
		Navytraining = MENU_COALITION:New(2,"NAVY TRAINING RANGE",RangeTopMenu)
		nmenu1 = MENU_COALITION_COMMAND:New(2,"Activate Type 052B Destroyer",Navytraining,activatenavy,navy1)
		nmenu2 = MENU_COALITION_COMMAND:New(2,"Activate Small Group",Navytraining,activatenavy,navy2)
		nmenu3 = MENU_COALITION_COMMAND:New(2,"Activate Small Fleet",Navytraining,activatenavy,navy3)
	elseif state == "inactive" then
		nmenu1:Remove()
		nmenu1 = MENU_COALITION_COMMAND:New(2,"Activate Type 052B Destroyer",Navytraining,activatenavy,navy1)
		nmenu2 = MENU_COALITION_COMMAND:New(2,"Activate Small Group",Navytraining,activatenavy,navy2)
		nmenu3 = MENU_COALITION_COMMAND:New(2,"Activate Small Fleet",Navytraining,activatenavy,navy3)
	elseif state == "active" then
		nmenu1:Remove()
		nmenu2:Remove()
		nmenu3:Remove()
		nmenu1 = MENU_COALITION_COMMAND:New(2,"Deactivate Chinese Navy Units",Navytraining,deactivatenavy,navytype)
	
	else
	
	
	end
end

navymenu("init")



SCHEDULER:New(nil,function() 
	if samlive == true then
		
		longrad = 0
		SetPlayer:ForEachClientInZone(longradzone,function(PlayerClient) 
			if PlayerClient:IsAlive() then
				longrad = longrad + 1 
			end
			BASE:E({"Longrad",longrad}) end,{})
		if longrad == 0 then
			deactivatesam(SA2)
			deactivatesam(SA3)
			deactivatesam(SA6)
			deactivatesam(SA8)
			deactivatesam(SA10)
			deactivatesam(SA11)
			deactivatesam(SA15)
			deactivatesam(SA19)
			sammenu("inactive") 
		end
	end
	if airlive == true then
		airzone = 0
		SetPlayer:ForEachClientInZone(ZONE:FindByName("AirtoAir"),function(PlayerClient) 
		if PlayerClient:IsAlive() then
			airzone = airzone + 1 
		end
		BASE:E({"airzone",airzone})
		
		end,{})
		if airzone == 0 then
			deactivateair(a2aguns)
			deactivateair(a2afox1)
			deactivateair(a2afox2)
			deactivateair(a2afox3)
			airmenu("inactive")
		end
	end
	if navylive == true then
		nzone = 0
		SetPlayer:ForEachClientInZone(navyzone,function(PlayerClient) 
		if PlayerClient:IsAlive() then
			nzone = nzone + 1
		end
		BASE:E({"navylive",navylive})
		end,{})
		if nzone == 0 then
			deactivatenavy(navy1)
			deactivatenavy(navy2)
			deactivatenavy(navy3)
			navymenu("inactive")
		end	
	end
end,{},5,60)




function respawntankers(tanker)
	if tanker:IsAlive() ~= true or tanker:AllOnGround() then
		tanker:Respawn()
	end
end

tankertraining = MENU_COALITION:New(2,"RANGE TANKER CONTROL",RangeTopMenu)
tmenu1 = MENU_COALITION_COMMAND:New(2,"Respawn SHELL 51",tankertraining,respawntankers,SH51)
tmenu2 = MENU_COALITION_COMMAND:New(2,"Respawn ARCO 61",tankertraining,respawntankers,AR61)
tmenu3 = MENU_COALITION_COMMAND:New(2,"Respawn ARCO 81",tankertraining,respawntankers,AR81)
tmenu3 = MENU_COALITION_COMMAND:New(2,"Respawn TEXACO 91",tankertraining,respawntankers,TX91)