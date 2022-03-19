lastupdate = "19 March 2022"


admin = false
-- user Variables
restarttime = "12pm"
restart = 6
usehypeman = true
password = "hahaha"
ADMINPASSWORD2 = "yeahright"
--
assert(loadfile(lfs.writedir() .."training\\mist.lua"))()

if usehypeman = true then
	assert(loadfile("C:/HypeMan/HypeMan.lua"))()  -- Set to your HYPEMAN PATH if usehypeman = true is set.
	function hm(msg)
		HypeMan.sendBotMessage(msg)
	end
	function hmlso(msg)
		HypeMan.sendLSOBotMessage(msg)
	end
else
	Hypeman = {}
	function hm(msg)
		BASE:E({"HM",msg})
	end
	function hmlso(msg)
		BASE:E({"HMLSO",msg})
	end
end

HypeMan.sendBotMessage("Training Server is Loading....")
HypeMan.sendBotMessage("Training Server mist.lua")
HypeMan.sendBotMessage("Training Server MOOSE.lua")
assert(loadfile(lfs.writedir() .."training\\moose.lua"))()
HypeMan.sendBotMessage("Training Server prac_main.lua")
assert(loadfile(lfs.writedir() .."training\\prac_main.lua"))()
HypeMan.sendBotMessage("Training Server markerevents.lua")
assert(loadfile(lfs.writedir() .."training\\CTLD.lua"))()
assert(loadfile(lfs.writedir() .."training\\markerevents.lua"))()
HypeMan.sendBotMessage("Training server active")
assert(loadfile(lfs.writedir() .."training\\ctldslotcheck.lua"))()
function runrob()
dofile(lfs.writedir() .. [[training\robcommands.lua]])

	if inputhash ~= lasthash then
		BASE:E("Hash has changed")
		local ran, errorMSG = pcall(robinput)
		if not ran then
			BASE:E({"robinput errored ",errorMSG})
		end
		lasthash = inputhash
	end

end


SCHEDULER:New(nil,function() 
	local ran, errorMSG = pcall(runrob)
	if not ran then
		BASE:E({"error in runrobo ",errorMSG})
	end
	
end,{},0,5)