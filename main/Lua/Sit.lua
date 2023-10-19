-- Sit, based on Continue State Switcher by MSF. Will be more complex later, but for now, this is good enough.

--	Continue State Switcher
--		Made as a fun experiment & learning experience.
--		Sorry for how busy the code is. I'm very much new to this.
--		Special thanks to amperbee for helping me out with a few issues!
--		And yes, I did ask ChatGPT for some help too...
--	~ MSF

freeslot("S_PLAYSIT", "SPR2_SIT_")

states[S_PLAYSIT] = {SPR_PLAY,SPR2_SIT_|A,8,nil,0,0,S_PLAYSIT}

local forceStop = false
local hasSit1 = ""
local currentSkin = ""
local storedHeight = 0
local isRSling = false

local function skinChecker(player)
	if player.mo.skin ~= currentSkin then
		currentSkin = player.mo.skin
		hasSit1 = P_IsValidSprite2(player.mo, SPR2_SIT_)
		forceStop = not hasSit1
	end
end

local function switchState(player)
	if ((player.mo.state == S_PLAY_STND) or (player.mo.state == S_PLAY_WAIT) or (player.mo.state == S_PLAY_WALK) or (player.mo.state == S_PLAY_RUN) or (player.mo.state == S_PLAY_EDGE)) and P_IsObjectOnGround(player.mo) then
		if hasSit1 then
			player.mo.state = S_PLAYSIT
			storedHeight = player.mo.height
		end
	elseif player.mo.state == S_PLAYSIT then
		player.mo.height = storedHeight
		player.mo.state = S_PLAY_STND
	end
end

addHook("MapLoad", function()
	if G_RingSlingerGametype() then
		isRSling = true
	else
		isRSling = false
	end
end)

addHook("PlayerThink", function(player)
	if (not isRSling) then
		for p in players.iterate do
			if not p.bot and not p.spectator and not p.togglesitoff then
				skinChecker(p)
				if not forceStop then
					if not (p.cmd.buttons & BT_FIRENORMAL) then
						p.sittapready = true
						p.sittapping = false
					elseif p.sittapready then
						p.sittapping = true
						p.sittapready = false
					else
						p.sittapping = false
					end
					if p.sittapping then
						switchState(p)
					end
					if p.mo.state == S_PLAYSIT then
						player.mo.height = (storedHeight/3) * 2
						if p.speed > 1*FRACUNIT then
							p.pflags = $ | PF_STASIS
						else
							if P_GetPlayerControlDirection(p) ~= 0 then
								p.pflags = $ & ~ PF_STASIS
								p.mo.state = S_PLAY_WALK
							end
						end
					end
					if (p.mo.state == S_PLAYSIT) and not P_IsObjectOnGround(p.mo) then
						p.mo.state = S_PLAY_FALL
					end
				end
			end
			if p.togglesitoff and (p.mo.state == S_PLAYSIT) then
				p.pflags = $ & ~ PF_STASIS
				p.mo.state = S_PLAY_STND
			end
		end
	end
end)

local function ToggleSit(player)
	if player.mo and player.mo.valid then
		if player.togglesitoff then
			player.togglesitoff = false
			CONS_Printf(player, "\x82"+"Sit State Switcher Enabled.")
		else
			player.togglesitoff = true
			CONS_Printf(player, "\x86"+"Sit State Switcher Disabled.")
		end
	else
		CONS_Printf (player, "\x85"+"You're not in a level!")
	end
end

COM_AddCommand("togglesit", function(player)
	ToggleSit(player)
end)

COM_AddCommand("togglesit2", ToggleSit, COM_SPLITSCREEN)

-- Holy shit Inferno. Thank you so much for letting me use this and helping me fix it.
-- This code's mostly from mctails, but it's based on the SRB2 source code anyway.
-- I asked if I could share this code, and he said:
-- Inferno, today @ 2:07 PM EST: "That's all good."
addHook("FollowMobj", function(player, tails)
	if not (player.mo.followitem == TAILSOVERLAY) return end -- made this more universal
	if player.mo.state == S_PLAYSIT
		tails.angle = player.drawangle
		tails.scale = player.mo.scale
		tails.state = S_TAILSOVERLAY_PLUS60DEGREES
		tails.skin = player.mo.skin
	-- horizontal offsets
		local zoffs = FixedMul(-16*FRACUNIT, tails.scale)
		local backwards = 16
		backwards = ($ - (8*FRACUNIT)) / 2
		if (player.mo.eflags & MFE_VERTICALFLIP)
			P_MoveOrigin(tails, 
			player.mo.x + P_ReturnThrustX(tails, tails.angle, FixedMul(backwards, tails.scale)),
			player.mo.y + P_ReturnThrustY(tails, tails.angle, FixedMul(backwards, tails.scale)),
			player.mo.z - zoffs)
		else
			P_MoveOrigin(tails, 
			player.mo.x + P_ReturnThrustX(tails, tails.angle, FixedMul(backwards, tails.scale)),
			player.mo.y + P_ReturnThrustY(tails, tails.angle, FixedMul(backwards, tails.scale)),
			player.mo.z + zoffs)
		end
		return true
	end
end, MT_TAILSOVERLAY)