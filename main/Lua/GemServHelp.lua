-- Epic hud nag by Poly
-- earless animation help from Zipper
local nagString = "\x80Use \x82gshelp \x80in the console \n\x80to get help and to \x85remove this\x80."
local saveFile = "gshelp.dat"
local earlesses = {"ERLSALAR", "ERLSALAR", "ERLSBLBR", "ERLSCLCR", "ERLSBLBR"}
local earlessFT = {5,5,3,3,2}
local earFrame = 1
local earTimer = 0
-- ear

addHook("PlayerSpawn", function(player)
	if (player.readHelp) return end
	if (player == server and not devparm)
		player.readHelp = true
		return
	end
	if not (player == consoleplayer) then return end
	local file = io.openlocal("client/"..saveFile, "r")
	
	if not (file) then return end
	
	if file:read("*number")
		COM_BufInsertText(player, "gshelp")
	end
end)

COM_AddCommand("gshelp", function(player, args)
	player.readHelp = true;
	if player == consoleplayer
		local file = io.openlocal("client/"..saveFile, "w+")
		file:write("1")
		io.close(file)
	end
	
	if args == none then
		CONS_Printf(player,"Usage: \x82[gshelp <turnsuper|pets|supercolor|skincolors|hats|wings>]\x80")

	elseif string.lower(args) == "turnsuper" then
		CONS_Printf(player,"")
		CONS_Printf(player,"Turning Super is quite simple! Just type 'superon' into the console.")
		CONS_Printf(player,"")
		CONS_Printf(player,"If it doesn't work, you can ask me to give everyone the Emeralds. I'll gladly do it for you.")
		CONS_Printf(player,"")
		CONS_Printf(player,"To revert back to normal without either dying or waiting an absurdly long time, just type 'superoff' into the console.")
		CONS_Printf(player,"")
		CONS_Printf(player,"Alternatively, you can press your 'toss flag' key to revert, but only while on the ground. You can turn that off with 'disablerevertbutton'.")
	elseif string.lower(args) == "pets" then
		CONS_Printf(player,"Confused as to why everyone has something random floating behind them? Those are called 'Pets'.")
		CONS_Printf(player,"")
		CONS_Printf(player,"To see what pets are currently available on my server-- and any other server running the Pets addon for that matter-- just type 'pet list' into the console.")
		CONS_Printf(player,"")
		CONS_Printf(player,"To select a pet, type 'pet skin', followed by the pet's name. For example, 'pet skin unknown'. Bam! You have a floating error sign following you now.")
		CONS_Printf(player,"")
		CONS_Printf(player,"As of Pets v3, there are tons of new pets, and also new functions.")
		CONS_Printf(player,"For starters, you can now color some pets with 'pet color'.")
		CONS_Printf(player,"Along with this, you can colorize them the same way you can colorize yourself, using 'petcolorize'. Colorize yourself using 'colorize'.")
		CONS_Printf(player,"You can change the height that your pet hovers off the ground, as well. Use 'pet height' to change it!")
	elseif string.lower(args) == "supercolor" then
		CONS_Printf(player,"To see what colors you can make your Super form, type 'supercolor list' into the console.")
		CONS_Printf(player,"")
		CONS_Printf(player,"For example: 'supercolor red' changes your Super color to be the same as Knuckles's in base SRB2.")
		CONS_Printf(player,"")
		CONS_Printf(player,"You can also use regular skin colors by adding 'n_' to the start of your argument.")
		CONS_Printf(player,"")
		CONS_Printf(player,"As of SuperColors v2, you can now simply hold Fire Normal to enter a graphical menu!")
	elseif string.lower(args) == "skincolors" then
		CONS_Printf(player,"This one's a little hard to explain.")
		CONS_Printf(player,"")
		CONS_Printf(player,"Go to mb.srb2.org and find 'SendColor' under the Releases > Skincolors section.")
		CONS_Printf(player,"")
		CONS_Printf(player,"If you still don't get it... I don't know what to say to you.")
	elseif string.lower(args) == "hats" then
		CONS_Printf(player,"The cosmetics menu is accessible by pressing the button shown when you first log in.")
		CONS_Printf(player,"Use cos_button to rebind it.")
	elseif string.lower(args) == "wings" then
		CONS_Printf(player,"To see what wing types are available, type 'wings' into the console.")
		CONS_Printf(player,"Once you find what set of wings you want, type 'wings [wing type]'.")
	end
end)

hud.add(function(v, stplyr, cam)
	if (not stplyr.readHelp)
		-- Draw the shiznits
		v.draw(140,30,v.cachePatch(earlesses[earFrame % #earlesses + 1]))
		v.drawString(260,100,nagString, V_ALLOWLOWERCASE | V_30TRANS, "center")
	end
	
end, "game")

addHook("ThinkFrame", function()
	earTimer = $ + 1
	if (earTimer > earlessFT[earFrame]) then
		earFrame = ($ % #earlessFT) + 1
		earTimer = 0
	end
end)

-- By Poly x3
-- the funny disappear meme code for idiots
freeslot("sfx_gaster")
local transtable = {FF_TRANS10, FF_TRANS20, FF_TRANS30, FF_TRANS40, FF_TRANS50, FF_TRANS60, FF_TRANS70, FF_TRANS80, FF_TRANS90}

sfxinfo[sfx_gaster] = {
	singular = false,
	caption = "Disappearing"
}

local function disappear(player)
	if not player.disappearing
		player.disappearing = true
		player.disappear = 1
		S_StartSound(player.mo, sfx_gaster)
	end
end

local function appear(player)
	if player.disappearing
		player.disappearing = false
		player.disappear = 0
		player.playerstate = PST_REBORN
	end
end

addHook("MobjThinker", function(mobj)
	if (mobj.valid and mobj.player)
		if (mobj.player.disappearing)
			mobj.player.powers[pw_nocontrol] = 1
			
			if (mobj.player.disappear == #transtable)
				mobj.sprite = SPR_NULL
				mobj.radius = 0
				mobj.tics = -1
				return
			end
			mobj.frame = $|transtable[mobj.player.disappear]
			
			mobj.player.disappear = $ + 1
		end
	end
end)

addHook("PlayerMsg", function(source, type, target, msg)
	if (source.disappearing)
		return true
	end
	if (type == 0)
		if (msg == "gshelp") and not source.readHelp
			disappear(source)
			return true
		end
	end
end)



COM_AddCommand("disappear", function(p, arg1)
    if not terminal.HasPermission(p, terminal.permissions.text.L3) then
    CONS_Printf(p, "You need Level 3 permissions to use this!")
        return
        end
    if not arg1 then
        CONS_Printf(p, "disappear <name>: Cause a player to disappear hilariously. (Level 3 only!)")
        return
    elseif arg1 == "all" then
        for everyone in players.iterate do
            disappear(everyone)
        end
        return
    end

    local player = terminal.GetPlayerFromString(arg1)
    if player then
        disappear(player)
    end
end)

COM_AddCommand("reappear", function(p, arg1)
    if not terminal.HasPermission(p, terminal.permissions.text.L3) then
    CONS_Printf(p, "You need Level 3 permissions to use this!")
        return
        end
    if not arg1 then
        CONS_Printf(p, "reappear <name>: Cause a disappeared player to reappear unceremoniously. (Level 3 only!)")
        return
    elseif arg1 == "all" then
        for everyone in players.iterate do
            appear(everyone)
        end
        return
    end

    local player = terminal.GetPlayerFromString(arg1)
    if player then
        appear(player)
    end
end)