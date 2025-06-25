-- Salt: Would've been merged with LUA_LV32, but I wanted to add it to the shop, so it needs to load first.
-- Cacti Shield Lua script
-- Ported by Gemini0 for GemServ.

freeslot("SPR_CCTV",
"SPR_CSPK",
"SPR_CCPK",
"MT_CACTISPIKE",
"MT_CACTISHIELD_BOX",
"MT_CACTISHIELD_GOLDBOX",
"MT_CACTUS_ICON", 
"S_CACTIICO1", 
"S_CACTIICO2",
"S_CACTIICO3", 
"S_CACTIICO4", 
"S_CACTIICO5",
"S_CACTISHIELD_BOX",
"S_CACTISHIELD_GOLDBOX",
"S_CACTISHIELD_FRONT1",
"S_CACTISHIELD_FRONT2",
"S_CACTISHIELD_FRONT3",
"S_CACTISHIELD_FRONT4",
"S_CACTISHIELD_BACK1",
"S_CACTISHIELD_BACK2",
"S_CACTISHIELD_BACK3",
"S_CACTISHIELD_BACK4",
"S_CACTISHIELD_ORB1",
"S_CACTISHIELD_ORB2",
"S_CACTISHIELD_ORB3",
"S_CACTISHIELD_ORB4",
"S_CACTISHIELD_FRONT_B1",
"S_CACTISHIELD_FRONT_B2",
"S_CACTISHIELD_FRONT_B3",
"S_CACTISHIELD_FRONT_B4",
"S_CACTISHIELD_BACK_B1",
"S_CACTISHIELD_BACK_B2",
"S_CACTISHIELD_BACK_B3",
"S_CACTISHIELD_BACK_B4",
"S_CACTISHIELD_ORB_B1",
"S_CACTISHIELD_ORB_B2",
"S_CACTISHIELD_ORB_B3",
"S_CACTISHIELD_ORB_B4",
"S_CACTISHIELD_ORB_B5",
"S_CACTISHIELD_ORB_B6",
"S_CACTISPIKE",
"sfx_cactsh"
)

sfxinfo[sfx_cactsh].caption = "Cacti Shield"

addHook("PlayerThink", function(p) -- spawns the actual shield parts.

	if p.powers[pw_shield] == SH_CACTISHIELD
		if p.mo and p.mo.valid
	//	and not actor.target.RRZ_cactishield
	//		actor.target.RRZ_cactishield = true
	//		p.powers[pw_shield] = ($1 & SH_STACK)
			if not (p.mo.cactis_orb and p.mo.cactis_orb.valid)
				-- P_SpawnShieldOrb does not work with these, so we'll have to use a more hacky method.
				local cactis_orb = P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z, MT_OVERLAY)
				cactis_orb.state = S_PITY1
				cactis_orb.target = p.mo
				p.mo.cactis_orb = cactis_orb
				
				local cactis_front = P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z, MT_OVERLAY)
				cactis_front.state = S_CACTISHIELD_FRONT1
				cactis_front.target = p.mo
				p.mo.cactis_front = cactis_front
				
				local cactis_back = P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z, MT_OVERLAY)
				cactis_back.state = S_CACTISHIELD_BACK1
				cactis_back.target = p.mo
				p.mo.cactis_back = cactis_back
				
				p.mo.cactishield_cooldown = 0
			end
			--print("Shield orb spawned.")
	//	else
	//		actor.target.RRZ_cactishield = false
		end
	end
end)

-- spike burst function to save us some time on instances where we'll need it

local function cactiSpikeBurst(mo)
	
	local h_angle = 0
	local v_angle = 0
	local dist = 32
	local frame = 0
	
	for i=1,26
		
		local s_x = mo.x+ dist*FixedMul(cos(h_angle), cos(v_angle))
		local s_y = mo.y+ dist*FixedMul(sin(h_angle), cos(v_angle))
		local s_z = (mo.z+mo.height/2)+ dist* sin(v_angle)
		
		local spike = P_SpawnMobj(s_x, s_y, s_z, MT_CACTISPIKE)
		spike.frame = frame
		spike.angle = h_angle
		spike.target = mo -- dont damage self rofl
		spike.fuse = TICRATE/3
		spike.momx = 32 * FixedMul(cos(h_angle), cos(v_angle))
		spike.momy = 32 * FixedMul(sin(h_angle), cos(v_angle))
		spike.momz = 32 * sin(v_angle)
		
		h_angle = $+ANGLE_45
		
		if i == 8
			v_angle = ANGLE_45
			frame = 1
		elseif i == 16
			v_angle = -ANGLE_45
			frame = 2
		elseif i == 24
			v_angle = ANGLE_90
			frame = 3
		elseif i == 25
			v_angle = -ANGLE_90
			frame = 4
		end	
	end
	
	P_NukeEnemies(mo, mo, 256*FRACUNIT)
	S_StartSound(mo, sfx_spkdth)
	mo.RRZ_nuke = true
end

--- HUD stuff copied and edited from the Rock shield. ---

local function drawShield(v, p, c) -- most code made by faye, you can tell because all the variables are one letter long, which is something i don't do, i'm weird i know
    local pudisplay = CV_FindVar("powerupdisplay").value    
    if pudisplay == 0 then return end

    local cactishield = v.cachePatch("CCTVC0")
    local hudstuff = {x = 288, y = 176, flags = V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS}
    local finishoffs = {0,0}
    local q = ((splitscreen and p == secondarydisplayplayer) and 2) or 1
    
    -- handle the finish symbol offsets first
    if (p.pflags & PF_FINISHED and CV_FindVar("exitmove").value) then
        finishoffs[q] = 20;
    elseif (finishoffs[q]) then
        if (finishoffs[q] > 1) then
            finishoffs[q] = 2*finishoffs[q]/3;
        else
            finishoffs[q] = 0;
        end
    end

    hudstuff.x = $ - finishoffs[q];
    
    if (p.powers[pw_shield] & SH_NOSTACK == SH_CACTISHIELD) and ((pudisplay == 1 and not c.chase) or pudisplay == 2)then
        --I directly looked up the offsets from the source and STILL had to guesstimate the positioning/scale. What the hell?
        v.drawScaled((hudstuff.x + cactishield.width/3)<< FRACBITS , (hudstuff.y+cactishield.height/2 +1) << FRACBITS, 2*FRACUNIT/3, cactishield,hudstuff.flags)
    end

end

hud.add(drawShield, "game")

-- main thinker for the shield and the player!

addHook("ThinkFrame", do
	for p in players.iterate
	
		if p.mo and p.mo.valid
		local mo = p.mo
			
			if (p.powers[pw_shield] != SH_CACTISHIELD)
				if (mo.cactis_orb and mo.cactis_orb.valid) P_RemoveMobj(mo.cactis_orb) end
				if (mo.cactis_front and mo.cactis_front.valid) P_RemoveMobj(mo.cactis_front) end
				if (mo.cactis_back and mo.cactis_back.valid) P_RemoveMobj(mo.cactis_back) end
				mo.cactishield_cooldown = 0
				continue
			end
			
			--handle spin press for spindash
			
			if p.pflags & PF_STARTDASH
			or (p.pflags & PF_SPINNING and not (p.pflags & PF_JUMPED))
				mo.spin_prev = true
			else
				if not (p.cmd.buttons & BT_USE)
				or not ((p.cmd.buttons & BT_USE) and p.pflags & PF_SPINNING and p.pflags & PF_JUMPED)
					mo.spin_prev = false
				end
			end	
			
			if (p.powers[pw_shield] == SH_CACTISHIELD)
				
				mo.RRZ_nuke = nil

				if p.cmd.buttons & BT_USE
				and p.pflags & PF_JUMPED
				and not mo.spin_prev
				and not (p.pflags & PF_THOKKED)
				and not mo.cactishield_cooldown
				and not p.powers[pw_invulnerability] 
				and not p.powers[pw_super]
					cactiSpikeBurst(mo)
					p.pflags = $1|PF_THOKKED
					mo.cactishield_cooldown = TICRATE*3
				end
				
				if p.powers[pw_invulnerability] 
				or p.powers[pw_super]
					mo.cactis_front.flags2 = $|MF2_DONTDRAW
					mo.cactis_back.flags2 = $|MF2_DONTDRAW
					mo.cactis_orb.flags2 = $|MF2_DONTDRAW
				else
					if ((mo.cactis_orb and mo.cactis_orb.valid) and (mo.cactis_front and mo.cactis_front.valid) and (mo.cactis_back and mo.cactis_back.valid))
						mo.cactis_back.flags2 = $ & ~MF2_DONTDRAW
						mo.cactis_front.flags2 = $ & ~MF2_DONTDRAW
						mo.cactis_orb.flags2 = $ & ~MF2_DONTDRAW
					end
				end	
				
				if mo.cactishield_cooldown == (11 or 22 or 33)
					S_StartSound(mo, sfx_s3k52)
				end
				
				if mo.cactishield_cooldown
					mo.cactishield_cooldown = max(0,$-1)	
					
					if mo.cactis_front and mo.cactis_front.valid and mo.cactis_back and mo.cactis_back.valid
						if (mo.cactishield_cooldown >TICRATE or (mo.cactishield_cooldown >6 and mo.cactishield_cooldown < 11 or mo.cactishield_cooldown > 17 and mo.cactishield_cooldown < 22 or mo.cactishield_cooldown > 28 and mo.cactishield_cooldown < 33))
						and mo.cactishield_cooldown > 2
							mo.cactis_front.flags2 = $|MF2_DONTDRAW
							mo.cactis_back.flags2 = $|MF2_DONTDRAW
						else
							if not p.powers[pw_invulnerability] and not p.powers[pw_super]
								mo.cactis_back.flags2 = $ & ~MF2_DONTDRAW
								mo.cactis_front.flags2 = $ & ~MF2_DONTDRAW
							end	
						end	
					end
				end	
			end
		end
	end
end)

addHook("MobjDamage", function(mo, inflictor)
	for p in players.iterate
		if mo and mo.valid and p.powers[pw_shield] == SH_CACTISHIELD
			if ((p.mo.cactis_front and p.mo.cactis_front.valid and p.mo.cactis_back and p.mo.cactis_back.valid) and p.mo.cactishield_cooldown == 0)
				cactiSpikeBurst(mo)
			end
		end
	end
end, MT_PLAYER)	

local function inSpikeSec(mo)
	local sec = mo.subsector.sector
	local numlines = #sec.lines
	
	if sec.special == 5
		return true
	end
	
	for i=1,numlines
	
		local v = sec.lines[i]
		if v
			
			if v.frontsector and v.frontsector.special == 5
			or v.backsector and v.backsector.special == 5
				return true
			end	
		end
	end
end

-- this shield prevents spike damage and direct enemy damage if the spikes are up!

addHook("ShouldDamage", function(mo, inflictor)
	
	if mo and mo.valid
	local p = mo.player

		if not p return end
		
		if p.powers[pw_shield] == SH_CACTISHIELD and inflictor and inflictor.valid
			if ((p.mo.cactis_front and p.mo.cactis_front.valid and p.mo.cactis_back and p.mo.cactis_back.valid) and p.mo.cactishield_cooldown == 0) 
			
				-- case 1: spike OBJECT related damage
				if inflictor.type == MT_SPIKE// and inflictor.flags & MF_AMBUSH
					return false
				end
				-- case 2: spike SECTOR related damage
				if inflictor.type == 0 and inSpikeSec(mo)
					return false
				end
				-- case 3: direct enemy attack WHILE SPINNING / JUMPING
				if inflictor.flags & MF_ENEMY and (p.pflags & PF_JUMPED or p.pflags & PF_SPINNING)
					P_DamageMobj(inflictor, mo, mo)
					return false
				end
				-- case 4: RRZ boss
	//			if inflictor.type == MT_RRZBOSS
	//				P_InstaThrust(mo, inflictor.angle, -mo.player.speed)
	//			end
				if inflictor.type == MT_PLAYER
				and inflictor.RRZ_nuke
					return false
				end
				if inflictor.type == MT_CACTISPIKE
				and not inflictor.instakill
					return false
				end
			end
		end
	end	
end, MT_PLAYER)	


mobjinfo[MT_CACTISHIELD_BOX] = {
	doomednum = 4025,
    spawnstate = S_CACTISHIELD_BOX,
    spawnhealth = 1,
    seestate = S_NULL,
    seesound = sfx_None,
    reactiontime = 8,
    attacksound = sfx_None,
    painstate = S_CACTISHIELD_BOX,
    painchance = 0,
    painsound = sfx_None,
    meleestate = S_NULL,
    missilestate = S_NULL,
    deathstate = S_BOX_POP1,
    xdeathstate = S_NULL,
    deathsound = sfx_pop,
    speed = 1,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    damage = MT_CACTUS_ICON,
    activesound = sfx_None,
    flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR,
    raisestate = S_NULL
}

mobjinfo[MT_CACTISHIELD_GOLDBOX] = {
	doomednum = 4025,
    spawnstate = S_CACTISHIELD_GOLDBOX,
    spawnhealth = 1,
    seestate = S_NULL,
    seesound = sfx_None,
    reactiontime = 8,
    attacksound = sfx_monton,
    painstate = S_CACTISHIELD_GOLDBOX,
    painchance = 0,
    painsound = sfx_None,
    meleestate = S_NULL,
    missilestate = S_NULL,
    deathstate = S_GOLDBOX_OFF1,
    xdeathstate = S_NULL,
    deathsound = sfx_pop,
    speed = 0,
	radius = 20*FRACUNIT,
	height = 44*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    damage = MT_CACTUS_ICON,
    activesound = sfx_None,
    flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE,
    raisestate = S_NULL
}

-- monitor icon object
mobjinfo[MT_CACTUS_ICON] = {
	doomednum = -1,
    spawnstate = S_CACTIICO1,
    spawnhealth = 1,
    seestate = S_NULL,
    seesound = sfx_cactsh,
    reactiontime = 8,
    attacksound = sfx_None,
    painstate = S_CACTISHIELD_BOX,
    painchance = 0,
    painsound = sfx_None,
    meleestate = S_NULL,
    missilestate = S_NULL,
    deathstate = S_NULL,
    xdeathstate = S_NULL,
    deathsound = sfx_pop,
    speed = 2*FRACUNIT,
    radius = 8*FRACUNIT,
    height = 14*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    damage = 62*FRACUNIT,
    activesound = sfx_None,
    flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_BOXICON,
    raisestate = MT_THOK
}

mobjinfo[MT_CACTISPIKE] = {
	doomednum = -1,
    spawnstate = S_CACTISPIKE,
    spawnhealth = 1000,
    seestate = S_NULL,
    seesound = 0,
    reactiontime = 8,
    attacksound = sfx_None,
    painstate = S_CACTISHIELD_BOX,
    painchance = 0,
    painsound = sfx_None,
    meleestate = S_NULL,
    missilestate = S_NULL,
    deathstate = S_NULL,
    xdeathstate = S_NULL,
    deathsound = sfx_spkdth,
    speed = 2*FRACUNIT,
    radius = 8*FRACUNIT,
    height = 14*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    damage = 0,
    activesound = sfx_None,
    flags = MF_MISSILE|MF_NOGRAVITY|MF_FLOAT,
    raisestate = 0
}

local SH_CACTISHIELD = 10 -- arbitrary number i know, but it works
SH_CACTISHIELD = $ | SH_PROTECTSPIKE 
rawset(_G, "SH_CACTISHIELD", SH_CACTISHIELD)

states[S_CACTISHIELD_BOX] = {SPR_CCTV, 0, 2, nil, 0, 0, S_BOX_FLICKER}
states[S_CACTISHIELD_GOLDBOX] = {SPR_CCTV, 1, 2, A_GoldMonitorSparkle, 0, 0, S_GOLDBOX_FLICKER}

states[S_CACTIICO1] = {SPR_CCTV, C, 4, nil, 0, 0, S_CACTIICO2}
states[S_CACTIICO2] = {SPR_TVPI, D, 4, nil, 0, 0, S_CACTIICO3}
states[S_CACTIICO3] = {SPR_TVPI, E, 4, nil, 0, 0, S_CACTIICO4}
states[S_CACTIICO4] = {SPR_TVPI, F, 4, nil, 0, 0, S_CACTIICO5}
states[S_CACTIICO5] = {SPR_CCTV, C, 18, A_GiveShield, SH_CACTISHIELD, 0, S_NULL}

states[S_CACTISHIELD_FRONT1] = {SPR_CSPK, A, 2, nil, 0, 0, S_CACTISHIELD_FRONT2}
states[S_CACTISHIELD_FRONT2] = {SPR_CSPK, B, 2, nil, 0, 0, S_CACTISHIELD_FRONT3}
states[S_CACTISHIELD_FRONT3] = {SPR_CSPK, C, 2, nil, 0, 0, S_CACTISHIELD_FRONT4}
states[S_CACTISHIELD_FRONT4] = {SPR_CSPK, D, 2, nil, 0, 0, S_CACTISHIELD_FRONT1}

states[S_CACTISHIELD_BACK1] = {SPR_CSPK, A, 2, nil, 1, 0, S_CACTISHIELD_BACK2}
states[S_CACTISHIELD_BACK2] = {SPR_CSPK, F, 2, nil, 1, 0, S_CACTISHIELD_BACK3}
states[S_CACTISHIELD_BACK3] = {SPR_CSPK, C, 2, nil, 1, 0, S_CACTISHIELD_BACK4}
states[S_CACTISHIELD_BACK4] = {SPR_CSPK, E, 2, nil, 1, 0, S_CACTISHIELD_BACK1}

states[S_CACTISHIELD_FRONT_B1] = {SPR_CSPK, G, 2, nil, 0, 0, S_CACTISHIELD_FRONT_B2}
states[S_CACTISHIELD_FRONT_B2] = {SPR_CSPK, H, 2, nil, 0, 0, S_CACTISHIELD_FRONT_B3}
states[S_CACTISHIELD_FRONT_B3] = {SPR_CSPK, I, 2, nil, 0, 0, S_CACTISHIELD_FRONT_B4}
states[S_CACTISHIELD_FRONT_B4] = {SPR_CSPK, J, 2, nil, 0, 0, S_CACTISHIELD_FRONT_B1}

states[S_CACTISHIELD_ORB_B1] = {SPR_CSPK, M, 1, nil, 0, 0, S_CACTISHIELD_ORB_B2}
states[S_CACTISHIELD_ORB_B2] = {SPR_CSPK, N, 1, nil, 0, 0, S_CACTISHIELD_ORB_B3}
states[S_CACTISHIELD_ORB_B3] = {SPR_CSPK, O, 1, nil, 0, 0, S_CACTISHIELD_ORB_B4}
states[S_CACTISHIELD_ORB_B4] = {SPR_CSPK, P, 1, nil, 0, 0, S_CACTISHIELD_ORB_B5}
states[S_CACTISHIELD_ORB_B5] = {SPR_CSPK, Q, 1, nil, 0, 0, S_CACTISHIELD_ORB_B6}
states[S_CACTISHIELD_ORB_B6] = {SPR_CSPK, R, 1, nil, 0, 0, S_CACTISHIELD_ORB_B1}

states[S_CACTISHIELD_BACK_B1] = {SPR_CSPK, G, 2, nil, 1, 0, S_CACTISHIELD_BACK_B2}
states[S_CACTISHIELD_BACK_B2] = {SPR_CSPK, L, 2, nil, 1, 0, S_CACTISHIELD_BACK_B3}
states[S_CACTISHIELD_BACK_B3] = {SPR_CSPK, I, 2, nil, 1, 0, S_CACTISHIELD_BACK_B4}
states[S_CACTISHIELD_BACK_B4] = {SPR_CSPK, K, 2, nil, 1, 0, S_CACTISHIELD_BACK_B1}

states[S_CACTISPIKE] = {SPR_CCPK, A, -1, nil, 0, 0, S_CACTISPIKE}