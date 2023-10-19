-- [[[ !!! MOD MAKERS !!! Look at the "mobjinfo" for MT_ROCKSHIELD_BOX and MT_ROCKSHIELD_GOLDBOX, replace the doomednum with your desired number! This will automatically prevent the whirlwind shield from being replaced with the rock shield, on top of obvbiously allowing you to place it down in a level editor.]]] ---
-- [[[ Make sure when updating this mod to replace the variables! ]]] ---

--[[ Rock Shield v1.1
Created by: birbhosre, aka EeveeEuphoria
Additional code by: Flame, Faye
Sprites created by: Sonic Time Twisted dev team

This aims to re-create the rock shield from Sonic: Time Twisted.

CHANGELOG, from v1.0 to v1.1
	- Added new HUD element, to make it sit in line with the other power-ups. Thanks to Faye for the help on this!
]]

freeslot(
"MT_ROCKSHIELD_ICON", "MT_ROCKSHIELD_BOX", "MT_ROCKSHIELD_GOLDBOX", "S_ROCKSHIELD_BOX", "S_ROCKSHIELD_GOLDBOX", "S_ROCKSHIELD_ICON1", "S_ROCKSHIELD_ICON2", "SPR_TVRS",
"MT_RSROCK", "MT_RSSHRAPNEL", "MT_AHEADOFPLAYER", "S_RSROCK1", "S_RSROCK2", "S_RSSHRHAPNEL1", "S_RSSHRHAPNEL2", "S_RSSHRHAPNEL3", "SPR_RSRO", "SPR_RSSH"
)

mobjinfo[MT_ROCKSHIELD_BOX] = {
		--$Name Rock Shield
		--$Sprite TVRSA0
		--$Category Monitors
		
		doomednum = -1, 							-- REPLACE ME!!
		spawnstate = S_ROCKSHIELD_BOX,
		spawnhealth = 1,
		seestate = S_NULL,
		seesound = sfx_None,
		reactiontime = 8,
		attacksound = sfx_None,
		painstate = S_ROCKSHIELD_BOX,
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
		damage = MT_ROCKSHIELD_ICON,
		activesound = sfx_None,
		flags  = MF_SOLID|MF_SHOOTABLE|MF_MONITOR,
		raisestate = S_NULL
	}

mobjinfo[MT_ROCKSHIELD_GOLDBOX] = {
		--$Name Rock Shield (Respawning)
		--$Sprite TVRSB0
		--$Category Monitors (Respawning)
		
		doomednum = -1, 							-- REPLACE ME TOO!
		spawnstate = S_ROCKSHIELD_GOLDBOX,
		spawnhealth = 1,
		seestate = S_NULL,
		seesound = sfx_None,
		reactiontime = 8,
		attacksound = sfx_monton,
		painstate = S_ROCKSHIELD_GOLDBOX,
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
		damage = MT_ROCKSHIELD_ICON,
		activesound = sfx_None,
		flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE,
		raisestate = S_NULL
	}

local SH_ROCKSHIELD = 8 -- arbitrary number i know, but it works
SH_ROCKSHIELD = $ | SH_PROTECTSPIKE 
rawset(_G, "SH_ROCKSHIELD", SH_ROCKSHIELD)

states[S_ROCKSHIELD_BOX] = {SPR_TVRS, 0, 2, nil, 0, 0, S_BOX_FLICKER}
states[S_ROCKSHIELD_GOLDBOX] = {SPR_TVRS, 1, 2, A_GoldMonitorSparkle, 0, 0, S_GOLDBOX_FLICKER}
states[S_ROCKSHIELD_ICON1] = {SPR_TVRS, FF_ANIMATE|2, 18, nil, 3, 4, S_ROCKSHIELD_ICON2}
states[S_ROCKSHIELD_ICON2] = {SPR_TVRS, 2, 18, A_GiveShield, SH_ROCKSHIELD, 0, S_NULL}


mobjinfo[MT_ROCKSHIELD_ICON] = {
		doomednum = -1,
		spawnstate = S_ROCKSHIELD_ICON1,
		spawnhealth = 1,
		seestate = S_NULL,
		seesound = sfx_s3k6e,
		reactiontime = 8,
		attacksound = sfx_None,
		painstate = S_NULL,
		painchance = 0,
		painsound = sfx_None,
		meleestate = S_NULL,
		missilestate = S_NULL,
		deathstate = S_NULL,
		xdeathstate = S_NULL,
		deathsound= sfx_None,
		speed = 2*FRACUNIT,
		radius = 8*FRACUNIT,
		height = 14*FRACUNIT,
		dispoffset = 0,
		mass = 100,
		damage = 62*FRACUNIT,
		activesound = sfx_None,
		flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_BOXICON,
		raisestate = S_NULL
	}

states[S_RSROCK1] = {
	sprite = SPR_RSRO,
	frame = A,
	tics = -1,
	nextstate = S_RSROCK1
}

states[S_RSROCK2] = {
	sprite = SPR_RSRO,
	frame = B,
	tics = -1,
	nextstate = S_RSROCK2
}

states[S_RSSHRHAPNEL1] = {
	sprite = SPR_RSSH,
	frame = A,
	tics = -1,
	nextstate = S_RSSHRHAPNEL1
}

states[S_RSSHRHAPNEL2] = {
	sprite = SPR_RSSH,
	frame = B,
	tics = -1,
	nextstate = S_RSSHRHAPNEL1
}

states[S_RSSHRHAPNEL3] = {
	sprite = SPR_RSSH,
	frame = C,
	tics = -1,
	nextstate = S_RSSHRHAPNEL1
}

mobjinfo[MT_RSROCK] = {
	doomednum = -1,
	spawnstate = S_RSROCK1,
	height = 25*FRACUNIT,
	radius = 25*FRACUNIT,
	activesound = sfx_s3k96,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
}

mobjinfo[MT_AHEADOFPLAYER] = {
	doomednum = -1,
	spawnstate = S_RSSHRHAPNEL1,
	height = 25*FRACUNIT,
	radius = 25*FRACUNIT,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
}

mobjinfo[MT_RSSHRAPNEL] = {
	doomednum = -1,
	spawnstate = S_RSSHRHAPNEL1,
	height = 5*FRACUNIT,
	radius = 5*FRACUNIT,
	flags = MF_BOUNCE|MF_NOCLIPTHING
}

-- [[[ Player Think ]]] ---

addHook("PlayerThink", function(player)

	-- [[ Actual Rock Shield logic ]] --
	
	if player.powers[pw_shield] == SH_ROCKSHIELD and player.exiting > 0 and not mmtVersion -- not pf_finished, cuz I Said So
		player.powers[pw_shield] = SH_NONE
	end
	
	if player.powers[pw_shield] != SH_ROCKSHIELD 
		if player.RSMod and player.RSMod.rock1 and player.RSMod.rock1.valid
			P_InstaThrust(player.RSMod.rock1, player.mo.angle, (player.speed) + (5*FRACUNIT))
			P_InstaThrust(player.RSMod.rock2, player.mo.angle, -((player.speed/2) + (5*FRACUNIT)))
		end
		player.RSMod.rock1 = nil
		player.RSMod.rock2 = nil
		return
	end
	
	if player.RSMod.zongle == nil -- used to be zangle, but was already used
		player.RSMod.zongle = 0
	else
		player.RSMod.zongle = $ + FixedAngle(4<<FRACBITS)
	end
	
	player.RSMod.rockr = (mobjinfo[player.mo.type].height) - (15*FRACUNIT) -- thanks to Flame and Faye on the SRB2 Discord for lending help on this!
	
	player.RSMod.rock1x = (player.mo.x) + FixedMul(cos(player.RSMod.zongle), player.RSMod.rockr)
	player.RSMod.rock1y = (player.mo.y) + FixedMul(sin(player.RSMod.zongle), player.RSMod.rockr)
	
	if (player.mo.eflags & MFE_VERTICALFLIP)
		player.RSMod.rock1z = (player.mo.z) - player.mo.height/2 + 17 * cos(player.RSMod.zongle)
	else
		player.RSMod.rock1z = (player.mo.z) + player.mo.height/2 + 17 * cos(player.RSMod.zongle)
	end
	
	player.RSMod.rock1z = $ + 10*FRACUNIT -- offset
	
	player.RSMod.rock2x = (player.mo.x) + FixedMul(cos(player.RSMod.zongle), -player.RSMod.rockr)
	player.RSMod.rock2y = (player.mo.y) + FixedMul(sin(player.RSMod.zongle), -player.RSMod.rockr)
	if (player.mo.eflags & MFE_VERTICALFLIP)
		player.RSMod.rock2z = (player.mo.z) - player.mo.height/2 - 17 * cos(player.RSMod.zongle)
	else
		player.RSMod.rock2z = (player.mo.z) + player.mo.height/2 - 17 * cos(player.RSMod.zongle)
	end
	
	
	player.RSMod.rock2z = $ + 10*FRACUNIT -- offset

	if not player.RSMod.rock1
		player.RSMod.rock1 = P_SpawnMobj(player.RSMod.rock1x, player.RSMod.rock1y, player.RSMod.rock1z, MT_RSROCK)
		player.RSMod.rock2 = P_SpawnMobj(player.RSMod.rock2x, player.RSMod.rock2y, player.RSMod.rock2z, MT_RSROCK)
		player.RSMod.rock1.They = player
		player.RSMod.rock2.They = player
		player.RSMod.rock1.number = 1
		player.RSMod.rock2.number = 2
		
		player.RSMod.rockarrow = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_AHEADOFPLAYER)
		player.RSMod.rockarrow.They = player
	end

end)

addHook("JumpSpinSpecial", function(player) --todo: make Z thrust a thing, for whatever the player is looking at in first-person
	if player.powers[pw_shield] != SH_ROCKSHIELD return end
	if player.RSMod.rock1.SendOut and player.RSMod.rock2.SendOut return end
	if (player.pflags & PF_SHIELDABILITY) return end
	if (player.pflags & PF_THOKKED) return end
	
	player.RSMod.distancetoarrow1 = R_PointToDist2(player.RSMod.rock1.x, player.RSMod.rock1.y, player.RSMod.rockarrow.x, player.RSMod.rockarrow.y)
	player.RSMod.distancetoarrow2 = R_PointToDist2(player.RSMod.rock2.x, player.RSMod.rock2.y, player.RSMod.rockarrow.x, player.RSMod.rockarrow.y)
	
	local function SendThem(rock)
		rock.SendOut = true
		S_StartSound(rock, sfx_zoom)
		P_InstaThrust(rock, player.mo.angle, (player.speed/2) + (35*FRACUNIT))
		rock.angle = player.mo.angle
		player.pflags = $1 | PF_SHIELDABILITY
		player.pflags = $1 | PF_THOKKED
	end
	
	
	if not (player.RSMod.rock1.SendOut or player.RSMod.rock1.CurrentlyDestroyed) and player.RSMod.distancetoarrow1 < player.RSMod.distancetoarrow2
		SendThem(player.RSMod.rock1)
	elseif not (player.RSMod.rock2.SendOut or player.RSMod.rock2.CurrentlyDestroyed)
		SendThem(player.RSMod.rock2)
	elseif (player.RSMod.rock2.SendOut or player.RSMod.rock2.CurrentlyDestroyed) and not (player.RSMod.rock1.SendOut or player.RSMod.rock1.CurrentlyDestroyed)
		SendThem(player.RSMod.rock1)
	end
	
end)

addHook("PlayerSpawn", function(player) -- had to do this for the sake of MMT compatibility

	player.RSMod = {}

	player.RSMod.rock1 = nil
	player.RSMod.rock2 = nil
	player.RSMod.zongle = nil

	player.RSMod.rockr = nil
	player.RSMod.rock1x = nil
	player.RSMod.rock1y = nil
	player.RSMod.rock1z = nil
	player.RSMod.rock1z = nil
	player.RSMod.rock2x = nil
	player.RSMod.rock2y = nil
	player.RSMod.rock2z = nil
	player.RSMod.rock2z = nil

end)

-- note: when rock needs to Fling, remove the noclip flags and stuff

addHook("MobjThinker", function(rock) local player = rock.They

	if not player.valid return end
	if not rock.valid return end
	if player.powers[pw_shield] != SH_ROCKSHIELD
		rock.SendOut = true
		rock.PlayerLostShield = true
	end
	
	local function RestoreState()
		if rock.number == 1
			rock.state = S_RSROCK1
		else
			rock.state = S_RSROCK2
		end
	end
	
	if (player.mo.eflags & MFE_VERTICALFLIP)
		rock.flags2 = $1 | MF2_OBJECTFLIP
		rock.eflags = $1 | MFE_VERTICALFLIP
	else
		rock.flags2 = $ & ~MF2_OBJECTFLIP
		rock.eflags = $ & ~MFE_VERTICALFLIP
	end
	
	if rock.timer == nil
		rock.timer = 0
		rock.transstate = 0
		rock.destroytimer = 0
		rock.bouncingtimer = 0
		RestoreState()
	end

	rock.shadowscale = (FRACUNIT/3) + (FRACUNIT/11)
	rock.scale = FRACUNIT + (FRACUNIT/3)
	
	rock.target = player.mo

	if not rock.SendOut
		rock.flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
		if rock.number == 1
			P_TeleportMove(rock, player.RSMod.rock1x, player.RSMod.rock1y, player.RSMod.rock1z)
		else
			P_TeleportMove(rock, player.RSMod.rock2x, player.RSMod.rock2y, player.RSMod.rock2z)
		end
	
	else -- rock is being sent out
		
		if not rock.replacedflags
			rock.flags = MF_MISSILE|MF_BOUNCE|MF_GRENADEBOUNCE
			rock.replacedflags = true
		end
		
		if not rock.rockvar2
			rock.rockvar1 = 5
			rock.rockvar2 = 16
		end
		
		if P_IsObjectOnGround(rock) 
			rock.timer = $ + 1
		end
		rock.bouncingtimer = $ + 1
		
		if (rock.timer > 2*TICRATE) or (rock.bouncingtimer > 7*TICRATE)
			rock.DestroySelf = true
		end
	end
	
	if rock.valid and rock.DestroySelf
		rock.SendOut = false
		rock.timer = 0
		rock.transstate = 0
		rock.destroytimer = 0
		rock.bouncingtimer = 0
		rock.rockvar1 = 5
		rock.rockvar2 = 16
		rock.flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
		rock.replacedflags = false
		rock.DestroySelf = false
		
		local piece1 = P_SpawnMobj(rock.x, rock.y, rock.z, MT_RSSHRAPNEL)
		local piece2 = P_SpawnMobj(rock.x, rock.y, rock.z, MT_RSSHRAPNEL)
		local piece3 = P_SpawnMobj(rock.x, rock.y, rock.z, MT_RSSHRAPNEL)
		piece1.number = 1
		piece2.number = 2
		piece3.number = 3
		piece1.angle = rock.angle + (ANG1 * (P_RandomRange(-10, 10)))
		piece2.angle = rock.angle + (ANG1 * (P_RandomRange(-10, 10)))
		piece3.angle = rock.angle + (ANG1 * (P_RandomRange(-10, 10)))
		
		if not rock.PlayerLostShield
			rock.CurrentlyDestroyed = true --confusing i know
			S_StartSound(rock, sfx_s3k6e)
		else
			P_RemoveMobj(rock)
			piece1.PlaySound = true
			return
		end
		
	end
	
	if rock.CurrentlyDestroyed
			
		rock.destroytimer = $ + 1
		
		if (rock.destroytimer % 17) == 0
			rock.transstate = $ + 1
		end
		
		if rock.transstate == 0
			rock.state = S_INVISIBLE
		elseif rock.transstate == 1
			RestoreState()
			rock.frame = $1 | TR_TRANS90
			if not rock.SummonedThem
				local piece1 = P_SpawnMobj(rock.x, rock.y, rock.z, MT_RSSHRAPNEL)
				local piece2 = P_SpawnMobj(rock.x, rock.y, rock.z, MT_RSSHRAPNEL)
				local piece3 = P_SpawnMobj(rock.x, rock.y, rock.z, MT_RSSHRAPNEL)
				piece1.number = 1
				piece2.number = 2
				piece3.number = 3
				piece1.angle = rock.angle
				piece2.angle = rock.angle
				piece3.angle = rock.angle
				piece1.They = rock
				piece2.They = rock
				piece3.They = rock				
				piece1.zongle = 0
				piece2.zongle = FixedAngle(120<<FRACBITS)
				piece3.zongle = FixedAngle(240<<FRACBITS)
				piece1.transstate2 = 0
				piece2.transstate2 = 0
				piece3.transstate2 = 0			
				piece1.rockradius = (154*FRACUNIT)
				piece2.rockradius = (154*FRACUNIT)
				piece3.rockradius = (154*FRACUNIT)
				rock.SummonedThem = true
			end
		elseif rock.transstate == 2
			RestoreState()
			rock.frame = $1 | TR_TRANS80
		elseif rock.transstate == 3
			RestoreState()
			rock.frame = $1 | TR_TRANS70
		elseif rock.transstate == 4
			RestoreState()
			rock.frame = $1 | TR_TRANS60
		elseif rock.transstate == 5
			RestoreState()
			rock.frame = $1 | TR_TRANS50
		elseif rock.transstate == 6
			RestoreState()
			rock.frame = $1 | TR_TRANS40
		elseif rock.transstate == 7
			RestoreState()
			rock.frame = $1 | TR_TRANS30
		elseif rock.transstate == 8
			RestoreState()
			rock.frame = $1 | TR_TRANS20
		elseif rock.transstate == 9
			RestoreState()
			rock.frame = $1 | TR_TRANS10
		elseif rock.transstate >= 10
			RestoreState()
			S_StartSound(rock, sfx_s3k6e)
			rock.CurrentlyDestroyed = false
			rock.SummonedThem = false
		end
	end

end, MT_RSROCK)


addHook("MobjThinker", function(arrow) local player = arrow.They -- use this to determine which rock to send out, or destroy, by whichever one is in front of the player

	if not player.valid return end
	if player.powers[pw_shield] != SH_ROCKSHIELD
		P_RemoveMobj(arrow)
		return
	end
	
	arrow.state = S_INVISIBLE
	
	P_TeleportMove(arrow, 
		player.mo.x + FixedMul(cos(player.mo.angle), player.RSMod.rockr),
		player.mo.y + FixedMul(sin(player.mo.angle), player.RSMod.rockr),
		player.mo.z + player.RSMod.rockr)

end, MT_AHEADOFPLAYER)

addHook("MobjThinker", function(pieces)
	
	pieces.shadowscale = FRACUNIT
	
	if pieces.PlaySound --janky solution, but it works
		S_StartSound(rock, sfx_s3k6e)
		pieces.PlaySound = false
	end
	
	local function RestoreState()
		if pieces.number == 1
			pieces.state = S_RSSHRHAPNEL1
		elseif pieces.number == 2
			pieces.state = S_RSSHRHAPNEL2
		else
			pieces.state = S_RSSHRHAPNEL3
		end
	end
	
	if pieces.They and pieces.They.valid
	
		if (pieces.They.eflags & MFE_VERTICALFLIP)
			pieces.flags2 = $1 | MF2_OBJECTFLIP
			pieces.eflags = $1 | MFE_VERTICALFLIP
		else
			pieces.flags2 = $ & ~MF2_OBJECTFLIP
			pieces.eflags = $ & ~MFE_VERTICALFLIP
		end
	
		pieces.zongle = $ + FixedAngle(8<<FRACBITS)
		pieces.rockradius = $ - FRACUNIT
		
		--print(pieces.rockradius/FRACUNIT)
		
		RestoreState()
		pieces.flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
		
        pieces.posx = (pieces.They.x) + FixedMul(cos(pieces.zongle), -pieces.rockradius)
        pieces.posy = (pieces.They.y) + 1 * cos(pieces.zongle)
        pieces.posz = (pieces.They.z) + pieces.They.height/2 + FixedMul(sin(pieces.zongle), -pieces.rockradius)
		
		P_TeleportMove(pieces, pieces.posx, pieces.posy, pieces.posz)
		
		if (pieces.They.destroytimer % 11) == 0
			pieces.transstate2 = $ + 1
		end
		
		if pieces.transstate2 == 0
			pieces.state = S_INVISIBLE
		elseif pieces.transstate2 == 1
			RestoreState()
			pieces.frame = $1 | TR_TRANS90
		elseif pieces.transstate2 == 2
			RestoreState()
			pieces.frame = $1 | TR_TRANS80
		elseif pieces.transstate2 == 3
			RestoreState()
			pieces.frame = $1 | TR_TRANS70
		elseif pieces.transstate2 == 4
			RestoreState()
			pieces.frame = $1 | TR_TRANS60
		elseif pieces.transstate2 == 5
			RestoreState()
			pieces.frame = $1 | TR_TRANS50
		elseif pieces.transstate2 == 6
			RestoreState()
			pieces.frame = $1 | TR_TRANS40
		elseif pieces.transstate2 == 7
			RestoreState()
			pieces.frame = $1 | TR_TRANS30
		elseif pieces.transstate2 == 8
			RestoreState()
			pieces.frame = $1 | TR_TRANS20
		elseif pieces.transstate2 == 9
			RestoreState()
			pieces.frame = $1 | TR_TRANS10
		elseif pieces.transstate2 == 10
			RestoreState()
		end
		
		if not pieces.They.SummonedThem
			P_RemoveMobj(pieces)
			return
		end
		
		return -- prevents the removing code from running
	end
	

	-- [[ remove shrapnel ]] --
	if pieces.timer == nil
		RestoreState()
		pieces.timer = 0
		pieces.transstate = 0
		P_SetObjectMomZ(pieces, P_RandomRange(2, 6)*FRACUNIT, false)
		P_InstaThrust(pieces, pieces.angle, -FixedMul((P_RandomRange(5, 35)*FRACUNIT)/12 + FRACUNIT + P_RandomFixed(), pieces.scale))
	end
	
	if not P_IsObjectOnGround(pieces)
		pieces.rollangle = $ + FixedAngle(4<<FRACBITS)
	else
		pieces.rollangle = $ + (ANG1/2)
		pieces.timer = $ + 1
	end
		
	if (pieces.timer % 5) == 0
		pieces.transstate = $ + 1
	end
	
	if pieces.transstate == 1
		RestoreState()
		pieces.frame = $1 | TR_TRANS10
	elseif pieces.transstate == 2
		RestoreState()
		pieces.frame = $1 | TR_TRANS20
	elseif pieces.transstate == 3
		RestoreState()
		pieces.frame = $1 | TR_TRANS30
	elseif pieces.transstate == 4
		RestoreState()
		pieces.frame = $1 | TR_TRANS40
	elseif pieces.transstate == 5
		RestoreState()
		pieces.frame = $1 | TR_TRANS50
	elseif pieces.transstate == 6
		RestoreState()
		pieces.frame = $1 | TR_TRANS60
	elseif pieces.transstate == 7
		RestoreState()
		pieces.frame = $1 | TR_TRANS70
	elseif pieces.transstate == 8
		RestoreState()
		pieces.frame = $1 | TR_TRANS80
	elseif pieces.transstate == 9
		RestoreState()
		pieces.frame = $1 | TR_TRANS90
	elseif pieces.transstate >= 10
		P_RemoveMobj(pieces)
		return
	end


end, MT_RSSHRAPNEL)

--- [[[ HUD Stuff ]]] ---

local function drawShield(v, p, c) -- most code made by faye, you can tell because all the variables are one letter long, which is something i don't do, i'm weird i know
    local pudisplay = CV_FindVar("powerupdisplay").value    
    if pudisplay == 0 then return end

    local rockshield = v.cachePatch("TVRSC0")
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
    
    if (p.powers[pw_shield] & SH_NOSTACK == SH_ROCKSHIELD) and ((pudisplay == 1 and not c.chase) or pudisplay == 2)then
        --I directly looked up the offsets from the source and STILL had to guesstimate the positioning/scale. What the hell?
        v.drawScaled((hudstuff.x + rockshield.width/3)<< FRACBITS , (hudstuff.y+rockshield.height/2 +1) << FRACBITS, 2*FRACUNIT/3, rockshield,hudstuff.flags)
    end

end

hud.add(drawShield, "game")