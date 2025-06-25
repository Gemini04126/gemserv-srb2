local vertical_dash_dist = 10*FRACUNIT
local horizontal_dash_dist = 0
local thokcount = 2

local function resetThokCount(player)
	local pmo = player.mo
	if pmo.eflags&MFE_JUSTHITFLOOR
		player.thokcount = 2
		if not player.powers[pw_super]
			player.vertical_dash_dist = 10*FRACUNIT
			player.horizontal_dash_dist = FixedMul(pmo.scale, player.actionspd)
		else
			player.vertical_dash_dist = 20*FRACUNIT
			player.horizontal_dash_dist = FixedMul(pmo.scale, (3*player.actionspd/2))
		end
	end
end

local function resetThokCountSpawned(player)
	local pmo = player.mo
	player.thokcount = 2
	player.vertical_dash_dist = 10*FRACUNIT
	player.horizontal_dash_dist = FixedMul(pmo.scale, player.actionspd)
end

addHook("PlayerThink", resetThokCount)
addHook("PlayerSpawn", resetThokCountSpawned)
--Handles dashing in 3D
local function Do3DMetalDash(player)
	local pmo = player.mo
	--my god is this code a mess
	local dash_forward = (player.cmd.forwardmove) and not (((player.pflags & PF_USEDOWN) and (player.cmd.forwardmove) or ((player.cmd.forwardmove) and (player.cmd.sidemove))) and not (pmo.state == S_PLAY_FLOAT or pmo.state == S_PLAY_FLOAT_RUN))
	local dash_diagonal = ((player.cmd.forwardmove) and (player.cmd.sidemove)) and not ((player.pflags & PF_USEDOWN) and not (pmo.state == S_PLAY_FLOAT or pmo.state == S_PLAY_FLOAT_RUN))
	local dash_sideward = (player.cmd.sidemove) and not ((player.cmd.forwardmove) and (player.cmd.sidemove))  and not ((player.pflags & PF_USEDOWN) and not (pmo.state == S_PLAY_FLOAT or pmo.state == S_PLAY_FLOAT_RUN))
	local dash_upward = P_GetPlayerControlDirection(player) == 0 and not ((player.pflags & PF_USEDOWN) and not (pmo.state == S_PLAY_FLOAT or pmo.state == S_PLAY_FLOAT_RUN))
	local dash_downward = (player.pflags & PF_USEDOWN) and pmo.state != S_PLAY_FLOAT and pmo.state != S_PLAY_FLOAT_RUN
	if dash_forward
		P_InstaThrust(pmo, player.drawangle, player.horizontal_dash_dist)
	elseif dash_diagonal
		P_InstaThrust(pmo, player.drawangle, player.horizontal_dash_dist)
	elseif dash_sideward
		P_InstaThrust(pmo, player.drawangle, player.horizontal_dash_dist)
	elseif dash_upward
		P_SetObjectMomZ(pmo, player.vertical_dash_dist, false)
	elseif dash_downward
		P_SetObjectMomZ(pmo, -player.vertical_dash_dist, false)
	end
end
--Handles dashing in 2D
--the exact same way it worked in Sonic 3 & Knuckles
local function Do2DMetalDash(player)
	local pmo = player.mo
	local dash_forward = (player.cmd.forwardmove)
	local dash_upward = (player.cmd.forwardmove > 0) and not (player.cmd.forwardmove < 0)
	local dash_downward = (player.cmd.forwardmove < 0) and not (player.cmd.forwardmove > 0)
	if not dash_forward
		P_InstaThrust(pmo, pmo.angle, player.actionspd)
	elseif dash_upward
		P_SetObjectMomZ(pmo, vertical_dash_dist, false)
	elseif dash_downward
		P_SetObjectMomZ(pmo, -vertical_dash_dist, false)
	end
end
--now we can dash, yay :DDDDDD
addHook("AbilitySpecial", function(player)
	local pmo = player.mo
	if pmo.skin != "metalsonic" then
		return
	end
	if (player.thokcount == 0) then
		player.pflags = $ | PF_THOKKED
		return
	end
	P_SpawnThokMobj(player)
	S_StartSound(pmo, sfx_s3kb6) 
--	P_NukeEnemies(pmo, pmo, 1214*FRACUNIT)
--	StartQuakes(player)
	player.thokcount = player.thokcount - 1
	if not (pmo.flags2 & MF2_TWOD)
		Do3DMetalDash(player) --3D Metal Dash
	else
		Do2DMetalDash(player) --2D Metal Dash
	end
end)