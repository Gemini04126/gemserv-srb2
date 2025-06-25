freeslot(
"S_DROPDASH",
"SPR_SHID",
"sfx_shidd", // hehe haha shidd
"SPR_PEEL"
)

states[S_DROPDASH] = {
	sprite = SPR_SHID,
	frame = FF_ANIMATE,
	tics = -1,
	var1 = 2,
	var2 = 1,
	nextstate = S_PLAY_ROLL
}

sfxinfo[sfx_3db16] = {
	singular = false,
	caption = "Dropdash"
}

// Drop Dash
// Iteration upon an iteration.

local ThokSpawnCooldown = 0

local function DropDash(player)
	if not player.mo and player.mo.valid return end
	
	if player.droptimer == nil
		player.droptimer = 0
	end
	
	if player.dropdashed == nil
		player.dropdashed = false
	end
	
	if player.dropspeed == nil
		player.dropspeed = 36*FRACUNIT
	end
	
	if player.mo.skin != "sonic" return end
	
	if ThokSpawnCooldown > 0
		ThokSpawnCooldown = $1 - 1
	end
	
	if player.powers[pw_super] == 1
		return
	end
	
	if P_PlayerInPain(player) or not(player.playerstate == PST_LIVE) or player.exiting or player.powers[pw_nocontrol]
		player.triedtodash = false
		player.droptimer = 0
//		player.mo.state = S_PLAY_ROLL
	end
		
	if (player.pflags & PF_JUMPED)
		if (player.triedtodash) then
			player.droptimer = 0
			player.mo.state = S_PLAY_JUMP
		else
			if (player.pflags & PF_USEDOWN) then
				player.droptimer = $1 + 1
				if player.dropspeed < 60*FRACUNIT
					if player.powers[pw_super]
						player.dropspeed = $ + FRACUNIT * 6 / 4
					else
						player.dropspeed = $ + FRACUNIT * 3 / 4
					end
				end
//				print(player.dropspeed/FRACUNIT)
			elseif player.droptimer > 0 then
				player.droptimer = 0
				player.triedtodrop = true
				player.dropspeed = 36*FRACUNIT
			end
		end
	end
	
	if (player.droptimer == 15) then
//	and not player.mo.state == S_DROPDASH
		S_StartSound(player.mo, sfx_3db16)
		player.mo.state = S_DROPDASH
	end
	
	if player.mo.state == S_DROPDASH
	and not (player.pflags & PF_USEDOWN)
		player.mo.state = S_PLAY_ROLL
	end
	
	if player.powers[pw_justsprung]
	or P_PlayerInPain(player)
		player.triedtodash = false
		player.droptimer = 0
		player.dropspeed = 36*FRACUNIT
		player.airdashed = false
	end
		
	
	if player.droptimer >= 15
	and player.powers[pw_super] 
	and P_IsObjectOnGround(player.mo)
		P_StartQuake(15*FRACUNIT,6)
	end
			
	if (player.mo.eflags & MFE_JUSTHITFLOOR or P_IsObjectOnGround(player.mo)) then
		if (player.droptimer >= 15) then
			player.mo.state = S_PLAY_ROLL
			player.pflags = $1|PF_SPINNING
			local radius = player.mo.radius >> FRACBITS
			P_SpawnMobjFromMobj(player.mo, P_RandomRange(-radius, radius) << FRACBITS, P_RandomRange(-radius, radius) << FRACBITS, 0, MT_SPINDUST)
			P_SpawnMobjFromMobj(player.mo, P_RandomRange(-radius, radius) << FRACBITS, P_RandomRange(-radius, radius) << FRACBITS, 0, MT_SPINDUST)
			P_SpawnMobjFromMobj(player.mo, P_RandomRange(-radius, radius) << FRACBITS, P_RandomRange(-radius, radius) << FRACBITS, 0, MT_SPINDUST)
			P_SpawnMobjFromMobj(player.mo, P_RandomRange(-radius, radius) << FRACBITS, P_RandomRange(-radius, radius) << FRACBITS, 0, MT_SPINDUST)
			P_InstaThrust(player.mo, player.mo.angle, FixedMul(player.dropspeed+(player.speed/8), player.mo.scale))
			S_StartSound(player.mo, sfx_zoom, player)
			player.dropdashed = true
//			DoSpindust(player, player.dropspeed)
		end
		player.triedtodash = false
		player.droptimer = 0
		player.dropspeed = 36*FRACUNIT
	end
	
	if player.dropdashed
	and player.mo.state != S_PLAY_ROLL
		player.dropdashed = false
	end		
end
				
addHook("PlayerThink", DropDash)

addHook("ThinkFrame", do
	for player in players.iterate
		if (player.mo.valid) and (player.mo.skin == "sonic")
			if player.dashmode >= 2*TICRATE
				if player.mo.state == S_PLAY_DASH and not player.powers[pw_super]
					for i = -40, 40
						
						local force = i*FRACUNIT/3
						local angle = ANGLE_90

						local shiftx = FixedMul(cos(player.drawangle + angle), force)
						local shifty = FixedMul(sin(player.drawangle + angle), force)
						
						local shiftx2 = FixedMul(cos(player.drawangle), FRACUNIT)
						local shifty2 = FixedMul(sin(player.drawangle), FRACUNIT)
						
						if i > 20
						or i < -20
							local peelout = P_SpawnMobjFromMobj(player.mo, shiftx2 + shiftx, shifty2 + shifty, 0, MT_OVERLAY)
							peelout.target = player.mo
							peelout.fuse = 1
							peelout.sprite = SPR_PEEL
							if i < 0
								if player.mo.frame == A
									peelout.frame = A
								elseif player.mo.frame == B
									peelout.frame = B
								elseif player.mo.frame == C
									peelout.frame = C
								elseif player.mo.frame == D
									peelout.frame = D
								end
								peelout.angle = player.drawangle + ANGLE_90/6
							else
								if player.mo.frame == A
									peelout.frame = C
								elseif player.mo.frame == B
									peelout.frame = D
								elseif player.mo.frame == C
									peelout.frame = A
								elseif player.mo.frame == D
									peelout.frame = B
								end
								peelout.angle = player.drawangle - ANGLE_90/6
							end
							peelout.renderflags = RF_PAPERSPRITE
							peelout.scale = player.mo.scale/2
							if player.mo.eflags & MFE_VERTICALFLIP
								peelout.eflags = $ | MFE_VERTICALFLIP
								peelout.z = player.mo.z + player.mo.height - peelout.height
							end
						end
					end
				end
			end
		end
	end
end)

local function DashSprites(player)
	if not player.mo and player.mo.valid return end
		
	if player.mo.skin != "sonic" return end
	
	if player.dashmode >= 2*TICRATE
		if player.speed > 36*FRACUNIT
		and player.mo.state == S_PLAY_RUN
			player.mo.state = S_PLAY_DASH
		end
		if player.mo.state == S_PLAY_DASH
		and player.speed <= 36*FRACUNIT
			if player.speed >= player.runspeed
				player.mo.state = S_PLAY_RUN
			else
				player.mo.state = S_PLAY_WALK
			end
		end
	end
	
	if player.mo.state == S_PLAY_DASH
	and player.dashmode < 2*TICRATE
		if player.speed >= player.runspeed
			player.mo.state = S_PLAY_RUN
		else
			player.mo.state = S_PLAY_WALK
		end
	end
end
