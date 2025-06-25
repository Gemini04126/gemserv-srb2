//Dig
//some parts of the code are from impostor
//credits to buggiethebug
freeslot(
	"S_KNUCKLES_DIGDOWN1",
	"S_KNUCKLES_DIGDOWN2",
	"S_KNUCKLES_DIGDOWN3",
	"S_KNUCKLES_DIGDOWN4",
	"S_KNUCKLES_DIGUP1",
	"S_KNUCKLES_DIGUP2",
	"S_KNUCKLES_DIGUP3",
	"S_KNUCKLES_DIGUP4",
	"SPR_KDRA",
	"SPR_KDRB",
	"MT_ROCKBLAST"
)

states[S_KNUCKLES_DIGDOWN1] = {
	sprite = SPR_KDRA,
	frame = A,
	tics = 1,
	nextstate = S_KNUCKLES_DIGDOWN2
}

states[S_KNUCKLES_DIGDOWN2] = {
	sprite = SPR_KDRA,
	frame = B,
	tics = 1,
	nextstate = S_KNUCKLES_DIGDOWN3
}

states[S_KNUCKLES_DIGDOWN3] = {
	sprite = SPR_KDRA,
	frame = C,
	tics = 1,
	nextstate = S_KNUCKLES_DIGDOWN4
}

states[S_KNUCKLES_DIGDOWN4] = {
	sprite = SPR_KDRA,
	frame = D,
	tics = 1,
	nextstate = S_KNUCKLES_DIGDOWN1
}

states[S_KNUCKLES_DIGUP1] = {
	sprite = SPR_KDRB,
	frame = A,
	tics = 1,
	nextstate = S_KNUCKLES_DIGUP2
}

states[S_KNUCKLES_DIGUP2] = {
	sprite = SPR_KDRB,
	frame = B,
	tics = 1,
	nextstate = S_KNUCKLES_DIGUP3
}

states[S_KNUCKLES_DIGUP3] = {
	sprite = SPR_KDRB,
	frame = C,
	tics = 1,
	nextstate = S_KNUCKLES_DIGUP4
}

states[S_KNUCKLES_DIGUP4] = {
	sprite = SPR_KDRB,
	frame = D,
	tics = 1,
	nextstate = S_KNUCKLES_DIGUP1
}

mobjinfo[MT_ROCKBLAST] = {
	spawnstate = S_ROCKCRUMBLEA,
	spawnhealth = 1000,
	radius = 8*FRACUNIT,
	height = 16*FRACUNIT,
	mass = 0,
	damage = 0,
	flags = MF_MISSILE|MF_BOUNCE|MF_GRENADEBOUNCE
}

local function kncuklesresetdig(p)
	p.height = skins[p.mo.skin].height
	p.charflags = skins[p.mo.skin].flags
	p.pflags = $ & ~(PF_INVIS|PF_THOKKED)
	p.mo.flags2 = $ & ~MF2_DONTDRAW
	p.shieldscale = skins[p.mo.skin].shieldscale
	p.charability2 = skins[p.mo.skin].ability2
	p.digging = false
	p.drilled = false
	p.charflags = $ & ~SF_NOSKID
	p.mo.flags = $ & ~MF_NOCLIPTHING
	if not p.hyperform
		p.pflags = $ & ~PF_GODMODE
	end
end

addHook("PlayerThink", function(player)
	if player.digtime == nil
		player.digtime = 0
	end
	if player.drilled == nil
		player.drilled = false
	end
	if player.digging == nil
		player.digging = false
	end
	if player.knuxexiting == nil
		player.knuxexiting = false
	end
end)

local function rockblast(player)
	for i = 1, 17
		local rock = P_SpawnPlayerMissile(player.mo, MT_ROCKBLAST, MF2_SCATTER)
		rock.tics = 100
		rock.frame = A
		P_InstaThrust(rock, i*ANGLE_22h, 5*player.mo.scale)
		rock.momz = 16*P_MobjFlip(player.mo)*player.mo.scale
		rock.eflags = player.mo.eflags & MFE_VERTICALFLIP
	end
end

//taken from the pins of the srb2 offical server scipting channel thanks tasurtu -->G: Tatsuru*
local function CheckAndCrumble(mo, sec)
  for fof in sec.ffloors()
    if not (fof.flags & FF_EXISTS) continue end -- Does it exist?
    if not (fof.flags & FF_BUSTUP) continue end -- Is it bustable?
    
    if mo.z + mo.height < fof.bottomheight continue end -- Are we too low?
    if mo.z > fof.topheight continue end -- Are we too high?

    -- Check for whatever else you may want to    

    EV_CrumbleChain(fof) -- Crumble
  end
end

addHook("PlayerThink", function(player)
	local mo = player.mo
	local me = player
	
	if mo.skin ~= "knuckles" return end
	
	if mo and mo.valid
	and player.playerstate == PST_LIVE
	and (player.cmd.buttons & BT_CUSTOM1)
	and not player.powers[pw_carry]
	and not (player.pflags & PF_SLIDING)
	and not player.knuxexiting
	and not me.drilled
	and not (me.exiting)
	and not P_IsObjectOnGround(mo)
	and not (player.prevc1)
	and mo.state ~= S_PLAY_CLING 
	and mo.state ~= S_PLAY_CLIMB
	and not P_PlayerInPain(player)
		player.drilled = true
		mo.state = S_KNUCKLES_DIGDOWN1
		S_StartSound(mo, sfx_zoom)
	end
	if player.drilled
	and (mo.eflags & MFE_GOOWATER)
	or player.drilled
	and player.powers[pw_carry]
	or player.drilled
	and player.playerstate == PST_DEAD
	or player.drilled
	and P_PlayerInPain(player)
		player.drilled = false
		//PRINT("AUGHHHHHHHHHH")
	end
	if player.drilled
	and not (mo.eflags & MFE_SPRUNG)
		mo.momx = 0
		mo.momy = 0
		P_SpawnGhostMobj(mo)
		player.pflags = $|PF_THOKKED
		player.pflags = $ & ~PF_GLIDING
		player.doublejumped = true
		player.momentumthokus = true
	end
	if player.drilled
	and not (mo.eflags & MFE_GOOWATER)
	and not (mo.eflags & MFE_SPRUNG)
		P_SetObjectMomZ(mo, -29*FRACUNIT)
	end
	if player.drilled
	and (mo.eflags & MFE_JUSTHITFLOOR or P_IsObjectOnGround(mo))
	and not (player.cmd.buttons & BT_JUMP)
		player.drilled = false
		player.digging = true
		S_StartSound(mo, sfx_s3k4c)
	end 
	if player.drilled
	and (mo.eflags & MFE_JUSTHITFLOOR or P_IsObjectOnGround(mo))
	and (player.cmd.buttons & BT_JUMP)
		player.drilled = false
		P_SetObjectMomZ(mo, 6*FRACUNIT)
		mo.state = S_PLAY_SPRING
		P_StartQuake(11, 11)
		S_StartSound(mo, sfx_s3k5f)
		CheckAndCrumble(mo, mo.subsector.sector)
		player.pflags = $ & ~PF_THOKKED
	end
	if player.digtime == 0
		P_SetObjectMomZ(mo, 7*FRACUNIT)
		mo.state = S_PLAY_FALL
		kncuklesresetdig(player)
		S_StartSound(mo, sfx_s3k51)
	end
	if player.digging
	and player.speed >= 6*FRACUNIT
	and leveltime%4 == 0
		local rxy = P_RandomRange(-10, 10)*FRACUNIT
		local ground = P_SpawnMobj(mo.x+rxy, mo.y+rxy, mo.z, MT_MINUSDIRT)
		if not S_SoundPlaying(mo, sfx_s3kd3l)
			S_StartSound(mo, sfx_s3kd3l)
		end	
		if mo.eflags & MFE_VERTICALFLIP
			ground.eflags = $|MFE_VERTICALFLIP
			ground.flags2 = $|MF2_OBJECTFLIP
		else
			ground.eflags = $ & ~MFE_VERTICALFLIP
			ground.flags2 = $ & ~MF2_OBJECTFLIP
		end
	end
	if player.digging
	and (player.cmd.buttons & BT_CUSTOM1)
	and not (player.prevc1)
		rockblast(player)
		P_SetObjectMomZ(mo, 22*FRACUNIT)
		S_StartSound(mo, sfx_crumbl)
		mo.state = S_KNUCKLES_DIGUP1
		kncuklesresetdig(player)
		player.pflags = $|PF_JUMPED
		player.pflags = $ & ~PF_THOKKED
		player.doublejumped = false
		player.momentumthokus = false
		player.knuxexiting = true
	end
	if mo.state >= S_KNUCKLES_DIGUP1
	and mo.momz <= 0
	and not (mo.eflags & MFE_VERTICALFLIP)
		player.knuxexiting = false
		mo.state = S_PLAY_FALL
	end
	if mo.state >= S_KNUCKLES_DIGUP1
	and mo.momz >= 0
	and (mo.eflags & MFE_VERTICALFLIP)
		player.knuxexiting = false
		mo.state = S_PLAY_FALL
	end
	if mo.sprite ~= SPR_KDRB
		player.knuxexiting = false
	end
end)

//the other checks
addHook("PlayerThink", function(player)
	if player.digging
		player.digtime = $1-1
		player.height = P_GetPlayerSpinHeight(player)
		player.pflags = $|PF_INVIS
		player.pflags = $|PF_THOKKED
		player.pflags = $|PF_GODMODE
		player.pflags = $ & ~PF_SPINNING
		player.charability2 = CA2_NONE
		player.charflags = $|SF_NOSKID
		player.mo.flags2 = $|MF2_DONTDRAW
		player.mo.flags = $|MF_NOCLIPTHING
		player.shieldscale = 0
	end
	if player.digging
	and not P_IsObjectOnGround(player.mo)
		player.digging = false
		player.mo.state = S_PLAY_FALL
		kncuklesresetdig(player)
		player.pflags = $|PF_JUMPED
		S_StartSound(player.mo, sfx_s3k51)
		if S_SoundPlaying(player.mo, sfx_jump)
			S_StopSoundByID(player.mo, sfx_jump)
		end
	end
	if player.digging
	and P_PlayerInPain(player)
		player.digging = false
	end
	if (player.drilled or player.mo.state >= S_KNUCKLES_DIGUP1)
	and (player.mo.eflags & MFE_SPRUNG)
		player.drilled = false
		S_StartSound(player.mo, sfx_sprong)
		player.mo.momz = $*5/4
		player.pflags = $ & ~PF_THOKKED
	end
	if S_SoundPlaying(player.mo, sfx_s3kd3l)
	and not player.digging 
	or S_SoundPlaying(player.mo, sfx_s3kd3l) 
	and player.speed < 6*FRACUNIT
		S_StopSoundByID(player.mo, sfx_s3kd3l)
	end
	if player.drilled
	and player.mo.sprite ~= SPR_KDRA
		player.mo.state = S_KNUCKLES_DIGDOWN1
	end
	if not player.digging
		player.digtime = $1+1
	end
	if player.digtime > 162
		player.digtime = 162
	end
end)

addHook("PlayerCanDamage", function(player)
	local mo = player.mo
	if mo.state >= S_KNUCKLES_DIGUP1
		return true
	end
end)

addHook("PlayerSpawn", function(player)
	if player.mo.skin == "knuckles"
		kncuklesresetdig(player)
		player.digtime = 162
		player.digging = false
	end
end)

addHook("PlayerThink", function(player)
	local me = player
	local mo = player.mo
	
	if not mo and mo.valid return end
	if mo.skin ~= "knuckles" return end
	
	if (me.exiting)
	and me.digging
		me.diging = false
		S_StartSound(mo, sfx_jump)
		P_SetObjectMomZ(mo, 7*FRACUNIT)
		knucklesresetdig(player)
		mo.state = S_PLAY_SPRING
	end
end)

local function digthing(v, player)
	if not player.mo and player.mo.valid return end
	if (player.powers[pw_carry] == CR_NIGHTSMODE) return end
	
	if player.mo.skin == "knuckles" then
		v.drawString(-10, 160, ("Dig Time:"),V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_YELLOWMAP, "left")
	end
end

hud.add(digthing, "game")

local function digthing2(v, player)
	if not player.mo and player.mo.valid return end
	if (player.powers[pw_carry] == CR_NIGHTSMODE) return end
	
	if player.mo.skin == "knuckles" then
		v.drawString(57, 160, (player.digtime),V_SNAPTOBOTTOM|V_ALLOWLOWERCASE, "left")
	end
end

hud.add(digthing2, "game")

//button checks I made
local function buttonchecks(player)
	player.prevspin = player.cmd.buttons & BT_SPIN
	player.prevuse = player.cmd.buttons & BT_USE
	player.prevjump = player.cmd.buttons & BT_JUMP
	player.prevc1 = player.cmd.buttons & BT_CUSTOM1
	player.prevc2 = player.cmd.buttons & BT_CUSTOM2
	player.prevc3 = player.cmd.buttons & BT_CUSTOM3
	player.prevtf = player.cmd.buttons & BT_TOSSFLAG
end

addHook("PlayerThink", buttonchecks)