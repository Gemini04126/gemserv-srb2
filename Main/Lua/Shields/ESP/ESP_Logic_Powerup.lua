addHook("PlayerThink", function(player)
	if not player.mo return end
	if not player.mo.pw_combine player.mo.pw_combine = 0 end
	if not player.mo.pw_goldrush player.mo.pw_goldrush = 0 end
	if not player.mo.pw_springsocks player.mo.pw_springsocks = 0 end
	if not player.mo.pw_mus_ctrl player.mo.pw_mus_ctrl = 0 end

	if player.mo.pw_goldrush > 0
		if player.mo.pw_goldrush % 7 > 2 and player.mo.pw_goldrush % 7 < 6
			player.mo.color = SKINCOLOR_SUPERGOLD2
			player.mo.colorized = true
		else
			if player.powers[pw_super]
				player.mo.color = skins[player.mo.skin].supercolor + 4
			else
				player.mo.color = player.skincolor
			end
			player.mo.colorized = false
		end
		if player.mo.pw_goldrush % 7 == 4
			A_Sparkling(player.mo,MT_GRUSH_SPARK)
		end
		player.mo.pw_goldrush = $ - 1
	end

	if player.mo.pw_springsocks > 1
		if player.powers[pw_super] and not (skins[player.mo.skin].flags & SF_NOSUPERJUMPBOOST)
			player.jumpfactor = skins[player.mo.skin].jumpfactor
		else
			player.jumpfactor = (skins[player.mo.skin].jumpfactor * 4) / 3
		end
		if (player.pflags & PF_JUMPED or player.pflags & PF_BOUNCING) and player.mo.pw_springsocks % 5 == 0
			P_SpawnGhostMobj(player.mo)
		end
		player.mo.pw_springsocks = $ - 1
	elseif player.mo.pw_springsocks == 1
		player.jumpfactor = skins[player.mo.skin].jumpfactor
		player.mo.pw_springsocks = 0
	end

	if player.mo.pw_mus_ctrl > 1
		player.mo.pw_mus_ctrl = $ - 1
	elseif player.mo.pw_mus_ctrl == 1
		P_RestoreMusic(player)
		player.mo.pw_mus_ctrl = 0
	end

	if player.playerstate == PST_DEAD
		player.mo.pw_combine = 0
		player.mo.pw_goldrush = 0
		player.mo.pw_springsocks = 0
	end
end)

local function GoldRushPlusOne(ring,plmo)
	if plmo.pw_goldrush > 1
		plmo.player.rings = $ + 1
	end
end

addHook("TouchSpecial", GoldRushPlusOne, MT_RING)
addHook("TouchSpecial", GoldRushPlusOne, MT_COIN)

function A_RingBox(actor)
	if actor.target and actor.target.player and actor.target.pw_goldrush > 1
		P_GivePlayerRings(actor.target.player, actor.info.reactiontime)
	end
	super(actor)
end

addHook("MobjDamage", function(mo,inf,src)
	if mo.pw_combine and mo.player.rings > 0 and not (mo.player.powers[pw_shield] & SH_NOSTACK or mo.player.powers[pw_shield] & SH_STACK)
		P_DoPlayerPain(mo.player,src,inf)
		S_StartSound(mo,sfx_shldls)
		P_PlayerRingBurst(mo.player,1)
		return true
	end
end, MT_PLAYER)

local function CombinedRingThinker(mo)
	if mo.target and mo.target.pw_combine and mo.fuse > 7*TICRATE
		mo.extravalue1 = mo.target.player.rings
		mo.scale, mo.momx, mo.momy, mo.momz = $*2, $*3, $*3, $*4
		mo.target.player.rings = 0
		mo.target.pw_combine = 0
	end
	if mo.extravalue1 and leveltime % 9 == 0
		A_Sparkling(mo,MT_SPARK)
	end
end

addHook("MobjThinker", CombinedRingThinker, MT_FLINGRING)
addHook("MobjThinker", CombinedRingThinker, MT_FLINGCOIN)

local function CombinedRingCollect(ring,plmo)
	if ring.extravalue1 and P_CanPickupItem(plmo.player,false)
		plmo.player.rings = ring.extravalue1 - 1
	end
end

addHook("TouchSpecial", CombinedRingCollect, MT_FLINGRING)
addHook("TouchSpecial", CombinedRingCollect, MT_FLINGCOIN)

local function CombinedRingBurst(mo)
	if mo.state >= S_SPRK1 return end

	if mo.extravalue1
		if mo.extravalue1 > 32
			mo.extravalue1 = 32
		end
		local snd = P_SpawnMobj(mo.x,mo.y,mo.z,MT_AXISTRANSFER)
		P_PlayRinglossSound(snd)
		snd.fuse = 2*TICRATE
		for i = 1, mo.extravalue1
			local ang = i*FixedAngle((360*FRACUNIT)/min(mo.extravalue1,16))
			local spl = P_SpawnMobj(mo.x+FixedMul(mo.radius/2, cos(ang)),
									mo.y+FixedMul(mo.radius/2, sin(ang)),
									mo.z+mo.height/2,MT_FLINGRING)
			if i > 16
				P_InstaThrust(spl,ang,3*FRACUNIT)
				P_SetObjectMomZ(spl,4*FRACUNIT)
			else
				P_InstaThrust(spl,ang,2*FRACUNIT)
				P_SetObjectMomZ(spl,3*FRACUNIT)
			end
			if mo.eflags & MFE_VERTICALFLIP
				spl.flags2 = MF2_OBJECTFLIP
			end
			spl.fuse = 8*TICRATE
		end
	end
end

addHook("MobjFuse", CombinedRingBurst, MT_FLINGRING)
addHook("MobjFuse", CombinedRingBurst, MT_FLINGCOIN)

-- initialize

addHook("PlayerSpawn", function(player)
	if not player.mo return end
	player.jumpfactor = skins[player.mo.skin].jumpfactor
end)