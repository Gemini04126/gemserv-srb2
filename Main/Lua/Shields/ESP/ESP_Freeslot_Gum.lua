freeslot("MT_GUM_BOX","MT_GUM_GOLDBOX","MT_GUM_ICON",
"MT_GUM_BUBBLE",
"S_GUM_BOX","S_GUM_GOLDBOX","S_GUM_ICON1","S_GUM_ICON2",
"S_GUM_BUBBLE",
"SPR_VMBS","SPR_PTBS")

local SH_GUM = 17
rawset(_G, "SH_GUM", SH_GUM)

mobjinfo[MT_GUM_BOX] = {
	--$Name Bubblegum Shield
	--$Sprite VMBSA0
	--$Category Monitors
	doomednum = 426,
	spawnstate = S_GUM_BOX,
	reactiontime = 8,
	painstate = S_GUM_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	mass = 100,
	damage = MT_GUM_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR
}

mobjinfo[MT_GUM_GOLDBOX] = {
	--$Name Bubblegum Shield (Respawning)
	--$Sprite VMBSB0
	--$Category Monitors (Respawning)
	doomednum = 456,
	spawnstate = S_GUM_GOLDBOX,
	reactiontime = 8,
	attacksound = sfx_monton,
	painstate = S_GUM_GOLDBOX,
	deathstate = S_GOLDBOX_OFF1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 20*FRACUNIT,
	height = 44*FRACUNIT,
	mass = 100,
	damage = MT_GUM_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE
}

mobjinfo[MT_GUM_ICON] = {
	doomednum = -1,
	spawnstate = S_GUM_ICON1,
	seesound = sfx_kc54,
	reactiontime = 8,
	deathsound = sfx_pop,
	speed = 2*FRACUNIT,
	radius = 8*FRACUNIT,
	height = 14*FRACUNIT,
	mass = 100,
	damage = 62*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP|MF_BOXICON|MF_SCENERY
}

mobjinfo[MT_GUM_BUBBLE] = {
	doomednum = -1,
	spawnstate = S_INVISIBLE,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT
}

states[S_GUM_BOX] = {SPR_VMBS,A,2,nil,0,0,S_BOX_FLICKER}
states[S_GUM_GOLDBOX] = {SPR_VMBS,B,2,A_GoldMonitorSparkle,0,0,S_GOLDBOX_FLICKER}
states[S_GUM_ICON1] = {SPR_VMBS,C|FF_ANIMATE,18,nil,3,4,S_GUM_ICON2}
states[S_GUM_ICON2] = {SPR_VMBS,C,18,A_GiveExtraShield,SH_GUM}
states[S_GUM_BUBBLE] = {SPR_PTBS,A,-1}