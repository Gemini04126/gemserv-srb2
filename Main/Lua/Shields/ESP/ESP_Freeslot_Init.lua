freeslot("MT_EXTRA_ORB","S_EXTRA_ORB","SPR_ORB_")

sfxinfo[sfx_kc54].caption = "New Shield"

mobjinfo[MT_EXTRA_ORB] = {
	doomednum = -1,
	spawnstate = S_EXTRA_ORB,
	spawnhealth = 1000,
	reactiontime = 8,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 16,
	dispoffset = 1,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_SCENERY
}

function A_GiveExtraShield(actor,var1)
	if actor.target and actor.target.player
		if actor.target.player.powers[pw_shield] != SH_GRAVITY
		and actor.target.player.powers[pw_shield] != SH_STAR
		and actor.target.player.powers[pw_shield] != SH_CLOCK
		and actor.target.player.powers[pw_shield] != SH_GUM
			local extraorb = P_SpawnMobj(actor.target.x,actor.target.y,actor.target.z,MT_EXTRA_ORB)
			extraorb.target = actor.target
		end
		P_SwitchShield(actor.target.player,var1)
		S_StartSound(actor.target,actor.info.seesound)
	end
end

function A_Sparkling(actor,var1)
-- P_RandomRange can suck my ass
	local rad = ((actor.radius/FRACUNIT)/2)*3
	local h8 = actor.height/FRACUNIT
-- Let's go. Action to replace A_BossScream since that can spawn stuff right in
-- front of your FPS viewpoint, which'll mess you up when RPing as Doomguy.
	local h1 = P_RandomRange(rad/8,rad)*FRACUNIT
	local h2 = P_RandomRange(rad/8,rad)*FRACUNIT
	local ang = actor.angle+FixedAngle(P_RandomRange(45,315)*FRACUNIT)
	local x = FixedMul(h1,cos(ang))
	local y = FixedMul(h2,sin(ang))
	local z = FixedDiv(actor.height/2,actor.scale)+(P_RandomRange(-h8/4,h8/4)*FRACUNIT)
	local spk = P_SpawnMobjFromMobj(actor,x,y,z,var1)
end

states[S_EXTRA_ORB] = {SPR_ORB_,A|TR_TRANS50|FF_ANIMATE,-1,nil,7,2,S_EXTRA_ORB}