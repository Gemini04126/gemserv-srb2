local forceStop = false
local hasSit = ""
local hasEepy = ""
local hasTrickFail1 = ""
local hasTrickFail2 = ""
local hasTrickFail3 = ""
local currentSkin = ""
local storedHeight = 0

local function skinChecker(player)
	if player.mo.skin ~= currentSkin then
		currentSkin = player.mo.skin
		hasSit = P_IsValidSprite2(player.mo, SPR2_SIT_)
		hasEepy = P_IsValidSprite2(player.mo, SPR2_EEPY)
		hasTrickFail1 = P_IsValidSprite2(player.mo, SPR2_SHIT)
		hasTrickFail2 = P_IsValidSprite2(player.mo, SPR2_SHET)
		hasTrickFail3 = P_IsValidSprite2(player.mo, SPR2_OOF_)
		forceStop = not (hasSit or hasEepy or hasTrickFail1 or hasTrickFail2 or hasTrickFail3)
	end
end

local function doSit(player)
	if ((player.mo.state == S_PLAY_STND) or (player.mo.state == S_PLAY_WAIT) or (player.mo.state == S_PLAY_WALK) or (player.mo.state == S_PLAY_RUN) or (player.mo.state == S_PLAY_EDGE)) and P_IsObjectOnGround(player.mo) then
		if hasSit then
			player.mo.state = S_PLAYSIT
			player.storedHeight = player.mo.height
		end
	elseif player.mo.state == S_PLAYSIT then
		player.mo.height = player.storedHeight
		player.mo.state = S_PLAY_STND
	end
end

local function doEepy(player)
	if ((player.mo.state == S_PLAY_STND) or (player.mo.state == S_PLAY_WAIT) or (player.mo.state == S_PLAY_WALK) or (player.mo.state == S_PLAY_RUN) or (player.mo.state == S_PLAY_EDGE)) and P_IsObjectOnGround(player.mo) then
		if hasEepy then
			player.mo.state = S_PLAYEEPY
			player.storedHeight = player.mo.height
		end
	elseif player.mo.state == S_PLAYEEPY then
		player.mo.height = player.storedHeight
		player.mo.state = S_PLAY_STND
	end
end

local function doTrickFail(player)
	if ((player.mo.state == S_PLAY_STND) or (player.mo.state == S_PLAY_WAIT) or (player.mo.state == S_PLAY_WALK) or (player.mo.state == S_PLAY_RUN) or (player.mo.state == S_PLAY_EDGE)) and P_IsObjectOnGround(player.mo) then
		if hasTrickFail1 then
			player.mo.state = S_PLAYSHIT
			player.storedHeight = player.mo.height
		elseif hasTrickFail2 then
			player.mo.state = S_PLAYSHET
			player.storedHeight = player.mo.height
		elseif hasTrickFail3 then
			player.mo.state = S_PLAYOOF_
			player.storedHeight = player.mo.height
		end
	elseif player.mo.state == (S_PLAYSHIT or S_PLAYSHET or S_PLAYOOF_) then
		player.mo.height = player.storedHeight
		player.mo.state = S_PLAY_STND
	end
end

addHook("PlayerThink", function(player)
	if (not G_RingSlingerGametype()) then
		for p in players.iterate do
			if not p.bot and not p.spectator and not p.togglephysemotesoff then
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
						doSit(p)
					end
					if p.mo.state == S_PLAYSIT then
						p.mo.height = (p.storedHeight/3) * 2
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
			if p.togglephysemotesoff and (p.mo.state == S_PLAYSIT) then
				p.pflags = $ & ~ PF_STASIS
				p.mo.state = S_PLAY_STND
			end
		end
	end
end)

local function TogglePhysEmotes(player)
	if player.mo and player.mo.valid then
		if player.togglephysemotesoff then
			player.togglephysemotesoff = false
			CONS_Printf(player, "\x82"+"Physical Emotes Enabled.")
		else
			player.togglephysemotesoff = true
			CONS_Printf(player, "\x86"+"Physical Emotes Disabled.")
		end
	else
		CONS_Printf (player, "\x85"+"You're not in a level!")
	end
end

COM_AddCommand("togglephysemotes", function(player)
	TogglePhysEmotes(player)
end)

COM_AddCommand("togglephysemotes2", TogglePhysEmotes, COM_SPLITSCREEN)

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