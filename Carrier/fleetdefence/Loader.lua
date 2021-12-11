server = true
env.info("Fleet Defence Loader")
env.info("Mission by Robert Graham")
env.info("Mission Script Loader Active")
env.info("Loading MOOSE")
dofile(lfs.writedir() .."fleetdefence\\Moose.lua")
env.info("Loading MIST")
dofile(lfs.writedir() .."fleetdefence\\mist_4_5_98.lua")
env.info("HypeMan")
assert(loadfile("C:/HypeMan/HypeMan.lua"))() 


function hm(msg)
	if server == true then
		HypeMan.sendBotMessage(msg)
	else
		BASE:E({msg})
		if GRPC == nil then
			GRPC = {}
		end
	end
end
hm("**Fleet Defender Loading.....** \n > MOOSE,MIST  Already Loaded, \n > I feel the *need*, the *NEED* for speed")
hm("> Randomising Maths because Maths needs SEEDS so things can grow")
function hmlso(msg)
	HypeMan.sendLSOBotMessage(msg)
end
HypeMan.sendBotMessage("> Hazel Link Starting, port 50052 \n Tower this is Ghost Rider, how do you hear us?")
GRPC.debug = true
GRPC.host = '0.0.0.0'
GRPC.port = 50052
GRPC.load()
hm("> GRPC is a go, We hear you five by five Ghost Rider!")
hm("> Strap the boys and girls in clients are going live")
dofile(lfs.writedir() .."fleetdefence\\client.lua")
hm("> Lets start up the primary 'game' loop")
dofile(lfs.writedir() .."fleetdefence\\game.lua")
hm("> Fleet Defender is a go")

