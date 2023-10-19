--made by Jisk#4833

local updaterate = CV_RegisterVar{
	name = "acb_updaterate",
	defaultvalue = "35",
	flags = CV_NETVAR,
	PossibleValue={MIN = 1, MAX = 350}
}

local resetrate = CV_RegisterVar{ 
	name = "acb_resetrate",
	defaultvalue = "70",
	flags = CV_NETVAR,
	PossibleValue={MIN = 1, MAX = 350}
}

local acbtoggle = CV_RegisterVar{
	name = "acb_toggle",
	defaultvalue = "On",
	flags = CV_NETVAR,
	PossibleValue = CV_OnOff
}

local showdebug = CV_RegisterVar{
	name = "acb_showdebug",
	defaultvalue = "Off",
	PossibleValue = CV_OnOff
}
-- 
COM_AddCommand("sendcmdupdate", function(player)
    player.cmdupdatesent = true
end)

addHook("ThinkFrame", do
    if acbtoggle.value == 1 then
        if (leveltime % updaterate.value) == 0 then
            for player in players.iterate()
                COM_BufInsertText(player, "sendcmdupdate")
            end
        end
        if (leveltime % resetrate.value) == 0 then
            for player in players.iterate()
                if player.cmdupdatesent then
                    player.cmdupdatesent = false
                    if showdebug.value == 1
                        print(player.name.. " Confirmed!")
                    end
                else
                    if player.jointime > TICRATE*5 and leveltime > TICRATE*5 then
                        COM_BufInsertText(server, "kick "..#player.." CMD Never sent (Chatbug/Lag)")
                    end
                end
            end
        end
    end
end)

addHook("PlayerMsg", function(source)
    if acbtoggle.value == 1
        if source.jointime < TICRATE*1 then
            return true
        end
    end
end)