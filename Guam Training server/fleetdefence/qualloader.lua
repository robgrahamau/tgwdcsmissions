server = true
version = "1.05.0"
lastupdate = "12/01/2022"
mission = " Guam Training Mission " 
env.info("Carrier Qual Loader")
env.info("Mission by Robert Graham")
env.info("Mission Script Loader Active")
env.info("Loading MOOSE")
dofile(lfs.writedir() .."fleetdefence\\Moose.lua")
env.info("Loading MIST")
dofile(lfs.writedir() .."fleetdefence\\mist_4_5_98.lua")
if server == true then
	env.info("hHypeMan")
	assert(loadfile("C:/HypeMan/HypeMan.lua"))() 
else
	if GRPC == nil then
		GRPC = {}
		function GRPC.load()
		
		end
	end
end



function hm(msg)
	if server == true then
		HypeMan.sendBotMessage(" **".. mission .."** > " .. msg .. "")
	else
		BASE:E({msg})
		
	end
end

function hmlso(msg)
	if server == true then
		HypeMan.sendLSOBotMessage(msg)
	end
end

GRPC.debug = true
GRPC.host = '0.0.0.0'
GRPC.port = setport
GRPC.load()

dofile(lfs.writedir() .."fleetdefence\\client.lua")
dofile(lfs.writedir() .."fleetdefence\\carrierqual.lua")
dofile(lfs.writedir() .."fleetdefence\\markerevents.lua")
dofile(lfs.writedir() .."fleetdefence\\samsites.lua")