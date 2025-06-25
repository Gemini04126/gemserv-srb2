-- Terminal v1.1 - The first SRB2 server hosting overhaul utility!
-- Created by Wolfy and RedEnchilada
-- Special thanks to Steel Titanium, Puppyfaic, and SonicX8000 for testing!
-- Edited by Alyssa, Shell, SSX and .Jazz.
-- Edited again by Seth! Sorry!
-- and included in GemServ by Gemini0... should probably call this GemTerm now-

-- Core file, contains base framework for Terminal functions.

-- Declare terminal library in global namespace
rawset(_G, "terminal", {})

-- Helper function for identifying a player
terminal.GetPlayerFromString = function(src)
	if tonumber(src) ~= nil then
		return players[tonumber(src)]
	else
		src = src:lower()
		for player in players.iterate do
			if player.name:lower() == src then return player end
		end
	end
end

-- Function to turn a decimal number string into a fixed! (Wrote my own so we don't need to ask JTE for his c: -Red)
terminal.FloatFixed = function(src)
	if src == nil then return nil end
	if not src:find("^-?%d+%.%d+$") then -- Not a valid number!
		--print("FAK U THIS NUMBER IS SHITE")
		if tonumber(src) then
			return tonumber(src)*FRACUNIT
		else
			return nil
		end
	end
	local decPlace = src:find("%.")
	local whole = tonumber(src:sub(1, decPlace-1))*FRACUNIT
	--print(whole)
	local dec = src:sub(decPlace+1)
	--print(dec)
	local decNumber = tonumber(dec)*FRACUNIT
	for i=1,dec:len() do
		decNumber = $1/10
	end
	if src:find("^-") then
		return whole-decNumber
	else
		return whole+decNumber
	end
end

--[[ Test command for above
COM_AddCommand("getfixed", function(p, a)
	CONS_Printf(p, terminal.FloatFixed(a))
end)]]

-- Convenience function to build a safe string to put as a console command
terminal.ConsoleCommand = function(...)
	local cmd = ""
	for _,i in ipairs({...}) do
		if i:find(" ") or i:find(";") then
			cmd = $1..' "'..i..'"'
		else
			cmd = $1.." "..i
		end
	end -- You could theoretically remove the leading space from cmd, but it doesn't actually affect the execution, so let's not. :)
	-- (Plus now that the code's also used for the changemap command...)
	
	return cmd
end

-- Helper function for ternary statements
rawset(_G, "tern", function(cond, t, f)
	if cond return t else return f end
end)

-- Function to return the map name of a specified map - errors out if the map header isn't set
terminal.MapName = function(i)
	if not mapheaderinfo[i] then error("MapName cannot be called with an empty map's index!", 2) end
	return mapheaderinfo[i].lvlttl:gsub("%z.*", ""):lower():gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
		..tern(mapheaderinfo[i].levelflags & LF_NOZONE, "", " Zone")
		..tern(mapheaderinfo[i].actnum == 0, "", " "..mapheaderinfo[i].actnum)
	-- Really long formula to generate the name string. Auto-capitalizes the first letter of each word.
end

-- Similar to above, but returns multiple variations for searching purposes, all regulated to lowercase
terminal.MapSearchNames = function(i)
	if not mapheaderinfo[i] then error("MapSearchNames cannot be called with an empty map's index!", 2) end
	local ret = {}
	
	-- Full name, always returned
	table.insert(ret, 
		mapheaderinfo[i].lvlttl:gsub("%z.*", ""):lower()
			..tern(mapheaderinfo[i].levelflags & LF_NOZONE, "", " zone")
			..tern(mapheaderinfo[i].actnum == 0, "", " act "..mapheaderinfo[i].actnum)
	)
	
	-- Without act keyword, only returned if an act was set
	if mapheaderinfo[i].actnum ~= 0 then
		table.insert(ret, 
			mapheaderinfo[i].lvlttl:gsub("%z.*", ""):lower()
				..tern(mapheaderinfo[i].levelflags & LF_NOZONE, "", " zone")
				.." "..mapheaderinfo[i].actnum
		)
	end
	
	-- Without zone keyword, only returned if "ZONE" was set
	if not (mapheaderinfo[i].levelflags & LF_NOZONE) then
		table.insert(ret, 
			mapheaderinfo[i].lvlttl:gsub("%z.*", ""):lower()
				..tern(mapheaderinfo[i].levelflags & LF_NOZONE, "", " zone")
				..tern(mapheaderinfo[i].actnum == 0, "", " act "..mapheaderinfo[i].actnum)
		)
	
		-- Without act keyword, only returned if an act was set
		if mapheaderinfo[i].actnum ~= 0 then
			table.insert(ret, 
				mapheaderinfo[i].lvlttl:gsub("%z.*", ""):lower()
					.." "..mapheaderinfo[i].actnum
			)
		end
	end
	
	-- TODO add abbreviation?
	
	return ret
end

-- Permissions system! -Red
terminal.permissions = {
	SELFCHEATS   = 2,
	OTHERCHEATS  = 4,
	GLOBALCHEATS = 8,
	PLAYERMANAGE = 16,
	GAMEMANAGE   = 32,
	FULLCONTROL  = 64
}

-- Colors!
terminal.colors = {
	-- proper names
	white  = "\x80",
	purple = "\x81",
	yellow = "\x82",
	green  = "\x83",
	blue   = "\x84",
	red    = "\x85",
	grey   = "\x86",
	orange = "\x87",
	
	-- indexes
	[1] = "\x80",
	[2] = "\x81",
	[3] = "\x82",
	[4] = "\x83",
	[5] = "\x84",
	[6] = "\x85",
	[7] = "\x86",
	[8] = "\x87",
}

-- Can use OR to check for multiple permissions - must have all of them!
terminal.HasPermission = function(p, permflags)
	if p == server --[[or p == admin]] then return true end -- Server has ALL the permissions!
	if not p.servperm then
		p.servperm = 0
	end
	return (p.servperm & permflags) == permflags
end

terminal.SetPermission = function(p, permflags)
	if not p.servperm then
		p.servperm = 0
	end
	p.servperm = permflags
end

-- Raw console commands for permissions
terminal.permissions.text = {
    L0     = 1,	
	L1     = terminal.permissions.SELFCHEATS,		
	L2     = terminal.permissions.SELFCHEATS|terminal.permissions.OTHERCHEATS|terminal.permissions.GLOBALCHEATS,	
	L3     = ~0 -- EVERYTHING! MWAHAHA
}

COM_AddCommand("defaultpermission", function(p, arg1)
  if not terminal.HasPermission(p, terminal.permissions.text.L3) then
	CONS_Printf(p, "You need Level 3 permissions to use this!")
	return
  end
  if arg1 == nil then -- No arguments passed!
    CONS_Printf(p, "defaultpermission <permission>: Set the default user permissions on the server, that everyone will receive upon join! Be very careful with this command, giving high permissions to random users can be risky!")
    -- Get available permissions
    local str = "Available permissions: L0/None, L1, L2 and L3."			
    CONS_Printf(p, str)
    return
  end
  if arg1 == "l1" then
	arg1 = "L1"
  elseif arg1 == "l2" then
	arg1 = "L2"
  elseif arg1 == "l3" then
	arg1 = "L3"
  elseif arg1 == "l0" or arg1 == "none" or arg1 == "None" or arg1 == "NONE" then
	arg1 = "L0"
  end
  if not terminal.permissions.text[arg1] then
	CONS_Printf(p, ("Invalid parameter \"%s\"."):format(arg1))
    return
  end
  server.defaultpermission = arg1
end)

addHook("MobjThinker", function(p)
	if server.defaultpermission and not p.player.servperm and not (p.player == server) then
	  if not terminal.permissions.text[server.defaultpermission] then
	    terminal.SetPermission(p.player, terminal.permissions.text["L0"])
	  else
		if server.defaultpermission == "L3" or server.defaultpermission == "L2" or server.defaultpermission == "L1" then
		  print(p.player.name.." has been given the default \""..server.defaultpermission.."\" permissions.")
		end
		terminal.SetPermission(p.player, terminal.permissions.text[server.defaultpermission])
	  end
	end
end, MT_PLAYER)

COM_AddCommand("setpermission", function(p, arg1, arg2)
	if not terminal.HasPermission(p, terminal.permissions.text.L3) then
		CONS_Printf(p, "You need Level 3 permissions to use this!")
		return
	end
	local lowertemp = 0	
	if arg1 == "all" then
	  arg1 = arg2
	  arg2 = nil
	end
	if arg1 == "lower" then
	  lowertemp = 1
	  arg1 = arg2
	  arg2 = nil
	end
	if arg2 == nil then
		if arg1 == nil then -- No arguments passed!
			CONS_Printf(p, "setpermission <user/all/lower> <permission>: Set a user's server permissions!")
			-- Get available permissions
			local str = "Available permissions: L0/None, L1, L2 and L3."			
			CONS_Printf(p, str)			
			CONS_Printf(p, "If a user is not given or if 'all' is used instead of a user, this will set the specified permissions for all users.")
			CONS_Printf(p, "If 'lower' is used instead of a user, this will set the specified permissions for all users with lower permissions than the specified one, useful to mantain high level permissions when distributing lower level ones to the entire server.")
			return
		end
		arg2 = arg1
		arg1 = nil
	end
	if arg2 == "l1" then
	  arg2 = "L1"
	elseif arg2 == "l2" then
	  arg2 = "L2"
	elseif arg2 == "l3" then
	  arg2 = "L3"
	elseif arg2 == "l0" or arg2 == "none" or arg2 == "None" or arg2 == "NONE" then
	  arg2 = "L0"
	end
	if not terminal.permissions.text[arg2] then
		CONS_Printf(p, ("Invalid parameter \"%s\"."):format(arg2))
		return
	end
	
	do (function(func)
		if arg1 == nil then
			for player in players.iterate do func(player) end
		else
			local player = terminal.GetPlayerFromString(arg1)
			if not player then
				CONS_Printf(p, "Player "..arg1.." does not exist!")
				return
			end
			if player == server then
				CONS_Printf(p, "You can't change the server's permissions!")
				return
			end
			func(player)
		end
	end)(function(player)
	    if lowertemp == 0 then
		  if arg2 == "L0" then
		    if player == server then			
		    else
			  print(player.name.." now has no permissions.")
			end
		  else
		    if player == server then			
		    else
			  print(player.name.." now has \""..arg2.."\" permissions.")
			end
		  end
		  terminal.SetPermission(player, terminal.permissions.text[arg2])
		elseif lowertemp == 1 then
		  if arg2 == "L0" then
		    return
		  else
		    if ((player == server) or ((arg2 == "L1" and terminal.HasPermission(player, terminal.permissions.text.L2)) or (arg2 == "L1" and terminal.HasPermission(player, terminal.permissions.text.L3)) or (arg2 == "L2" and terminal.HasPermission(player, terminal.permissions.text.L3))))	    
		    else
		      print(player.name.." now has \""..arg2.."\" permissions.")
			end
		  end
		  if ((player == server) or ((arg2 == "L1" and terminal.HasPermission(player, terminal.permissions.text.L2)) or (arg2 == "L1" and terminal.HasPermission(player, terminal.permissions.text.L3)) or (arg2 == "L2" and terminal.HasPermission(player, terminal.permissions.text.L3))))	    
		  else
		    terminal.SetPermission(player, terminal.permissions.text[arg2])
		  end
		end		
	end) end
	lowertemp = 0
end)

COM_AddCommand("removepermission", function(p, arg1)
	if not terminal.HasPermission(p, terminal.permissions.text.L3) then
		CONS_Printf(p, "You need Level 3 permissions to use this!")
		return
	end
    if arg1 == nil then -- No arguments passed!
	  CONS_Printf(p, "removepermission <user/all> : Remove server permissions from a user!")
	  CONS_Printf(p, "If 'all' is used instead of a user, this will remove all permissions from all users.")
	  return
	end
	do (function(func)
		if arg1 == "all" then
			for player in players.iterate do func(player) end
		else
			local player = terminal.GetPlayerFromString(arg1)
			if not player then
				CONS_Printf(p, "Player "..arg1.." does not exist!")
				return
			end
			if player == server then
				CONS_Printf(p, "You can't change the server's permissions!")
				return
			end
			func(player)
		end
	end)(function(player)
	    if player == server then		  
		else
		  print(player.name.." now has no permissions.")
		  terminal.SetPermission(player, terminal.permissions.text["L0"])
		end
	end) end
end)

-- Outdated hack for dedicated servers. It turns out that 2.1.14 still needs this shit!
local dediServer

COM_AddCommand("iamtheserver", function(p)
	if p == server or p == admin then return end -- Dedicated servers only!
	dediServer = p
	--COM_BufInsertText(p, "wait 15;wait 15;wait 15;iamtheserver") -- To keep syncing it for players! (lol NetVars hook still being broken)
end, 1)

-- Deprecated synchronization code
addHook("PlayerJoin", do
	if dediServer and dediServer.valid then
		COM_BufInsertText(dediServer, "wait 1;iamtheserver")
	end
end)

terminal.server = function()
	if not netgame then return server end -- Should work properly in SP since this is here
	return server or dediServer
end

-- Change the color of permission symbols. TODO: Option for permission color to be determined by team
local cv_permcolor = CV_RegisterVar({"permissioncolor", "green", 0, {white = 1, purple = 2, yellow = 3, green = 4, blue = 5, red = 6, grey = 7, orange = 8}}) 

-- Player symbol management. The ... argument is only used for /me.
local function getSymbol(player)
	local function c(s) return terminal.colors[cv_permcolor.value]..s..terminal.colors.white end
	if player == server then return c("~") end -- Server
	local p = player.servperm
	if not (p) or (p == 1) then return "" end -- No permissions! D:
	if (p & terminal.permissions.FULLCONTROL) then return c("&") end -- Admin
	if (p & terminal.permissions.PLAYERMANAGE) then return c("@") end -- Operator
	if (p & terminal.permissions.GAMEMANAGE) then return c("%") end -- Half-Op
	if (p & terminal.permissions.GLOBALCHEATS) then return c("#") end 
	if (p & terminal.permissions.text.L1) then return c("+") end -- Cheater
end

-- Function for retrieving the current team color.
local function getTeamColor(p) 
	if G_GametypeHasTeams() then
		if p.ctfteam == 0 return terminal.colors.white end
		if p.ctfteam == 1 then return terminal.colors.red end 
		if p.ctfteam == 2 then return terminal.colors.blue end 
	else return ""
	end
end

-- Grabs Terminal names, so the pMsg hook below isn't a clustered mess.
local function getTermName(p) 
	return getSymbol(p)..getTeamColor(p)..p.name..terminal.colors.white
end

-- Spectate yourself!
COM_AddCommand("spectate", function(p)
	if p.spectator or not p.mo then CONS_Printf(p, "You're already spectating!") return end
	P_KillMobj(p.mo)
	p.ctfteam = 0
	p.spectator = true
	print(p.name.." became a spectator.")
end)

--Player tracking! -Red
local function R_GetScreenCoords(p, c, mx, my, mz)
	local camx, camy, camz, camangle, camaiming
	if p.awayviewtics then
		camx = p.awayviewmobj.x
		camy = p.awayviewmobj.y
		camz = p.awayviewmobj.z
		camangle = p.awayviewmobj.angle
		camaiming = p.awayviewaiming
	elseif c.chase then
		camx = c.x
		camy = c.y
		camz = c.z
		camangle = c.angle
		camaiming = c.aiming
	else
		camx = p.mo.x
		camy = p.mo.y
		camz = p.mo.z+p.viewheight
		camangle = p.mo.angle
		camaiming = p.aiming
	end
	
	local x = camangle-R_PointToAngle2(camx, camy, mx, my)
	local distfact = FixedMul(FRACUNIT, cos(x))
	if x > ANGLE_90 or x < ANGLE_270 then
		x = 9999*FRACUNIT
	else
		x = FixedMul(tan(x+ANGLE_90), 160<<FRACBITS)+160<<FRACBITS
	end
	
	local y = camz-mz
	--print(y/FRACUNIT)
	y = FixedDiv(y, FixedMul(distfact, R_PointToDist2(camx, camy, mx, my)))
	y = (y*160)+100<<FRACBITS
	y = y+camaiming
	
	local scale = FixedDiv(160*FRACUNIT, FixedMul(distfact, R_PointToDist2(camx, camy, mx, my)))
	--print(scale)
	
	return x, y, scale
end

-- Complicated shit that Wolfy will never understand
hud.add(function(v, p, c)
	if p.spectator then return end
	if p.showPOn then
		local patch = v.cachePatch("CROSHAI1")
		do (function(func)
			if G_PlatformGametype() then
				for player in players.iterate do
					if player ~= p then
						func(player)
					end
				end
			elseif G_GametypeHasTeams() then
				for player in players.iterate do
					if player ~= p and player.ctfteam == p.ctfteam then
						func(player)
					end
				end
			end
		end)(function(player)
			if not player.mo then return end
			local x, y = R_GetScreenCoords(p, c, player.mo.x, player.mo.y, player.mo.z + 20*player.mo.scale)
			if x < 0 or x > 320*FRACUNIT or y < 0 or y > 200*FRACUNIT then return end
			v.drawScaled(x, y, FRACUNIT/2, patch, V_40TRANS)
			v.drawString(x/FRACUNIT+1, y/FRACUNIT+1, player.name, V_ALLOWLOWERCASE|V_40TRANS, "small-left")
		end) end
	end
end, "game")

-- Previously part of Terminal_Cheats. Showplayers is awesome though, so it's in Core now.
COM_AddCommand("showplayers", function(p)
	if not p.showPOn
		p.showPOn = true
		--CONS_Printf(p, "The Eggman Empire is ALWAYS watching its subjects...")
		CONS_Printf(p, "Player location display enabled.")
	else 
		p.showPOn = false		
		CONS_Printf(p, "Player location display disabled.")
	end
end)

-- Change the current map
COM_AddCommand("changemap", function(p, ...)
	if not terminal.HasPermission(p, terminal.permissions.text.L3) then
		CONS_Printf(p, "You need Level 3 permissions to use this!")
		return						
	end
	if not ... then -- TODO: open a menu that can be operated with game controls?
		CONS_Printf(p, "changemap <MAPxx>: Change the game map!")
		return
	end
	
	local cmd = "map"..terminal.ConsoleCommand(...)
	
	-- TODO make this less of a lazy hack
	COM_BufInsertText(terminal.server(), cmd)
	CONS_Printf(p, "Changing map... (If nothing happens, try -force or -gametype!)")
end)

-- Kill other players! 
COM_AddCommand("kill", function(p, arg1)
	if not terminal.HasPermission(p, terminal.permissions.text.L3) then
		CONS_Printf(p, "You need Level 3 permissions to use this!")		
		return
	end
	if arg1 == nil then
		CONS_Printf(p, "kill <player>: Kill a player.")
		return
	end
	local player = terminal.GetPlayerFromString(arg1)
	if not player then
		CONS_Printf(p, "Player "..arg1.." does not exist!")
		return
	end
	if player.mo and player.mo.health > 0	
		player.pflags = $1 & ~PF_GODMODE		
		player.powers[pw_super] = 0
		player.exiting = 0	
		P_KillMobj(player.mo)		
		print(p.name+" killed "..player.name..".")
	else
		CONS_Printf(p, "Player "..player.name.." is not alive!")
	end
end)

-- Kick and ban players
COM_AddCommand("dokick", function(p, arg1, ...)
	if not terminal.HasPermission(p, terminal.permissions.text.L3) then
		CONS_Printf(p, "You need Level 3 permissions to use this!")
		return
	end
	if arg1 == nil then
		CONS_Printf(p, "dokick <player> [<reason>]: Kick a player from the server.")
		return
	end
	local player = terminal.GetPlayerFromString(arg1)
	if not player then
		CONS_Printf(p, "Player "..arg1.." does not exist!")
		return
	end
	
	if terminal.HasPermission(player, terminal.permissions.text.L3) and not terminal.HasPermission(p, terminal.permissions.text.L3) then
		CONS_Printf(p, "Only Level 3 users can kick other Level 3 users.")
		return
	end
	
	CONS_Printf(player, terminal.colors.red..("FULL KICK REASON FROM %s:"):format(p.name)..terminal.ConsoleCommand(...))
	COM_BufInsertText(terminal.server(), ("kick %s <%s>"):format(#player, p.name)..terminal.ConsoleCommand(...))
end)

-- SRB2 seriously needs a super() function for replaced commands.
COM_AddCommand("doban", function(p, arg1, ...)
	if not terminal.HasPermission(p, terminal.permissions.text.L3) then
		CONS_Printf(p, "You need Level 3 permissions to use this!")
		return
	end
	if arg1 == nil then
		CONS_Printf(p, "doban <player> [<reason>]: Ban a player from the server.")
		return
	end
	local player = terminal.GetPlayerFromString(arg1)
	if not player then
		CONS_Printf(p, "Player "..arg1.." does not exist!")
		return
	end
	
	if terminal.HasPermission(player, terminal.permissions.text.L3) then
		CONS_Printf(p, "Level 3 users cannot be banned.")
		return
	end
	
	CONS_Printf(player, terminal.colors.red..("FULL BAN REASON FROM %s:"):format(p.name)..terminal.ConsoleCommand(...))
	COM_BufInsertText(terminal.server(), ("ban %s <%s>"):format(#player, p.name)..terminal.ConsoleCommand(...))
end)

-- "do" command, for ultimate power! (And this one doesn't need the command to be wrapped in quotes! -Red)
COM_AddCommand("do", function(p, ...)
	--print(_VERSION)
	if not terminal.HasPermission(p, terminal.permissions.text.L3) then
		CONS_Printf(p, "You need Level 3 permissions to use this!")
		return
	end
	if not ... then
		CONS_Printf(p, "do <command>: Execute a command remotely as the host.")
		return
	end
	
	-- Command blacklist
	local blacklist = { "loadhash", -- Terminal internal commands - alter this part as needed
	"quit", "setcontrol", "vid_mode", "exitgame", "say", "sayteam", "sayto", "startmovie", "screenshot", "stopmovie", "setcontrol2", "bind", "alias", "loadcfg", "savecfg", "cpusleep", "apng_compress_level", "apng_memory_level", "apng_strategy", "apng_window_size", "apng_speed", "gif_optimize", "gif_downscale", "moviemode_mode", "png_window_size", "png_compress_level", "png_memory_level", "png_strategy", "screenshot_folder", "screenshot_option", "allcaps", "controlperkey", "con_textsize", "con_speed", "con_hudtime", "con_hudlines", "con_height", "con_backpic", "skin", "chasecam", "cam_speed", "cam_still", "cam2_speed", "cam_rotate", "cam_height", "cam_dist", "autorecord", "crosshair", "cpuaffinity", "gr_fov", "gr_filtermode", "gr_fovchange", "invertmouse", "joyaxis_fire", "joyaxis2_fire", "joyaxis_firenormal", "joyaxis2_firenormal", "joyaxis_look", "joyaxis2_look", "joyaxis_side", "joyaxis2_side", "joyaxis_turn", "joyaxis2_turn", "masterserver", "name", "ontop", "scr_depth", "scr_height", "scr_width", "use_joystick", "use_joystick2", "use_mouse", "use_mouse2", "useranalog", "useranalog2", "viewheight", "soundvolume", "midimusicvolume", "digmusicvolume", "allowjoin", "echo"}
	local firstcmd = ...
	for _,i in ipairs(blacklist) do
		if firstcmd == i then
			CONS_Printf(p, ("Command \"%s\" has been blacklisted from the \"do\" command."):format(i))
			return
		end
	end
	
	local cmd = terminal.ConsoleCommand(...)
	--print(cmd)
	CONS_Printf(p, "Executing"..terminal.colors.yellow..cmd..terminal.colors.white.." in the server console.")
	CONS_Printf(terminal.server(), terminal.colors.yellow..p.name.." executed the following in the server console: "..terminal.colors.blue..">"..cmd:sub(2))
	COM_BufInsertText(terminal.server(), cmd)
end)

-- "findmap" command; go to a map by name! :O
-- Start with a helper function, for Levenshtein distance (thanks https://gist.github.com/Badgerati/3261142 !)
terminal.LevenshteinDistance = function(str1, str2)
	local len1 = string.len(str1)
	local len2 = string.len(str2)
	local matrix = {}
	local cost = 0
	
        -- quick cut-offs to save time
	if (len1 == 0) then
		return len2
	elseif (len2 == 0) then
		return len1
	elseif (str1 == str2) then
		return 0
	end
	
        -- initialise the base matrix values
	for i = 0, len1, 1 do
		matrix[i] = {}
		matrix[i][0] = i
	end
	for j = 0, len2, 1 do
		matrix[0][j] = j
	end
	
        -- actual Levenshtein algorithm
	for i = 1, len1, 1 do
		for j = 1, len2, 1 do
			if (str1:byte(i) == str2:byte(j)) then
				cost = 0
			else
				cost = 1
			end
			
			matrix[i][j] = min(min(matrix[i-1][j] + 1, matrix[i][j-1] + 1), matrix[i-1][j-1] + cost)
		end
	end
	
        -- return the last value - this is the Levenshtein distance
	return matrix[len1][len2]
end

-- A function to search the available maps for one by name. Returns the maplist sorted in order of closeness, each entry in the following struct:
--[[
	name = map name
	maptext = MAPxx
	dist = lev distance
]]
-- If exact match is found, fuck everything else and return a table with *JUST* this entry
terminal.SortMapsByName = function(name, alwaysall)
	local ret = {}
	name = $1:lower()
	
	for i=1, #mapheaderinfo do
		if not mapheaderinfo[i] then continue end
		
		local block = {}
		
		local names = terminal.MapSearchNames(i)
		
		block.name = names[1]
		block.maptext = G_BuildMapName(i)
		
		local dist = 9999*FRACUNIT
		
		for _,v in ipairs(names) do
			dist = min($1, (terminal.LevenshteinDistance(name, v)*FRACUNIT)/v:len())
			
			if (not alwaysall) and dist == 0 then -- Quick escape!
				block.dist = 0
				return {block}
			end
		end
		
		block.dist = dist
		table.insert(ret, block)
	end
	
	table.sort(ret, function(a, b) return a.dist < b.dist end)
	
	--[[ debug
	for _,v in ipairs(ret) do
		print(v.dist.." "..v.maptext.." "..v.name)
	end --]]
	
	return ret
end

-- Now the actual console command!
COM_AddCommand("findmap", function(p, name, ...)
	local nowarp
	if ... == "-nowarp" then
		nowarp = true
	elseif not terminal.HasPermission(p, terminal.permissions.text.L3) then
		CONS_Printf(p, "You need Level 3 permissions to use this!")
		return
	end
	if not name then -- TODO: open a menu that can be operated with game controls?
		CONS_Printf(p, "findmap \"<level name>\": Change the game map!")
		return
	end
	
	local names = terminal.SortMapsByName(name, nowarp)
	
	if nowarp then
		CONS_Printf(p, "Closest matches for \""..name.."\":")
		for i = 1,5 do
			CONS_Printf(p, i..") "..names[i].maptext..": "..names[i].name)
		end
		return
	end
	
	if names[1].dist > FRACUNIT/2 or (names[2] and FixedDiv(names[1].dist, names[2].dist) > 60000) then
		CONS_Printf(p, "No close enough match for \""..name.."\" found! Closest matches:")
		for i = 1,5 do
			CONS_Printf(p, i..") "..names[i].maptext..": "..names[i].name)
		end
		return
	end
	
	local cmd = "map "..names[1].maptext..terminal.ConsoleCommand(...)
	
	-- TODO make this less of a lazy hack
	COM_BufInsertText(terminal.server(), cmd)
	CONS_Printf(p, "Changing map... (If nothing happens, try -force or -gametype!)")
end)