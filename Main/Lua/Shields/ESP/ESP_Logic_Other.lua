addHook("MobjThinker",function(mo)
	if not mo.target
		if mo.effthis
			mo.effthis.target = nil
		end
		P_RemoveMobj(mo)
		return
	end
	if not mo.effthis
		mo.effthis = P_SpawnMobjFromMobj(mo.target,0,0,0,MT_OVERLAY)
		mo.effthis.target = mo.target
		mo.effthis.state = S_GUM_BUBBLE
		mo.effthis.color = SKINCOLOR_BUBBLEGUM
	end

	if mo.target.player.powers[pw_shield] != SH_GUM
	or P_IsObjectOnGround(mo.target)
	or mo.target.eflags & MFE_SPRUNG
	or mo.target.eflags & MFE_GOOWATER
	or mo.target.player.powers[pw_carry]
		S_StartSound(mo.target,sfx_s3k77)
		mo.target = nil
		return
	end
	if mo.target.state != S_PLAY_RIDE
		mo.target.state = S_PLAY_RIDE
		mo.target.player.panim = PA_RIDE
	end
	if (not (mo.target.eflags & MFE_VERTICALFLIP) and mo.target.momz < FRACUNIT)
		P_SetObjectMomZ(mo.target,-mo.target.momz/8,true)
	end
	if (mo.target.eflags & MFE_VERTICALFLIP and mo.target.momz > -FRACUNIT)
		P_SetObjectMomZ(mo.target,mo.target.momz/8,true)
	end

	if mo.target.player.cmd.buttons & BT_JUMP
		S_StartSound(mo.target,sfx_s3k77)
		P_DoJump(mo.target.player,false)
		mo.target.player.pflags = $ & ~PF_STARTJUMP & ~PF_JUMPED
		mo.target.state = S_PLAY_SPRING
		mo.target.player.panim = PA_SPRING
		mo.target = nil
		return
	end
end, MT_GUM_BUBBLE)

addHook("MobjThinker",function(mo)
	if not mo.target
		P_RemoveMobj(mo)
		return
	end

	if P_IsObjectOnGround(mo.target)
	or mo.target.player.powers[pw_shield] != SH_CLOCK
		P_RemoveMobj(mo)
		return
	end
end, MT_CLOCK_REWIND)

addHook("MobjRemoved",function(mo)
-- bottomless pits suck
	if mo.tracer
		mo.tracer.clockrw = nil
	end
	if mo.target
		mo.target.rewindpoint = nil
		mo.target = nil
	end
end, MT_CLOCK_REWIND)