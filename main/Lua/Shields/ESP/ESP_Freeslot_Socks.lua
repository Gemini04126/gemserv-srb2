freeslot("MT_SOCKS_BOX","MT_SOCKS_GOLDBOX","MT_SOCKS_ICON",
"S_SOCKS_BOX","S_SOCKS_GOLDBOX","S_SOCKS_ICON1","S_SOCKS_ICON2",
"SPR_VMSK")

mobjinfo[MT_SOCKS_BOX] = {
	--$Name Spring Socks
	--$Sprite VMSKA0
	--$Category Monitors
	doomednum = 429,
	spawnstate = S_SOCKS_BOX,
	reactiontime = 8,
	painstate = S_SOCKS_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	mass = 100,
	damage = MT_SOCKS_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR
}

mobjinfo[MT_SOCKS_GOLDBOX] = {
	--$Name Spring Socks (Respawning)
	--$Sprite VMSKB0
	--$Category Monitors (Respawning)
	doomednum = 459,
	spawnstate = S_SOCKS_GOLDBOX,
	reactiontime = 8,
	attacksound = sfx_monton,
	painstate = S_SOCKS_GOLDBOX,
	deathstate = S_GOLDBOX_OFF1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 20*FRACUNIT,
	height = 44*FRACUNIT,
	mass = 100,
	damage = MT_SOCKS_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE
}

mobjinfo[MT_SOCKS_ICON] = {
	doomednum = -1,
	spawnstate = S_SOCKS_ICON1,
	reactiontime = 8,
	speed = 2*FRACUNIT,
	radius = 8*FRACUNIT,
	height = 14*FRACUNIT,
	mass = 100,
	damage = 62*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP|MF_BOXICON|MF_SCENERY
}

function A_SpringSocks(actor)
	if actor.target and actor.target.player
		local plyr = actor.target.player
		actor.target.pw_springsocks = sneakertics + 1
		actor.target.pw_mus_ctrl = sneakertics + 1

		if not plyr.powers[pw_super]
			P_PlayJingleMusic(plyr,"_SOCKS",16384,false,JT_SHOES)
			S_StartMusicCaption("Spring Socks",sneakertics+1)
		end
	end
end

states[S_SOCKS_BOX] = {SPR_VMSK,A,2,nil,0,0,S_BOX_FLICKER}
states[S_SOCKS_GOLDBOX] = {SPR_VMSK,B,2,A_GoldMonitorSparkle,0,0,S_GOLDBOX_FLICKER}
states[S_SOCKS_ICON1] = {SPR_VMSK,C|FF_ANIMATE,18,nil,3,4,S_SOCKS_ICON2}
states[S_SOCKS_ICON2] = {SPR_VMSK,C,18,A_SpringSocks}