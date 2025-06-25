freeslot("MT_GRAVITORB_BOX","MT_GRAVITORB_GOLDBOX","MT_GRAVITORB_ICON",
"MT_GRAVITORB_PART_B","MT_GRAVITORB_PART_O",
"S_GRAVITORB_BOX","S_GRAVITORB_GOLDBOX","S_GRAVITORB_ICON1","S_GRAVITORB_ICON2",
"S_GRAVITORB_PB1","S_GRAVITORB_PB2","S_GRAVITORB_PO1","S_GRAVITORB_PO2",
"SPR_VMGS","SPR_PTGS")

local SH_GRAVITY = 14
rawset(_G, "SH_GRAVITY", SH_GRAVITY)

mobjinfo[MT_GRAVITORB_BOX] = {
	--$Name Gravity Shield
	--$Sprite VMGSA0
	--$Category Monitors
	doomednum = 423,
	spawnstate = S_GRAVITORB_BOX,
	reactiontime = 8,
	painstate = S_GRAVITORB_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	mass = 100,
	damage = MT_GRAVITORB_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR
}

mobjinfo[MT_GRAVITORB_GOLDBOX] = {
	--$Name Gravity Shield (Respawning)
	--$Sprite VMGSB0
	--$Category Monitors (Respawning)
	doomednum = 453,
	spawnstate = S_GRAVITORB_GOLDBOX,
	reactiontime = 8,
	attacksound = sfx_monton,
	painstate = S_GRAVITORB_GOLDBOX,
	deathstate = S_GOLDBOX_OFF1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 20*FRACUNIT,
	height = 44*FRACUNIT,
	mass = 100,
	damage = MT_GRAVITORB_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE
}

mobjinfo[MT_GRAVITORB_ICON] = {
	doomednum = -1,
	spawnstate = S_GRAVITORB_ICON1,
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

mobjinfo[MT_GRAVITORB_PART_B] = {
	doomednum = -1,
	spawnstate = S_GRAVITORB_PB1,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT
}

mobjinfo[MT_GRAVITORB_PART_O] = {
	doomednum = -1,
	spawnstate = S_GRAVITORB_PO1,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT
}

states[S_GRAVITORB_BOX] = {SPR_VMGS,A,2,nil,0,0,S_BOX_FLICKER}
states[S_GRAVITORB_GOLDBOX] = {SPR_VMGS,B,2,A_GoldMonitorSparkle,0,0,S_GOLDBOX_FLICKER}
states[S_GRAVITORB_ICON1] = {SPR_VMGS,C|FF_ANIMATE,18,nil,3,4,S_GRAVITORB_ICON2}
states[S_GRAVITORB_ICON2] = {SPR_VMGS,C,18,A_GiveExtraShield,SH_GRAVITY}
states[S_GRAVITORB_PB1] = {SPR_PTGS,A,3,nil,0,0,S_GRAVITORB_PB2}
states[S_GRAVITORB_PB2] = {SPR_PTGS,A,1,A_GhostMe}
states[S_GRAVITORB_PO1] = {SPR_PTGS,B,3,nil,0,0,S_GRAVITORB_PO2}
states[S_GRAVITORB_PO2] = {SPR_PTGS,B,1,A_GhostMe}