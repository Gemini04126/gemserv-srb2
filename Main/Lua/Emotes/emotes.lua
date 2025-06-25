--Sounds
local EMOTE_SOUNDS = {sfx_s3k63, sfx_s3k63, sfx_3db06, sfx_hello, sfx_notadd, sfx_kc5d, sfx_bruh, sfx_hearte, sfx_adderr, sfx_taco, sfx_vineb}
local EMOTE_STATES = {S_ALART1, S_EMOTE2, S_EMOTE3, S_EMOTE4, S_EMOTE5, S_EMOTE6, S_EMOTE7, S_EMOTE8, S_EMOTE9, S_EMOTE10, S_EMOTE11}
local EMOTE_SPRITES = {"EWHEEL1", "EWHEEL2", "EWHEEL3", "EWHEEL4", "EWHEEL5", "EWHEEL6", "EWHEEL7", "EWHEEL8", "EWHEEL9", "EWHEEL10", "EWHEEL11"}
local SND_HELPME = sfx_alart
local SND_PINGSPAM = sfx_s3k67
local PINGSPAM_TIMER = 12 * TICRATE

--Print for player only
local function printF(player,str)
	if consoleplayer == player
		print(str)
	end
end

--Workaround to get the consoleplayer's camera mobj... ugh
local consoleplayer_camera = nil
local function getcam(v, player, camera)
    consoleplayer_camera = camera
end
hud.add(getcam, "game")

local function doemote(player, num)
	if num > #EMOTE_SOUNDS
		return
	end
	
	player.pingspam = $ + 110
	if player.pingspam >= PINGSPAM_TIMER
		player.pingspam = PINGSPAM_TIMER + TICRATE
		printF(player,"\133Too many emotes - slow down!")
		S_StartSoundAtVolume(nil,SND_PINGSPAM,200,player)
		return
	end
	
	local mo = player.mo
	local scale = player.mo.scale
	local pingsound = EMOTE_SOUNDS[num]
	local teamonly = false
	local help = false
	local ping = P_SpawnMobj(mo.x,mo.y,mo.z + 45 *scale,MT_GHOST)
	ping.fuse = 3/2 * TICRATE
	ping.momz = scale / 2
	ping.scale = scale * 3 / 2
	ping.destscale = ping.scale
	ping.state = EMOTE_STATES[num]
	
	local seeping = false
	if isdedicatedserver or (gametyperules & GTR_FRIENDLY)
		seeping = true
	
	elseif consoleplayer.ctfteam == player.ctfteam
		seeping = true
	
	elseif consoleplayer.spectator
		seeping = true
	end
	
	if num == 1--Help me ping
		if (gametyperules & GTR_TEAMS) or (gametyperules & GTR_FRIENDLY)
			pingsound = SND_HELPME
			teamonly = true
			help = true
			ping.colorized = true
			ping.fuse = 4 * TICRATE
			if player.ctfteam == 1
				ping.color = SKINCOLOR_RED
			elseif player.ctfteam == 2
				ping.color = SKINCOLOR_BLUE
			end
			player.pingspam = PINGSPAM_TIMER
			
			mo.help_ping = ping.fuse
			
			for player2 in players.iterate
				if player2.mo and player2.mo.valid and player2 != player
					local arr = P_SpawnMobj(player2.mo.x,player2.mo.y,player2.mo.z, MT_GHOST)
					arr.state = S_HELPARR
					arr.target = player2.mo
					arr.helptarget = ping
					arr.fuse = ping.fuse
					arr.color = player.mo.color
					arr.colorized = true
					if player2 != consoleplayer or not seeping
						arr.flags2 = $ | MF2_DONTDRAW
					end
				end
			end
		end
		ping.needhelptarget = mo
		ping.scale = $ * 5 / 12
	end
	
	if teamonly
		if seeping and help
			local endtext = "!"
			if (not isdedicatedserver)
				if consoleplayer != player
					local cpm = consoleplayer.mo
					if cpm and cpm.valid
						if R_PointToDist2(mo.x,mo.y,cpm.x,cpm.y) < 3000 * FRACUNIT
							endtext = " from nearby!"
						elseif R_PointToDist2(mo.x,mo.y,cpm.x,cpm.y) > 6000 * FRACUNIT
							endtext = " from far away!"
						end
					end
				end
			end
			print("\x82"..player.name.." is requesting help"..endtext)
		end
		if seeping == false
			ping.flags2 = $ | MF2_DONTDRAW
		end
	end
	
	if (teamonly and seeping) or (not teamonly)
		if help
			S_StartSound(nil,pingsound,nil)
		else
			S_StartSound(mo,pingsound,nil)
		end
	end
end

COM_AddCommand("emote", function(player, num)
	num = tonumber(num)
	if player and player.mo and player.mo.valid and num
		doemote(player, tonumber(num))
	end
end)

--Arrow thinker
addHook("MobjThinker", function(mo)
	if mo.target and mo.target.valid
		local t = mo.target
		local fp = false
		if t.player and t.player.valid and (t.player == consoleplayer) and consoleplayer_camera and (consoleplayer_camera.chase == false)
			fp = true
		end

		if mo.helptarget and mo.helptarget.valid--I am looking for my teammate who is calling for help
			local xx = t.x
			local yy = t.y
			local zz = t.z
			mo.angle = R_PointToAngle2(xx, yy, mo.helptarget.x, mo.helptarget.y)
			if fp
				local xoff = cos(mo.angle) * 30
				local yoff = sin(mo.angle) * 30
				xx = $ + xoff
				yy = $ + yoff
				zz = $ + (20 * FRACUNIT)
				
				if mo.state == S_HELPARR
					mo.state = S_ALART1
				end
				mo.scale = t.scale/6
			else
				mo.state = S_HELPARR
				mo.scale = t.scale
			end
			P_TeleportMove(mo, xx, yy, zz)
		end
		
		return
	end
	
	if mo.needhelptarget and mo.needhelptarget.valid--I am calling for help
		P_TeleportMove(mo, mo.needhelptarget.x, mo.needhelptarget.y, mo.needhelptarget.z + 55 *mo.needhelptarget.scale)
	end
end, MT_GHOST)

local emote_wheel_trans = 20
local emote_wheel_quick = 1
local emote_wheel_hover = -1
local emote_wheel_x = 0
local emote_wheel_y = 0
local emote_wheel_lock_camera_aiming = 0
local emote_wheel_lock_camera_angle = 0
local emote_wheel_prevselection = -1
--Ping system
addHook("PreThinkFrame", function()
	for player in players.iterate
		--Ping system
		if player.emotes_prevbuttons == nil
			player.emotes_prevbuttons = player.cmd.buttons
		end
		local prev = player.emotes_prevbuttons
		local wepbtn = player.cmd.buttons & BT_WEAPONMASK
		local prevwepbtn = prev & BT_WEAPONMASK
		local custom3 = player.cmd.buttons & BT_CUSTOM3
		if player.pingspam == nil
			player.pingspam = 0
		end
		if player.pingspam > 0
			player.pingspam = $ - 1
		end
		if player.mo and player.mo.help_ping
			player.mo.help_ping = $ - 1
		end
		if player.mo and player.mo.valid and not player.spectator
			if custom3 and not (prev & BT_CUSTOM3)
				player.emote_wheel = true
				player.emote_wheel_lock_angle = player.mo.angle
				player.emote_wheel_lock_cmd_aiming = player.cmd.aiming
				player.emote_wheel_lock_aiming = player.aiming
				if (player == consoleplayer)
					emote_wheel_lock_camera_aiming = camera.aiming
					emote_wheel_lock_camera_angle = camera.angle
					emote_wheel_x = 0
					emote_wheel_y = 0
					emote_wheel_prevselection = -1
					emote_wheel_hover = -1
					emote_wheel_trans = 20
				end
			elseif (prev & BT_CUSTOM3) and not custom3
				player.emote_wheel = false
				if (player == consoleplayer)
					if (emote_wheel_hover != -1)
						emote_wheel_quick = emote_wheel_hover
						COM_BufInsertText(player, "emote "..(emote_wheel_quick))
					elseif emote_wheel_trans >= 10
						COM_BufInsertText(player, "emote "..(emote_wheel_quick))
					end
				end
			end
			if player.emote_wheel
				player.mo.angle = player.emote_wheel_lock_angle
				player.cmd.aiming = player.emote_wheel_lock_cmd_aiming
				player.aiming = player.emote_wheel_lock_aiming
				if (player == consoleplayer)
					if (emote_wheel_trans > 2)
						emote_wheel_trans = $ - 2
					end
					camera.aiming = emote_wheel_lock_camera_aiming
					camera.angle = emote_wheel_lock_camera_angle
					emote_wheel_x = $ + mouse.dx * FRACUNIT
					emote_wheel_y = $ + mouse.dy * FRACUNIT
					local distance = R_PointToDist2(0, 0, emote_wheel_x, emote_wheel_y)
					local ang = R_PointToAngle2(0, 0, emote_wheel_x, emote_wheel_y)
					local maxdist = 1500
					if distance > maxdist * FRACUNIT
						emote_wheel_x = cos(ang) * maxdist
						emote_wheel_y = sin(ang) * maxdist
					end
					local numchoices = #EMOTE_SOUNDS
					if distance > maxdist * FRACUNIT / 2
						local af = AngleFixed(ang - ANGLE_90) / (360/numchoices)
						emote_wheel_hover = 1 + (FixedFloor(af + (FRACUNIT/2)) / FRACUNIT)
						if emote_wheel_hover == numchoices + 1
							emote_wheel_hover = 1
						end
						if emote_wheel_hover != emote_wheel_prevselection
							S_StartSoundAtVolume(nil, sfx_s25d, 50, player)
						end
					else
						emote_wheel_hover = -1
					end
					emote_wheel_prevselection = emote_wheel_hover
				end
			end
			if wepbtn and prevwepbtn == 0 and not (gametyperules & GTR_RINGSLINGER and not RingSlinger)
				doemote(player, wepbtn)
			end
		end
		player.emotes_prevbuttons = player.cmd.buttons
	end
end)

local function hud_wheel(v, player)
	if player.emote_wheel and emote_wheel_trans < 10
		local flags = V_10TRANS * emote_wheel_trans
		local numchoices = #EMOTE_SOUNDS
		for i = 1, numchoices
			local patch = v.cachePatch(EMOTE_SPRITES[i])
			local ang = ANG1 * (i - 1) * (360/numchoices) + ANGLE_90
			local xx = cos(ang) * 60
			local yy = sin(ang) * 60
			local scale = FRACUNIT
			if (emote_wheel_hover == i)
				scale = (FRACUNIT * 2)
			end
			v.drawScaled(160*FRACUNIT + xx, 100*FRACUNIT + yy, scale, patch, flags)
		end
		local mx = emote_wheel_x / 25
		local my = emote_wheel_y / 25
		v.drawScaled(160*FRACUNIT + mx, 100*FRACUNIT + my, FRACUNIT, v.cachePatch("EMCURSOR"), 0)
	end
end
hud.add(hud_wheel, "game")