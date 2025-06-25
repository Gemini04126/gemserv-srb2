addHook("MobjThinker", function(mo)
	if not mo.target P_KillMobj(mo) return end

	if mo.target.player.powers[pw_shield] == SH_GRAVITY
		if not (mo.flags2 & MF2_DONTDRAW)
			if mo.target.flags2 & MF2_OBJECTFLIP
				mo.color = SKINCOLOR_SUPERORANGE5
				A_Sparkling(mo,MT_GRAVITORB_PART_O)
			else
				mo.color = SKINCOLOR_CORNFLOWER
				A_Sparkling(mo,MT_GRAVITORB_PART_B)
			end
		end
	elseif mo.target.player.powers[pw_shield] == SH_STAR
		mo.color = SKINCOLOR_PURPLE
		if mo.target.starlightdash == nil
			mo.target.starlightdash = 0
			mo.target.star_timer = 0
		elseif mo.target.starlightdash == 5 -- failed to lightdash
			mo.target.starlightdash = 0
			mo.target.star_timer = 0
			mo.frame = A|TR_TRANS50|FF_ANIMATE
		elseif mo.target.starlightdash == 4 -- restore character
			mo.target.state = S_PLAY_JUMP
			if mo.target.player.charflags & SF_NOJUMPDAMAGE
				mo.target.player.pflags = $ & ~PF_SPINNING
			end
			mo.target.starlightdash = 0
			mo.target.star_timer = 0
			mo.target.momz = $ / 2
		elseif mo.target.starlightdash == 3 -- gfx and exit mid-dash
			if (not mo.target.target)
			or (mo.target.target and P_IsObjectOnGround(mo.target))
			or (mo.target.target and not (mo.target.player.pflags & PF_JUMPED))
			or (mo.target.z - mo.target.target.z > 64*FRACUNIT)
			or (mo.target.z + mo.target.target.z < 64*FRACUNIT)
				mo.target.starlightdash = 4
			end
			A_Sparkling(mo,MT_STAR_STAR)
			S_StartSound(mo.target, sfx_s227)
			mo.target.star_timer = $ + 1
		elseif mo.target.starlightdash == 2 -- play sound and start effects
			if mo.target.state >= S_STAR_LDASH1
			and mo.target.state <= S_STAR_LDASH8
				S_StartSound(mo.target, sfx_s3k74)
				mo.target.player.pflags = $ | PF_SPINNING
				mo.target.starlightdash = 3
				mo.frame = A|TR_TRANS50|FF_ANIMATE
			else
				S_StartSound(mo.target, sfx_s3k72)
				mo.target.starlightdash = 5
			end
		elseif mo.target.starlightdash == 1 -- start
			mo.target.state = S_STAR_LDASH1
			mo.target.starlightdash = 2
			mo.frame = A
		end
		if mo.target.star_timer >= 105
			mo.target.state = S_PLAY_JUMP
			mo.target.starlightdash = 4
		end
	elseif mo.target.player.powers[pw_shield] == SH_CLOCK
		mo.color = SKINCOLOR_JET
		if not mo.clocklay
			mo.clocklay = P_SpawnMobj(mo.x,mo.y,mo.z,MT_OVERLAY)
			mo.clocklay.target = mo
			mo.clocklay.state = S_CLOCK_OVERLAY
			mo.clockhr = P_SpawnMobj(mo.x,mo.y,mo.z,MT_OVERLAY)
			mo.clockhr.target = mo.clocklay
			mo.clockhr.state = S_CLOCK_OVERLAY_HR
			mo.clockmin = P_SpawnMobj(mo.x,mo.y,mo.z,MT_OVERLAY)
			mo.clockmin.target = mo.clocklay
			mo.clockmin.state = S_CLOCK_OVERLAY_MIN
		end
		if mo.target.player.pflags & PF_JUMPED and not (mo.target.player.pflags & PF_THOKKED)
			mo.clockmin.rollangle = $-ANG1
			mo.clockhr.rollangle = $-ANG1/8
		end
		if mo.target.player.pflags & PF_SHIELDABILITY
			mo.clockmin.rollangle = 0
			mo.clockhr.rollangle = 0
			mo.target.player.pflags = $ & ~PF_SHIELDABILITY
		end
		if not (mo.flags2 & MF2_DONTDRAW)
			mo.clocklay.flags2 = $ & ~MF2_DONTDRAW
			mo.clockhr.flags2 = $ & ~MF2_DONTDRAW
			mo.clockmin.flags2 = $ & ~MF2_DONTDRAW
		else
			mo.clocklay.flags2 = $ | MF2_DONTDRAW
			mo.clockhr.flags2 = $ | MF2_DONTDRAW
			mo.clockmin.flags2 = $ | MF2_DONTDRAW
		end
		if mo.target.player.pflags & PF_STARTJUMP and not mo.clockrw
			if mo.target.player.speed == 0
				mo.clockrw = P_SpawnMobjFromMobj(mo.target,0,0,0,MT_CLOCK_REWIND)
			else
				mo.clockrw = P_SpawnMobj(mo.target.x - FixedMul(mo.target.player.speed, cos(mo.target.angle)),
											mo.target.y - FixedMul(mo.target.player.speed, sin(mo.target.angle)),
											mo.target.z, MT_CLOCK_REWIND)
			end
			mo.clockrw.target = mo.target
			mo.clockrw.tracer = mo
			mo.clockrw.angle = mo.target.angle
			mo.target.rewindpoint = mo.clockrw
		end
	elseif mo.target.player.powers[pw_shield] == SH_GUM
		mo.color = SKINCOLOR_BUBBLEGUM
	end
	if mo.target.player.powers[pw_shield] != SH_CLOCK and mo.clocklay
		P_KillMobj(mo.clocklay)
		mo.clocklay = nil
		mo.target.clockx = nil
	end
	mo.scale = skins[mo.target.skin].shieldscale + (FRACUNIT/10)
	if (mo.target.player.powers[pw_invulnerability] > 0)
	or (mo.target.player.powers[pw_super] > 0)
		mo.flags2 = $ | MF2_DONTDRAW
	else
		mo.flags2 = $ & ~MF2_DONTDRAW
	end
	if mo.target.player.powers[pw_shield] != SH_GRAVITY
	and mo.target.player.powers[pw_shield] != SH_STAR
	and mo.target.player.powers[pw_shield] != SH_CLOCK
	and mo.target.player.powers[pw_shield] != SH_GUM
		mo.target.flags2 = $ & ~MF2_OBJECTFLIP
		mo.target.star_timer = 0
		P_KillMobj(mo)
		return
	end
	if (mo.target.sprite2 == SPR2_ROLL)
	or (mo.target.sprite2 == SPR2_SPIN)
	or (mo.target.sprite2 == SPR2_GLID)
		A_CapeChase(mo,(-7*FRACUNIT)+0)
	else
		A_CapeChase(mo)
	end
end, MT_EXTRA_ORB)

addHook("ShieldSpecial", function(player)
	if player.powers[pw_shield] == SH_GRAVITY
		if player.mo.flags2 & MF2_OBJECTFLIP
			player.mo.flags2 = $ & ~MF2_OBJECTFLIP
		else
			player.mo.flags2 = $ | MF2_OBJECTFLIP
		end
		S_StartSound(player.mo, sfx_peww)
		player.pflags = $ | PF_THOKKED
		return true
	elseif player.powers[pw_shield] == SH_STAR
		player.mo.starlightdash = 1
		player.mo.star_timer = 0
		player.pflags = $ | PF_THOKKED
		return true
	elseif player.powers[pw_shield] == SH_CLOCK
		if player.mo.rewindpoint
			S_StartSound(player.mo, sfx_kc31)
			P_FlashPal(player,PAL_WHITE,10)
			P_TeleportMove(player.mo,
				player.mo.rewindpoint.x,
				player.mo.rewindpoint.y,
				player.mo.rewindpoint.z)
			A_ForceStop(player.mo)
			player.mo.angle = player.mo.rewindpoint.angle
			P_ResetPlayer(player)
			player.powers[pw_nocontrol] = 17
			player.pflags = $ | PF_THOKKED | PF_SHIELDABILITY
		end
		return true
	elseif player.powers[pw_shield] == SH_GUM
		S_StartSound(player.mo, sfx_s3k8a)
		local bubb = P_SpawnMobjFromMobj(player.mo,0,0,0,MT_GUM_BUBBLE)
		bubb.target = player.mo
		player.pflags = $ & ~PF_STARTJUMP & ~PF_JUMPED & ~PF_SPINNING
		player.pflags = $ | PF_THOKKED
		return true
	end
end)