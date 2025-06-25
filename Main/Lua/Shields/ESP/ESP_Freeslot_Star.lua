freeslot("MT_STAR_BOX","MT_STAR_GOLDBOX","MT_STAR_ICON",
"MT_STAR_STAR",
"S_STAR_BOX","S_STAR_GOLDBOX","S_STAR_ICON1","S_STAR_ICON2",
"S_STAR_STAR1","S_STAR_STAR2","S_STAR_LDASH1","S_STAR_LDASH2","S_STAR_LDASH3","S_STAR_LDASH4","S_STAR_LDASH5","S_STAR_LDASH6","S_STAR_LDASH7","S_STAR_LDASH8",
"SPR_VMSS","SPR_PTSS")

sfxinfo[sfx_s227].caption = "Light dash"

local SH_STAR = 15
rawset(_G, "SH_STAR", SH_STAR)

mobjinfo[MT_STAR_BOX] = {
	--$Name Star Shield
	--$Sprite VMSSA0
	--$Category Monitors
	doomednum = 424,
	spawnstate = S_STAR_BOX,
	reactiontime = 8,
	painstate = S_STAR_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	mass = 100,
	damage = MT_STAR_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR
}

mobjinfo[MT_STAR_GOLDBOX] = {
	--$Name Star Shield (Respawning)
	--$Sprite VMSSB0
	--$Category Monitors (Respawning)
	doomednum = 454,
	spawnstate = S_STAR_GOLDBOX,
	reactiontime = 8,
	attacksound = sfx_monton,
	painstate = S_STAR_GOLDBOX,
	deathstate = S_GOLDBOX_OFF1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 20*FRACUNIT,
	height = 44*FRACUNIT,
	mass = 100,
	damage = MT_STAR_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE
}

mobjinfo[MT_STAR_ICON] = {
	doomednum = -1,
	spawnstate = S_STAR_ICON1,
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

mobjinfo[MT_STAR_STAR] = {
	doomednum = -1,
	spawnstate = S_STAR_STAR1,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT
}

states[S_STAR_BOX] = {SPR_VMSS,A,2,nil,0,0,S_BOX_FLICKER}
states[S_STAR_GOLDBOX] = {SPR_VMSS,B,2,A_GoldMonitorSparkle,0,0,S_GOLDBOX_FLICKER}
states[S_STAR_ICON1] = {SPR_VMSS,C|FF_ANIMATE,18,nil,3,4,S_STAR_ICON2}
states[S_STAR_ICON2] = {SPR_VMSS,C,18,A_GiveExtraShield,SH_STAR}
states[S_STAR_STAR1] = {SPR_PTSS,A,1,nil,0,0,S_STAR_STAR2}
states[S_STAR_STAR2] = {SPR_PTSS,A,1,A_GhostMe}
states[S_STAR_LDASH1] = {SPR_PLAY,SPR2_ROLL,0,A_CheckThingCount,(MT_RING*FRACUNIT)+1,(256*FRACUNIT)+S_STAR_LDASH2,S_PLAY_JUMP}
states[S_STAR_LDASH2] = {SPR_PLAY,SPR2_ROLL,0,A_FindTarget,MT_RING,0,S_STAR_LDASH3}
states[S_STAR_LDASH3] = {SPR_PLAY,SPR2_ROLL,0,A_CheckTrueRange,256,S_STAR_LDASH4,S_PLAY_ROLL}
states[S_STAR_LDASH4] = {SPR_PLAY,SPR2_ROLL,1,A_HomingChase,40*FRACUNIT,0,S_STAR_LDASH5}
states[S_STAR_LDASH5] = {SPR_PLAY,SPR2_ROLL,0,A_GhostMe,0,0,S_STAR_LDASH6}
states[S_STAR_LDASH6] = {SPR_PLAY,SPR2_ROLL,0,A_RemoteAction,-1,S_STAR_LDASH8,S_STAR_LDASH7}
states[S_STAR_LDASH7] = {SPR_PLAY,SPR2_ROLL,0,nil,0,0,S_STAR_LDASH1}
states[S_STAR_LDASH8] = {SPR_PLAY,SPR2_ROLL,0,A_CheckHealth,0,S_NULL}