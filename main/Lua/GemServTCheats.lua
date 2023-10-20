-- Terminal Cheats:
-- renamed to GemServTCheats.lua because GemServCore needs to load first and I want to be able to work on this in a folder

assert(terminal, "the Terminal core script must be added first!")

-- If it's a cheat in vanilla, it's here. If it isn't, it probably is anyway.

--SetRings Command
COM_AddCommand("setrings", function(p, rings)
	if not terminal.HasPermission(p, terminal.permissions.text.L2) then
		CONS_Printf(p, "You need Level 2 permissions to use this!")
		return
	end
	rings = tonumber(rings)
	if rings and rings >= 9999
		rings = 9999
	end
	if rings and rings < 0
		rings = nil
	end
	if rings == nil
		CONS_Printf(p, "setrings <number of rings>: Sets everyone's rings to a specific number.")
		return
	end
	for player in players.iterate
		if player.spectator then continue end
		player.rings = rings 
		player.mo.rings = rings
	end
end)

--SetLives Command
COM_AddCommand("setlives", function(p, lives)
	if not terminal.HasPermission(p, terminal.permissions.text.L2) then
		CONS_Printf(p, "You need Level 2 permissions to use this!")
		return
	end
	lives = tonumber(lives)
	if lives then
		if lives >= 127 then
			lives = 127
		end
		if lives < 0 then
			lives = nil
		end
	else
		CONS_Printf(p, "setlives <number of lives>: Sets the player's lives to a specific number.")
		return
	end
	for player in players.iterate
		player.lives = lives
	end
end)

--God Command
COM_AddCommand("god", function(p)	
	if not terminal.HasPermission(p, terminal.permissions.text.L1) then
		CONS_Printf(p, "You need Level 1 permissions to use this!")
		return
	end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	if not (p.pflags & PF_GODMODE)
		p.pflags = $1|PF_GODMODE
		CONS_Printf(p, "God mode is ON.")
	else 
		p.pflags = $1 & ~PF_GODMODE
		CONS_Printf(p, "God mode is OFF.")
	end	
end)

--NoClip Command
COM_AddCommand("noclip", function(p)
	if not terminal.HasPermission(p, terminal.permissions.text.L1) then
		CONS_Printf(p, "You need Level 1 permissions to use this!")
		return
	end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	if not (p.pflags & PF_NOCLIP)
		p.pflags = $1|PF_NOCLIP
		CONS_Printf(p, "NoClip is ON.")
	else 
		p.pflags = $1 & ~PF_NOCLIP
		CONS_Printf(p, "NoClip is OFF.")
	end
end)

-- Warp to another player
COM_AddCommand("warpto", function(p, arg1)
	if not terminal.HasPermission(p, terminal.permissions.text.L1) then
		CONS_Printf(p, "You need Level 1 permissions to use this!")
		return
	end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if arg1 == nil then
		CONS_Printf(p, "warpto <player>: Warp to another player's location!")
		return
	end
	local player = terminal.GetPlayerFromString(arg1)
	if not player then
		CONS_Printf(p, "Player "..arg1.." does not exist!")
		return
	end
	if player.spectator then
		CONS_Printf(p, "Cannot warp to spectator \""..player.name.."\".")
		return
	end
	P_TeleportMove(p.mo, player.mo.x, player.mo.y, player.mo.z)
	--print(p.name.." warped to "..player.name..".")
	P_FlashPal(p, PAL_MIXUP, 10)
	S_StartSound(p.mo, sfx_mixup)
end)

-- Kill yourself
COM_AddCommand("suicide", function(p)
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "Can't kill what's already dead!") return end
	if p.mo and p.mo.health > 0
		p.pflags = $1 & ~PF_GODMODE
		p.powers[pw_super] = 0
		p.exiting = 0		
		P_KillMobj(p.mo)
		print(p.name+" suicided!")		
    end
end)

-- Change your scale
COM_AddCommand("scale", function(p, scale)
	if not terminal.HasPermission(p, terminal.permissions.text.L1) then
		CONS_Printf(p, "You need Level 1 permissions to use this!")
		return
	end
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	local nScale = terminal.FloatFixed(scale)
	if not nScale then
		CONS_Printf(p, "scale <number>: Make yourself bigger or smaller!")
		return
	end
	if not terminal.HasPermission(p, terminal.permissions.text.L2) and
	 nScale > 5*FRACUNIT then
	CONS_Printf(p, "Please pick a number between 0.01 and 5!")
	    return
	end
	     p.mo.destscale = nScale
	  --print(p.name .. " changed size!")
	end)

-- Normal Speed
COM_AddCommand("normalspeed", function(player, arg1)
	if not terminal.HasPermission(player, terminal.permissions.text.L1) then
		CONS_Printf(player, "You need Level 1 permissions to use this!")
		return
	end
	if not arg1 or (tonumber(arg1) == nil) then
		CONS_Printf(player, "normalspeed <number>: Change your normal speed.")
		return
	end
	if arg1 == "default" then
		player.normalspeed = skins[player.mo.skin].normalspeed
	else
		player.normalspeed = (tonumber(arg1))*FRACUNIT
	end
end)

-- Run Speed
COM_AddCommand("runspeed", function(player, arg1)
	if not terminal.HasPermission(player, terminal.permissions.text.L1) then
		CONS_Printf(player, "You need Level 1 permissions to use this!")
		return
	end
	if not arg1 or (tonumber(arg1) == nil) then
		CONS_Printf(player, "runspeed <number>: Change your run speed.")
		return
	end
	if arg1 == "default" then
		player.runspeed = skins[player.mo.skin].runspeed
	else
		player.runspeed = (tonumber(arg1))*FRACUNIT
	end
end)

-- Jump Factor
COM_AddCommand("jumpfactor", function(player, arg1)
	if not terminal.HasPermission(player, terminal.permissions.text.L1) then
		CONS_Printf(player, "You need Level 1 permissions to use this!")
		return
	end
	if not arg1 or (tonumber(arg1) == nil) then
		CONS_Printf(player, "jumpfactor <number>: Change the height of your jump.")
		return
	end
	if arg1 == "default" then
		player.jumpfactor = skins[player.mo.skin].jumpfactor
	else
			player.jumpfactor = ((tonumber(arg1))*FRACUNIT) 	
	end
end)

-- Thrust Factor
COM_AddCommand("thrustfactor", function(player, arg1)
	if not terminal.HasPermission(player, terminal.permissions.text.L1) then
		CONS_Printf(player, "You need Level 1 permissions to use this!")
		return
	end
	if not arg1 or (tonumber(arg1) == nil) then
		CONS_Printf(player, "thrustfactor <number>: Change your thrust factor.")
		return
	end
	if arg1 == "default" then
		player.thrustfactor = skins[player.mo.skin].thrustfactor
	else
		player.thrustfactor = tonumber(arg1) 
	end
end)

-- Accel Start
COM_AddCommand("accelstart", function(player, arg1)
	if not terminal.HasPermission(player, terminal.permissions.text.L1) then
		CONS_Printf(player, "You need Level 1 permissions to use this!")
		return
	end
	if not arg1 or (tonumber(arg1) == nil) then
		CONS_Printf(player, "accelstart <number>: Change your acceleration start.")
		return
	end
	if arg1 == "default" then
		player.accelstart = skins[player.mo.skin].accelstart
	else
		player.accelstart = tonumber(arg1)
	end
end)

-- Acceleration
COM_AddCommand("acceleration", function(player, arg1)
	if not terminal.HasPermission(player, terminal.permissions.text.L1) then
		CONS_Printf(player, "You need Level 1 permissions to use this!")
		return
	end
	if not arg1 or (tonumber(arg1) == nil) then
		CONS_Printf(player, "acceleration <number>: Set your acceleration.")
		return
	end
	if arg1 == "default" then
		player.acceleration = skins[player.mo.skin].acceleration
	else
		player.acceleration = tonumber(arg1)
	end
end)

-- Min Dash
COM_AddCommand("mindash", function(player, arg1)
	if not terminal.HasPermission(player, terminal.permissions.text.L1) then
		CONS_Printf(player, "You need Level 1 permissions to use this!")
		return
	end
	if not arg1 or (tonumber(arg1) == nil) then
		CONS_Printf(player, "mindash <number>: Change your minimum spindash speed.")
		return
	end
	if arg1 == "default" then
		player.mindash = skins[player.mo.skin].mindash
	else
		player.mindash = (tonumber(arg1))*FRACUNIT
	end
end)

-- Max Dash
COM_AddCommand("maxdash", function(player, arg1)
	if not terminal.HasPermission(player, terminal.permissions.text.L1) then
		CONS_Printf(player, "You need Level 1 permissions to use this!")
		return
	end
	if not arg1 or (tonumber(arg1) == nil) then
		CONS_Printf(player, "maxdash <number>: Change your fully charged spindash speed.")
		return
	end
	if arg1 == "default" then
		player.maxdash = skins[player.mo.skin].maxdash
	else
		player.maxdash = (tonumber(arg1))*FRACUNIT
	end
end)

-- Action Speed
COM_AddCommand("actionspd", function(p, arg1)
	if not terminal.HasPermission(p, terminal.permissions.text.L1) then
		CONS_Printf(p, "You need Level 1 permissions to use this!")
		return
	end
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if not arg1 or (tonumber(arg1) == nil) then
		CONS_Printf(p, "actionspd <value>: Change how fast you can execute abilities.")
		return
	end
	if arg1 == "default" then
		p.actionspd = skins[p.mo.skin].actionspd
	else
		p.actionspd = terminal.FloatFixed(arg1)
	end
end)

-- Gravity Flip
COM_AddCommand("gravflip", function(p)
	if not terminal.HasPermission(p, terminal.permissions.text.L1) then
		CONS_Printf(p, "You need Level 1 permissions to use this!")
		return
	end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	p.mo.flags2 = $1^^MF2_OBJECTFLIP
end)

-- Give Shield
COM_AddCommand("giveshield", function(p, shield)
	if not terminal.HasPermission(p, terminal.permissions.text.L1) then
		CONS_Printf(p, "You need Level 1 permissions to use this!")
		return
	end
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	local sh = P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z, MT_THOK)
	sh.target = p.mo
	
	if shield == "none" or shield == "remove" then
		if (p.powers[pw_shield] & SH_FORCEHP) then
		P_RemoveShield(p)
		P_RemoveShield(p)
		S_StartSound(p.mo, sfx_shldls)
		else
		P_RemoveShield(p)
		S_StartSound(p.mo, sfx_shldls)
		end
	elseif shield == "force" then
		P_SwitchShield(p, SH_FORCE|1)
		S_StartSound(p.mo, sfx_forcsg)
	elseif shield == "halfforce" then
		if (p.powers[pw_shield] & SH_FORCEHP) then
		P_RemoveShield(p)
		S_StartSound(p.mo, sfx_frcssg)
		else
		P_SwitchShield(p, SH_FORCE)
		S_StartSound(p.mo, sfx_frcssg)
		end
	elseif shield == "pity" or shield == "normal" then
		P_SwitchShield(p, SH_PITY)
		S_StartSound(p.mo, sfx_shield)
	elseif shield == "amy" or shield == "pink" then
		P_SwitchShield(p, SH_PINK)
		S_StartSound(p.mo, sfx_cdpcm6)
		S_StartSound(p.mo, sfx_shield)
	elseif shield == "elemental" then
		P_SwitchShield(p, SH_ELEMENTAL)
		S_StartSound(p.mo, sfx_elemsg)
	elseif shield == "attraction" then
		P_SwitchShield(p, SH_ATTRACT)
		S_StartSound(p.mo, sfx_attrsg)
	elseif shield == "whirlwind" then
		P_SwitchShield(p, SH_WHIRLWIND)
		S_StartSound(p.mo, sfx_wirlsg)
	elseif shield == "armageddon" or shield == "nuke" then
		P_SwitchShield(p, SH_ARMAGEDDON)
		S_StartSound(p.mo, sfx_armasg)
	elseif shield == "fire" or shield == "flame" then
		P_SwitchShield(p, SH_FLAMEAURA)
		S_StartSound(p.mo, sfx_s3k3e)
	elseif shield == "bubble" or shield == "water" then
		P_SwitchShield(p, SH_BUBBLEWRAP)
		S_StartSound(p.mo, sfx_s3k3f)
	elseif shield == "thunder" or shield == "electric" then
		P_SwitchShield(p, SH_THUNDERCOIN)
		S_StartSound(p.mo, sfx_s3k41)
	elseif shield == "fireflower" then
		P_SwitchShield(p, SH_FIREFLOWER)
		S_StartSound(p.mo, sfx_mario3)
	elseif shield == "rock" then
		P_SwitchShield(p, SH_ROCKSHIELD)
		S_StartSound(p.mo, sfx_s3k6e)
	elseif shield == "cactus" or shield == "cacti" then
		P_SwitchShield(p, SH_CACTISHIELD)
		S_StartSound(p.mo, sfx_cactsh)
	else
		CONS_Printf(p,"Usage: [giveshield <type>]")
		CONS_Printf(p,"")
		CONS_Printf(p,"Possible options are: none/remove, force, halfforce, pity/normal, amy/pink, elemental, attraction, whirlwind, armageddon/nuke, fire/flame, bubble/water, thunder/electric, fireflower, rock, and cactus/cacti. Check the \"esp\" command for more.")
		P_RemoveMobj(sh)
		return
	end
	P_RemoveMobj(sh)
	CONS_Printf(p, "Shield changed to \""..shield.."\".")
end)

-- Run On Water
COM_AddCommand("runonwater", function(p)
	if not terminal.HasPermission(p, terminal.permissions.text.L1) then
		CONS_Printf(p, "You need Level 1 permissions to use this!")
		return
	end
	if not (p.charflags & SF_RUNONWATER) then
		CONS_Printf(p, "Running on water is ON.")
		p.charflags = $1|SF_RUNONWATER
	else
		p.charflags = $1 & ~SF_RUNONWATER
		CONS_Printf(p, "Running on water is OFF.")
	end
end)

-- Template function for evaluating psuedo variables in flag strings
local function generateFlags(flags, original)
	local flagtype = original
	local temp = 0
	local test = pcall(function()
		flags = $1:gsub("$1", original)--[[
		if flags:sub(1, 3) == "$1|" then
		    temp = flags:upper():sub(4)
			flagtype = $1|_G[temp]
			--flagtype = $1|EvalMath(flags:upper():sub(4))
		elseif flags:sub(1, 3) == "$1&" then
		    temp = flags:upper():sub(4)
			flagtype = $1&_G[temp]
			--flagtype = $1&EvalMath(flags:upper():sub(4))
		elseif flags:sub(1, 4) == "$1^^" then
		    temp = flags:upper():sub(5)
			flagtype = $1^^_G[temp]
			--flagtype = $1^^EvalMath(flags:upper():sub(5))
		else]]
		    temp = flags:upper()
			flagtype = _G[temp]
			--flagtype = EvalMath(flags:upper())	
		--end
	end)
	if not test then
		return nil
	end
	return flagtype
end

-- Help listing
terminal.AddHelp("cheats",
[[The Terminal cheats module provides various console commands to mess with the game with! Most of the commands need either Level 1 or Level 2 permissions.

Some useful commands:
  god, noclip, devmode: Same (or similar) functions as in the full game.
  showplayers: Toggles drawing crosshairs pointing at every friendly player in the game.
  warpto: Teleport to another player.
  giveshield: Get a shield.
  setmyrings, setmylives: Self-explanatory.

More commands are available, too.]])

-- BREAKING NEWS: WOLFY ADDS USELESS SILLY THINGS -Red

-- Helper function for parsing flag tables
terminal.generateFlags = function(flagtype, flags)
	local ret, flagprefix
	local newflags = {}
	if flagtype == "skin" then
		flagprefix = "SF_"
	elseif flagtype == "mobj" then
		flagprefix = "MF_"
	elseif flagtype == "mobj2" then
		flagprefix = "MF2_"
	elseif flagtype == "extra" then
		flagprefix = "MFE_"
	else
		flagprefix = "PF_"
	end
	for i, v in ipairs(flags) do
		flags[i] = $1:upper()
		if flags[i]:sub(1, flagprefix:len()) ~= flagprefix then
			flags[i] = flagprefix..flags[i]
		end
		newflags[i] = _G[flags[i]]
		if (ret == nil) then
			ret = newflags[i]
		else
			ret = $1|newflags[i]
		end
	end
	return ret
end

-- Add flags to the player
COM_AddCommand("addflags", function(p, flagtype, ...)
	if not terminal.HasPermission(p, terminal.permissions.text.L1) then
		CONS_Printf(p, "You need Level 1 permissions to use this!")
		return
	end
	if not ... or not flagtype then
		CONS_Printf(p, [[addflags <flagtype> <flags>: Add to your current flags! You can separate multiple flags with a space. Possible flag types are skin, mobj, mobj2, extra, and player. 
Flags don't need prefixes (SF_) and can also be lowercase.
Example usage: 'addflags skin runonwater noskid']])
		return
	end
	
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	
	local setflags = terminal.generateFlags(flagtype, {...})
	local cmd = flagtype.." "..table.concat({...}, " ")
	if setflags == nil then
		CONS_Printf(p, "Error occurred while parsing "..terminal.colors.yellow..cmd..terminal.colors.white..".")
		return
	end
	if flagtype == "skin" then
		p.charflags = $1|setflags
	elseif flagtype == "mobj" then
		p.mo.flags = $1|setflags
	elseif flagtype == "mobj2" then
		p.mo.flags2 = $1|setflags
	elseif flagtype == "extra" then
		p.mo.eflags = $1|setflags
	elseif flagtype == "player" then
		p.pflags = $1|setflags
	end
end)

-- Remove flags from the player
COM_AddCommand("removeflags", function(p, flagtype, ...)
	if not terminal.HasPermission(p, terminal.permissions.text.L1) then
		CONS_Printf(p, "You need Level 1 permissions to use this!")
		return
	end
	if not ... or not flagtype then
		CONS_Printf(p, [[removeflags <flagtype> <flags>: Remove some of your current flags! You can separate multiple flags with a space. Possible flag types are skin, mobj, mobj2, extra, and player. 
Flags don't need prefixes (SF_) and can also be lowercase.
Example usage: 'removeflags skin runonwater noskid']])
		return
	end
	
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	
	local setflags = terminal.generateFlags(flagtype, {...})
	local cmd = flagtype.." "..table.concat({...}, " ")
	if setflags == nil then
		CONS_Printf(p, "Error occurred while parsing "..terminal.colors.yellow..cmd..terminal.colors.white..".")
		return
	end
	if flagtype == "skin" then
		p.charflags = $1 & ~setflags
	elseif flagtype == "mobj" then
		p.mo.flags = $1 & ~setflags
	elseif flagtype == "mobj2" then
		p.mo.flags2 = $1 & ~setflags
	elseif flagtype == "extra" then
		p.mo.eflags = $1 & ~setflags
	elseif flagtype == "player" then
		p.pflags = $1 & ~setflags
	end
end)

-- Thok Item
COM_AddCommand("thokitem", function(p, flags)
	if not terminal.HasPermission(p, terminal.permissions.text.L2) then
		CONS_Printf(p, "You need Level 2 permissions to use this!")
		return
	end
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	if not flags then
		CONS_Printf(p, [[thokitem <object type>: Change your Thok Item.]])
		return
	end
	if flags == "0" then
	  p.thokitem = 0
	return end
	if tonumber(flags)
	  if tonumber(flags) < 673 and tonumber(flags) > 0
	    p.thokitem = tonumber(flags)
	  else
	  CONS_Printf(p, "You have entered a nonexistent object.")
	  return end
	else
	  local test = generateFlags(flags, p.thokitem)
	  if test == nil then
		CONS_Printf(p, "You have entered a nonexistent object.")
		return
	  else
	    p.thokitem = test
	  end
	end	
end)

-- Spin Item
COM_AddCommand("spinitem", function(p, flags)
	if not terminal.HasPermission(p, terminal.permissions.text.L2) then
		CONS_Printf(p, "You need Level 2 permissions to use this!")
		return
	end
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	if not flags then
		CONS_Printf(p, [[spinitem <object type>: Change your Spin Item.]])
		return
	end
	if flags == "0" then
	  p.spinitem = 0
	return end
	if tonumber(flags)
	  if tonumber(flags) < 673 and tonumber(flags) > 0
	    p.spinitem = tonumber(flags)
	  else
	  CONS_Printf(p, "You have entered a nonexistent object.")
	  return end
	else
	  local test = generateFlags(flags, p.spinitem)
	  if test == nil then
		CONS_Printf(p, "You have entered a nonexistent object.")
		return
	  else
	    p.spinitem = test
	  end
	end	
end)

-- Rev Item
COM_AddCommand("revitem", function(p, flags)
	if not terminal.HasPermission(p, terminal.permissions.text.L2) then
		CONS_Printf(p, "You need Level 2 permissions to use this!")
		return
	end
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	if not flags then
		CONS_Printf(p, [[revitem <object type>: Change your Rev Item.]])
		return
	end
	if flags == "0" then
	  p.revitem = 0
	return end
	if tonumber(flags)
	  if tonumber(flags) < 673 and tonumber(flags) > 0
	    p.revitem = tonumber(flags)
	  else
	  CONS_Printf(p, "You have entered a nonexistent object.")
	  return end
	else
	  local test = generateFlags(flags, p.revitem)
	  if test == nil then
		CONS_Printf(p, "You have entered a nonexistent object.")
		return
	  else
	    p.revitem = test
	  end
	end	
end)

-- Rev Item
COM_AddCommand("followitem", function(p, flags)
	if not terminal.HasPermission(p, terminal.permissions.text.L2) then
		CONS_Printf(p, "You need Level 2 permissions to use this!")
		return
	end
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	if not flags then
		CONS_Printf(p, [[followitem <object type>: Change your Follow Item.]])
		return
	end
	if flags == "0" then
	  p.followitem = 0
	return end
	if tonumber(flags)
	  if tonumber(flags) < 673 and tonumber(flags) > 0
	    p.followitem = tonumber(flags)
	  else
	  CONS_Printf(p, "You have entered a nonexistent object.")
	  return end
	else
	  local test = generateFlags(flags, p.followitem)
	  if test == nil then
		CONS_Printf(p, "You have entered a nonexistent object.")
		return
	  else
	    p.followitem = test
	  end
	end	
end)

-- PAnim
COM_AddCommand("panim", function(p, flags)
	if not terminal.HasPermission(p, terminal.permissions.text.L2) then
		CONS_Printf(p, "You need Level 2 permissions to use this!")
		return
	end
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	if not flags then
		CONS_Printf(p, [[panim <constant>: Change your Player Animation.]])
		return
	end
	if flags == "0" then
	  p.panim = 0
	return end
	if tonumber(flags)
	  if tonumber(flags) < 7 and tonumber(flags) > 0
	    p.panim = tonumber(flags)
	  else
	  CONS_Printf(p, "You have entered a nonexistent animation.")
	  return end
	else
	  local test = generateFlags(flags, p.panim)
	  if test == nil then
		CONS_Printf(p, "You have entered a nonexistent animation.")
		return
	  else
	    p.panim = test
	  end
	end	
end)

-- Kill all enemies in the map
COM_AddCommand("destroyallenemies", function(p)
	if not terminal.HasPermission(p, terminal.permissions.text.L2) then
		CONS_Printf(p, "You need Level 2 permissions to use this!")
		return
	end
	for player in players.iterate
		for mobj in thinkers.iterate("mobj") do
			if ((mobj.valid) and ((mobj.flags & MF_ENEMY) or (mobj.flags & MF_BOSS))) then
				P_KillMobj(mobj, player.mo, player.mo)
			end
		end
	end
end)

-- Spawn an object
COM_AddCommand("spawnobject", function(p, objecttype)
  if not terminal.HasPermission(p, terminal.permissions.text.L2) then
    CONS_Printf(p, "You need Level 2 permissions to use this!")
    return
  end
  if not objecttype then CONS_Printf(p, "spawnobject <mobj>: Spawns the corresponding mobj 100 fracunits in front of you!") return end
  if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
  if objecttype == "0" then
    objecttype = 0
  return end
  if tonumber(objecttype)
    if tonumber(objecttype) < 673 and tonumber(objecttype) > 0
      objecttype = tonumber(objecttype)
    else
	  CONS_Printf(p, "You have entered a nonexistent object.")
	end
  else
    local test = generateFlags(objecttype, 0)
    if test == nil then
      CONS_Printf(p, "You have entered a nonexistent object.")
      return
    else
	  objecttype = test
	end
  end
  local call = pcall(do
    local playerscalecorrect = p.mo.scale/FRACUNIT
    local butt = P_SpawnMobj(p.mo.x + 100*cos(p.mo.angle)*playerscalecorrect, p.mo.y + 100*sin(p.mo.angle)*playerscalecorrect, p.mo.z, objecttype)
    butt.angle = p.mo.angle
    butt.color = p.mo.color
    butt.skin = p.mo.skin
    butt.scale = p.mo.scale		
  end)	
end)


-- Change your character's ability
COM_AddCommand("charability", function(p, arg1)
	if not terminal.HasPermission(p, terminal.permissions.text.L1) then
		CONS_Printf(p, "You need Level 1 permissions to use this!")
		return
	end
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if not arg1 then
		CONS_Printf(p, "charability <ability>: Change your ability! Accepts CA_ arguments or numbers.")
		return
	end
	if arg1 == "default" then
		p.charability = skins[p.mo.skin].ability
	else
	  if arg1 == "0" then
	    p.charability = 0
	  return end
	if tonumber(arg1)
	  if tonumber(arg1) < 14 and tonumber(arg1) > 0
	    p.charability = tonumber(arg1)
	  else
	  CONS_Printf(p, "You have entered a nonexistent ability.")
	  return end
	else
	  local test = generateFlags(arg1, p.charability)
	  if test == nil then
		CONS_Printf(p, "You have entered a nonexistent ability.")
		return
	  else
	    p.charability = test
	  end
	 end
    end
end)

-- Change your character's secondary ability
COM_AddCommand("charability2", function(p, arg1)
	if not terminal.HasPermission(p, terminal.permissions.text.L1) then
		CONS_Printf(p, "You need Level 1 permissions to use this!")
		return
	end
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if not arg1 then
		CONS_Printf(p, "charability2 <ability>: Change your secondary ability! Accepts CA2_ arguments or numbers.")
		return
	end
	if arg1 == "default" then
		p.charability2 = skins[p.mo.skin].ability2
	else
	  if arg1 == "0" then
	    p.charability2 = 0
	  return end
	if tonumber(arg1)
	  if tonumber(arg1) < 3 and tonumber(arg1) > 0
	    p.charability2 = tonumber(arg1)
	  else
	  CONS_Printf(p, "You have entered a nonexistent secondary ability.")
	  return end
	else
	  local test = generateFlags(arg1, p.charability2)
	  if test == nil then
		CONS_Printf(p, "You have entered a nonexistent secondary ability.")
		return
	  else
	    p.charability2 = test
	  end
	 end
	end
end)


-- Set a player's size
COM_AddCommand("setscale", function(p, arg1, scale)
	if not terminal.HasPermission(p, terminal.permissions.text.L2) then
		CONS_Printf(p, "You need Level 2 permissions to use this!")
		return
	end
	if arg1 == nil then
		CONS_Printf(p, "setscale <player> <scale>: Change a player's size.")
		return
	end
	local player = terminal.GetPlayerFromString(arg1)
	if not p.mo then CONS_Printf(p, "You can't use this while you're spectating.") return end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	if not player then
		CONS_Printf(p, "Player "..arg1.." does not exist!") return end
	local nScale = terminal.FloatFixed(scale)
	if not nScale then
		CONS_Printf(p, "setscale <player> <scale>: Change a player's size.")
		return
	end
	player.mo.destscale = nScale
	--print(p.name .. " changed size.")
end)

-- Set Rings For
COM_AddCommand("setringsfor", function(p, arg1, rings)
	if not terminal.HasPermission(p, terminal.permissions.text.L2) then
		CONS_Printf(p, "You need Level 2 permissions to use this!")
		return
	end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	if arg1 == nil then
		CONS_Printf(p, "setringsfor <node> <rings>: Set rings for one player!")
		return
	end
	rings = tonumber(rings)
	if rings and rings >= 9999
		rings = 9999
	end
	if rings and rings < 0
		rings = nil
	end
	if rings == nil
		CONS_Printf(p, "setringsfor <node> <rings>: Set rings for one player!.")
		return
	end
	local player = terminal.GetPlayerFromString(arg1)
	if not player then
		CONS_Printf(p, "Player "..arg1.." does not exist!")
		return
	end
	if player.spectator then
		CONS_Printf(p, "Cannot give rings to spectator \""..player.name.."\".")
		return
	end
	player.rings = rings
	player.mo.rings = rings
end)

--  Set Lives For
COM_AddCommand("setlivesfor", function(p, arg1, lives)
	if not terminal.HasPermission(p, terminal.permissions.text.L2) then
		CONS_Printf(p, "You need Level 2 permissions to use this!")
		return
	end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return end
	if arg1 == nil then
		CONS_Printf(p, "setlivesfor <node> <lives>: Set lives for one player!")
		return
	end
	lives = tonumber(lives)
	if lives and lives >= 127
		lives = 127
	end
	if lives and lives < 0
		lives = nil
	end
	if lives == nil
		CONS_Printf(p, "setlivesfor <node> <lives>: Set lives for one player!")
		return
	end
	local player = terminal.GetPlayerFromString(arg1)
	if not player then
		CONS_Printf(p, "Player "..arg1.." does not exist!")
		return
	end
	if player.spectator then
		CONS_Printf(p, "Cannot give lives to spectator \""..player.name.."\".")
		return
	end
		player.lives = lives	
end)

-- Freeze
COM_AddCommand("freeze", function(p, arg1)
    if not terminal.HasPermission(p, terminal.permissions.text.L3) then
	CONS_Printf(p, "You need Level 3 permissions to use this!")
		return
		end
	if not arg1 then
		CONS_Printf(p, "freeze <name>: lock a player's controls (Level 3 only)")
		CONS_Printf(p, "Use \"all\" to freeze everyone, and \"none\" to unfreeze everyone.")
		return
	elseif arg1 == "all" then
		for everyone in players.iterate do
			everyone.frozen = true
		end
		print(p.name.." froze everyone.")
		return
	elseif arg1 == "none" then
		for everyone in players.iterate do
			everyone.frozen = false
		end
		print(p.name.." unfroze everyone.")
		return
	end
	
	local player = terminal.GetPlayerFromString(arg1)
	if player then
		player.frozen = not $1
		if player.frozen then
			print(player.name.." is now frozen.")
		else
			print(player.name.." is no longer frozen.")
		end
	end
end)
	
	addHook("ThinkFrame", function()
	for player in players.iterate do
		if player.frozen then
			player.powers[pw_nocontrol] = max($1, 2)
		end
		if player.deadtimer and player.gotflag then
			P_PlayerFlagBurst(player, false)
			player.tossdelay = max($1, 2*TICRATE)
		end
	end
end)

-- DoFor
COM_AddCommand("dofor", function(p, arg1, arg2)
    if not terminal.HasPermission(p, terminal.permissions.text.L3) then
    CONS_Printf(p, "You need Level 3 permissions to use this!")
        return
        end
    if not arg1 and not arg2 then
        CONS_Printf(p, "dofor <name> <command>: execute a command in another player's console (Level 3 only)")
        return
    elseif arg1 == "all" then
        for everyone in players.iterate do
            COM_BufInsertText(everyone, arg2)
        end
        return
    end

    local player = terminal.GetPlayerFromString(arg1)
    if player then
        COM_BufInsertText(player, arg2)
    end
end)

-- Set My Rings
COM_AddCommand("setmyrings", function(p, rings)
	if not terminal.HasPermission(p, terminal.permissions.text.L1) then
		CONS_Printf(p, "You need Level 1 permissions to use this!")
		return
  end
	if p.playerstate ~= PST_LIVE then CONS_Printf(p, "You can't cheat death!") return 
  end
	rings = tonumber(rings)
	if rings and rings >= 9999
		rings = 9999
	end
	if rings and rings < 0
		rings = nil
	end
	if rings == nil
		CONS_Printf(p, "setmyrings <rings>: Set your amount of rings.")
		return
	end
	p.rings = rings
	p.mo.rings = rings
    end)
	
-- Set My Lives
COM_AddCommand("setmylives", function(p, lives)
if not terminal.HasPermission(p, terminal.permissions.text.L1) then
		CONS_Printf(p, "You need Level 1 permissions to use this!")
		return
	end	
	lives = tonumber(lives)
	if lives and lives >= 127
		lives = 127
	end
	if lives and lives < 0
		lives = nil
	end
	if lives == nil
		CONS_Printf(p, "setmylives <lives>: Set your amount of lives.")
		return
	end
		p.lives = lives	
end)