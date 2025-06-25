freeslot("MT_GRUSH_BOX","MT_GRUSH_GOLDBOX","MT_GRUSH_ICON","MT_GRUSH_SPARK",
"S_GRUSH_BOX","S_GRUSH_GOLDBOX","S_GRUSH_ICON1","S_GRUSH_ICON2",
"S_GRUSH_SPARK",
"SPR_VMRU","SPR_PTRH")

mobjinfo[MT_GRUSH_BOX] = {
	--$Name Gold Rush
	--$Sprite VMRUA0
	--$Category Monitors
	doomednum = 428,
	spawnstate = S_GRUSH_BOX,
	reactiontime = 8,
	painstate = S_GRUSH_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	mass = 100,
	damage = MT_GRUSH_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR
}

mobjinfo[MT_GRUSH_GOLDBOX] = {
	--$Name Gold Rush (Respawning)
	--$Sprite VMRUB0
	--$Category Monitors (Respawning)
	doomednum = 458,
	spawnstate = S_GRUSH_GOLDBOX,
	reactiontime = 8,
	attacksound = sfx_monton,
	painstate = S_GRUSH_GOLDBOX,
	deathstate = S_GOLDBOX_OFF1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 20*FRACUNIT,
	height = 44*FRACUNIT,
	mass = 100,
	damage = MT_GRUSH_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE
}

mobjinfo[MT_GRUSH_ICON] = {
	doomednum = -1,
	spawnstate = S_GRUSH_ICON1,
	reactiontime = 8,
	speed = 2*FRACUNIT,
	radius = 8*FRACUNIT,
	height = 14*FRACUNIT,
	mass = 100,
	damage = 62*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP|MF_BOXICON|MF_SCENERY
}

mobjinfo[MT_GRUSH_SPARK] = {
	doomednum = -1,
	spawnstate = S_GRUSH_SPARK,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT
}

function A_GoldRush(actor)
	if actor.target and actor.target.player
		local plyr = actor.target.player
		actor.target.pw_goldrush = invulntics + 1
		actor.target.pw_mus_ctrl = invulntics + 1

		if not plyr.powers[pw_super]
			P_PlayJingleMusic(plyr,"_GRUSH",16384,false,JT_INV)
			S_StartMusicCaption("Gold Rush",invulntics+1)
		end
	end
end

states[S_GRUSH_BOX] = {SPR_VMRU,A,2,nil,0,0,S_BOX_FLICKER}
states[S_GRUSH_GOLDBOX] = {SPR_VMRU,B,2,A_GoldMonitorSparkle,0,0,S_GOLDBOX_FLICKER}
states[S_GRUSH_ICON1] = {SPR_VMRU,C|FF_ANIMATE,18,nil,3,4,S_GRUSH_ICON2}
states[S_GRUSH_ICON2] = {SPR_VMRU,C,18,A_GoldRush}
states[S_GRUSH_SPARK] = {SPR_PTRH,FF_ANIMATE,6,nil,2,2}