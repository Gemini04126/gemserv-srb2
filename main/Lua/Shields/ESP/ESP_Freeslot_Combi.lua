freeslot("MT_COMBINE_BOX","MT_COMBINE_GOLDBOX","MT_COMBINE_ICON",
"S_COMBINE_BOX","S_COMBINE_GOLDBOX","S_COMBINE_ICON1","S_COMBINE_ICON2",
"SPR_VMCO")

sfxinfo[sfx_cdfm63].caption = "Rings combined"

mobjinfo[MT_COMBINE_BOX] = {
	--$Name Combine Ring
	--$Sprite VMCOA0
	--$Category Monitors
	doomednum = 427,
	spawnstate = S_COMBINE_BOX,
	reactiontime = 8,
	painstate = S_COMBINE_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	mass = 100,
	damage = MT_COMBINE_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR
}

mobjinfo[MT_COMBINE_GOLDBOX] = {
	--$Name Combine Ring (Respawning)
	--$Sprite VMCOB0
	--$Category Monitors (Respawning)
	doomednum = 457,
	spawnstate = S_COMBINE_GOLDBOX,
	reactiontime = 8,
	attacksound = sfx_monton,
	painstate = S_COMBINE_GOLDBOX,
	deathstate = S_GOLDBOX_OFF1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 20*FRACUNIT,
	height = 44*FRACUNIT,
	mass = 100,
	damage = MT_COMBINE_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE
}

mobjinfo[MT_COMBINE_ICON] = {
	doomednum = -1,
	spawnstate = S_COMBINE_ICON1,
	seesound = sfx_cdfm63,
	reactiontime = 8,
	speed = 2*FRACUNIT,
	radius = 8*FRACUNIT,
	height = 14*FRACUNIT,
	mass = 100,
	damage = 62*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP|MF_BOXICON|MF_SCENERY
}

function A_CombineRing(actor)
	if actor.target and actor.target.player
		actor.target.pw_combine = 1
		S_StartSound(actor.target,actor.info.seesound)
	end
end

states[S_COMBINE_BOX] = {SPR_VMCO,A,2,nil,0,0,S_BOX_FLICKER}
states[S_COMBINE_GOLDBOX] = {SPR_VMCO,B,2,A_GoldMonitorSparkle,0,0,S_GOLDBOX_FLICKER}
states[S_COMBINE_ICON1] = {SPR_VMCO,C|FF_ANIMATE,18,nil,3,4,S_COMBINE_ICON2}
states[S_COMBINE_ICON2] = {SPR_VMCO,C,18,A_CombineRing}