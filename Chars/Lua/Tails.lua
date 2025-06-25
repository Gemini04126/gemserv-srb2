local B = {}
local S = B.SkinVars
local state_swipe = 1
local state_thrust = 2
local cooldown_swipe = TICRATE
local cooldown_dash = TICRATE*1/10
local cooldown_throw = cooldown_dash
local sideangle = ANG20
local throw_strength = 25
local throw_lift = 10
local thrustpower = 23
local throwitem = MT_CYBRAKDEMON_NAPALM_BOMB_LARGE



freeslot("SPR_TWTH", "SKINCOLOR_WHENTHEORANGEDOESNTEXIST")

skincolors[SKINCOLOR_WHENTHEORANGEDOESNTEXIST] = { -- zeno made some colors and i used it as a base                   d
	name = "ass",
	ramp = {52,52,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	invcolor = SKINCOLOR_SANDY,
	invshade = 1, 
	chatcolor = V_AQUAMAP,
	accessible = false
}

local rainbowtable = {
	SKINCOLOR_RED,     --red
	SKINCOLOR_WHENTHEORANGEDOESNTEXIST,   --orange
	SKINCOLOR_KETCHUP, --yellow
	SKINCOLOR_EMERALD, --green
	SKINCOLOR_CERULEAN,    --blue
	SKINCOLOR_MAGENTA  --purple
}

B.Action = {} -- replacement for CBW_Battle
function B.CanDoAction(p)
	if p.playerstate == 0 then
		return true
	end
	return false
end
function B.ApplyCooldown(p, cd)
	
end
function B.GetSVSprite(p, o)
	return S_PLAY_GLIDE_LANDING
end
function B.DrawSVSprite(p, o)
	p.mo.state = S_PLAY_GLIDE_LANDING
end

local function sbvars(m,pmo)
	if m and m.valid then
		m.fuse = 20
		m.momx = $ + pmo.momx/2
		m.momy = $ + pmo.momy/2
		m.scale = $/2
		S_StartSoundAtVolume(m,sfx_s3kb8,190)
	end
end


local function swipe(p) -- the part where we make it happen
	if p.mo.skin != "tails" then
		return
	end	
	local dos = 0
	if p.cmd.buttons & BT_CUSTOM1 then
		if p.preswipe == nil then
			dos = 1
			--print("swipe")
		end
		p.preswipe = true
	else
		p.preswipe = nil
	end
	B.Action.TailSwipe(p.mo,dos,0)
	
end
addHook("PlayerThink", swipe)


local function sb2vars(u,pmo)
	if u and u.valid then
	local xyangle = R_PointToAngle2(0,0,u.momx,u.momy)
	local zangle = B.GetZAngle(0,0,0,u.momx,u.momy,u.momz)
	local speed = u.info.speed
		u.fuse = 20
		B.InstaThrustZAim(u,xyangle,zangle+ANG15/3,speed*3/2)
		u.momx = $ + pmo.momx/2
		u.momy = $ + pmo.momy/2
		u.scale = $/2
		S_StartSoundAtVolume(u,sfx_s3kb8,190)
	end 
end

local function sb3vars(d,pmo)
	if d and d.valid then
	local xyangle = R_PointToAngle2(0,0,d.momx,d.momy)
	local zangle = B.GetZAngle(0,0,0,d.momx,d.momy,d.momz)
	local speed = d.info.speed
		d.fuse = 20
		B.InstaThrustZAim(d,xyangle,zangle-ANG15/3,speed*3/2)
		d.momx = $ + pmo.momx/2
		d.momy = $ + pmo.momy/2
		d.scale = $/2
		S_StartSoundAtVolume(d,sfx_s3kb8,190)
	end 
end

/*local function domissile(mo,thrustfactor)
	--Projectile
	local m = P_SPMAngle(mo,throwitem,mo.angle+sideangle,0)
	sbvars(m,mo)
	--Do Side Projectiles
	local m = P_SPMAngle(mo,throwitem,mo.angle-sideangle,0)
	sbvars(m,mo)
	local m = P_SPMAngle(mo,throwitem,mo.angle,0)
	sbvars(m,mo)
	--Thrust
	if not(P_IsObjectOnGround(mo))
		P_InstaThrust(mo,mo.angle+ANGLE_180,thrustfactor*5)
	else
		P_Thrust(mo,mo.angle+ANGLE_180,thrustfactor*10)
	end
end

local function domissile2(mo,thrustfactor)
	--Projectile
	local m = P_SPMAngle(mo,throwitem,mo.angle+sideangle,0)
	sbvars(m,mo)
	--Do Side Projectiles
	local m = P_SPMAngle(mo,throwitem,mo.angle-sideangle,0)
	sbvars(m,mo)
	local m = P_SPMAngle(mo,throwitem,mo.angle,0)
	sbvars(m,mo)
	--Thrust
	if not(P_IsObjectOnGround(mo))
		P_InstaThrust(mo,mo.angle+ANGLE_180,thrustfactor*8)
	else
		P_Thrust(mo,mo.angle+ANGLE_180,thrustfactor*10)
	end
end*/

local function dodust(mo)
	if P_IsObjectOnGround(mo)
		local player = mo.player
		local dust = P_SpawnMobjFromMobj(mo,0,0,0,MT_DUST)
		P_InstaThrust(dust,player.drawangle,mo.scale*12)
	end
end

B.Action.TailSwipe_Priority = function(player)
local mo = player.mo
local momxy = FixedHypot(mo.momx,mo.momy)
local momxyz = FixedHypot(mo.momz,momxy)
	
	if (player.actionstate == state_thrust
	and (momxyz > 35*FRACUNIT)) or
	(player.actionstate == state_swipe and player.actiontime < 10) then
	--or mo.momz < -15*FRACUNIT
	--or mo.momz > 15*FRACUNIT)
		B.SetPriority(player,2,1,nil,2,1,"flight dash")
	end
end

B.Action.TailSwipe = function(mo,doaction,doaction2)
	local player = mo.player
	if not(B.CanDoAction(player)) 
		if mo.state == B.GetSVSprite(player,1)
			B.ResetPlayerProperties(player,false,true)
		end
	return end
	
	if player.actionstate == nil then
		player.actionstate = 0
	end
	
	local flying = player.panim == PA_ABILITY
	--print(flying)
	local carrying = false
	
	local swipetrigger = (player.actionstate == 0 and doaction == 1 and not(flying or carrying))
	local thrusttrigger = (player.actionstate == 0 and doaction == 1 and flying and not(carrying))
	local throwtrigger = false
	--Get thrust speed multiplier
	local thrustfactor = mo.scale
	if mo.eflags&MFE_UNDERWATER
		thrustfactor = $>>1
	end
	if mo.flags2&MF2_TWOD or twodlevel
		thrustfactor = $>>1
	end
	
	player.actionrings = 0
	/*if flying then
		player.pflags = $&~(PF_CANCARRY)-- no carrying, says zeno
	end*/
	
	if player.actionstate != 0 then
		player.exhaustmeter = FRACUNIT
	end
	
	--Activate swipe
	if swipetrigger and not thrusttrigger
		--B.PayRings(player)
		B.ApplyCooldown(player,cooldown_swipe)
		--Set state
		player.actionstate = state_swipe
		player.actiontime = 0
		player.pflags = $&~(PF_SPINNING|PF_JUMPED)
		--Missile attack
		//domissile(mo,thrustfactor)
		
		--Physics
		if not(P_IsObjectOnGround(mo))
			P_SetObjectMomZ(mo,FRACUNIT*3,true)
		end
		--Effects
		P_SpawnParaloop(mo.x,mo.y,mo.z,mo.scale*64,12,MT_DUST,ANGLE_90,nil,true)
		S_StartSound(mo,sfx_spdpad)
	end

	--Activate thrust
	if thrusttrigger 
		--B.PayRings(player)
		--Tails can get as much as 4x cooldown for using flight dash after flying for a while
		if mo.state == S_PLAY_FLY_TIRED
			B.ApplyCooldown(player, cooldown_dash * 3)
		else
			B.ApplyCooldown(player, min(cooldown_dash * 3, max(cooldown_dash, (cooldown_dash * 5) - ((FRACUNIT/2) * 300/FRACUNIT))))
		end
		--Set state
		//player.powers[pw_tailsfly] = 0
		player.heglide = false
		player.pflags = ($|PF_JUMPED|PF_THOKKED)
		player.actionstate = state_thrust
		player.actiontime = 0
		mo.state = S_PLAY_ROLL
		--Physics
		P_Thrust(mo,mo.angle,thrustfactor*thrustpower)
		if player.cmd.buttons & BT_SPIN then
			P_SetObjectMomZ(mo,FRACUNIT*-7,false)
		else
			P_SetObjectMomZ(mo,FRACUNIT*3,false)
		end
		--Effects
		local radius = mo.radius/FRACUNIT
		local height = mo.height/FRACUNIT
		local r1 = do
			return P_RandomRange(-radius,radius)*FRACUNIT
		end
		local r2 = do
			return P_RandomRange(0,height)*FRACUNIT
		end
		for n = 1,16
			P_SpawnMobjFromMobj(mo,r1(),r1(),r2(),MT_DUST)
		end
		S_StartSound(mo,sfx_zoom)
	end
	
	--Activate throw
	if throwtrigger 
		--B.PayRings(player)
		B.ApplyCooldown(player,cooldown_throw)
		--Set state
		//player.powers[pw_tailsfly] = 0
		player.heglide = false
		player.pflags = ($|PF_JUMPED)--|PF_THOKKED)
		player.actionstate = state_thrust
		player.actiontime = 0
		mo.state = S_PLAY_ROLL
	
		--Throw Partner
		for otherplayer in players.iterate
-- 			print(otherplayer.mo.tracer)
-- 			print(otherplayer.powers[pw_carry])
			if not(
				otherplayer.mo and otherplayer.mo.valid
				and otherplayer.mo.tracer == mo
				and otherplayer.powers[pw_carry] == CR_PLAYER
			)
				continue
			end
			local partner = otherplayer.mo
			partner.tracer = nil
			otherplayer.powers[pw_carry] = 0
			partner.state = S_PLAY_ROLL
			otherplayer.pflags = $|PF_SPINNING|PF_THOKKED
			P_InstaThrust(partner,mo.angle,thrustfactor*throw_strength)
			partner.momx = $ + mo.momx/2
			partner.momy = $ + mo.momy/2
			partner.momz = throw_lift*mo.scale*P_MobjFlip(mo) + mo.momz/2
		end
-- 		--Free carry ID
-- 		player.carry_id = nil
		
		--Physics
		if not(P_IsObjectOnGround(mo))
			P_SetObjectMomZ(mo,FRACUNIT*5,false)
		end
		--Effects
		P_SpawnParaloop(mo.x,mo.y,mo.z,mo.scale*64,12,MT_DUST,ANGLE_90,nil,true)
		S_StartSound(mo,sfx_spdpad)
	end
	
	--Swipe state
	if player.actionstate == state_swipe
		player.actiontime = $+1
		--if P_IsObjectOnGround(mo)
			--player.lockaim = true
		--end
		--player.lockmove = true
		//player.pflags = $|PF_SPINNING
 		//player.powers[pw_nocontrol] = $|2
		--Anim states
		if player.actiontime < 4
			--Fast Spin anim
			player.drawangle = mo.angle-ANGLE_90*(player.actiontime-4)
			B.DrawSVSprite(player,1)
			P_SetMobjStateNF(player.followmobj,S_NULL)
			dodust(mo)
			player.pflags = $|PF_SPINNING
		elseif player.actiontime < 12
			--Medium Spin anim
			player.drawangle = mo.angle-ANGLE_45*(player.actiontime-4)
			B.DrawSVSprite(player,1)
			P_SetMobjStateNF(player.followmobj,S_NULL)
			dodust(mo)
		else
			player.pflags = $&~(PF_SPINNING)
			--Teeter anim
			player.drawangle = mo.angle-ANGLE_45/2*(player.actiontime-4)
			mo.state = S_PLAY_EDGE
			mo.frame = 0
			mo.tics = 0
		end
		--Reset to neutral
		if player.actiontime >= 22
			player.actionstate = 0
			player.drawangle = mo.angle
			mo.state = S_PLAY_WALK
			player.pflags = $ &~ PF_JUMPED
			mo.frame = 0
		end
	else
	end
	--Thrust state
	if player.actionstate == state_thrust
		player.actiontime = $+1
		player.drawangle = mo.angle-ANG60*player.actiontime
		if not (P_IsObjectOnGround(mo))
			//player.pflags = $|PF_SPINNING
			//player.powers[pw_nocontrol] = $|1	
			player.lockmove = true
		end
-- 		P_SpawnGhostMobj(mo)
		--player.powers[pw_tailsfly] = 0
		local radius = mo.radius/FRACUNIT
		local height = mo.height/FRACUNIT
		local r1 = do
			return P_RandomRange(-radius,radius)*FRACUNIT
		end
		local r2 = do
			return P_RandomRange(0,height)*FRACUNIT
		end
		local s = P_SpawnMobjFromMobj(mo,r1(),r1(),r2(),MT_SPARK)
		s.colorized = true
		s.color = SKINCOLOR_WHITE
		s.scale = $/3
		s.momx = mo.momx/2
		s.momy = mo.momy/2
		s.momz = mo.momz/2
		s.flags2 = $|MF2_SHADOW
		
		--Reset to neutral
		if player.pflags & PF_THOKKED == 0 then
			player.actionstate = 0
			player.drawangle = mo.angle
			--mo.state = S_PLAY_WALK
			mo.frame = 0
		else
			B.DrawSVSprite(mo.player)
			player.followmobj.state = S_NULL
			--mo.player.followmobj.flags2 = $ | MF2_DONTDRAW
			--Priority above a set speed
			--local momxy = FixedHypot(mo.momx,mo.momy)
			--local momxyz = FixedHypot(mo.momz,momxy)
			if true--player.speed > 45*FRACUNIT 
			--or mo.momz < -15*FRACUNIT
			--or mo.momz > 15*FRACUNIT
			and mo.player.actiontime % 3 == 0
				local g = P_SpawnMobjFromMobj(mo, 0,0,0, MT_THOK)
				g.color = SKINCOLOR_AETHER
				if player.powers[pw_invulnerability] then
					g.color = rainbowtable[(((player.actiontime/3)-1)%6)+1]
					--print((((player.actiontime/3)-1)%6)+1)
				end
				g.angle = mo.player.drawangle
				g.sprite = SPR_TWTH
				g.momx = mo.momx/2
				g.momy = mo.momy/2
				g.momz = mo.momz/2
				--g.frame = ($ &~ (FF_TRANS60|FF_TRANS90))--|FF_TRANS30
				g.scale = $
				if player == displayplayer
					if (camera == nil)
					or (camera.chase == false)
						g.flags2 = $ | MF2_DONTDRAW
					else
						g.flags2 = $ & ~MF2_DONTDRAW
					end
				end	
			end
		end
	end
end