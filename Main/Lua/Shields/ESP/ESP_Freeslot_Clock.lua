freeslot("MT_CLOCK_BOX","MT_CLOCK_GOLDBOX","MT_CLOCK_ICON",
"MT_CLOCK_REWIND",
"S_CLOCK_BOX","S_CLOCK_GOLDBOX","S_CLOCK_ICON1","S_CLOCK_ICON2",
"S_CLOCK_OVERLAY","S_CLOCK_OVERLAY_HR","S_CLOCK_OVERLAY_MIN",
"SPR_VMCS","SPR_PTCS")

sfxinfo[sfx_kc31].caption = "Rewound time"

local SH_CLOCK = 16
rawset(_G, "SH_CLOCK", SH_CLOCK)

mobjinfo[MT_CLOCK_BOX] = {
	--$Name Clock Shield
	--$Sprite VMCSA0
	--$Category Monitors
	doomednum = 425,
	spawnstate = S_CLOCK_BOX,
	reactiontime = 8,
	painstate = S_CLOCK_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	mass = 100,
	damage = MT_CLOCK_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR
}

mobjinfo[MT_CLOCK_GOLDBOX] = {
	--$Name Clock Shield (Respawning)
	--$Sprite VMCSB0
	--$Category Monitors (Respawning)
	doomednum = 455,
	spawnstate = S_CLOCK_GOLDBOX,
	reactiontime = 8,
	attacksound = sfx_monton,
	painstate = S_CLOCK_GOLDBOX,
	deathstate = S_GOLDBOX_OFF1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 20*FRACUNIT,
	height = 44*FRACUNIT,
	mass = 100,
	damage = MT_CLOCK_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE
}

mobjinfo[MT_CLOCK_ICON] = {
	doomednum = -1,
	spawnstate = S_CLOCK_ICON1,
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

mobjinfo[MT_CLOCK_REWIND] = {
	doomednum = -1,
	spawnstate = S_INVISIBLE,
	radius = 16*FRACUNIT,
	height = 48*FRACUNIT
}

states[S_CLOCK_BOX] = {SPR_VMCS,A,2,nil,0,0,S_BOX_FLICKER}
states[S_CLOCK_GOLDBOX] = {SPR_VMCS,B,2,A_GoldMonitorSparkle,0,0,S_GOLDBOX_FLICKER}
states[S_CLOCK_ICON1] = {SPR_VMCS,C|FF_ANIMATE,18,nil,3,4,S_CLOCK_ICON2}
states[S_CLOCK_ICON2] = {SPR_VMCS,C,18,A_GiveExtraShield,SH_CLOCK}
states[S_CLOCK_OVERLAY] = {SPR_PTCS,A|TR_TRANS30}
states[S_CLOCK_OVERLAY_HR] = {SPR_PTCS,B|TR_TRANS30}
states[S_CLOCK_OVERLAY_MIN] = {SPR_PTCS,C|TR_TRANS30}